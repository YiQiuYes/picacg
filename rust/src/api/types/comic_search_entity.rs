use crate::api::types::image_entity::ImageEntity;
use serde::{Deserialize, Serialize};

#[derive(Debug, Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct ComicSearchEntity {
    #[serde(rename = "_id")]
    pub id: String,
    #[serde(default)]
    pub author: String,
    pub categories: Vec<String>,
    #[serde(default)]
    pub chinese_team: String,
    #[serde(rename = "created_at")]
    pub created_at: String,
    #[serde(default)]
    pub description: String,
    pub finished: bool,
    pub likes_count: i64,
    pub tags: Vec<String>,
    pub thumb: ImageEntity,
    pub title: String,
    pub total_likes: Option<i64>,
    pub total_views: Option<i64>,
    #[serde(rename = "updated_at")]
    pub updated_at: String,
}
