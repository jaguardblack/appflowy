import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:appflowy_editor_plugins/src/table/src/cell_node_widget.dart';
import 'package:appflowy_editor_plugins/src/table/src/models/table_data_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TableCell extends StatefulWidget {
  const TableCell({
    Key? key,
    required this.colIdx,
    required this.rowIdx,
    required this.editorState,
    required this.node,
  }) : super(key: key);

  final int colIdx;
  final int rowIdx;
  final EditorState editorState;
  final Node node;

  @override
  State<TableCell> createState() => _TableCellState();
}

class _TableCellState extends State<TableCell> {
  late Node node;
  late TextNode textNode;

  @override
  void initState() {
    node = Node(type: 'table/cell');
    // TODO(zoli): move this to parent.
    final cellData =
        context.read<TableData>().getCell(widget.colIdx, widget.rowIdx);

    textNode = Node.fromJson(cellData) as TextNode;
    textNode.addListener(() => context
        .read<TableData>()
        .setCell(widget.colIdx, widget.rowIdx, textNode.toJson()));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      node.insert(textNode);
      widget.node.insert(node);
    });

    context.read<TableData>().setNode(widget.colIdx, widget.rowIdx, textNode);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight:
            context.select((TableData td) => td.getRowHeight(widget.rowIdx)),
      ),
      width: double.infinity,
      child: CellNodeWidget(
        key: node.key,
        node: node,
        textNode: textNode,
        editorState: widget.editorState,
        colIdx: widget.colIdx,
        rowIdx: widget.rowIdx,
      ),
    );
  }
}
