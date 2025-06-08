use crate::api::types::profile_entity::ProfileEntity;
use crate::api::{
    types::login_entity::LoginEntity,
    utils::client::{picacg_request, HttpExpectBody, HttpResponseBody},
};
use flutter_rust_bridge::{for_generated::anyhow, frb};
use serde_json::Value;

/// 登录到 Picacg 平台。
///
/// # 参数
/// - `username`：用户邮箱或用户名。
/// - `password`：用户密码。
///
/// # 返回
/// - `Ok(LoginEntity)`：登录成功，返回登录实体。
/// - `Err(anyhow::Error)`：登录失败，返回错误信息。
///
/// # 错误
/// - 当用户名或密码为空时，返回错误。
/// - 当 API 响应非 200 状态码时，返回错误信息。
/// - 当响应体不是文本格式时，返回错误。
#[frb]
pub async fn picacg_user_login(
    username: String,
    password: String,
) -> Result<LoginEntity, anyhow::Error> {
    if username.is_empty() || password.is_empty() {
        return Err(anyhow::anyhow!("Username or password cannot be empty"));
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
    .await?;

    if let HttpResponseBody::Text(text) = response.body {
        let json: Value = serde_json::from_str(&text)?;

        match json["code"].as_i64() {
            Some(200) => {
                let login_entity: LoginEntity = serde_json::from_value(json["data"].clone())
                    .map_err(|e| anyhow::anyhow!("Failed to parse login entity: {}", e))?;
                Ok(login_entity)
            }
            _ => Err(anyhow::anyhow!(json["message"].clone())),
        }
    } else {
        Err(anyhow::anyhow!("login api result expected text response"))
    }
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
/// - `Err(anyhow::Error)`：注册失败，返回错误信息。
///
/// # 错误
/// - 当 API 响应非 200 状态码时，返回错误信息。
/// - 当响应体不是文本格式时，返回错误。
#[frb]
pub async fn picacg_user_register(
    email: String,
    password: String,
    name: String,
    birthday: String,
    gender: String, // [m, f, bot]
    answer1: String,
    answer2: String,
    answer3: String,
    question1: String,
    question2: String,
    question3: String,
) -> Result<bool, anyhow::Error> {
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
    .await?;

    let json: Value = match response.body {
        HttpResponseBody::Text(text) => serde_json::from_str(&text)?,
        _ => {
            return Err(anyhow::anyhow!(
                "register api result expected text response"
            ))
        }
    };

    match json["code"].as_i64() {
        Some(200) => Ok(true),
        _ => Err(anyhow::anyhow!(json["message"].clone())),
    }
}

/// 获取 Picacg 平台的用户个人资料。
///
/// # 返回
/// - `Ok(UserProfileEntity)`：获取成功，返回用户资料实体。
/// - `Err(anyhow::Error)`：获取失败，返回错误信息。
///
/// # 错误
/// - 当 API 响应非 200 状态码时，返回错误信息。
/// - 当响应体不是文本格式时，返回错误。
/// - 当解析用户资料失败时，返回错误。
#[frb]
pub async fn picacg_user_profile() -> Result<ProfileEntity, anyhow::Error> {
    let response = picacg_request(
        "GET",
        "/users/profile",
        None,
        None,
        Some(HttpExpectBody::Text),
    )
    .await?;

    let json: Value = match response.body {
        HttpResponseBody::Text(text) => serde_json::from_str(&text)?,
        _ => return Err(anyhow::anyhow!("profile api result expected text response")),
    };

    match json["code"].as_i64() {
        Some(200) => {
            let user_profile: ProfileEntity =
                serde_json::from_value(json["data"]["user"].clone())
                    .map_err(|e| anyhow::anyhow!("Failed to parse user profile: {}", e))?;
            Ok(user_profile)
        }
        _ => Err(anyhow::anyhow!(json["message"].clone())),
    }
}

/// 用户每日签到（打卡）Picacg 平台。
///
/// # 返回
/// - `Ok(true)`：签到成功。
/// - `Err(anyhow::Error)`：签到失败，返回错误信息。
///
/// # 错误
/// - 当 API 响应非 200 状态码时，返回错误信息。
/// - 当响应体不是文本格式时，返回错误。
#[frb]
pub async fn picacg_user_punch_in() -> Result<bool, anyhow::Error> {
    let response = picacg_request(
        "POST",
        "/users/punch-in",
        Some("{}".to_string()),
        None,
        Some(HttpExpectBody::Text),
    )
    .await?;

    let json: Value = match response.body {
        HttpResponseBody::Text(text) => serde_json::from_str(&text)?,
        _ => {
            return Err(anyhow::anyhow!(
                "punch-in api result expected text response"
            ))
        }
    };

    match json["code"].as_i64() {
        Some(200) => Ok(true),
        _ => Err(anyhow::anyhow!(json["message"].clone())),
    }
}

#[cfg(test)]
mod tests {
    use crate::api::reqs::user::{
        picacg_user_login, picacg_user_profile, picacg_user_punch_in, picacg_user_register,
    };

    #[tokio::test]
    async fn test_picacg_login() {
        let result = picacg_user_login("email".to_string(), "password".to_string()).await;
        assert_eq!(result.is_err(), true);
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

        assert_eq!(result.is_err(), true);
    }

    #[tokio::test]
    async fn test_picacg_user_profile() {
        let result = picacg_user_profile().await;
        assert_eq!(result.is_err(), true);
    }

    #[tokio::test]
    async fn test_picacg_user_punch_in() {
        let result = picacg_user_punch_in().await;
        assert_eq!(result.is_err(), true);
    }
}
