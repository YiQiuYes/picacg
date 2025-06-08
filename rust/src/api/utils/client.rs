use crate::api::utils::crypto::hmac_hex;
use chrono::prelude::Local;
use flutter_rust_bridge::{for_generated::anyhow, frb};
use reqwest::{
    header::{HeaderName, HeaderValue},
    Method, Url,
};
use reqwest_middleware::{ClientBuilder, ClientWithMiddleware};
use reqwest_retry::{policies::ExponentialBackoff, RetryTransientMiddleware};
use std::{
    str::FromStr,
    sync::{LazyLock, RwLock},
    time::Duration,
};

const HOST_URL: &str = "https://picaapi.picacomic.com";
const API_KEY: &str = "C69BAF41DA5ABD1FFEDC6D2FEA56B";
const NONCE: &str = "b1ab87b4800d4d4590a11701b8551afa";
const DIGEST_KEY: &str = "~d}$Q7$eIni=V)9\\RK/P.RM4;9[7|@/CA}b~OW!3?EV`:<>M7pddUBL5n|0/*Cn";

struct Client {
    client: LazyLock<ClientWithMiddleware>,
    token: RwLock<String>,
}

static CLIENT: Client = Client {
    client: LazyLock::new(|| {
        ClientBuilder::new(
            reqwest::Client::builder()
                .danger_accept_invalid_certs(true)
                .build()
                .unwrap(),
        )
        .with(RetryTransientMiddleware::new_with_policy(
            ExponentialBackoff::builder().build_with_max_retries(2),
        ))
        .build()
    }),
    token: RwLock::new(String::new()),
};

#[derive(Debug)]
pub enum HttpResponseBody {
    Text(String),
    Bytes(Vec<u8>),
}

pub enum HttpExpectBody {
    Text,
    Bytes,
}

pub struct HttpResponse {
    pub headers: Vec<(String, String)>,
    pub status_code: u16,
    pub body: HttpResponseBody,
}

#[frb]
pub async fn send_request(
    method: &str,
    url: &str,
    headers: Option<Vec<(String, String)>>,
    payload: Option<String>,
    query: Option<Vec<(String, String)>>,
    expect_body: Option<HttpExpectBody>,
) -> Result<HttpResponse, anyhow::Error> {
    let method = match method.to_uppercase().as_str() {
        "GET" => Method::GET,
        "POST" => Method::POST,
        "PUT" => Method::PUT,
        "DELETE" => Method::DELETE,
        _ => Method::GET,
    };

    let mut request = CLIENT
        .client
        .request(method, url)
        .timeout(Duration::from_secs(5));
    if let Some(headers) = headers {
        for (k, v) in headers {
            let header_name =
                HeaderName::from_str(&k).map_err(|e| anyhow::anyhow!(e.to_string()))?;
            let header_value =
                HeaderValue::from_str(&v).map_err(|e| anyhow::anyhow!(e.to_string()))?;
            request = request.header(header_name, header_value);
        }
    }

    if let Some(body) = payload {
        request = request.body(body);
    }

    if let Some(query) = query {
        request = request.query(&query);
    }

    match request.send().await {
        Ok(response) => {
            let status_code = response.status().as_u16();
            let headers = response
                .headers()
                .iter()
                .map(|(k, v)| (k.to_string(), v.to_str().unwrap_or("").to_string()))
                .collect();

            let body = match expect_body {
                Some(HttpExpectBody::Text) => {
                    let text = response.text().await?;
                    HttpResponseBody::Text(text)
                }
                Some(HttpExpectBody::Bytes) => {
                    let bytes = response.bytes().await?.to_vec();
                    HttpResponseBody::Bytes(bytes)
                }
                None => {
                    let text = response.text().await?;
                    HttpResponseBody::Text(text)
                }
            };

            Ok(HttpResponse {
                headers,
                status_code,
                body,
            })
        }
        Err(error) => Err(anyhow::anyhow!(error)),
    }
}

#[frb]
pub async fn picacg_request(
    method: &str,
    url: &str,
    payload: Option<String>,
    query: Option<Vec<(String, String)>>,
    expect_body: Option<HttpExpectBody>,
) -> Result<HttpResponse, anyhow::Error> {
    let time = Local::now().timestamp().to_string();
    let url = match url.starts_with("/") {
        true => url.trim_start_matches("/").to_owned(),
        false => url.to_owned(),
    };

    let mut headers: Vec<(String, String)> = vec![
        ("api-key".to_string(), API_KEY.to_string()),
        (
            "accept".to_string(),
            "application/vnd.picacomic.com.v1+json".to_string(),
        ),
        ("app-channel".to_string(), "2".to_string()),
        ("time".to_string(), time.to_string()),
        ("nonce".to_string(), NONCE.to_string()),
        ("app-version".to_string(), "2.2.1.2.3.3".to_string()),
        ("app-uuid".to_string(), "defaultUuid".to_string()),
        ("app-platform".to_string(), "android".to_string()),
        ("app-build-version".to_string(), "44".to_string()),
        (
            "Content-Type".to_string(),
            "application/json; charset=UTF-8".to_string(),
        ),
        ("User-Agent".to_string(), "okhttp/3.8.1".to_string()),
        ("image-quality".to_string(), "original".to_string()),
        (
            "signature".to_string(),
            hmac_hex(
                DIGEST_KEY,
                ("".to_string() + url.as_str() + time.as_str() + NONCE + method + API_KEY)
                    .to_lowercase()
                    .as_str(),
            ),
        ),
    ];

    let token = get_picacg_token();
    if !token.is_empty() {
        headers.push(("authorization".to_string(), token));
    }

    let base_url = Url::parse(HOST_URL)?;
    let url = base_url.join(url.as_str())?;

    send_request(
        method,
        url.as_str(),
        Some(headers),
        payload,
        query,
        expect_body,
    )
    .await
}

#[frb(sync)]
pub fn set_picacg_token(token: String) {
    if let Ok(mut token_guard) = CLIENT.token.write() {
        *token_guard = token;
    }
}

#[frb(sync)]
pub fn get_picacg_token() -> String {
    if let Ok(token_guard) = CLIENT.token.read() {
        token_guard.clone()
    } else {
        String::new()
    }
}

#[cfg(test)]
mod tests {
    use crate::api::utils::client::{
        picacg_request, send_request, HttpExpectBody, HttpResponseBody, HOST_URL,
    };
    use serde_json::Value;

    #[tokio::test]
    async fn test_send_request() {
        let response = send_request(
            "GET",
            HOST_URL,
            None,
            None,
            None,
            Some(HttpExpectBody::Text),
        )
        .await;

        match response {
            Ok(res) => {
                assert_eq!(res.status_code, 400);

                if let HttpResponseBody::Text(text) = res.body {
                    let json: Value = serde_json::from_str(&text).unwrap();
                    assert_eq!(json["code"], 400);
                } else {
                    panic!("Expected text response");
                }
            }
            Err(err) => panic!("{:?}", err),
        }
    }

    #[tokio::test]
    async fn test_picacg_request() {
        let response = picacg_request(
            "POST",
            "/auth/sign-in",
            Some(
                serde_json::json!({
                "email": "email",
                "password": "password",
                })
                .to_string(),
            ),
            None,
            Some(HttpExpectBody::Text),
        )
        .await;

        match response {
            Ok(res) => {
                assert_eq!(res.status_code, 400);

                if let HttpResponseBody::Text(text) = res.body {
                    let json: Value = serde_json::from_str(&text).unwrap();
                    assert_eq!(json["code"], 400);
                    assert_eq!(json["error"], "1004");
                } else {
                    panic!("Expected text response");
                }
            }
            Err(err) => panic!("{:?}", err),
        }
    }
}
