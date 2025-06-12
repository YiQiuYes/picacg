use flutter_rust_bridge::for_generated::anyhow;

pub enum CustomErrorType {
    BadRequest,
    ParameterError,
    ParseJsonError,
    UnKnownError,
    ParseError,
}

pub struct CustomError {
    pub error_code: CustomErrorType,
    pub error_message: String,
}

impl From<anyhow::Error> for CustomError {
    fn from(error: anyhow::Error) -> Self {
        CustomError {
            error_code: CustomErrorType::UnKnownError,
            error_message: error.to_string(),
        }
    }
}
