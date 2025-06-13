use crate::api::{
    error::custom_error::{CustomError, CustomErrorType},
    storage::user_data::UserData,
};
use flutter_rust_bridge::frb;
use serde::{Deserialize, Serialize};
use std::{fs, sync::RwLock};

static CONFIG_FILE_PATH: &str = "config.json";

pub static CONFIG: RwLock<Config> = RwLock::new(Config {
    user_data: UserData {
        token: String::new(),
    },
});

#[derive(Serialize, Deserialize, Debug, Clone)]
pub struct Config {
    #[serde(default = "default_user_data")]
    pub user_data: UserData,
}

fn default_user_data() -> UserData {
    UserData {
        token: String::new(),
    }
}

#[frb(sync)]
pub fn picacg_load_config(path: String) -> Result<Config, CustomError> {
    let path = if path.ends_with('/') {
        path
    } else {
        path + "/"
    };
    let file_path = path + CONFIG_FILE_PATH;

    if !fs::metadata(&file_path).is_ok() {
        let default_config = Config {
            user_data: default_user_data(),
        };

        let default_config_json =
            serde_json::to_string(&default_config).map_err(|e| CustomError {
                error_code: CustomErrorType::SerializeJsonError,
                error_message: format!("Failed to serialize default config: {}", e),
            })?;
        fs::write(&file_path, default_config_json).map_err(|e| CustomError {
            error_code: CustomErrorType::FileWriteError,
            error_message: format!("Failed to write default config file: {}", e),
        })?;

        CONFIG
            .write()
            .map_err(|_| CustomError {
                error_code: CustomErrorType::LockError,
                error_message: "Failed to acquire write lock on CONFIG".to_string(),
            })?
            .user_data = default_config.user_data;

        Ok(CONFIG
            .read()
            .map_err(|_| CustomError {
                error_code: CustomErrorType::LockError,
                error_message: "Failed to acquire read lock on CONFIG".to_string(),
            })?
            .clone())
    } else {
        let config = fs::read_to_string(&file_path).map_err(|e| CustomError {
            error_code: CustomErrorType::FileReadError,
            error_message: format!("Failed to read config file: {}", e),
        })?;

        let config: Config = serde_json::from_str(&config).map_err(|e| CustomError {
            error_code: CustomErrorType::ParseJsonError,
            error_message: format!("Failed to parse config file: {}", e),
        })?;

        CONFIG
            .write()
            .map_err(|_| CustomError {
                error_code: CustomErrorType::LockError,
                error_message: "Failed to acquire write lock on CONFIG".to_string(),
            })?
            .user_data = config.user_data;

        Ok(CONFIG
            .read()
            .map_err(|_| CustomError {
                error_code: CustomErrorType::LockError,
                error_message: "Failed to acquire read lock on CONFIG".to_string(),
            })?
            .clone())
    }
}

#[frb(sync)]
pub fn picacg_save_config(path: String) -> Result<(), CustomError> {
    let path = if path.ends_with('/') {
        path
    } else {
        path + "/"
    };
    let file_path = path + CONFIG_FILE_PATH;

    let config = CONFIG.read().map_err(|_| CustomError {
        error_code: CustomErrorType::LockError,
        error_message: "Failed to acquire read lock on CONFIG".to_string(),
    })?;

    let config_json = serde_json::to_string(&*config).map_err(|e| CustomError {
        error_code: CustomErrorType::SerializeJsonError,
        error_message: format!("Failed to serialize config: {}", e),
    })?;

    fs::write(&file_path, config_json).map_err(|e| CustomError {
        error_code: CustomErrorType::FileWriteError,
        error_message: format!("Failed to write config file: {}", e),
    })?;

    Ok(())
}

#[frb(sync)]
pub fn picacg_set_config(path: String, config: Config) -> Result<(), CustomError> {
    let path = if path.ends_with('/') {
        path
    } else {
        path + "/"
    };
    let file_path = path + CONFIG_FILE_PATH;

    let config_json = serde_json::to_string(&config).map_err(|e| CustomError {
        error_code: CustomErrorType::SerializeJsonError,
        error_message: format!("Failed to serialize config: {}", e),
    })?;

    fs::write(&file_path, config_json).map_err(|e| CustomError {
        error_code: CustomErrorType::FileWriteError,
        error_message: format!("Failed to write config file: {}", e),
    })?;

    CONFIG
        .write()
        .map_err(|_| CustomError {
            error_code: CustomErrorType::LockError,
            error_message: "Failed to acquire write lock on CONFIG".to_string(),
        })?
        .user_data = config.user_data;

    Ok(())
}

#[cfg(test)]
mod tests {
    use crate::api::storage::config::{
        picacg_load_config, picacg_save_config, picacg_set_config, Config, CONFIG_FILE_PATH,
    };
    use crate::api::storage::user_data::UserData;

    #[test]
    fn test_config_save_read() {
        let result = picacg_save_config("./".to_string());
        assert!(result.is_ok());

        let config = picacg_load_config("./".to_string());
        match config {
            Ok(loaded_config) => {
                assert_eq!(loaded_config.user_data.token, "");
            }
            Err(e) => {
                panic!("Failed to load config: {:?}", e);
            }
        }

        let config = Config {
            user_data: UserData {
                token: "test_token".to_string(),
            },
        };

        let result = picacg_set_config("./".to_string(), config.clone());
        assert!(result.is_ok());
        let loaded_config = picacg_load_config("./".to_string());
        match loaded_config {
            Ok(loaded_config) => {
                assert_eq!(loaded_config.user_data.token, "test_token");
            }
            Err(e) => {
                panic!("Failed to load config: {:?}", e);
            }
        }

        let result = std::fs::remove_file(CONFIG_FILE_PATH);
        assert!(result.is_ok());
    }
}
