use chrono::{DateTime, Utc};
use serde::{Deserialize, Serialize};
use crate::api::types::creator_entity::CreatorEntity;
use crate::api::types::image_entity::ImageEntity;

#[derive(Serialize, Deserialize, Debug)]
#[serde(rename_all = "camelCase")]
pub struct ComicInfoEntity {
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
    #[serde(rename = "_creator")]
    pub creator: CreatorEntity,
    pub description: String,
    pub chinese_team: String,
    pub tags: Vec<String>,
    #[serde(rename = "updated_at")]
    pub updated_at: DateTime<Utc>,
    #[serde(rename = "created_at")]
    pub created_at: String,
    pub allow_download: bool,
    pub views_count: i32,
    pub is_liked: bool,
    pub comments_count: i32,
}