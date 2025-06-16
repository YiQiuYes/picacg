use flutter_rust_bridge::frb;
use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize, Debug)]
#[frb(dart_metadata=("freezed"))]
pub struct LoginEntity {
    pub token: String,
}
