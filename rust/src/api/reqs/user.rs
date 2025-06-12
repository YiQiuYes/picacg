use crate::api::{
    error::custom_error::{CustomError, CustomErrorType},
    types::{login_entity::LoginEntity, profile_entity::ProfileEntity},
    utils::{
        client::{picacg_request, HttpExpectBody},
        parse_json::parse_json_from_text,
    },
};
use flutter_rust_bridge::frb;

/// 登录到 Picacg 平台。
///
/// # 参数
/// - `username`：用户邮箱。
/// - `password`：用户密码。
///
/// # 返回
/// - `Ok(LoginEntity)`：登录成功，返回登录实体。
/// - `Err(CustomError)`：登录失败，返回错误信息。
///
/// # 错误
/// - 当用户名或密码为空时，返回参数错误。
/// - 当 API 请求失败时，返回请求错误。
/// - 当响应体不是文本格式时，返回格式错误。
/// - 当解析登录实体失败时，返回解析错误。
#[frb]
pub async fn picacg_user_login(
    username: String,
    password: String,
) -> Result<LoginEntity, CustomError> {
    if username.is_empty() || password.is_empty() {
        return Err(CustomError {
            error_code: CustomErrorType::ParameterError,
            error_message: "Username or password cannot be empty".to_string(),
        });
    }

    let response = picacg_request(
        "POST",
        "/auth/sign-in",
        Some(
            serde_json::json!({
            "email": username,
            "password": password,
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
            serde_json::from_value(json["data"].clone()).map_err(|e| CustomError {
                error_code: CustomErrorType::ParseJsonError,
                error_message: format!("Failed to parse login entity: {}", e),
            })
        },
        "login api result expected text response".to_string(),
    )
}

/// 注册到 Picacg 平台。
///
/// # 参数
/// - `email`：用户邮箱。
/// - `password`：用户密码。
/// - `name`：用户名。
/// - `birthday`：生日，格式为 yyyy-mm-dd。
/// - `gender`：性别，可选值为 "m"、"f"、"bot"。
/// - `answer1`：安全问题 1 的答案。
/// - `answer2`：安全问题 2 的答案。
/// - `answer3`：安全问题 3 的答案。
/// - `question1`：安全问题 1。
/// - `question2`：安全问题 2。
/// - `question3`：安全问题 3。
///
/// # 返回
/// - `Ok(true)`：注册成功。
/// - `Err(CustomError)`：注册失败，返回错误信息。
///
/// # 错误
/// - 当 API 响应非 200 状态码时，返回错误信息。
/// - 当响应体不是文本格式时，返回错误。
#[frb]
#[allow(clippy::too_many_arguments)]
pub async fn picacg_user_register(
    email: String,
    password: String,
    name: String,
    birthday: String,
    gender: String,
    answer1: String,
    answer2: String,
    answer3: String,
    question1: String,
    question2: String,
    question3: String,
) -> Result<bool, CustomError> {
    let response = picacg_request(
        "POST",
        "/auth/register",
        Some(
            serde_json::json!({
                "email": email,
                "password": password,
                "name": name,
                "birthday": birthday,
                "gender": gender,
                "answer1": answer1,
                "answer2": answer2,
                "answer3": answer3,
                "question1": question1,
                "question2": question2,
                "question3": question3,
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
        |_json| Ok(true),
        "register api result expected text response".to_string(),
    )
}

/// 获取 Picacg 平台的用户个人资料。
///
/// # 返回
/// - `Ok(UserProfileEntity)`：获取成功，返回用户资料实体。
/// - `Err(CustomError)`：获取失败，返回错误信息。
///
/// # 错误
/// - 当 API 响应非 200 状态码时，返回错误信息。
/// - 当响应体不是文本格式时，返回错误。
/// - 当解析用户资料失败时，返回错误。
#[frb]
pub async fn picacg_user_profile() -> Result<ProfileEntity, CustomError> {
    let response = picacg_request(
        "GET",
        "/users/profile",
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
            serde_json::from_value(json["data"]["user"].clone()).map_err(|e| CustomError {
                error_code: CustomErrorType::ParseJsonError,
                error_message: format!("Failed to parse user profile: {}", e),
            })
        },
        "profile api result expected text response".to_string(),
    )
}

/// 用户每日签到（打卡）Picacg 平台。
///
/// # 返回
/// - `Ok(true)`：签到成功。
/// - `Err(CustomError)`：签到失败，返回错误信息。
///
/// # 错误
/// - 当 API 响应非 200 状态码时，返回错误信息。
/// - 当响应体不是文本格式时，返回错误。
#[frb]
pub async fn picacg_user_punch_in() -> Result<bool, CustomError> {
    let response = picacg_request(
        "POST",
        "/users/punch-in",
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
        |_json| Ok(true),
        "punch-in api result expected text response".to_string(),
    )
}

#[cfg(test)]
mod tests {
    use crate::api::reqs::user::{
        picacg_user_login, picacg_user_profile, picacg_user_punch_in, picacg_user_register,
    };

    #[tokio::test]
    async fn test_picacg_login() {
        let result = picacg_user_login("email".to_string(), "password".to_string()).await;
        assert!(result.is_err());
    }

    #[tokio::test]
    async fn test_picacg_register() {
        let result = picacg_user_register(
            "email".to_string(),
            "password".to_string(),
            "name".to_string(),
            "2000-01-01".to_string(),
            "m".to_string(),
            "answer1".to_string(),
            "answer2".to_string(),
            "answer3".to_string(),
            "question1".to_string(),
            "question2".to_string(),
            "question3".to_string(),
        )
        .await;
        assert!(result.is_err());
    }

    #[tokio::test]
    async fn test_picacg_user_profile() {
        let result = picacg_user_profile().await;
        assert!(result.is_err());
    }

    #[tokio::test]
    async fn test_picacg_user_punch_in() {
        let result = picacg_user_punch_in().await;
        assert!(result.is_err());
    }
}
