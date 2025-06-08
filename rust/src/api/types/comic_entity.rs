use serde::{Deserialize, Serialize};
use crate::api::types::image_entity::ImageEntity;

#[derive(Serialize, Deserialize, Debug)]
#[serde(rename_all = "camelCase")]
pub struct ComicEntity {
    #[serde(rename = "_id")]
    pub id: String,
    pub title: String,
    pub author: String,
    pub pages_count: i32,
    pub eps_count: i32,
    pub finished: bool,
    pub categories: Vec<String>,
    pub thumb: ImageEntity,
    pub likes_count: i32,
    pub tags: Vec<String>,
    pub total_likes: i32,
    pub total_views: i32,
}