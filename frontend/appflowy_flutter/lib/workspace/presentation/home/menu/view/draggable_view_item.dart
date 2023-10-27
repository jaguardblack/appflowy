import 'package:appflowy/util/platform_extension.dart';
import 'package:appflowy/workspace/application/view/view_bloc.dart';
import 'package:appflowy/workspace/application/view/view_ext.dart';
import 'package:appflowy/workspace/presentation/widgets/draggable_item/draggable_item.dart';
import 'package:appflowy_backend/log.dart';
import 'package:appflowy_backend/protobuf/flowy-folder2/view.pb.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum DraggableHoverPosition {
  none,
  top,
  center,
  bottom,
}

class DraggableViewItem extends StatefulWidget {
  const DraggableViewItem({
    super.key,
    required this.view,
    this.feedback,
    required this.child,
    this.isFirstChild = false,
    this.centerHighlightColor,
    this.topHighlightColor,
    this.bottomHighlightColor,
  });

  final Widget child;
  final WidgetBuilder? feedback;
  final ViewPB view;
  final bool isFirstChild;
  final Color? centerHighlightColor;
  final Color? topHighlightColor;
  final Color? bottomHighlightColor;

  @override
  State<DraggableViewItem> createState() => _DraggableViewItemState();
}

class _DraggableViewItemState extends State<DraggableViewItem> {
  DraggableHoverPosition position = DraggableHoverPosition.none;

  final _dividerHeight = 2.0;

  @override
  Widget build(BuildContext context) {
    // add top border if the draggable item is on the top of the list
    // highlight the draggable item if the draggable item is on the center
    // add bottom border if the draggable item is on the bottom of the list
    final child = PlatformExtension.isMobile
        ? _buildMobileDraggableItem()
        : _buildDesktopDraggableItem();

    return DraggableItem<ViewPB>(
      data: widget.view,
      onWillAccept: (data) => true,
      onMove: (data) {
        final renderBox = context.findRenderObject() as RenderBox;
        final offset = renderBox.globalToLocal(data.offset);
        final position = _computeHoverPosition(offset, renderBox.size);
        if (!_shouldAccept(data.data, position)) {
          return;
        }
        Log.debug(
          'offset: $offset, position: $position, size: ${renderBox.size}',
        );
        _updatePosition(position);
      },
      onLeave: (_) => _updatePosition(
        DraggableHoverPosition.none,
      ),
      onAccept: (data) {
        _move(
          data,
          widget.view,
        );
        _updatePosition(
          DraggableHoverPosition.none,
        );
      },
      feedback: IntrinsicWidth(
        child: Opacity(
          opacity: 0.5,
          child: widget.feedback?.call(context) ?? child,
        ),
      ),
      child: child,
    );
  }

  Widget _buildDesktopDraggableItem() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // only show the top border when the draggable item is the first child
        if (widget.isFirstChild)
          Divider(
            height: _dividerHeight,
            thickness: _dividerHeight,
            color: position == DraggableHoverPosition.top
                ? widget.topHighlightColor ??
                    Theme.of(context).colorScheme.secondary
                : Colors.transparent,
          ),
        Container(
          color: position == DraggableHoverPosition.center
              ? widget.centerHighlightColor ??
                  Theme.of(context).colorScheme.secondary.withOpacity(0.5)
              : Colors.transparent,
          child: widget.child,
        ),
        Divider(
          height: _dividerHeight,
          thickness: _dividerHeight,
          color: position == DraggableHoverPosition.bottom
              ? widget.bottomHighlightColor ??
                  Theme.of(context).colorScheme.secondary
              : Colors.transparent,
        ),
      ],
    );
  }

  Widget _buildMobileDraggableItem() {
    return Stack(
      children: [
        if (widget.isFirstChild)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: _dividerHeight,
            child: Divider(
              height: _dividerHeight,
              thickness: _dividerHeight,
              color: position == DraggableHoverPosition.top
                  ? widget.topHighlightColor ??
                      Theme.of(context).colorScheme.secondary
                  : Colors.transparent,
            ),
          ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
            color: position == DraggableHoverPosition.center
                ? widget.centerHighlightColor ??
                    Theme.of(context).colorScheme.secondary.withOpacity(0.5)
                : Colors.transparent,
          ),
          child: widget.child,
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: _dividerHeight,
          child: Divider(
            height: _dividerHeight,
            thickness: _dividerHeight,
            color: position == DraggableHoverPosition.bottom
                ? widget.bottomHighlightColor ??
                    Theme.of(context).colorScheme.secondary
                : Colors.transparent,
          ),
        ),
      ],
    );
  }

  void _updatePosition(DraggableHoverPosition position) {
    if (PlatformExtension.isMobile && position != this.position) {
      HapticFeedback.mediumImpact();
    }
    setState(
      () => this.position = position,
    );
  }

  void _move(ViewPB from, ViewPB to) {
    if (position == DraggableHoverPosition.center &&
        to.layout != ViewLayoutPB.Document) {
      // not support moving into a database
      return;
    }

    switch (position) {
      case DraggableHoverPosition.top:
        context.read<ViewBloc>().add(
              ViewEvent.move(
                from,
                to.parentViewId,
                null,
              ),
            );
        break;
      case DraggableHoverPosition.bottom:
        context.read<ViewBloc>().add(
              ViewEvent.move(
                from,
                to.parentViewId,
                to.id,
              ),
            );
        break;
      case DraggableHoverPosition.center:
        context.read<ViewBloc>().add(
              ViewEvent.move(
                from,
                to.id,
                to.childViews.lastOrNull?.id,
              ),
            );
        break;
      case DraggableHoverPosition.none:
        break;
    }
  }

  DraggableHoverPosition _computeHoverPosition(Offset offset, Size size) {
    final threshold = size.height / 3.0;
    if (widget.isFirstChild && offset.dy < -5.0) {
      return DraggableHoverPosition.top;
    }
    if (offset.dy > threshold) {
      return DraggableHoverPosition.bottom;
    }
    return DraggableHoverPosition.center;
  }

  bool _shouldAccept(ViewPB data, DraggableHoverPosition position) {
    // could not move the view to a database
    if (widget.view.layout.isDatabaseView &&
        position == DraggableHoverPosition.center) {
      return false;
    }

    // ignore moving the view to itself
    if (data.id == widget.view.id) {
      return false;
    }

    // ignore moving the view to its child view
    if (data.containsView(widget.view)) {
      return false;
    }

    return true;
  }
}

extension on ViewPB {
  bool containsView(ViewPB view) {
    if (id == view.id) {
      return true;
    }

    return childViews.any((v) => v.containsView(view));
  }
}
