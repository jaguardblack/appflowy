import 'package:appflowy/generated/locale_keys.g.dart';
import 'package:appflowy/plugins/document/application/doc_bloc.dart';
import 'package:appflowy/plugins/document/presentation/editor_plugins/base/insert_page_command.dart';
import 'package:appflowy/plugins/document/presentation/editor_plugins/base/selectable_svg_widget.dart';
import 'package:appflowy/workspace/application/view/view_service.dart';
import 'package:appflowy_backend/protobuf/flowy-folder2/view.pb.dart';
import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:easy_localization/easy_localization.dart';

SelectionMenuItem gridViewMenuItem(DocumentBloc documentBloc) =>
    SelectionMenuItem(
      name: LocaleKeys.document_slashMenu_grid_createANewGrid.tr(),
      icon: (editorState, onSelected, style) => SelectableSvgWidget(
        name: 'editor/grid',
        isSelected: onSelected,
        style: style,
      ),
      keywords: ['grid'],
      handler: (editorState, menuService, context) async {
        if (!documentBloc.view.hasParentViewId()) {
          return;
        }

        final appId = documentBloc.view.parentViewId;
        final service = ViewBackendService();

        final result = (await service.createView(
          parentViewId: appId,
          name: LocaleKeys.menuAppHeader_defaultNewPageName.tr(),
          layoutType: ViewLayoutPB.Grid,
        ))
            .getLeftOrNull();

        // If the result is null, then something went wrong here.
        if (result == null) {
          return;
        }

        final app = (await service.getView(result.viewId)).getLeftOrNull();
        // We should show an error dialog.
        if (app == null) {
          return;
        }

        final view = (await service.getChildView(
          parentViewId: result.viewId,
          childViewId: result.id,
        ))
            .getLeftOrNull();
        // As this.
        if (view == null) {
          return;
        }

        editorState.insertPage(app, view);
      },
    );
