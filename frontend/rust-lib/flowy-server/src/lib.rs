use std::sync::Arc;

use appflowy_integrate::RemoteCollabStorage;

use flowy_database2::deps::DatabaseCloudService;
use flowy_document2::deps::DocumentCloudService;
use flowy_folder2::deps::FolderCloudService;
use flowy_user::event_map::UserService;

pub mod local_server;
mod request;
mod response;
pub mod self_host;
pub mod supabase;
pub mod util;

pub trait AppFlowyServer: Send + Sync + 'static {
  fn enable_sync(&self, _enable: bool) {}
  fn user_service(&self) -> Arc<dyn UserService>;
  fn folder_service(&self) -> Arc<dyn FolderCloudService>;
  fn database_service(&self) -> Arc<dyn DatabaseCloudService>;
  fn document_service(&self) -> Arc<dyn DocumentCloudService>;
  fn collab_storage(&self) -> Option<Arc<dyn RemoteCollabStorage>>;
}
