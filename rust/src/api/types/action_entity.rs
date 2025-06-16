use flutter_rust_bridge::frb;
use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize, Debug)]
#[serde(rename_all = "camelCase")]
#[frb(dart_metadata=("freezed"))]
pub struct ActionEntity {
    #[serde(default = "default_string")]
    pub action: String,
}

fn default_string() -> String {
    "".to_string()
}
