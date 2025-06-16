use crate::api::{
    error::custom_error::{CustomError, CustomErrorType},
    types::{
        ad_entity::AdEntity,
        announcement_entity::AnnouncementEntity,
        page_data::{AnnouncementPageData, PageData},
    },
    utils::{
        client::{picacg_request, HttpExpectBody},
        parse_json::parse_json_from_text,
    },
};
use flutter_rust_bridge::frb;

#[frb]
pub async fn picacg_notice_ad() -> Result<Vec<AdEntity>, CustomError> {
    let response = picacg_request("GET", "/banners", None, None, Some(HttpExpectBody::Text))
        .await
        .map_err(|e| CustomError {
            error_code: CustomErrorType::BadRequest,
            error_message: format!("Failed to make request: {}", e),
        })?;

    parse_json_from_text(
        response.body,
        |json| {
            let ads: Vec<AdEntity> = serde_json::from_value(json["data"]["banners"].clone())
                .map_err(|e| CustomError {
                    error_code: CustomErrorType::ParseJsonError,
                    error_message: format!("Failed to parse ad entities: {}", e),
                })?;
            Ok(ads)
        },
        "Response body is not text".to_string(),
    )
}

#[frb]
pub async fn picacg_notice_announcements(page: i32) -> Result<AnnouncementPageData, CustomError> {
    let response = picacg_request(
        "GET",
        &format!("/announcements?page={}", page),
        None,
        None,
        Some(HttpExpectBody::Text),
    )
    .await
    .map_err(|e| CustomError {
        error_code: CustomErrorType::BadRequest,
        error_message: format!("Failed to make request: {}", e),
    })?;

    parse_json_from_text(
        response.body,
        |json| {
            let page_data: PageData<AnnouncementEntity> =
                serde_json::from_value(json["data"]["announcements"].clone()).map_err(|e| {
                    CustomError {
                        error_code: CustomErrorType::ParseJsonError,
                        error_message: format!("Failed to parse notice announcements data: {}", e),
                    }
                })?;

            Ok(AnnouncementPageData::from(page_data))
        },
        "notice announcements api result expected text response".to_string(),
    )
}

#[cfg(test)]
mod tests {
    use super::*;

    #[tokio::test]
    async fn test_picacg_notice_ad() {
        let response = picacg_notice_ad().await;
        assert!(response.is_err());
    }

    #[tokio::test]
    async fn test_picacg_notice_announcements() {
        let response = picacg_notice_announcements(1).await;
        assert!(response.is_err());
    }
}
