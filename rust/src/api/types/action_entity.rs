use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize, Debug)]
#[serde(rename_all = "camelCase")]
pub struct ActionEntity {
    #[serde(default = "default_string")]
    pub action: String,
}

fn default_string() -> String {
    "".to_string()
}