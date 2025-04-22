part of 'theme.dart';

final smallButtonStyle = ButtonStyle(
  minimumSize: const WidgetStatePropertyAll(Size(0, 24)),
  textStyle: WidgetStatePropertyAll(EvTextTheme.systemSmall.semibold),
  padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 12)),
);

final microButtonStyle = ButtonStyle(
  minimumSize: const WidgetStatePropertyAll(Size(0, 24)),
  textStyle: WidgetStatePropertyAll(EvTextTheme.systemMicro.semibold),
  padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 12)),
);

final filledButtonTheme = FilledButtonThemeData(
  style: FilledButton.styleFrom(
    textStyle: EvTextTheme.systemBody1.regular,
    foregroundColor: Colors.white,
    disabledForegroundColor: EvColors.disabledForegroundColor,
    disabledBackgroundColor: EvColors.disabledBackgroundColor,
  ),
);

OutlinedButtonThemeData outlinedButtonTheme(Color color) =>
    OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        textStyle: EvTextTheme.systemBody1.regular,
        foregroundColor: color,
        side: BorderSide(color: color),
      ),
    );

TextButtonThemeData textButtonTheme(Color color) => TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: color,
        minimumSize: Size.zero,
        padding: const EdgeInsets.all(1),
        textStyle: EvTextTheme.systemSmall.regular.copyWith(
          decoration: TextDecoration.underline,
          height: 1.4,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(2)),
        ),
      ),
    );

final elevatedButtonTheme = ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    textStyle: EvTextTheme.systemBody1.regular,
  ),
);

const inputDecorationTheme = InputDecorationTheme(
  hintStyle: TextStyle(color: EvColors.disabledForegroundColor),
  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  isCollapsed: true,
  filled: true,
  fillColor: Colors.white,
  errorMaxLines: 3,
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(12)),
    borderSide: BorderSide(color: EvColors.disabledForegroundColor),
  ),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(12)),
  ),
);

AppBarTheme appBarTheme({
  required Color onSurface,
  required Color backgroundColor,
}) =>
    AppBarTheme(
      centerTitle: true,
      titleSpacing: 16,
      backgroundColor: backgroundColor,
      titleTextStyle: EvTextTheme.pageTitle.copyWith(color: onSurface),
    );

IconThemeData iconTheme(Color onSurface) => IconThemeData(color: onSurface);

IconButtonThemeData iconButtonTheme({
  required Color foregroundColor,
  required Color backgroundColor,
  double iconSize = 22,
  Size fixedSize = const Size(36, 36),
}) =>
    IconButtonThemeData(
      style: IconButton.styleFrom(
        iconSize: iconSize,
        visualDensity: const VisualDensity(
          horizontal: -4,
          vertical: -4,
        ),
        padding: EdgeInsets.zero,
        fixedSize: fixedSize,
        foregroundColor: foregroundColor,
        backgroundColor: backgroundColor,
      ),
    );

DividerThemeData dividerTheme(Color dividerColor) => DividerThemeData(
      color: dividerColor,
      thickness: 1,
    );

const pageTransitionsTheme = PageTransitionsTheme(
  builders: {
    TargetPlatform.android: CupertinoPageTransitionsBuilder(),
    TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
    TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
  },
);

// pageTransitionsTheme: const PageTransitionsTheme(builders: {
// TargetPlatform.android: SlidePageTransitionsBuilder(),
// TargetPlatform.iOS: SlidePageTransitionsBuilder(),
// TargetPlatform.macOS: FadePageTransitionsBuilder(),
// TargetPlatform.windows: FadePageTransitionsBuilder(),
// TargetPlatform.linux: FadePageTransitionsBuilder(),
// }),
ProgressIndicatorThemeData progressIndicatorTheme({
  required Color color,
  required Color linearTrackColor,
}) =>
    ProgressIndicatorThemeData(
      color: color,
      linearTrackColor: linearTrackColor,
    );




