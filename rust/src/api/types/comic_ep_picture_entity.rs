use crate::api::types::image_entity::ImageEntity;
use flutter_rust_bridge::frb;
use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize, Debug)]
#[frb(dart_metadata=("freezed"))]
pub struct ComicEpPictureEntity {
    #[serde(rename = "_id")]
    pub id: String,
    pub media: ImageEntity,
}
