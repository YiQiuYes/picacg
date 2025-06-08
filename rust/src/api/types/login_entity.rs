use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize, Debug)]
pub struct LoginEntity {
    pub token: String,
}
