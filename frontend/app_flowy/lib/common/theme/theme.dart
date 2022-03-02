import 'package:flutter/material.dart';

// FIXME: Different colors for different themes (light/dark).
extension ColorSchemeExtension on ColorScheme {
  Color get red => const Color(0xFFffadad);
  Color get orange => const Color(0xFFffcfad);
  Color get yellow => const Color(0xFFfffead);
  Color get lime => const Color(0xFFe6ffa3);
  Color get green => const Color(0xFFbcffad);
  Color get aqua => const Color(0xFFadffe2);
  Color get blue => const Color(0xFFade4ff);
  Color get purple => const Color(0xFFc3adff);
  Color get pink => const Color(0xFFffadf9);

  Color get shader1 => _isDark ? const Color(0xFFffffff) : const Color(0xFF333333);
  Color get shader2 => _isDark ? const Color(0xFFffffff) : const Color(0xFF4f4f4f);
  Color get shader3 => const Color(0xFF828282);
  Color get shader4 => const Color(0xFFbdbdbd);

  bool get _isDark => brightness == Brightness.dark;
}

class FlowyTheme {
  FlowyTheme(this._theme);

  FlowyTheme.fromName(String name) {
    _theme = DefaultThemesExtension.fromName(name);
  }

  late final DefaultThemes _theme;

  DefaultThemes get theme => _theme;

  bool get isDark => _theme == DefaultThemes.dark ? true : false;

  ThemeData get themeData => ThemeData(
        brightness: isDark ? Brightness.dark : Brightness.light,

        primaryColor: const Color(0xFF00bcf0),

        // TODO: Custom color with tins and shades
        primarySwatch: Colors.blue,

        scaffoldBackgroundColor: isDark ? const Color(0xFF292929) : const Color(0xFFf7f8fc),
        backgroundColor: isDark ? const Color(0xFF292929) : const Color(0xFFf7f8fc),

        canvasColor: isDark ? Colors.grey.shade700 : Colors.grey.shade100,

        hoverColor: isDark ? const Color(0xFF1f1f1f) : const Color(0xFFe0e0e0),

        textTheme: const TextTheme(
          bodyText1: TextStyle(),
          bodyText2: TextStyle(),
        ).apply(
          bodyColor: isDark ? const Color(0xFFffffff) : const Color(0xFF333333),
          displayColor: isDark ? const Color(0xFFffffff) : const Color(0xFF333333),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            onPrimary: isDark ? const Color(0xFF000000) : const Color(0xFFfefefe),
          ),
        ),

        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color(0xFFb061ff),
          selectionHandleColor: Color(0xFFb061ff),
        ),

        primaryIconTheme: const IconThemeData(color: Color(0xFF00bcf0)),
        iconTheme: IconThemeData(color: isDark ? const Color(0xFFfefefe) : const Color(0xFF000000)),

        colorScheme: ColorScheme(
          brightness: isDark ? Brightness.dark : Brightness.light,

          // Brand styles.
          primary: const Color(0xFF00bcf0),
          primaryVariant: const Color(0xFF009cc7),
          secondary: const Color(0xFFb061ff),
          secondaryVariant: const Color(0xFF9327ff),
          // onPrimary: const Color(0xFFf7f8fc),
          // onSecondary: const Color(0xFFf7f8fc),
          onPrimary: isDark ? Colors.white : Colors.black,
          onSecondary: isDark ? Colors.white : Colors.black,

          // Text styles.
          onBackground: isDark ? const Color(0xFFffffff) : const Color(0xFF333333),
          onSurface: isDark ? const Color(0xFFffffff) : const Color(0xFF333333),

          // Backgrounds.
          background: isDark ? const Color(0xFF292929) : const Color(0xFFf7f8fc),
          surface: isDark ? const Color(0xFF292929) : const Color(0xFFf7f8fc),

          // Alerts.
          error: const Color(0xFFfb006d),
          onError: isDark ? const Color(0xFFffffff) : const Color(0xFF333333),
        ),
      ).copyWith(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        highlightColor: const Color(0xFF00bcf0),
        indicatorColor: const Color(0xFF00bcf0),
        toggleableActiveColor: const Color(0xFF00bcf0),
      );

  Color shift(Color c, double d) => ColorUtils.shiftHsl(c, d * (isDark ? -1 : 1));
}

class ColorUtils {
  static Color shiftHsl(Color c, [double amt = 0]) {
    var hslc = HSLColor.fromColor(c);
    return hslc.withLightness((hslc.lightness + amt).clamp(0.0, 1.0)).toColor();
  }

  static Color parseHex(String value) => Color(int.parse(value.substring(1, 7), radix: 16) + 0xFF000000);

  static Color blend(Color dst, Color src, double opacity) {
    return Color.fromARGB(
      255,
      (dst.red.toDouble() * (1.0 - opacity) + src.red.toDouble() * opacity).toInt(),
      (dst.green.toDouble() * (1.0 - opacity) + src.green.toDouble() * opacity).toInt(),
      (dst.blue.toDouble() * (1.0 - opacity) + src.blue.toDouble() * opacity).toInt(),
    );
  }
}

extension DefaultThemesExtension on DefaultThemes {
  String get name {
    switch (this) {
      case DefaultThemes.light:
        return "light";
      case DefaultThemes.dark:
        return "dark";
    }
  }

  static DefaultThemes fromName(String name) {
    switch (name) {
      case "light":
        return DefaultThemes.light;
      case "dark":
        return DefaultThemes.dark;
      default:
        return DefaultThemes.light;
    }
  }
}

enum DefaultThemes {
  light,
  dark,
}
