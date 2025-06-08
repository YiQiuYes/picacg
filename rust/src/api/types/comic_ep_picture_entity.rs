use crate::api::types::image_entity::ImageEntity;
use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize, Debug)]
pub struct ComicEpPictureEntity {
    #[serde(rename = "_id")]
    pub id: String,
    pub media: ImageEntity,
}
