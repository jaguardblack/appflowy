use std::ops::Deref;

use crate::util::AFCloudTest;

pub struct AFCloudDocumentTest {
  inner: AFCloudTest,
}

impl AFCloudDocumentTest {
  pub async fn new() -> Option<Self> {
    let inner = AFCloudTest::new().await?;
    inner.af_cloud_sign_up().await;
    Some(Self { inner })
  }

  pub async fn create_document(&self) -> String {
    let current_workspace = self.inner.get_current_workspace().await;
    let view = self
      .inner
      .create_document(&current_workspace.id, "my document".to_string(), vec![])
      .await;
    view.id
  }
}

impl Deref for AFCloudDocumentTest {
  type Target = AFCloudTest;

  fn deref(&self) -> &Self::Target {
    &self.inner
  }
}
