import 'package:appflowy/plugins/database_view/application/cell/cell_service.dart';
import 'package:appflowy/plugins/database_view/application/field/type_option/type_option_context.dart';
import 'package:appflowy/plugins/database_view/application/row/row_data_controller.dart';
import 'package:appflowy/plugins/database_view/grid/application/row/row_detail_bloc.dart';
import 'package:appflowy/workspace/presentation/widgets/dialogs.dart';
import 'package:appflowy_backend/log.dart';
import 'package:flowy_infra/theme_extension.dart';
import 'package:flowy_infra/image.dart';
import 'package:flowy_infra_ui/flowy_infra_ui.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:appflowy/generated/locale_keys.g.dart';
import 'package:appflowy_backend/protobuf/flowy-database/field_entities.pb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:appflowy_popover/appflowy_popover.dart';

import '../../application/row/row_service.dart';
import '../../grid/presentation/layout/sizes.dart';
import 'accessory/cell_accessory.dart';
import 'cell_builder.dart';
import 'cells/date_cell/date_cell.dart';
import 'cells/select_option_cell/select_option_cell.dart';
import 'cells/text_cell/text_cell.dart';
import 'cells/url_cell/url_cell.dart';
import '../../grid/presentation/widgets/header/field_cell.dart';
import '../../grid/presentation/widgets/header/field_editor.dart';

class RowDetailPage extends StatefulWidget with FlowyOverlayDelegate {
  final RowController dataController;
  final GridCellBuilder cellBuilder;

  const RowDetailPage({
    required this.dataController,
    required this.cellBuilder,
    Key? key,
  }) : super(key: key);

  @override
  State<RowDetailPage> createState() => _RowDetailPageState();

  static String identifier() {
    return (RowDetailPage).toString();
  }
}

class _RowDetailPageState extends State<RowDetailPage> {
  @override
  Widget build(BuildContext context) {
    return FlowyDialog(
      child: BlocProvider(
        create: (context) {
          return RowDetailBloc(dataController: widget.dataController)
            ..add(const RowDetailEvent.initial());
        },
        child: ListView(
          children: [
            // const SizedBox(height: 100),
            // const Divider(height: 1.0),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    flex: 4,
                    child: _PropertyColumn(
                      cellBuilder: widget.cellBuilder,
                      viewId: widget.dataController.viewId,
                    ),
                  ),
                  const VerticalDivider(width: 1.0),
                  Flexible(
                    child: _RowOptionColumn(
                      viewId: widget.dataController.viewId,
                      rowId: widget.dataController.rowId,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1.0),
            const SizedBox(height: 200)
          ],
        ),
      ),
    );
  }
}

class _PropertyColumn extends StatelessWidget {
  final String viewId;
  final GridCellBuilder cellBuilder;
  const _PropertyColumn({
    required this.viewId,
    required this.cellBuilder,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RowDetailBloc, RowDetailState>(
      buildWhen: (previous, current) => previous.gridCells != current.gridCells,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(50, 50, 50, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...state.gridCells
                  .map(
                    (cell) => Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: _PropertyCell(
                        cellId: cell,
                        cellBuilder: cellBuilder,
                      ),
                    ),
                  )
                  .toList(),
              const VSpace(20),
              _CreatePropertyButton(viewId: viewId),
            ],
          ),
        );
      },
    );
  }
}

class _CreatePropertyButton extends StatefulWidget {
  final String viewId;

  const _CreatePropertyButton({
    required this.viewId,
    Key? key,
  }) : super(key: key);

  @override
  State<_CreatePropertyButton> createState() => _CreatePropertyButtonState();
}

class _CreatePropertyButtonState extends State<_CreatePropertyButton> {
  late PopoverController popoverController;

  @override
  void initState() {
    popoverController = PopoverController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppFlowyPopover(
      constraints: BoxConstraints.loose(const Size(240, 200)),
      controller: popoverController,
      direction: PopoverDirection.topWithLeftAligned,
      margin: EdgeInsets.zero,
      child: SizedBox(
        height: 40,
        child: FlowyButton(
          text: FlowyText.medium(
            LocaleKeys.grid_field_newProperty.tr(),
            color: AFThemeExtension.of(context).textColor,
          ),
          hoverColor: AFThemeExtension.of(context).lightGreyHover,
          onTap: () {},
          leftIcon: svgWidget(
            "home/add",
            color: AFThemeExtension.of(context).textColor,
          ),
        ),
      ),
      popupBuilder: (BuildContext popOverContext) {
        return FieldEditor(
          viewId: widget.viewId,
          typeOptionLoader: NewFieldTypeOptionLoader(viewId: widget.viewId),
          onDeleted: (fieldId) {
            popoverController.close();

            NavigatorAlertDialog(
              title: LocaleKeys.grid_field_deleteFieldPromptMessage.tr(),
              confirm: () {
                context
                    .read<RowDetailBloc>()
                    .add(RowDetailEvent.deleteField(fieldId));
              },
            ).show(context);
          },
        );
      },
    );
  }
}

class _PropertyCell extends StatefulWidget {
  final CellIdentifier cellId;
  final GridCellBuilder cellBuilder;
  const _PropertyCell({
    required this.cellId,
    required this.cellBuilder,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PropertyCellState();
}

class _PropertyCellState extends State<_PropertyCell> {
  final PopoverController popover = PopoverController();

  @override
  Widget build(BuildContext context) {
    final style = _customCellStyle(widget.cellId.fieldType);
    final cell = widget.cellBuilder.build(widget.cellId, style: style);

    final gesture = GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => cell.beginFocus.notify(),
      child: AccessoryHover(
        contentPadding: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
        child: cell,
      ),
    );

    return IntrinsicHeight(
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 30),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppFlowyPopover(
              controller: popover,
              constraints: BoxConstraints.loose(const Size(240, 600)),
              margin: EdgeInsets.zero,
              triggerActions: PopoverTriggerFlags.none,
              popupBuilder: (popoverContext) => buildFieldEditor(),
              child: SizedBox(
                width: 150,
                child: FieldCellButton(
                  field: widget.cellId.fieldInfo.field,
                  onTap: () => popover.show(),
                  radius: BorderRadius.circular(6),
                ),
              ),
            ),
            const HSpace(10),
            Expanded(child: gesture),
          ],
        ),
      ),
    );
  }

  Widget buildFieldEditor() {
    return FieldEditor(
      viewId: widget.cellId.viewId,
      fieldName: widget.cellId.fieldInfo.field.name,
      isGroupField: widget.cellId.fieldInfo.isGroupField,
      typeOptionLoader: FieldTypeOptionLoader(
        viewId: widget.cellId.viewId,
        field: widget.cellId.fieldInfo.field,
      ),
      onDeleted: (fieldId) {
        popover.close();

        NavigatorAlertDialog(
          title: LocaleKeys.grid_field_deleteFieldPromptMessage.tr(),
          confirm: () {
            context
                .read<RowDetailBloc>()
                .add(RowDetailEvent.deleteField(fieldId));
          },
        ).show(context);
      },
    );
  }
}

GridCellStyle? _customCellStyle(FieldType fieldType) {
  switch (fieldType) {
    case FieldType.Checkbox:
      return null;
    case FieldType.DateTime:
      return DateCellStyle(
        alignment: Alignment.centerLeft,
      );
    case FieldType.MultiSelect:
      return SelectOptionCellStyle(
        placeholder: LocaleKeys.grid_row_textPlaceholder.tr(),
      );
    case FieldType.Checklist:
      return SelectOptionCellStyle(
        placeholder: LocaleKeys.grid_row_textPlaceholder.tr(),
      );
    case FieldType.Number:
      return null;
    case FieldType.RichText:
      return GridTextCellStyle(
        placeholder: LocaleKeys.grid_row_textPlaceholder.tr(),
      );
    case FieldType.SingleSelect:
      return SelectOptionCellStyle(
        placeholder: LocaleKeys.grid_row_textPlaceholder.tr(),
      );

    case FieldType.URL:
      return GridURLCellStyle(
        placeholder: LocaleKeys.grid_row_textPlaceholder.tr(),
        accessoryTypes: [
          GridURLCellAccessoryType.edit,
          GridURLCellAccessoryType.copyURL,
        ],
      );
  }
  throw UnimplementedError;
}

class _RowOptionColumn extends StatelessWidget {
  final RowBackendService _rowBackendService;
  final String rowId;

  _RowOptionColumn({required String viewId, required this.rowId, Key? key})
      : _rowBackendService = RowBackendService(viewId: viewId),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: FlowyText(LocaleKeys.grid_row_action.tr()),
          ),
          const VSpace(15),
          SizedBox(
            height: GridSize.popoverItemHeight,
            child: FlowyButton(
              text: FlowyText.regular(LocaleKeys.grid_field_delete.tr()),
              leftIcon: const FlowySvg(name: "home/trash"),
              onTap: () async {
                final result = await _rowBackendService.deleteRow(rowId);
                result.fold(
                  (l) => null,
                  (err) => Log.error(err),
                );
                if (context.mounted) {
                  FlowyOverlay.pop(context);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
