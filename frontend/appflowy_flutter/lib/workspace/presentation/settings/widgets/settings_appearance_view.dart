import 'package:appflowy/workspace/application/appearance.dart';
import 'package:appflowy/workspace/presentation/settings/widgets/settings_appearance/create_file_setting.dart';
import 'package:flowy_infra/plugins/bloc/dynamic_plugin_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'settings_appearance/settings_appearance.dart';

class SettingsAppearanceView extends StatelessWidget {
  const SettingsAppearanceView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: BlocProvider<DynamicPluginBloc>(
        create: (_) => DynamicPluginBloc(),
        child: BlocBuilder<AppearanceSettingsCubit, AppearanceSettingsState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ColorSchemeSetting(
                  currentTheme: state.appTheme.themeName,
                  bloc: context.read<DynamicPluginBloc>(),
                ),
                const Divider(),
                BrightnessSetting(
                  currentThemeMode: state.themeMode,
                ),
                const Divider(),
                ThemeFontFamilySetting(
                  currentFontFamily: state.font,
                ),
                const Divider(),
                LayoutDirectionSetting(
                  currentLayoutDirection: state.layoutDirection,
                ),
                const Divider(),
                TextDirectionSetting(
                  currentTextDirection: state.textDirection,
                ),
                const Divider(),
                CreateFileSettings(),
                const Divider(),
              ],
            );
          },
        ),
      ),
    );
  }
}
