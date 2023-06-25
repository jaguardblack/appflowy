import 'package:appflowy/workspace/application/settings/shortcuts/settings_shortcuts_cubit.dart';
import 'package:appflowy/workspace/application/settings/shortcuts/settings_shortcuts_service.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
// ignore: depend_on_referenced_packages
import 'package:mocktail/mocktail.dart';

class MockSettingsShortcutService extends Mock
    implements SettingsShortcutService {}

void main() {
  group("ShortcutsCubit", () {
    late SettingsShortcutService service;
    late ShortcutsCubit shortcutsCubit;

    setUp(() async {
      service = MockSettingsShortcutService();
      when(
        () => service.saveAllShortcuts(any()),
      ).thenAnswer((_) async => true);
      when(
        () => service.getCustomizeShortcuts(),
      ).thenAnswer((_) async => []);

      shortcutsCubit = ShortcutsCubit(service);
    });

    test('initial state is correct', () {
      final shortcutsCubit = ShortcutsCubit(service);
      expect(shortcutsCubit.state, const ShortcutsState());
    });

    group('fetchShortcuts', () {
      blocTest<ShortcutsCubit, ShortcutsState>(
        'calls loadShortcuts() once',
        build: () => shortcutsCubit,
        act: (cubit) => cubit.fetchShortcuts(),
        verify: (_) {
          verify(() => service.getCustomizeShortcuts()).called(1);
        },
      );

      blocTest<ShortcutsCubit, ShortcutsState>(
        'emits [updating, failure] when loadShortcuts() throws',
        setUp: () {
          when(
            () => service.getCustomizeShortcuts(),
          ).thenThrow(Exception('oops'));
        },
        build: () => shortcutsCubit,
        act: (cubit) => cubit.fetchShortcuts(),
        expect: () => <dynamic>[
          const ShortcutsState(status: ShortcutsStatus.updating),
          isA<ShortcutsState>()
              .having((w) => w.status, 'status', ShortcutsStatus.failure)
              .having(
                (w) => w.error,
                'error',
                kCouldNotLoadErrorMsg,
              ),
        ],
      );

      // blocTest<ShortcutsCubit, ShortcutsState>(
      //   'emits [updating, success] when loadShortcuts() returns shortcuts',
      //   build: () => shortcutsCubit,
      //   act: (cubit) => cubit.fetchShortcuts(),
      //   expect: () => <dynamic>[
      //     const ShortcutsState(status: ShortcutsStatus.updating),
      //     isA<ShortcutsState>()
      //         .having((w) => w.status, 'status', ShortcutsStatus.success)
      //         .having(
      //           (w) => w.commandShortcutEvents,
      //           'shortcuts',
      //           commandShortcutEvents,
      //         ),
      //   ],
      // );
    });

    group('updateShortcut', () {
      blocTest<ShortcutsCubit, ShortcutsState>(
        'calls saveShortcuts() once',
        build: () => shortcutsCubit,
        act: (cubit) => cubit.updateAllShortcuts(),
        verify: (_) {
          verify(() => service.saveAllShortcuts(any())).called(1);
        },
      );

      blocTest<ShortcutsCubit, ShortcutsState>(
        'emits [updating, failure] when updateShortcuts() throws',
        setUp: () {
          when(
            () => service.saveAllShortcuts(any()),
          ).thenThrow(Exception('oops'));
        },
        build: () => shortcutsCubit,
        act: (cubit) => cubit.updateAllShortcuts(),
        expect: () => <dynamic>[
          const ShortcutsState(status: ShortcutsStatus.updating),
          isA<ShortcutsState>()
              .having((w) => w.status, 'status', ShortcutsStatus.failure)
              .having(
                (w) => w.error,
                'error',
                kCouldNotSaveErrorMsg,
              ),
        ],
      );

      blocTest<ShortcutsCubit, ShortcutsState>(
        'emits [updating, success] when updateShortcuts() is successful',
        build: () => shortcutsCubit,
        act: (cubit) => cubit.updateAllShortcuts(),
        expect: () => <dynamic>[
          const ShortcutsState(status: ShortcutsStatus.updating),
          isA<ShortcutsState>()
              .having((w) => w.status, 'status', ShortcutsStatus.success)
        ],
      );
    });
  });
}
