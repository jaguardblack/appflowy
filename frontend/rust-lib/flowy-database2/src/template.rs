use collab_database::database::{gen_database_id, gen_database_view_id, gen_row_id, timestamp};
use collab_database::rows::CreateRowParams;
use collab_database::views::{
  CreateDatabaseParams, CreateViewParams, DatabaseLayout, LayoutSettings,
};

use crate::entities::FieldType;
use crate::services::cell::{insert_select_option_cell, insert_text_cell};
use crate::services::field::{
  FieldBuilder, SelectOption, SelectOptionColor, SingleSelectTypeOption,
};
use crate::services::field_settings::default_field_settings_for_fields;
use crate::services::setting::{BoardLayoutSetting, CalendarLayoutSetting};

pub fn make_default_grid(name: &str) -> CreateDatabaseParams {
  let database_id = gen_database_id();

  let text_field = FieldBuilder::from_field_type(FieldType::RichText)
    .name("Name")
    .visibility(true)
    .primary(true)
    .build();

  let single_select = FieldBuilder::from_field_type(FieldType::SingleSelect)
    .name("Type")
    .visibility(true)
    .build();

  let checkbox_field = FieldBuilder::from_field_type(FieldType::Checkbox)
    .name("Done")
    .visibility(true)
    .build();

  let fields = vec![text_field, single_select, checkbox_field];

  let field_settings = default_field_settings_for_fields(&fields, DatabaseLayout::Grid);

  let timestamp = timestamp();

  CreateDatabaseParams {
    database_id: database_id.clone(),
    inline_view_id: gen_database_view_id(),
    rows: vec![
      CreateRowParams::new(gen_row_id()),
      CreateRowParams::new(gen_row_id()),
      CreateRowParams::new(gen_row_id()),
    ],
    fields,
    views: vec![CreateViewParams {
      database_id,
      view_id: gen_database_view_id(),
      name: name.to_string(),
      layout: DatabaseLayout::Grid,
      layout_settings: Default::default(),
      filters: vec![],
      group_settings: vec![],
      sorts: vec![],
      deps_field_setting: vec![],
      deps_fields: vec![],
      field_settings,
      created_at: timestamp,
      modified_at: timestamp,
    }],
  }
}

pub fn make_default_board(name: &str) -> CreateDatabaseParams {
  let database_id = gen_database_id();

  // text
  let text_field = FieldBuilder::from_field_type(FieldType::RichText)
    .name("Description")
    .visibility(true)
    .primary(true)
    .build();
  let text_field_id = text_field.id.clone();

  // single select
  let to_do_option = SelectOption::with_color("To Do", SelectOptionColor::Purple);
  let doing_option = SelectOption::with_color("Doing", SelectOptionColor::Orange);
  let done_option = SelectOption::with_color("Done", SelectOptionColor::Yellow);
  let mut single_select_type_option = SingleSelectTypeOption::default();
  single_select_type_option
    .options
    .extend(vec![to_do_option.clone(), doing_option, done_option]);
  let single_select = FieldBuilder::new(FieldType::SingleSelect, single_select_type_option)
    .name("Status")
    .visibility(true)
    .build();
  let single_select_field_id = single_select.id.clone();

  let mut rows = vec![];
  for i in 0..3 {
    let mut row = CreateRowParams::new(gen_row_id());
    row.cells.insert(
      single_select_field_id.clone(),
      insert_select_option_cell(vec![to_do_option.id.clone()], &single_select),
    );
    row.cells.insert(
      text_field_id.clone(),
      insert_text_cell(format!("Card {}", i + 1), &text_field),
    );
    rows.push(row);
  }

  let fields = vec![text_field, single_select];

  let field_settings = default_field_settings_for_fields(&fields, DatabaseLayout::Board);

  let mut layout_settings = LayoutSettings::default();
  layout_settings.insert(DatabaseLayout::Board, BoardLayoutSetting::new().into());

  let timestamp = timestamp();

  CreateDatabaseParams {
    database_id: database_id.clone(),
    inline_view_id: gen_database_view_id(),
    rows,
    fields,
    views: vec![CreateViewParams {
      database_id,
      view_id: gen_database_view_id(),
      name: name.to_string(),
      layout: DatabaseLayout::Board,
      layout_settings,
      filters: vec![],
      group_settings: vec![],
      sorts: vec![],
      deps_field_setting: vec![],
      deps_fields: vec![],
      field_settings,
      created_at: timestamp,
      modified_at: timestamp,
    }],
  }
}

pub fn make_default_calendar(name: &str) -> CreateDatabaseParams {
  let database_id = gen_database_id();

  // text
  let text_field = FieldBuilder::from_field_type(FieldType::RichText)
    .name("Title")
    .visibility(true)
    .primary(true)
    .build();

  // date
  let date_field = FieldBuilder::from_field_type(FieldType::DateTime)
    .name("Date")
    .visibility(true)
    .build();
  let date_field_id = date_field.id.clone();

  // multi select
  let multi_select_field = FieldBuilder::from_field_type(FieldType::MultiSelect)
    .name("Tags")
    .visibility(true)
    .build();

  let fields = vec![text_field, date_field, multi_select_field];

  let field_settings = default_field_settings_for_fields(&fields, DatabaseLayout::Calendar);

  let mut layout_settings = LayoutSettings::default();
  layout_settings.insert(
    DatabaseLayout::Calendar,
    CalendarLayoutSetting::new(date_field_id).into(),
  );

  let timestamp = timestamp();

  CreateDatabaseParams {
    database_id: database_id.clone(),
    inline_view_id: gen_database_view_id(),
    rows: vec![],
    fields,
    views: vec![CreateViewParams {
      database_id,
      view_id: gen_database_view_id(),
      name: name.to_string(),
      layout: DatabaseLayout::Calendar,
      layout_settings,
      filters: vec![],
      group_settings: vec![],
      sorts: vec![],
      deps_field_setting: vec![],
      deps_fields: vec![],
      field_settings,
      created_at: timestamp,
      modified_at: timestamp,
    }],
  }
}
