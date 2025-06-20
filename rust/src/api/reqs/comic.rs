use crate::api::{
    error::custom_error::{CustomError, CustomErrorType},
    types::{
        action_entity::ActionEntity,
        category_entity::CategoryEntity,
        comic_comment_entity::ComicCommentEntity,
        comic_entity::ComicEntity,
        comic_ep_entity::ComicEpEntity,
        comic_ep_picture_entity::ComicEpPictureEntity,
        comic_info_entity::ComicInfoEntity,
        comic_search_entity::ComicSearchEntity,
        init_entity::InitEntity,
        page_data::{
            ComicCommentPageData, ComicEpPageData, ComicEpPicturePageData, ComicPageData,
            ComicSearchPageData, PageData,
        },
        sort::Sort,
    },
    utils::{
        client::{picacg_request, HttpExpectBody},
        parse_json::parse_json_from_text,
    },
};
use flutter_rust_bridge::frb;

/// 获取随机漫画列表。
///
/// 该函数会向 `/comics/random` 接口发起 GET 请求，
/// 并尝试将返回的 JSON 数据解析为 `Vec<ComicEntity>`。
///
/// # 返回
/// - `Ok(Vec<ComicEntity>)`：请求成功并解析成功时返回漫画实体列表。
/// - `Err(CustomError)`：请求失败或解析失败时返回错误信息。
#[frb]
pub async fn picacg_comic_random() -> Result<Vec<ComicEntity>, CustomError> {
    let response = picacg_request(
        "GET",
        "/comics/random",
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
            serde_json::from_value(json["data"]["comics"].clone()).map_err(|e| CustomError {
                error_code: CustomErrorType::ParseJsonError,
                error_message: format!("Failed to parse comic entity: {}", e),
            })
        },
        "random api result expected text response".to_string(),
    )
}

/// 获取漫画分页列表。
///
/// 该函数会向 `/comics` 接口发起 GET 请求，根据传入的筛选参数（如分类、标签、作者、汉化组、排序方式和页码）
/// 构建查询字符串，并尝试将返回的 JSON 数据解析为 `ComicPageData`。
///
/// # 参数
/// - `category`: 可选，漫画分类
/// - `tag`: 可选，漫画标签
/// - `creator_id`: 可选，作者 ID
/// - `chinese_team`: 可选，汉化组
/// - `sort`: 排序方式（`Sort` 枚举）
/// - `page`: 页码（从 1 开始）
///
/// # 返回
/// - `Ok(ComicPageData)`：请求成功并解析成功时返回分页数据
/// - `Err(CustomError)`：请求失败或解析失败时返回错误信息
#[frb]
pub async fn picacg_comic_page(
    category: Option<String>,
    tag: Option<String>,
    creator_id: Option<String>,
    chinese_team: Option<String>,
    sort: Sort,
    page: i32,
) -> Result<ComicPageData, CustomError> {
    let mut query_params = Vec::new();
    if let Some(category) = category {
        query_params.push(("c".to_string(), category));
    }

    if let Some(tag) = tag {
        query_params.push(("t".to_string(), tag));
    }

    if let Some(creator_id) = creator_id {
        query_params.push(("ca".to_string(), creator_id));
    }

    if let Some(chinese_team) = chinese_team {
        query_params.push(("ct".to_string(), chinese_team));
    }

    query_params.push(("s".to_string(), sort.as_str().to_string()));
    query_params.push(("page".to_string(), page.to_string()));

    let mut url = String::new();
    url.push_str("/comics");
    if !query_params.is_empty() {
        url.push('?');
        url.push_str(
            &query_params
                .iter()
                .map(|(k, v)| format!("{}={}", k, v))
                .collect::<Vec<String>>()
                .join("&"),
        );
    }

    let response = picacg_request("GET", &url, None, None, Some(HttpExpectBody::Text))
        .await
        .map_err(|e| CustomError {
            error_code: CustomErrorType::BadRequest,
            error_message: format!("Failed to make request: {}", e),
        })?;

    parse_json_from_text(
        response.body,
        |json| {
            let page_data: PageData<ComicEntity> =
                serde_json::from_value(json["data"]["comics"].clone()).map_err(|e| {
                    CustomError {
                        error_code: CustomErrorType::ParseJsonError,
                        error_message: format!("Failed to parse comic page data: {}", e),
                    }
                })?;

            Ok(ComicPageData::from(page_data))
        },
        "comic page api result expected text response".to_string(),
    )
}

/// 获取指定漫画的详细信息。
///
/// 该函数会向 `/comics/{comic_id}` 接口发起 GET 请求，
/// 并尝试将返回的 JSON 数据解析为 `ComicInfoEntity`。
///
/// # 参数
/// - `comic_id`: 漫画的唯一标识符。
///
/// # 返回
/// - `Ok(ComicInfoEntity)`：请求成功并解析成功时返回漫画详细信息。
/// - `Err(CustomError)`：请求失败或解析失败时返回错误信息。
#[frb]
pub async fn picacg_comic_info(comic_id: String) -> Result<ComicInfoEntity, CustomError> {
    let response = picacg_request(
        "GET",
        &format!("/comics/{}", comic_id),
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
            serde_json::from_value(json["data"]["comic"].clone()).map_err(|e| CustomError {
                error_code: CustomErrorType::ParseJsonError,
                error_message: format!("Failed to parse comic info entity: {}", e),
            })
        },
        "comic info api result expected text response".to_string(),
    )
}

/// 获取指定漫画的章节分页列表。
///
/// 该函数会向 `/comics/{comic_id}/eps` 接口发起 GET 请求，
/// 并尝试将返回的 JSON 数据解析为 `ComicEpPageData`。
///
/// # 参数
/// - `comic_id`: 漫画的唯一标识符。
/// - `page`: 页码（从 1 开始）。
///
/// # 返回
/// - `Ok(ComicEpPageData)`：请求成功并解析成功时返回章节分页数据。
/// - `Err(CustomError)`：请求失败或解析失败时返回错误信息。
#[frb]
pub async fn picacg_comic_eps(comic_id: String, page: i32) -> Result<ComicEpPageData, CustomError> {
    let response = picacg_request(
        "GET",
        &format!("/comics/{}/eps?page={}", comic_id, page),
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
            let page_data: PageData<ComicEpEntity> =
                serde_json::from_value(json["data"]["eps"].clone()).map_err(|e| CustomError {
                    error_code: CustomErrorType::ParseJsonError,
                    error_message: format!("Failed to parse comic eps data: {}", e),
                })?;

            Ok(ComicEpPageData::from(page_data))
        },
        "comic eps api result expected text response".to_string(),
    )
}

/// 获取指定漫画某一章节的图片分页列表。
///
/// 该函数会向 `/comics/{comic_id}/order/{ep_order}/pages?page={page}` 接口发起 GET 请求，
/// 并尝试将返回的 JSON 数据解析为 `ComicEpPicturePageData`。
///
/// # 参数
/// - `comic_id`: 漫画的唯一标识符。
/// - `ep_order`: 章节序号。
/// - `page`: 页码（从 1 开始）。
///
/// # 返回
/// - `Ok(ComicEpPicturePageData)`：请求成功并解析成功时返回章节图片分页数据。
/// - `Err(CustomError)`：请求失败或解析失败时返回错误信息。
#[frb]
pub async fn picacg_comic_ep_pictures(
    comic_id: String,
    ep_order: i32,
    page: i32,
) -> Result<ComicEpPicturePageData, CustomError> {
    let response = picacg_request(
        "GET",
        &format!(
            "/comics/{}/order/{}/pages?page={}",
            comic_id, ep_order, page
        ),
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
            let page_data: PageData<ComicEpPictureEntity> =
                serde_json::from_value(json["data"]["pages"].clone()).map_err(|e| CustomError {
                    error_code: CustomErrorType::ParseJsonError,
                    error_message: format!("Failed to parse comic ep pictures data: {}", e),
                })?;

            Ok(ComicEpPicturePageData::from(page_data))
        },
        "comic ep pictures api result expected text response".to_string(),
    )
}

/// 获取用户收藏的漫画分页列表。
///
/// 该函数会向 `/users/favourite` 接口发起 GET 请求，
/// 根据传入的排序方式和页码构建查询字符串，
/// 并尝试将返回的 JSON 数据解析为 `ComicPageData`。
///
/// # 参数
/// - `sort`: 排序方式（`Sort` 枚举）
/// - `page`: 页码（从 1 开始）
///
/// # 返回
/// - `Ok(ComicPageData)`：请求成功并解析成功时返回收藏漫画的分页数据
/// - `Err(CustomError)`：请求失败或解析失败时返回错误信息
#[frb]
pub async fn picacg_comic_favourite(sort: Sort, page: i32) -> Result<ComicPageData, CustomError> {
    let response = picacg_request(
        "GET",
        &format!("/users/favourite?s={}&page={}", sort.as_str(), page),
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
            let page_data: PageData<ComicEntity> =
                serde_json::from_value(json["data"]["comics"].clone()).map_err(|e| {
                    CustomError {
                        error_code: CustomErrorType::ParseJsonError,
                        error_message: format!("Failed to parse comic favourite data: {}", e),
                    }
                })?;

            Ok(ComicPageData::from(page_data))
        },
        "comic favourite api result expected text response".to_string(),
    )
}

/// 切换指定漫画的点赞状态（Like/Unlike）。
///
/// 该函数会向 `/comics/{comic_id}/like` 接口发起 POST 请求，
/// 用于切换漫画的点赞（Like）或取消点赞（Unlike）状态。
///
/// # 参数
/// - `comic_id`: 漫画的唯一标识符。
///
/// # 返回
/// - `Ok(ActionEntity)`：请求成功并解析成功时返回操作结果实体。
/// - `Err(CustomError)`：请求失败或解析失败时返回错误信息。
#[frb]
pub async fn picacg_comic_switch_like(comic_id: String) -> Result<ActionEntity, CustomError> {
    let response = picacg_request(
        "POST",
        &format!("/comics/{}/like", comic_id),
        Some("{}".to_string()),
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
            serde_json::from_value(json["data"].clone()).map_err(|e| CustomError {
                error_code: CustomErrorType::ParseJsonError,
                error_message: format!("Failed to parse action entity: {}", e),
            })
        },
        "switch like api result expected text response".to_string(),
    )
}

/// 切换指定漫画的收藏状态（收藏/取消收藏）。
///
/// 该函数会向 `/comics/{comic_id}/favourite` 接口发起 POST 请求，
/// 用于切换漫画的收藏（Favourite）或取消收藏状态。
///
/// # 参数
/// - `comic_id`: 漫画的唯一标识符。
///
/// # 返回
/// - `Ok(ActionEntity)`：请求成功并解析成功时返回操作结果实体。
/// - `Err(CustomError)`：请求失败或解析失败时返回错误信息。
#[frb]
pub async fn picacg_comic_switch_favourite(comic_id: String) -> Result<ActionEntity, CustomError> {
    let response = picacg_request(
        "POST",
        &format!("/comics/{}/favourite", comic_id),
        Some("{}".to_string()),
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
            serde_json::from_value(json["data"].clone()).map_err(|e| CustomError {
                error_code: CustomErrorType::ParseJsonError,
                error_message: format!("Failed to parse action entity: {}", e),
            })
        },
        "switch favourite api result expected text response".to_string(),
    )
}

/// 获取指定漫画的评论分页列表。
///
/// 该函数会向 `/comics/{comic_id}/comments` 接口发起 GET 请求，
/// 并尝试将返回的 JSON 数据解析为 `ComicCommentPageData`。
///
/// # 参数
/// - `comic_id`: 漫画的唯一标识符。
/// - `page`: 页码（从 1 开始）。
///
/// # 返回
/// - `Ok(ComicCommentPageData)`：请求成功并解析成功时返回评论分页数据。
/// - `Err(CustomError)`：请求失败或解析失败时返回错误信息。
#[frb]
pub async fn picacg_comic_comments(
    comic_id: String,
    page: i32,
) -> Result<ComicCommentPageData, CustomError> {
    let response = picacg_request(
        "GET",
        &format!("/comics/{}/comments?page={}", comic_id, page),
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
            let page_data: PageData<ComicCommentEntity> =
                serde_json::from_value(json["data"]["comments"].clone()).map_err(|e| {
                    CustomError {
                        error_code: CustomErrorType::ParseJsonError,
                        error_message: format!("Failed to parse comic comments data: {}", e),
                    }
                })?;

            Ok(ComicCommentPageData::from(page_data))
        },
        "comic comments api result expected text response".to_string(),
    )
}

/// 向指定漫画发布评论。
///
/// 该函数会向 `/comics/{comic_id}/comments` 接口发起 POST 请求，
/// 并提交评论内容。成功时返回 `Ok(())`，失败时返回错误信息。
///
/// # 参数
/// - `comic_id`: 漫画的唯一标识符。
/// - `content`: 评论内容。
///
/// # 返回
/// - `Ok(())`：评论发布成功。
/// - `Err(CustomError)`：请求失败或解析失败时返回错误信息。
#[frb]
pub async fn picacg_comic_post_comment(
    comic_id: String,
    content: String,
) -> Result<(), CustomError> {
    let response = picacg_request(
        "POST",
        &format!("/comics/{}/comments", comic_id),
        Some(serde_json::json!({ "content": content }).to_string()),
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
        |_json| Ok(()),
        "post comment api result expected text response".to_string(),
    )
}

/// 向指定评论发布子评论（回复）。
///
/// 该函数会向 `/comments/{comment_id}` 接口发起 POST 请求，
/// 并提交子评论内容。成功时返回 `Ok(())`，失败时返回错误信息。
///
/// # 参数
/// - `comment_id`: 父评论的唯一标识符。
/// - `content`: 子评论内容。
///
/// # 返回
/// - `Ok(())`：子评论发布成功。
/// - `Err(CustomError)`：请求失败或解析失败时返回错误信息。
#[frb]
pub async fn picacg_comic_post_child_comment(
    comment_id: String,
    content: String,
) -> Result<(), CustomError> {
    let response = picacg_request(
        "POST",
        &format!("/comments/{}", comment_id),
        Some(serde_json::json!({ "content": content }).to_string()),
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
        |_json| Ok(()),
        "post child comment api result expected text response".to_string(),
    )
}

/// 使用高级搜索功能搜索漫画。
///
/// 该函数会向 `/comics/advanced-search` 接口发起 POST 请求，
/// 根据传入的关键词、排序方式、页码和分类列表进行搜索，
/// 并尝试将返回的 JSON 数据解析为 `ComicSearchPageData`。
///
/// # 参数
/// - `content`: 搜索关键词。
/// - `sort`: 排序方式（`Sort` 枚举）。
/// - `page`: 页码（从 1 开始）。
/// - `categories`: 分类列表。
///
/// # 返回
/// - `Ok(ComicSearchPageData)`：请求成功并解析成功时返回搜索结果分页数据。
/// - `Err(CustomError)`：请求失败或解析失败时返回错误信息。
#[frb]
pub async fn picacg_comic_search(
    content: String,
    sort: Sort,
    page: i32,
    categories: Vec<String>,
) -> Result<ComicSearchPageData, CustomError> {
    let response = picacg_request(
        "POST",
        &format!("/comics/advanced-search?page={}", page),
        Some(
            serde_json::json!({
                "keyword": content,
                "sort": sort.as_str(),
                "categories": categories,
            })
            .to_string(),
        ),
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
            let page_data: PageData<ComicSearchEntity> =
                serde_json::from_value(json["data"]["comics"].clone()).map_err(|e| {
                    CustomError {
                        error_code: CustomErrorType::ParseJsonError,
                        error_message: format!("Failed to parse comic search data: {}", e),
                    }
                })?;

            Ok(ComicSearchPageData::from(page_data))
        },
        "comic search api result expected text response".to_string(),
    )
}

/// 获取所有漫画分类。
///
/// 该函数会向 `/categories` 接口发起 GET 请求，
/// 并尝试将返回的 JSON 数据解析为 `Vec<CategoryEntity>`。
///
/// # 返回
/// - `Ok(Vec<CategoryEntity>)`：请求成功并解析成功时返回分类实体列表。
/// - `Err(CustomError)`：请求失败或解析失败时返回错误信息。
#[frb]
pub async fn picacg_comic_category() -> Result<Vec<CategoryEntity>, CustomError> {
    let response = picacg_request("GET", "/categories", None, None, Some(HttpExpectBody::Text))
        .await
        .map_err(|e| CustomError {
            error_code: CustomErrorType::BadRequest,
            error_message: format!("Failed to make request: {}", e),
        })?;

    parse_json_from_text(
        response.body,
        |json| {
            serde_json::from_value(json["data"]["categories"].clone()).map_err(|e| CustomError {
                error_code: CustomErrorType::ParseJsonError,
                error_message: format!("Failed to parse category entities: {}", e),
            })
        },
        "category api result expected text response".to_string(),
    )
}

/// 获取所有漫画分类的 ID 信息。
///
/// 该函数会向 `/init?platform=android` 接口发起 GET 请求，
/// 并尝试将返回的 JSON 数据解析为 `Vec<CategoryIdEntity>`。
///
/// # 返回
/// - `Ok(Vec<CategoryIdEntity>)`：请求成功并解析成功时返回分类 ID 实体列表。
/// - `Err(CustomError)`：请求失败或解析失败时返回错误信息。
#[frb]
pub async fn picacg_comic_init() -> Result<InitEntity, CustomError> {
    let response = picacg_request(
        "GET",
        "/init?platform=android",
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
            serde_json::from_value(json["data"].clone()).map_err(|e| CustomError {
                error_code: CustomErrorType::ParseJsonError,
                error_message: format!("Failed to parse init entities: {}", e),
            })
        },
        "init api result expected text response".to_string(),
    )
}

#[frb]
pub async fn picacg_comic_keywords() -> Result<Vec<String>, CustomError> {
    let response = picacg_request("GET", "/keywords", None, None, Some(HttpExpectBody::Text))
        .await
        .map_err(|e| CustomError {
            error_code: CustomErrorType::BadRequest,
            error_message: format!("Failed to make request: {}", e),
        })?;

    parse_json_from_text(
        response.body,
        |json| {
            serde_json::from_value(json["data"]["keywords"].clone()).map_err(|e| CustomError {
                error_code: CustomErrorType::ParseJsonError,
                error_message: format!("Failed to parse keywords: {}", e),
            })
        },
        "comic keywords api result expected text response".to_string(),
    )
}

#[cfg(test)]
mod tests {
    use crate::api::{
        reqs::comic::{
            picacg_comic_category, picacg_comic_comments, picacg_comic_ep_pictures,
            picacg_comic_eps, picacg_comic_favourite, picacg_comic_info, picacg_comic_init,
            picacg_comic_keywords, picacg_comic_page, picacg_comic_post_child_comment,
            picacg_comic_post_comment, picacg_comic_random, picacg_comic_search,
            picacg_comic_switch_favourite, picacg_comic_switch_like,
        },
        types::sort::Sort,
    };

    #[tokio::test]
    async fn test_picacg_comic_random() {
        let result = picacg_comic_random().await;
        assert!(result.is_err());
    }

    #[tokio::test]
    async fn test_picacg_comic_page() {
        let result = picacg_comic_page(None, None, None, None, Sort::SORT_DEFAULT, 1).await;
        assert!(result.is_err());
    }

    #[tokio::test]
    async fn test_picacg_comic_info() {
        let result = picacg_comic_info("5b6bdf4558ed442d899486b7".to_string()).await;
        assert!(result.is_err());
    }

    #[tokio::test]
    async fn test_picacg_comic_eps() {
        let result = picacg_comic_eps("5b6bdf4558ed442d899486b7".to_string(), 1).await;
        assert!(result.is_err());
    }

    #[tokio::test]
    async fn test_picacg_comic_ep_pictures() {
        let result = picacg_comic_ep_pictures("5b6bdf4558ed442d899486b7".to_string(), 1, 1).await;
        assert!(result.is_err());
    }

    #[tokio::test]
    async fn test_picacg_comic_favourite() {
        let result = picacg_comic_favourite(Sort::SORT_DEFAULT, 1).await;
        assert!(result.is_err());
    }

    #[tokio::test]
    async fn test_picacg_comic_switch_like() {
        let result = picacg_comic_switch_like("5b6bdf4558ed442d899486b7".to_string()).await;
        assert!(result.is_err());
    }

    #[tokio::test]
    async fn test_picacg_comic_switch_favourite() {
        let result = picacg_comic_switch_favourite("5b6bdf4558ed442d899486b7".to_string()).await;
        assert!(result.is_err());
    }

    #[tokio::test]
    async fn test_picacg_comic_comments() {
        let result = picacg_comic_comments("5b6bdf4558ed442d899486b7".to_string(), 1).await;
        assert!(result.is_err());
    }

    #[tokio::test]
    async fn test_picacg_comic_post_comment() {
        let result =
            picacg_comic_post_comment("5b6bdf4558ed442d899486b7".to_string(), "love!".to_string())
                .await;
        assert!(result.is_err());
    }

    #[tokio::test]
    async fn test_picacg_comic_post_child_comment() {
        let result = picacg_comic_post_child_comment(
            "5b6bdf4558ed442d899486b7".to_string(),
            "love child!".to_string(),
        )
        .await;
        assert!(result.is_err());
    }

    #[tokio::test]
    async fn test_picacg_comic_search() {
        let result = picacg_comic_search("test".to_string(), Sort::SORT_DEFAULT, 1, vec![]).await;
        assert!(result.is_err());
    }

    #[tokio::test]
    async fn test_picacg_comic_category() {
        let result = picacg_comic_category().await;
        assert!(result.is_err());
    }

    #[tokio::test]
    async fn test_picacg_comic_init() {
        let result = picacg_comic_init().await;
        assert!(result.is_err());
    }

    #[tokio::test]
    async fn test_picacg_comic_keywords() {
        let result = picacg_comic_keywords().await;
        assert!(result.is_err());
    }
}
