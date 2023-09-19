use serde::{Deserialize, Serialize};

use flowy_error::{ErrorCode, FlowyError};

pub const AF_CLOUD_BASE_URL: &str = "AF_CLOUD_BASE_URL";
pub const AF_CLOUD_WS_BASE_URL: &str = "AF_CLOUD_WS_BASE_URL";

#[derive(Debug, Serialize, Deserialize, Clone, Default)]
pub struct AFCloudConfiguration {
  pub base_url: String,
  pub ws_base_url: String,
}

impl AFCloudConfiguration {
  pub fn from_env() -> Result<Self, FlowyError> {
    let base_url = std::env::var(AF_CLOUD_BASE_URL)
      .map_err(|_| FlowyError::new(ErrorCode::InvalidAuthConfig, "Missing AF_CLOUD_BASE_URL"))?;

    let ws_base_url = std::env::var(AF_CLOUD_WS_BASE_URL)
      .map_err(|_| FlowyError::new(ErrorCode::InvalidAuthConfig, "Missing AF_CLOUD_WS_BASE_URL"))?;

    Ok(Self {
      base_url,
      ws_base_url,
    })
  }

  /// Write the configuration to the environment variables.
  pub fn write_env(&self) {
    std::env::set_var(AF_CLOUD_BASE_URL, &self.base_url);
    std::env::set_var(AF_CLOUD_WS_BASE_URL, &self.ws_base_url);
  }
}
