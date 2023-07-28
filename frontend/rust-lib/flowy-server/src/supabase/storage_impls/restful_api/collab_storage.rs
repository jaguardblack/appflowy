use std::str::FromStr;
use std::sync::Arc;

use anyhow::Error;
use chrono::{DateTime, Utc};
use collab::preclude::merge_updates_v1;
use collab_plugins::cloud_storage::{
  CollabObject, MsgId, RemoteCollabSnapshot, RemoteCollabState, RemoteCollabStorage,
  RemoteUpdateReceiver,
};
use tokio::task::spawn_blocking;

use lib_infra::async_trait::async_trait;
use lib_infra::util::md5;

use crate::supabase::storage_impls::restful_api::request::{
  create_snapshot, get_latest_snapshot_from_server, get_updates_from_server,
  FetchObjectUpdateAction, UpdateItem,
};
use crate::supabase::storage_impls::restful_api::util::{ExtendedResponse, InsertParamsBuilder};
use crate::supabase::storage_impls::restful_api::{PostgresWrapper, SupabaseServerService};
use crate::supabase::storage_impls::{partition_key, table_name};

pub struct RESTfulSupabaseCollabStorageImpl<T>(T);

impl<T> RESTfulSupabaseCollabStorageImpl<T> {
  pub fn new(server: T) -> Self {
    Self(server)
  }
}

#[async_trait]
impl<T> RemoteCollabStorage for RESTfulSupabaseCollabStorageImpl<T>
where
  T: SupabaseServerService,
{
  fn is_enable(&self) -> bool {
    true
  }

  async fn get_all_updates(&self, object: &CollabObject) -> Result<Vec<Vec<u8>>, Error> {
    let postgrest = self.0.try_get_weak_postgrest()?;
    let action = FetchObjectUpdateAction::new(object.id.clone(), object.ty.clone(), postgrest);
    let updates = action.run().await?;
    Ok(updates)
  }

  async fn get_latest_snapshot(&self, object_id: &str) -> Option<RemoteCollabSnapshot> {
    let postgrest = self.0.try_get_postgrest().ok()?;
    get_latest_snapshot_from_server(object_id, postgrest)
      .await
      .ok()?
  }

  async fn get_collab_state(&self, object_id: &str) -> Result<Option<RemoteCollabState>, Error> {
    let postgrest = self.0.try_get_postgrest()?;
    let json = postgrest
      .from("af_collab_state")
      .select("*")
      .eq("oid", object_id)
      .order("snapshot_created_at.desc".to_string())
      .limit(1)
      .execute()
      .await?
      .get_json()
      .await?;

    Ok(
      json
        .as_array()
        .and_then(|array| array.first())
        .and_then(|value| {
          let created_at = value.get("snapshot_created_at").and_then(|created_at| {
            created_at
              .as_str()
              .map(|id| DateTime::<Utc>::from_str(id).ok())
              .and_then(|date| date)
          })?;

          let current_edit_count = value.get("current_edit_count").and_then(|id| id.as_i64())?;
          let last_snapshot_edit_count = value
            .get("last_snapshot_edit_count")
            .and_then(|id| id.as_i64())?;

          Some(RemoteCollabState {
            current_edit_count,
            last_snapshot_edit_count,
            last_snapshot_created_at: created_at.timestamp(),
          })
        }),
    )
  }

  async fn create_snapshot(&self, object: &CollabObject, snapshot: Vec<u8>) -> Result<i64, Error> {
    let postgrest = self.0.try_get_postgrest()?;
    create_snapshot(&postgrest, object, snapshot).await
  }

  async fn send_update(
    &self,
    object: &CollabObject,
    _id: MsgId,
    update: Vec<u8>,
  ) -> Result<(), Error> {
    let postgrest = self.0.try_get_postgrest()?;
    let workspace_id = object
      .get_workspace_id()
      .ok_or(anyhow::anyhow!("Invalid workspace id"))?;
    send_update(workspace_id, object, update, &postgrest).await
  }

  async fn send_init_sync(
    &self,
    object: &CollabObject,
    _id: MsgId,
    init_update: Vec<u8>,
  ) -> Result<(), Error> {
    let postgrest = self.0.try_get_postgrest()?;
    let workspace_id = object
      .get_workspace_id()
      .ok_or(anyhow::anyhow!("Invalid workspace id"))?;

    let update_items = get_updates_from_server(&object.id, &object.ty, postgrest.clone()).await?;

    // If the update_items is empty, we can send the init_update directly
    if update_items.is_empty() {
      send_update(workspace_id, object, init_update, &postgrest).await?;
    } else {
      // 2.Merge the updates into one and then delete the merged updates
      let merge_result = spawn_blocking(move || merge_updates(update_items, init_update)).await??;
      tracing::trace!("Merged updates count: {}", merge_result.merged_keys.len());
      let override_key = merge_result.merged_keys.last().cloned().unwrap();

      let value_size = merge_result.new_update.len() as i32;
      let md5 = md5(&merge_result.new_update);
      let new_update = format!("\\x{}", hex::encode(merge_result.new_update));
      let params = InsertParamsBuilder::new()
        .insert("oid", object.id.clone())
        .insert("new_key", override_key)
        .insert("new_value", new_update)
        .insert("md5", md5)
        .insert("value_size", value_size)
        .insert("partition_key", partition_key(&object.ty))
        .insert("uid", object.uid)
        .insert("workspace_id", workspace_id)
        .insert("removed_keys", merge_result.merged_keys)
        .build();

      postgrest
        .rpc("flush_collab_updates", params)
        .execute()
        .await?
        .success()
        .await?;
    }
    Ok(())
  }

  async fn subscribe_remote_updates(&self, _object: &CollabObject) -> Option<RemoteUpdateReceiver> {
    todo!()
  }
}

async fn send_update(
  workspace_id: String,
  object: &CollabObject,
  update: Vec<u8>,
  postgrest: &Arc<PostgresWrapper>,
) -> Result<(), Error> {
  let value_size = update.len() as i32;
  let md5 = md5(&update);
  let update = format!("\\x{}", hex::encode(update));
  let builder = InsertParamsBuilder::new()
    .insert("oid", object.id.clone())
    .insert("partition_key", partition_key(&object.ty))
    .insert("value", update)
    .insert("uid", object.uid)
    .insert("md5", md5)
    .insert("workspace_id", workspace_id)
    .insert("value_size", value_size);

  let params = builder.build();
  postgrest
    .from(&table_name(&object.ty))
    .insert(params)
    .execute()
    .await?
    .success()
    .await?;
  Ok(())
}

fn merge_updates(update_items: Vec<UpdateItem>, new_update: Vec<u8>) -> Result<MergeResult, Error> {
  let mut updates = vec![];
  let mut merged_keys = vec![];
  for item in update_items {
    merged_keys.push(item.key);
    updates.push(item.value);
  }
  if !new_update.is_empty() {
    updates.push(new_update);
  }
  let updates = updates
    .iter()
    .map(|update| update.as_ref())
    .collect::<Vec<&[u8]>>();

  let new_update = merge_updates_v1(&updates)?;
  Ok(MergeResult {
    merged_keys,
    new_update,
  })
}

struct MergeResult {
  merged_keys: Vec<i64>,
  new_update: Vec<u8>,
}
