use flowy_derive::{ProtoBuf, ProtoBuf_Enum};
use flowy_error::ErrorCode;

use crate::entities::parser::NotEmptyStr;
use crate::services::setting::{CalendarLayout, CalendarLayoutSetting};

use super::DateCellDataPB;

#[derive(Debug, Clone, Eq, PartialEq, Default, ProtoBuf)]
pub struct CalendarLayoutSettingPB {
  #[pb(index = 1)]
  pub field_id: String,

  #[pb(index = 2)]
  pub layout_ty: CalendarLayoutPB,

  #[pb(index = 3)]
  pub first_day_of_week: i32,

  #[pb(index = 4)]
  pub show_weekends: bool,

  #[pb(index = 5)]
  pub show_week_numbers: bool,
}

impl std::convert::From<CalendarLayoutSettingPB> for CalendarLayoutSetting {
  fn from(pb: CalendarLayoutSettingPB) -> Self {
    CalendarLayoutSetting {
      layout_ty: pb.layout_ty.into(),
      first_day_of_week: pb.first_day_of_week,
      show_weekends: pb.show_weekends,
      show_week_numbers: pb.show_week_numbers,
      field_id: pb.field_id,
    }
  }
}

impl std::convert::From<CalendarLayoutSetting> for CalendarLayoutSettingPB {
  fn from(params: CalendarLayoutSetting) -> Self {
    CalendarLayoutSettingPB {
      field_id: params.field_id,
      layout_ty: params.layout_ty.into(),
      first_day_of_week: params.first_day_of_week,
      show_weekends: params.show_weekends,
      show_week_numbers: params.show_week_numbers,
    }
  }
}

#[derive(Debug, Clone, Eq, PartialEq, Default, ProtoBuf_Enum)]
#[repr(u8)]
pub enum CalendarLayoutPB {
  #[default]
  MonthLayout = 0,
  WeekLayout = 1,
  DayLayout = 2,
}

impl std::convert::From<CalendarLayoutPB> for CalendarLayout {
  fn from(pb: CalendarLayoutPB) -> Self {
    match pb {
      CalendarLayoutPB::MonthLayout => CalendarLayout::Month,
      CalendarLayoutPB::WeekLayout => CalendarLayout::Week,
      CalendarLayoutPB::DayLayout => CalendarLayout::Day,
    }
  }
}
impl std::convert::From<CalendarLayout> for CalendarLayoutPB {
  fn from(layout: CalendarLayout) -> Self {
    match layout {
      CalendarLayout::Month => CalendarLayoutPB::MonthLayout,
      CalendarLayout::Week => CalendarLayoutPB::WeekLayout,
      CalendarLayout::Day => CalendarLayoutPB::DayLayout,
    }
  }
}

#[derive(Debug, Clone, Default, ProtoBuf)]
pub struct CalendarEventRequestPB {
  #[pb(index = 1)]
  pub view_id: String,

  // Currently, requesting the events within the specified month
  // is not supported
  #[pb(index = 2)]
  pub month: String,
}

#[derive(Debug, Clone, Default)]
pub struct CalendarEventRequestParams {
  pub view_id: String,
  pub month: String,
}

impl TryInto<CalendarEventRequestParams> for CalendarEventRequestPB {
  type Error = ErrorCode;

  fn try_into(self) -> Result<CalendarEventRequestParams, Self::Error> {
    let view_id = NotEmptyStr::parse(self.view_id).map_err(|_| ErrorCode::ViewIdIsInvalid)?;
    Ok(CalendarEventRequestParams {
      view_id: view_id.0,
      month: self.month,
    })
  }
}

#[derive(Debug, Clone, Default, ProtoBuf)]
pub struct CalendarEventPB {
  #[pb(index = 1)]
  pub row_id: String,

  #[pb(index = 2)]
  pub date_field_id: String,

  #[pb(index = 3)]
  pub title: String,

  #[pb(index = 4)]
  pub date: DateCellDataPB,
}

#[derive(Debug, Clone, Default, ProtoBuf)]
pub struct RepeatedCalendarEventPB {
  #[pb(index = 1)]
  pub items: Vec<CalendarEventPB>,
}

#[derive(Debug, Clone, Default, ProtoBuf)]
pub struct MoveCalendarEventPB {
  #[pb(index = 1)]
  pub row_id: String,

  #[pb(index = 2)]
  pub field_id: String,

  #[pb(index = 3)]
  pub timestamp: i64,
}
