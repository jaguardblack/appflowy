import 'package:app_flowy/generated/locale_keys.g.dart';
import 'package:app_flowy/workspace/application/appearance.dart';
import 'package:appflowy_popover/appflowy_popover.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flowy_infra/image.dart';
import 'package:flowy_infra/theme.dart';
import 'package:flowy_infra_ui/flowy_infra_ui.dart';
import 'package:flowy_infra_ui/style_widget/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsAppearanceView extends StatelessWidget {
  const SettingsAppearanceView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: BlocBuilder<AppearanceSettingsCubit, AppearanceSettingsState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ThemeModeSetting(currentThemeMode: state.themeMode),
              ThemeTypeSetting(currentThemeType: state.themeType),
            ],
          );
        },
      ),
    );
  }
}

class ThemeTypeSetting extends StatelessWidget {
  final ThemeType currentThemeType;
  const ThemeTypeSetting({required this.currentThemeType, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: FlowyText.medium(
            "Theme Type",
            overflow: TextOverflow.ellipsis,
          ),
        ),
        AppFlowyPopover(
          direction: PopoverDirection.bottomWithRightAligned,
          child: FlowyTextButton(
            _themeTypeLabelText(currentThemeType),
            fillColor: Colors.transparent,
            hoverColor: Theme.of(context).colorScheme.secondary,
            onPressed: () {},
          ),
          popupBuilder: (BuildContext context) {
            return IntrinsicWidth(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _themeTypeItemButton(context, ThemeType.official),
                  _themeTypeItemButton(context, ThemeType.dandelion),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _themeTypeItemButton(BuildContext context, ThemeType themeType) {
    return SizedBox(
      height: 32,
      child: FlowyButton(
        text: FlowyText.medium(_themeTypeLabelText(themeType)),
        rightIcon: currentThemeType == themeType
            ? svgWidget("grid/checkmark")
            : const SizedBox(),
        onTap: () {
          context
              .read<AppearanceSettingsCubit>()
              .setTheme(getThemeName(themeType));
          if (currentThemeType != themeType) {
            context.read<AppearanceSettingsCubit>().setThemeType(themeType);
          }
        },
      ),
    );
  }

  String _themeTypeLabelText(ThemeType themeType) {
    switch (themeType) {
      case (ThemeType.official):
        return "Default Flowy Theme";
      case (ThemeType.dandelion):
        return "Dandelion Community Theme";
      default:
        return "";
    }
  }

  String getThemeName(ThemeType ty) {
    switch (ty) {
      case ThemeType.official:
        return "Default Flowy Theme";
      case ThemeType.dandelion:
        return "Dandelion Community Theme";
    }
  }
}

// class ThemeNameSetting extends StatelessWidget {
//   const ThemeNameSetting({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const FlowyText.medium(
//           "Theme Type",
//           overflow: TextOverflow.ellipsis,
//         ),
//         SizedBox(
//             height: 500,
//             child: ListView.builder(
//               padding: const EdgeInsets.all(2),
//               itemCount: ThemeType.values.length,
//               itemBuilder: (context, index) {
//                 final itemAppTheme = ThemeType.values[index];
//                 return Card(
//                   child: ListTile(
//                     title: FlowyText.regular(
//                       getThemeName(itemAppTheme),
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     onTap: () {
//                       context
//                           .read<AppearanceSettingsCubit>()
//                           .setTheme(getThemeName(itemAppTheme));
//                     },
//                   ),
//                 );
//               },
//             )),
//       ],
//     );
//   }

//   String getThemeName(ThemeType ty) {
//     switch (ty) {
//       case ThemeType.official:
//         return "Default Flowy Theme";
//       case ThemeType.dandelion:
//         return "Dandelion Community Theme";
//     }
//   }
// }

class ThemeModeSetting extends StatelessWidget {
  final ThemeMode currentThemeMode;
  const ThemeModeSetting({required this.currentThemeMode, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: FlowyText.medium(
            LocaleKeys.settings_appearance_themeMode_label.tr(),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        AppFlowyPopover(
          direction: PopoverDirection.bottomWithRightAligned,
          child: FlowyTextButton(
            _themeModeLabelText(currentThemeMode),
            fillColor: Colors.transparent,
            hoverColor: Theme.of(context).colorScheme.secondary,
            onPressed: () {},
          ),
          popupBuilder: (BuildContext context) {
            return IntrinsicWidth(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _themeModeItemButton(context, ThemeMode.light),
                  _themeModeItemButton(context, ThemeMode.dark),
                  _themeModeItemButton(context, ThemeMode.system),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _themeModeItemButton(BuildContext context, ThemeMode themeMode) {
    return SizedBox(
      height: 32,
      child: FlowyButton(
        text: FlowyText.medium(_themeModeLabelText(themeMode)),
        rightIcon: currentThemeMode == themeMode
            ? svgWidget("grid/checkmark")
            : const SizedBox(),
        onTap: () {
          if (currentThemeMode != themeMode) {
            context.read<AppearanceSettingsCubit>().setThemeMode(themeMode);
          }
        },
      ),
    );
  }

  String _themeModeLabelText(ThemeMode themeMode) {
    switch (themeMode) {
      case (ThemeMode.light):
        return LocaleKeys.settings_appearance_themeMode_light.tr();
      case (ThemeMode.dark):
        return LocaleKeys.settings_appearance_themeMode_dark.tr();
      case (ThemeMode.system):
        return LocaleKeys.settings_appearance_themeMode_system.tr();
      default:
        return "";
    }
  }
}
