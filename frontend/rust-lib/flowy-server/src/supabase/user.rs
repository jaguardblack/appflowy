use std::sync::Arc;

use postgrest::Postgrest;

use flowy_error::FlowyError;
use flowy_user::entities::{SignInResponse, SignUpResponse, UpdateUserProfileParams, UserProfile};
use flowy_user::event_map::UserAuthService;
use lib_infra::box_any::BoxAny;
use lib_infra::future::FutureResult;

use crate::supabase::request::*;

pub(crate) const USER_TABLE: &str = "user";
pub(crate) const USER_PROFILE_TABLE: &str = "user_profile";
pub(crate) struct PostgrestUserAuthServiceImpl {
  postgrest: Arc<Postgrest>,
}

impl PostgrestUserAuthServiceImpl {
  pub(crate) fn new(postgrest: Arc<Postgrest>) -> Self {
    Self { postgrest }
  }
}

impl UserAuthService for PostgrestUserAuthServiceImpl {
  fn sign_up(&self, params: BoxAny) -> FutureResult<SignUpResponse, FlowyError> {
    let postgrest = self.postgrest.clone();
    FutureResult::new(async move {
      let uuid = uuid_from_box_any(params)?;
      let uid = create_user_with_uuid(postgrest, uuid).await?;
      Ok(SignUpResponse {
        user_id: uid,
        ..Default::default()
      })
    })
  }

  fn sign_in(&self, params: BoxAny) -> FutureResult<SignInResponse, FlowyError> {
    let postgrest = self.postgrest.clone();
    FutureResult::new(async move {
      let uuid = uuid_from_box_any(params)?;
      match get_user_id_with_uuid(postgrest, uuid).await? {
        None => Err(FlowyError::user_not_exist()),
        Some(uid) => Ok(SignInResponse {
          user_id: uid,
          ..Default::default()
        }),
      }
    })
  }

  fn sign_out(&self, _token: Option<String>) -> FutureResult<(), FlowyError> {
    FutureResult::new(async { Ok(()) })
  }

  fn update_user(
    &self,
    _uid: i64,
    _token: &Option<String>,
    params: UpdateUserProfileParams,
  ) -> FutureResult<(), FlowyError> {
    let postgrest = self.postgrest.clone();
    FutureResult::new(async move {
      let _ = update_user_profile(postgrest, params).await?;
      Ok(())
    })
  }

  fn get_user_profile(
    &self,
    _token: Option<String>,
    uid: i64,
  ) -> FutureResult<Option<UserProfile>, FlowyError> {
    let postgrest = self.postgrest.clone();
    FutureResult::new(async move {
      let profile = get_user_profile(postgrest, uid)
        .await?
        .map(|profile| UserProfile {
          id: profile.id,
          email: profile.email,
          name: profile.name,
          token: "".to_string(),
          icon_url: "".to_string(),
          openai_key: "".to_string(),
        });
      Ok(profile)
    })
  }
}

#[cfg(test)]
mod tests {
  use std::sync::Arc;

  use dotenv::dotenv;

  use flowy_user::entities::UpdateUserProfileParams;

  use crate::supabase::request::get_user_profile;
  use crate::supabase::user::{create_user_with_uuid, get_user_id_with_uuid, update_user_profile};
  use crate::supabase::{SupabaseServer, SupabaseServerConfiguration};

  #[tokio::test]
  async fn read_user_table_test() {
    dotenv().ok();
    if let Ok(config) = SupabaseServerConfiguration::from_env() {
      let server = Arc::new(SupabaseServer::new(config));
      let uid = get_user_id_with_uuid(
        server.postgres.clone(),
        "c8c674fc-506f-403c-b052-209e09817f6e".to_string(),
      )
      .await
      .unwrap();
      println!("uid: {:?}", uid);
    }
  }

  #[tokio::test]
  async fn insert_user_table_test() {
    dotenv().ok();
    if let Ok(config) = SupabaseServerConfiguration::from_env() {
      let server = Arc::new(SupabaseServer::new(config));
      let uuid = uuid::Uuid::new_v4();
      // let uuid = "c8c674fc-506f-403c-b052-209e09817f6e";
      let uid = create_user_with_uuid(server.postgres.clone(), uuid.to_string()).await;
      println!("uid: {:?}", uid);
    }
  }

  #[tokio::test]
  async fn create_and_then_update_user_profile_test() {
    dotenv().ok();
    if let Ok(config) = SupabaseServerConfiguration::from_env() {
      let server = Arc::new(SupabaseServer::new(config));
      let uuid = uuid::Uuid::new_v4();
      let uid = create_user_with_uuid(server.postgres.clone(), uuid.to_string())
        .await
        .unwrap();
      let params = UpdateUserProfileParams {
        id: uid,
        name: Some("nathan".to_string()),
        ..Default::default()
      };
      let result = update_user_profile(server.postgres.clone(), params)
        .await
        .unwrap();
      println!("result: {:?}", result);

      let result = get_user_profile(server.postgres.clone(), uid)
        .await
        .unwrap()
        .unwrap();
      assert_eq!(result.name, "nathan".to_string());
    }
  }
}
