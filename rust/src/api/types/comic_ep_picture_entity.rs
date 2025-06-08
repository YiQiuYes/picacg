use serde::{Deserialize, Serialize};
use crate::api::types::image_entity::ImageEntity;

#[derive(Serialize, Deserialize, Debug)]
pub struct ComicEpPictureEntity {
    #[serde(rename = "_id")]
    pub id: String,
    pub media: ImageEntity,
}