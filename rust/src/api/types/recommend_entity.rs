use flutter_rust_bridge::frb;
use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize, Debug)]
#[serde(rename_all = "camelCase")]
#[frb(dart_metadata=("freezed"))]
pub struct RecommendEntity {
    pub id: String,
    pub pic: String,
    pub title: String,
}
