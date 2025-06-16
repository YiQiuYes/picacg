use crate::api::types::{
    comic_comment_entity::ComicCommentEntity, comic_entity::ComicEntity,
    comic_ep_entity::ComicEpEntity, comic_ep_picture_entity::ComicEpPictureEntity,
    comic_search_entity::ComicSearchEntity,
};
use flutter_rust_bridge::frb;
use serde::{Deserialize, Serialize};
use std::num::ParseIntError;

#[derive(Debug, Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
#[frb(dart_metadata=("freezed"))]
pub struct PageData<T> {
    #[serde(deserialize_with = "fuzzy_i32")]
    pub total: i32,
    #[serde(deserialize_with = "fuzzy_i32")]
    pub limit: i32,
    #[serde(deserialize_with = "fuzzy_i32")]
    pub page: i32,
    #[serde(deserialize_with = "fuzzy_i32")]
    pub pages: i32,
    pub docs: Vec<T>,
}

fn fuzzy_i32<'de, D>(d: D) -> Result<i32, D::Error>
where
    D: serde::Deserializer<'de>,
{
    let value: serde_json::Value = serde::Deserialize::deserialize(d)?;
    if value.is_i64() {
        Ok(value.as_i64().unwrap() as i32)
    } else if value.is_string() {
        let str = value.as_str().unwrap();
        let from: Result<i32, ParseIntError> = std::str::FromStr::from_str(str);
        match from {
            Ok(from) => Ok(from),
            Err(_) => Err(serde::de::Error::custom(
                "pagedata failed to parse i32 from string",
            )),
        }
    } else {
        Err(serde::de::Error::custom("pagedata expected i32 or string"))
    }
}

#[derive(Debug, Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
#[frb(dart_metadata=("freezed"))]
pub struct ComicPageData {
    pub total: i32,
    pub limit: i32,
    pub page: i32,
    pub pages: i32,
    pub docs: Vec<ComicEntity>,
}

impl From<PageData<ComicEntity>> for ComicPageData {
    fn from(page_data: PageData<ComicEntity>) -> Self {
        ComicPageData {
            total: page_data.total,
            limit: page_data.limit,
            page: page_data.page,
            pages: page_data.pages,
            docs: page_data.docs,
        }
    }
}

#[derive(Debug, Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
#[frb(dart_metadata=("freezed"))]
pub struct ComicEpPageData {
    pub total: i32,
    pub limit: i32,
    pub page: i32,
    pub pages: i32,
    pub docs: Vec<ComicEpEntity>,
}

impl From<PageData<ComicEpEntity>> for ComicEpPageData {
    fn from(page_data: PageData<ComicEpEntity>) -> Self {
        ComicEpPageData {
            total: page_data.total,
            limit: page_data.limit,
            page: page_data.page,
            pages: page_data.pages,
            docs: page_data.docs,
        }
    }
}

#[derive(Debug, Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
#[frb(dart_metadata=("freezed"))]
pub struct ComicEpPicturePageData {
    pub total: i32,
    pub limit: i32,
    pub page: i32,
    pub pages: i32,
    pub docs: Vec<ComicEpPictureEntity>,
}

impl From<PageData<ComicEpPictureEntity>> for ComicEpPicturePageData {
    fn from(page_data: PageData<ComicEpPictureEntity>) -> Self {
        ComicEpPicturePageData {
            total: page_data.total,
            limit: page_data.limit,
            page: page_data.page,
            pages: page_data.pages,
            docs: page_data.docs,
        }
    }
}

#[derive(Debug, Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
#[frb(dart_metadata=("freezed"))]
pub struct ComicCommentPageData {
    pub total: i32,
    pub limit: i32,
    pub page: i32,
    pub pages: i32,
    pub docs: Vec<ComicCommentEntity>,
}

impl From<PageData<ComicCommentEntity>> for ComicCommentPageData {
    fn from(page_data: PageData<ComicCommentEntity>) -> Self {
        ComicCommentPageData {
            total: page_data.total,
            limit: page_data.limit,
            page: page_data.page,
            pages: page_data.pages,
            docs: page_data.docs,
        }
    }
}

#[derive(Debug, Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
#[frb(dart_metadata=("freezed"))]
pub struct ComicSearchPageData {
    pub total: i32,
    pub limit: i32,
    pub page: i32,
    pub pages: i32,
    pub docs: Vec<ComicSearchEntity>,
}

impl From<PageData<ComicSearchEntity>> for ComicSearchPageData {
    fn from(page_data: PageData<ComicSearchEntity>) -> Self {
        ComicSearchPageData {
            total: page_data.total,
            limit: page_data.limit,
            page: page_data.page,
            pages: page_data.pages,
            docs: page_data.docs,
        }
    }
}
