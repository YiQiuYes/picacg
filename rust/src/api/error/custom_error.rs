use flutter_rust_bridge::for_generated::anyhow;

#[derive(Debug)]
pub enum CustomErrorType {
    BadRequest,
    ParameterError,
    ParseJsonError,
    UnKnownError,
    ParseError,
    FileReadError,
    FileWriteError,
    SerializeJsonError,
    LockError,
}

#[derive(Debug)]
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
