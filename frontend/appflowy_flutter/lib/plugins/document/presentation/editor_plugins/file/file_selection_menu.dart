import 'package:appflowy/plugins/document/presentation/editor_plugins/plugins.dart';
import 'package:appflowy_editor/appflowy_editor.dart';

extension InsertFile on EditorState {
  Future<void> insertEmptyFileBlock() async {
    final selection = this.selection;
    if (selection == null || !selection.isCollapsed) {
      return;
    }
    final node = getNodeAtPath(selection.end.path);
    if (node == null) {
      return;
    }
    final file = fileNode(url: '');
    final transaction = this.transaction;

    // if the current node is empty paragraph, replace it with the file node
    if (node.type == ParagraphBlockKeys.type &&
        (node.delta?.isEmpty ?? false)) {
      transaction
        ..insertNode(node.path, file)
        ..deleteNode(node);
    } else {
      transaction.insertNode(node.path.next, file);
    }

    transaction.afterSelection =
        Selection.collapsed(Position(path: node.path.next));

    return apply(transaction);
  }
}
