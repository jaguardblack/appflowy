import 'package:appflowy/plugins/database/application/cell/cell_controller_builder.dart';
import 'package:appflowy/plugins/database/widgets/row/cells/timestamp_cell/timestamp_cell_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'card_cell.dart';

class TimestampCardCellStyle extends CardCellStyle {
  final TextStyle textStyle;

  TimestampCardCellStyle({
    required super.padding,
    required this.textStyle,
  });
}

class TimestampCardCell extends CardCell<TimestampCardCellStyle> {
  final TimestampCellController cellController;

  const TimestampCardCell({
    super.key,
    required super.style,
    required this.cellController,
  });

  @override
  State<TimestampCardCell> createState() => _TimestampCellState();
}

class _TimestampCellState extends State<TimestampCardCell> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        return TimestampCellBloc(cellController: widget.cellController)
          ..add(const TimestampCellEvent.initial());
      },
      child: BlocBuilder<TimestampCellBloc, TimestampCellState>(
        buildWhen: (previous, current) => previous.dateStr != current.dateStr,
        builder: (context, state) {
          if (state.dateStr.isEmpty) {
            return const SizedBox.shrink();
          }

          return Container(
            alignment: AlignmentDirectional.centerStart,
            padding: widget.style.padding,
            child: Text(
              state.dateStr,
              style: widget.style.textStyle,
            ),
          );
        },
      ),
    );
  }
}
