use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize, Debug, Clone)]
pub struct UserData {
    #[serde(default = "default_string")]
    pub token: String,
}

fn default_string() -> String {
    String::new()
}
