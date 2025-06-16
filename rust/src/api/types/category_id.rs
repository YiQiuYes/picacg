use flutter_rust_bridge::frb;
use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize, Debug)]
#[serde(rename_all = "camelCase")]
#[frb(dart_metadata=("freezed"))]
pub struct CategoryIdEntity {
    #[serde(rename = "_id")]
    pub id: String,
    pub title: String,
}
