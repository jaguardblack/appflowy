import React, { useCallback } from 'react';
import ActionButton from '$app/components/editor/components/tools/selection_toolbar/actions/_shared/ActionButton';
import { useTranslation } from 'react-i18next';
import { useSlateStatic } from 'slate-react';
import { CustomEditor } from '$app/components/editor/command';
import { ReactComponent as UnderlineSvg } from '$app/assets/underline.svg';

export function Underline() {
  const { t } = useTranslation();
  const editor = useSlateStatic();
  const isActivated = CustomEditor.isMarkActive(editor, 'underline');

  const onClick = useCallback(() => {
    CustomEditor.toggleMark(editor, {
      key: 'underline',
      value: true,
    });
  }, [editor]);

  return (
    <ActionButton onClick={onClick} active={isActivated} tooltip={t('editor.underline')}>
      <UnderlineSvg />
    </ActionButton>
  );
}

export default Underline;
