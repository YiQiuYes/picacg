use crate::api::types::image_entity::ImageEntity;
use flutter_rust_bridge::frb;
use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize, Debug)]
#[serde(rename_all = "camelCase")]
#[frb(dart_metadata=("freezed"))]
pub struct CategoryEntity {
    pub title: String,
    #[serde(default = "default_is_web")]
    pub is_web: bool,
    #[serde(default = "default_active")]
    pub active: bool,
    #[serde(default = "default_link")]
    pub link: String,
    pub thumb: ImageEntity,
}

fn default_active() -> bool {
    true
}

fn default_is_web() -> bool {
    false
}

fn default_link() -> String {
    String::from("")
}
