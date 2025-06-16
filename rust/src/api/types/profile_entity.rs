use crate::api::types::image_entity::{avatar_default, ImageEntity};
use chrono::{DateTime, Utc};
use flutter_rust_bridge::frb;
use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize, Debug)]
#[serde(rename_all = "camelCase")]
#[frb(dart_metadata=("freezed"))]
pub struct ProfileEntity {
    #[serde(rename = "_id")]
    pub id: String,
    pub gender: String,
    pub name: String,
    pub title: String,
    pub verified: bool,
    pub exp: i32,
    pub level: i32,
    pub characters: Vec<String>,
    #[serde(default = "avatar_default")]
    pub avatar: ImageEntity,
    pub birthday: String,
    pub email: String,
    #[serde(rename = "created_at")]
    pub created_at: DateTime<Utc>,
    pub is_punched: bool,
}
