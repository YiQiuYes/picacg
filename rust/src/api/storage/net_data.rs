use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize, Debug, Clone)]
pub struct NetData {
    #[serde(default = "default_string")]
    pub image_server: String,
}

fn default_string() -> String {
    String::new()
}
