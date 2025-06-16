use crate::api::types::comment_user_entity::CommentUserEntity;
use flutter_rust_bridge::frb;
use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize, Debug)]
#[serde(rename_all = "camelCase")]
#[frb(dart_metadata=("freezed"))]
pub struct ComicCommentEntity {
    #[serde(rename = "_id")]
    pub id: String,
    pub content: String,
    #[serde(rename = "_user")]
    pub user: CommentUserEntity,
    pub is_top: bool,
    pub hide: bool,
    #[serde(rename = "created_at")]
    pub created_at: String,
    pub likes_count: i64,
    pub comments_count: i64,
    pub is_liked: bool,
    #[serde(rename = "_comic", default = "default_string")]
    pub comic: String,
    #[serde(rename = "_game", default = "default_string")]
    pub game: String,
    #[serde(rename = "_parent", default = "default_string")]
    pub parent: String,
}

fn default_string() -> String {
    "".to_string()
}
