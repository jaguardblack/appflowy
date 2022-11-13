use crate::entities::{TextFilterCondition, TextFilterPB};
use crate::services::cell::{AnyCellData, CellData, CellFilterOperation};
use crate::services::field::{RichTextTypeOptionPB, TextCellData};
use flowy_error::FlowyResult;

impl TextFilterPB {
    pub fn is_visible<T: AsRef<str>>(&self, cell_data: T) -> bool {
        let cell_data = cell_data.as_ref();
        let s = cell_data.to_lowercase();
        if let Some(content) = self.content.as_ref() {
            match self.condition {
                TextFilterCondition::Is => &s == content,
                TextFilterCondition::IsNot => &s != content,
                TextFilterCondition::Contains => s.contains(content),
                TextFilterCondition::DoesNotContain => !s.contains(content),
                TextFilterCondition::StartsWith => s.starts_with(content),
                TextFilterCondition::EndsWith => s.ends_with(content),
                TextFilterCondition::TextIsEmpty => s.is_empty(),
                TextFilterCondition::TextIsNotEmpty => !s.is_empty(),
            }
        } else {
            false
        }
    }
}

impl CellFilterOperation<TextFilterPB> for RichTextTypeOptionPB {
    fn apply_filter(&self, any_cell_data: AnyCellData, filter: &TextFilterPB) -> FlowyResult<bool> {
        if !any_cell_data.is_text() {
            return Ok(true);
        }

        let cell_data: CellData<TextCellData> = any_cell_data.into();
        let text_cell_data = cell_data.try_into_inner()?;
        Ok(filter.is_visible(text_cell_data))
    }
}
#[cfg(test)]
mod tests {
    #![allow(clippy::all)]
    use crate::entities::{TextFilterCondition, TextFilterPB};

    #[test]
    fn text_filter_equal_test() {
        let text_filter = TextFilterPB {
            condition: TextFilterCondition::Is,
            content: Some("appflowy".to_owned()),
        };

        assert!(text_filter.is_visible("AppFlowy"));
        assert_eq!(text_filter.is_visible("appflowy"), true);
        assert_eq!(text_filter.is_visible("Appflowy"), true);
        assert_eq!(text_filter.is_visible("AppFlowy.io"), false);
    }
    #[test]
    fn text_filter_start_with_test() {
        let text_filter = TextFilterPB {
            condition: TextFilterCondition::StartsWith,
            content: Some("appflowy".to_owned()),
        };

        assert_eq!(text_filter.is_visible("AppFlowy.io"), true);
        assert_eq!(text_filter.is_visible(""), false);
        assert_eq!(text_filter.is_visible("https"), false);
    }

    #[test]
    fn text_filter_end_with_test() {
        let text_filter = TextFilterPB {
            condition: TextFilterCondition::EndsWith,
            content: Some("appflowy".to_owned()),
        };

        assert_eq!(text_filter.is_visible("https://github.com/appflowy"), true);
        assert_eq!(text_filter.is_visible("App"), false);
        assert_eq!(text_filter.is_visible("appflowy.io"), false);
    }
    #[test]
    fn text_filter_empty_test() {
        let text_filter = TextFilterPB {
            condition: TextFilterCondition::TextIsEmpty,
            content: Some("appflowy".to_owned()),
        };

        assert_eq!(text_filter.is_visible(""), true);
        assert_eq!(text_filter.is_visible("App"), false);
    }
    #[test]
    fn text_filter_contain_test() {
        let text_filter = TextFilterPB {
            condition: TextFilterCondition::Contains,
            content: Some("appflowy".to_owned()),
        };

        assert_eq!(text_filter.is_visible("https://github.com/appflowy"), true);
        assert_eq!(text_filter.is_visible("AppFlowy"), true);
        assert_eq!(text_filter.is_visible("App"), false);
        assert_eq!(text_filter.is_visible(""), false);
        assert_eq!(text_filter.is_visible("github"), false);
    }
}
