use std::convert::TryFrom;
use std::sync::Arc;

use collab_entity::{CollabObject, CollabType};
use tracing::{error, instrument};

use flowy_error::{FlowyError, FlowyResult};
use flowy_sqlite::schema::user_workspace_table;
use flowy_sqlite::{query_dsl::*, ConnectionPool, ExpressionMethods};
use flowy_user_pub::entities::{Role, UserWorkspace, WorkspaceMember};
use lib_dispatch::prelude::af_spawn;

use crate::entities::{RepeatedUserWorkspacePB, ResetWorkspacePB};
use crate::notification::{send_notification, UserNotification};
use crate::services::sqlite_sql::workspace_sql::UserWorkspaceTable;
use crate::user_manager::UserManager;

impl UserManager {
  #[instrument(skip(self), err)]
  pub async fn open_workspace(&self, workspace_id: &str) -> FlowyResult<()> {
    let uid = self.user_id()?;
    let _ = self
      .cloud_services
      .get_user_service()?
      .open_workspace(workspace_id)
      .await;
    if let Some(user_workspace) = self.get_user_workspace(uid, workspace_id) {
      if let Err(err) = self
        .user_status_callback
        .read()
        .await
        .open_workspace(uid, &user_workspace)
        .await
      {
        error!("Open workspace failed: {:?}", err);
      }
    }
    Ok(())
  }

  pub async fn add_workspace_member(
    &self,
    user_email: String,
    workspace_id: String,
  ) -> FlowyResult<()> {
    self
      .cloud_services
      .get_user_service()?
      .add_workspace_member(user_email, workspace_id)
      .await?;
    Ok(())
  }

  pub async fn remove_workspace_member(
    &self,
    user_email: String,
    workspace_id: String,
  ) -> FlowyResult<()> {
    self
      .cloud_services
      .get_user_service()?
      .remove_workspace_member(user_email, workspace_id)
      .await?;
    Ok(())
  }

  pub async fn get_workspace_members(
    &self,
    workspace_id: String,
  ) -> FlowyResult<Vec<WorkspaceMember>> {
    let members = self
      .cloud_services
      .get_user_service()?
      .get_workspace_members(workspace_id)
      .await?;
    Ok(members)
  }

  pub async fn update_workspace_member(
    &self,
    user_email: String,
    workspace_id: String,
    role: Role,
  ) -> FlowyResult<()> {
    self
      .cloud_services
      .get_user_service()?
      .update_workspace_member(user_email, workspace_id, role)
      .await?;
    Ok(())
  }

  pub fn get_user_workspace(&self, uid: i64, workspace_id: &str) -> Option<UserWorkspace> {
    let mut conn = self.db_connection(uid).ok()?;
    let row = user_workspace_table::dsl::user_workspace_table
      .filter(user_workspace_table::id.eq(workspace_id))
      .first::<UserWorkspaceTable>(&mut *conn)
      .ok()?;
    Some(UserWorkspace::from(row))
  }

  pub fn get_all_user_workspaces(&self, uid: i64) -> FlowyResult<Vec<UserWorkspace>> {
    let mut conn = self.db_connection(uid)?;
    let rows = user_workspace_table::dsl::user_workspace_table
      .filter(user_workspace_table::uid.eq(uid))
      .load::<UserWorkspaceTable>(&mut *conn)?;

    if let Ok(service) = self.cloud_services.get_user_service() {
      if let Ok(pool) = self.db_pool(uid) {
        af_spawn(async move {
          if let Ok(new_user_workspaces) = service.get_all_workspace(uid).await {
            let _ = save_user_workspaces(uid, pool, &new_user_workspaces);
            let repeated_workspace_pbs = RepeatedUserWorkspacePB::from(new_user_workspaces);
            send_notification(&uid.to_string(), UserNotification::DidUpdateUserWorkspaces)
              .payload(repeated_workspace_pbs)
              .send();
          }
        });
      }
    }
    Ok(rows.into_iter().map(UserWorkspace::from).collect())
  }

  /// Reset the remote workspace using local workspace data. This is useful when a user wishes to
  /// open a workspace on a new device that hasn't fully synchronized with the server.
  pub async fn reset_workspace(&self, reset: ResetWorkspacePB) -> FlowyResult<()> {
    let collab_object = CollabObject::new(
      reset.uid,
      reset.workspace_id.clone(),
      CollabType::Folder,
      reset.workspace_id.clone(),
      self.authenticate_user.user_config.device_id.clone(),
    );
    self
      .cloud_services
      .get_user_service()?
      .reset_workspace(collab_object)
      .await?;
    Ok(())
  }
}

pub fn save_user_workspaces(
  uid: i64,
  pool: Arc<ConnectionPool>,
  user_workspaces: &[UserWorkspace],
) -> FlowyResult<()> {
  let user_workspaces = user_workspaces
    .iter()
    .flat_map(|user_workspace| UserWorkspaceTable::try_from((uid, user_workspace)).ok())
    .collect::<Vec<UserWorkspaceTable>>();

  let mut conn = pool.get()?;
  conn.immediate_transaction(|conn| {
    for user_workspace in user_workspaces {
      if let Err(err) = diesel::update(
        user_workspace_table::dsl::user_workspace_table
          .filter(user_workspace_table::id.eq(user_workspace.id.clone())),
      )
      .set((
        user_workspace_table::name.eq(&user_workspace.name),
        user_workspace_table::created_at.eq(&user_workspace.created_at),
        user_workspace_table::database_storage_id.eq(&user_workspace.database_storage_id),
      ))
      .execute(conn)
      .and_then(|rows| {
        if rows == 0 {
          let _ = diesel::insert_into(user_workspace_table::table)
            .values(user_workspace)
            .execute(conn)?;
        }
        Ok(())
      }) {
        tracing::error!("Error saving user workspace: {:?}", err);
      }
    }
    Ok::<(), FlowyError>(())
  })
}
