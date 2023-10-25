import 'package:appflowy/generated/flowy_svgs.g.dart';
import 'package:appflowy/generated/locale_keys.g.dart';
import 'package:appflowy/workspace/presentation/settings/widgets/settings_appearance/font_family_setting.dart';
import 'package:appflowy_backend/log.dart';
import 'package:appflowy_editor/appflowy_editor.dart' hide Log;
import 'package:appflowy_popover/appflowy_popover.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

final customizeFontToolbarItem = ToolbarItem(
  id: 'editor.font',
  group: 4,
  isActive: onlyShowInTextType,
  builder: (context, editorState, highlightColor, _) {
    final selection = editorState.selection!;
    final popoverController = PopoverController();
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: FontFamilyDropDown(
        currentFontFamily: '',
        offset: const Offset(0, 12),
        popoverController: popoverController,
        onOpen: () => keepEditorFocusNotifier.increase(),
        onClose: () => keepEditorFocusNotifier.decrease(),
        showResetButton: true,
        onFontFamilyChanged: (fontFamily) async {
          popoverController.close();
          try {
            await editorState.formatDelta(selection, {
              AppFlowyRichTextKeys.fontFamily: fontFamily,
            });
          } catch (e) {
            Log.error('Failed to set font family: $e');
          }
        },
        onResetFont: () async => await editorState.formatDelta(selection, {
          AppFlowyRichTextKeys.fontFamily: null,
        }),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: SVGIconItemWidget(
            size: const Size.square(18),
            tooltip: LocaleKeys.document_plugins_fonts.tr(),
            isHighlight: false,
            highlightColor: highlightColor,
            iconBuilder: (_) => const FlowySvg(
              FlowySvgs.font_family_s,
              size: Size.square(16.0),
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  },
);
