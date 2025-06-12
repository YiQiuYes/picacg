use crate::api::{
    error::custom_error::{CustomError, CustomErrorType},
    utils::client::HttpResponseBody,
};
use serde_json::Value;

pub fn parse_json_from_text<T, F>(
    body: HttpResponseBody,
    parse_fn: F,
    no_text_error_message: String,
) -> Result<T, CustomError>
where
    F: Fn(Value) -> Result<T, CustomError>,
{
    if let HttpResponseBody::Text(text) = body {
        let json: Value = serde_json::from_str(&text).map_err(|e| CustomError {
            error_code: CustomErrorType::ParseJsonError,
            error_message: format!("Failed to parse JSON response: {}", e),
        })?;

        match json["code"].as_i64() {
            Some(200) => {
                let result = parse_fn(json).map_err(|e| CustomError {
                    error_code: e.error_code,
                    error_message: e.error_message,
                })?;
                Ok(result)
            }
            _ => Err(CustomError {
                error_code: CustomErrorType::ParseJsonError,
                error_message: json["message"].clone().to_string(),
            }),
        }
    } else {
        Err(CustomError {
            error_code: CustomErrorType::BadRequest,
            error_message: no_text_error_message,
        })
    }
}
