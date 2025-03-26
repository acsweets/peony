import 'package:flutter/material.dart';

import 'text_theme.dart';

part 'theme_fragment.dart';

abstract class EvColors {
  static const primary = Color(0xFF049DFA);
  static const darkPrimary = Color(0xFF408DDB);
  static const darkSecondary = Color(0xFF04C1FA);
  static const lightBlue = Color(0xFF3E74FF);

  static const lightText = Color(0xFF001A41);
  static const secondaryText = Color(0xFF757F90);
  static const warningBackground = Color(0xFFFFFBEC);
  static const warningText = Color(0xFFFC9003);

  static const error = Color(0xFFED0226);

  static const divider = Color(0x4DDADADA);
  static const darkDivider = Color(0xFFEFF1F4);
  static const disabledForegroundColor = Color(0xFF9CA9B9);
  static const disabledBackgroundColor = Color(0xFFDAE0E9);
}

final lightColorScheme = ColorScheme.fromSeed(
  seedColor: EvColors.primary,
  primary: EvColors.primary,
  surface: Colors.white,
  onSurface: const Color(0xFF001A41),
  onSecondaryContainer: EvColors.secondaryText,
  error: EvColors.error,
);

final darkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: EvColors.darkPrimary,
  primary: EvColors.darkPrimary,
  secondary: EvColors.darkSecondary,
  onSurface: Colors.white,
  surface: const Color(0xFF202528),
  error: EvColors.error,
);

final lightTheme = ThemeData(
  colorScheme: lightColorScheme,
  filledButtonTheme: filledButtonTheme,
  outlinedButtonTheme: outlinedButtonTheme(EvColors.primary),
  textButtonTheme: textButtonTheme(EvColors.primary),
  elevatedButtonTheme: elevatedButtonTheme,
  iconTheme: iconTheme(lightColorScheme.onSurface),
  iconButtonTheme: iconButtonTheme(
    foregroundColor: const Color(0xFF181C21),
    backgroundColor: Colors.white,
  ),
  inputDecorationTheme: inputDecorationTheme,
  appBarTheme: appBarTheme(
    onSurface: lightColorScheme.onSurface,
    backgroundColor: Colors.white,
  ),
  dividerColor: EvColors.divider,
  dividerTheme: dividerTheme(EvColors.divider),
  progressIndicatorTheme: progressIndicatorTheme(
    color: const Color(0xFF2B99EA),
    linearTrackColor: const Color(0xFFEFF1F4),
  ),
  pageTransitionsTheme: pageTransitionsTheme,
  listTileTheme: listTileTheme,
  fontFamily: 'Poppins',
  useMaterial3: true,
);

final darkTheme = ThemeData(
  colorScheme: darkColorScheme,
  filledButtonTheme: filledButtonTheme,
  outlinedButtonTheme: outlinedButtonTheme(Colors.white),
  textButtonTheme: textButtonTheme(EvColors.darkPrimary),
  elevatedButtonTheme: elevatedButtonTheme,
  iconTheme: iconTheme(darkColorScheme.onSurface),
  iconButtonTheme: iconButtonTheme(
    foregroundColor: Colors.white,
    backgroundColor: const Color(0xFF222325),
  ),
  inputDecorationTheme: inputDecorationTheme,
  appBarTheme: appBarTheme(
    onSurface: darkColorScheme.onSurface,
    backgroundColor: const Color(0xFF303739),
  ),
  dividerColor: EvColors.darkDivider,
  dividerTheme: dividerTheme(EvColors.darkDivider),
  progressIndicatorTheme: progressIndicatorTheme(
    color: EvColors.darkSecondary,
    linearTrackColor: const Color(0xFFE8E8E8),
  ),
  pageTransitionsTheme: pageTransitionsTheme,
  listTileTheme: listTileTheme,
  fontFamily: 'Poppins',
  useMaterial3: true,
);

final listTileTheme = ListTileThemeData(
  titleTextStyle: EvTextTheme.bodyLarge.semibold,
  subtitleTextStyle: EvTextTheme.caption.regular,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(6),
  ),
  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
  dense: false,
  visualDensity: const VisualDensity(
    horizontal: -4,
    vertical: -4,
  ),
);
