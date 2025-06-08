use crate::api::types::image_entity::avatar_default;
use crate::api::types::image_entity::ImageEntity;
use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize, Debug)]
#[serde(rename_all = "camelCase")]
pub struct CommentUserEntity {
    #[serde(rename = "_id")]
    pub id: String,
    pub gender: String,
    pub name: String,
    pub title: String,
    pub verified: bool,
    pub exp: i64,
    pub level: i64,
    #[serde(default = "default_vec")]
    pub characters: Vec<String>,
    #[serde(default = "avatar_default")]
    pub avatar: ImageEntity,
    pub role: String,
}

fn default_vec<T>() -> Vec<T> {
    vec![]
}
