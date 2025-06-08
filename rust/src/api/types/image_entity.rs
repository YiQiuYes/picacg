use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize, Debug)]
#[serde(rename_all = "camelCase")]
pub struct ImageEntity {
    pub file_server: String,
    pub original_name: String,
    pub path: String,
}

pub fn avatar_default() -> ImageEntity {
    ImageEntity {
        file_server: "".to_string(),
        path: "".to_string(),
        original_name: "".to_string(),
    }
}
