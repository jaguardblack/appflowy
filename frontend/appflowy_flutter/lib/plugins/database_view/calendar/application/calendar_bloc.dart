import 'package:appflowy/plugins/database_view/application/field/field_controller.dart';
import 'package:appflowy/plugins/database_view/application/row/row_cache.dart';
import 'package:appflowy_backend/protobuf/flowy-error/protobuf.dart';
import 'package:appflowy_backend/protobuf/flowy-folder/protobuf.dart';
import 'package:appflowy_backend/protobuf/flowy-database/protobuf.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../application/database_controller.dart';

part 'calendar_bloc.freezed.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  final DatabaseController _databaseController;
  final EventController calendarEventsController = EventController();

  FieldController get fieldController => _databaseController.fieldController;
  String get viewId => _databaseController.viewId;

  CalendarBloc({required ViewPB view})
      : _databaseController = DatabaseController(
          view: view,
          layoutType: LayoutTypePB.Calendar,
        ),
        super(CalendarState.initial(view.id)) {
    on<CalendarEvent>(
      (event, emit) async {
        await event.when(
          initial: () async {
            _startListening();
            await _openDatabase(emit);
          },
          didReceiveCalendarSettings: (CalendarLayoutSettingsPB settings) {
            emit(state.copyWith(settings: Some(settings)));
          },
          didReceiveDatabaseUpdate: (DatabasePB database) {
            emit(state.copyWith(database: Some(database)));
          },
          didReceiveError: (FlowyError error) {
            emit(state.copyWith(noneOrError: Some(error)));
          },
          didReceiveDateField: (FieldInfo fieldInfo) {},
        );
      },
    );
  }

  Future<void> _openDatabase(Emitter<CalendarState> emit) async {
    final result = await _databaseController.open();
    result.fold(
      (database) => emit(
        state.copyWith(loadingState: DatabaseLoadingState.finish(left(unit))),
      ),
      (err) => emit(
        state.copyWith(loadingState: DatabaseLoadingState.finish(right(err))),
      ),
    );
  }

  RowCache? getRowCache(String blockId) {
    return _databaseController.rowCache;
  }

  void _startListening() {
    final onDatabaseChanged = DatabaseCallbacks(
      onDatabaseChanged: (database) {
        if (isClosed) return;
      },
      onRowsChanged: (rowInfos, reason) {
        if (isClosed) return;
      },
      onFieldsChanged: (fieldInfos) {
        if (isClosed) return;

        // final fieldInfo = fieldInfos
        //     .firstWhere((element) => element.fieldType == FieldType.DateTime);
      },
    );

    final onLayoutChanged = LayoutCallbacks(
      onLayoutChanged: _didReceiveLayout,
      onLoadLayout: _didReceiveLayout,
    );

    _databaseController.addListener(
      onDatabaseChanged: onDatabaseChanged,
      onLayoutChanged: onLayoutChanged,
    );
  }

  void _didReceiveLayout(LayoutSettingPB layoutSetting) {
    if (layoutSetting.hasCalendar()) {
      if (isClosed) return;
      add(CalendarEvent.didReceiveCalendarSettings(layoutSetting.calendar));
    }
  }

  // void _initializeEvents(FieldPB dateField) {
  //   calendarEventsController.removeWhere((element) => true);
  //   const events = <CalendarEventData<CalendarData>>[];

  //   // final List<CalendarEventData<CalendarData>> events = rows.map((row) {
  //   // final event = CalendarEventData(
  //   //   title: "",
  //   //   date: row -> dateField -> value,
  //   //   event: row,
  //   // );

  //   // return event;
  //   // }).toList();

  //   calendarEventsController.addAll(events);
  // }
}

@freezed
class CalendarEvent with _$CalendarEvent {
  const factory CalendarEvent.initial() = _InitialCalendar;
  const factory CalendarEvent.didReceiveDateField(FieldInfo fieldInfo) =
      _DidReceiveDateField;
  const factory CalendarEvent.didReceiveCalendarSettings(
      CalendarLayoutSettingsPB settings) = _DidReceiveCalendarSettings;
  const factory CalendarEvent.didReceiveError(FlowyError error) =
      _DidReceiveError;
  const factory CalendarEvent.didReceiveDatabaseUpdate(DatabasePB database) =
      _DidReceiveDatabaseUpdate;
}

@freezed
class CalendarState with _$CalendarState {
  const factory CalendarState({
    required String databaseId,
    required Option<DatabasePB> database,
    required Option<FieldPB> dateField,
    required Option<List<RowInfo>> unscheduledRows,
    required Option<CalendarLayoutSettingsPB> settings,
    required DatabaseLoadingState loadingState,
    required Option<FlowyError> noneOrError,
  }) = _CalendarState;

  factory CalendarState.initial(String databaseId) => CalendarState(
        database: none(),
        databaseId: databaseId,
        dateField: none(),
        unscheduledRows: none(),
        settings: none(),
        noneOrError: none(),
        loadingState: const _Loading(),
      );
}

@freezed
class DatabaseLoadingState with _$DatabaseLoadingState {
  const factory DatabaseLoadingState.loading() = _Loading;
  const factory DatabaseLoadingState.finish(
      Either<Unit, FlowyError> successOrFail) = _Finish;
}

class CalendarEditingRow {
  RowPB row;
  int? index;

  CalendarEditingRow({
    required this.row,
    required this.index,
  });
}

class CalendarData {
  final RowInfo rowInfo;
  CalendarData(this.rowInfo);
}
