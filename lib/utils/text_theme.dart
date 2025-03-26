import 'package:flutter/widgets.dart';

mixin TextScaleSetMixin {
  TextStyle get regular;
  TextStyle get semibold;
}

abstract class TextScaleSet extends TextStyle with TextScaleSetMixin {
  const TextScaleSet();

  @override
  double get fontSize;
  @override
  double get height;
  @override
  String get fontFamily => 'Poppins';
  @override
  TextStyle get regular;
  @override
  TextStyle get semibold;

  TextStyle expand({
    Color? color,
    double? fontSize,
    double? height,
    FontWeight? fontWeight,
    String? fontFamily,
    List<String>? fontFamilyFallback,
    TextDecoration? decoration,
  }) =>
      TextStyle(
        fontSize: fontSize ?? this.fontSize,
        height: height ?? this.height,
        color: color,
        fontWeight: fontWeight,
        fontFamily: fontFamily,
        fontFamilyFallback: fontFamilyFallback,
        decoration: decoration,
      );
}

class _TitleTextTheme extends TextScaleSet {
  const _TitleTextTheme();

  @override
  double get fontSize => 18;
  @override
  double get height => 1.5556;
  @override
  TextStyle get regular => const TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 18,
        height: 1.5556,
        fontFamily: 'Poppins',
      );
  @override
  TextStyle get semibold => const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 18,
        height: 1.5556,
        fontFamily: 'Poppins',
      );
}

class _BodySmallTextTheme extends TextScaleSet {
  const _BodySmallTextTheme();

  @override
  double get fontSize => 14;
  @override
  double get height => 1.4286;
  @override
  TextStyle get regular => const TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 14,
        height: 1.4286,
        fontFamily: 'Poppins',
      );
  @override
  TextStyle get semibold => const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 14,
        height: 1.4286,
        fontFamily: 'Poppins',
      );
}

class _BodyLargeTextTheme extends TextScaleSet {
  const _BodyLargeTextTheme();

  @override
  double get fontSize => 16;
  @override
  double get height => 1.5000;
  @override
  TextStyle get regular => const TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 16,
        height: 1.5000,
        fontFamily: 'Poppins',
      );
  @override
  TextStyle get semibold => const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 16,
        height: 1.5000,
        fontFamily: 'Poppins',
      );
}

class _BodyTextBody2TextTheme extends TextScaleSet {
  const _BodyTextBody2TextTheme();

  @override
  double get fontSize => 14;
  @override
  double get height => 1.5714;
  @override
  TextStyle get regular => const TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 14,
        height: 1.5714,
        fontFamily: 'Poppins',
      );
  @override
  TextStyle get semibold => const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 14,
        height: 1.5714,
        fontFamily: 'Poppins',
      );
}

class _SystemSmallTextTheme extends TextScaleSet {
  const _SystemSmallTextTheme();

  @override
  double get fontSize => 12;
  @override
  double get height => 1.5000;
  @override
  TextStyle get regular => const TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 12,
        height: 1.5000,
        fontFamily: 'Poppins',
      );
  @override
  TextStyle get semibold => const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 12,
        height: 1.5000,
        fontFamily: 'Poppins',
      );
}

class _SystemBody1TextTheme extends TextScaleSet {
  const _SystemBody1TextTheme();

  @override
  double get fontSize => 16;
  @override
  double get height => 1.5000;
  @override
  TextStyle get regular => const TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 16,
        height: 1.5000,
        fontFamily: 'Poppins',
      );
  @override
  TextStyle get semibold => const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 16,
        height: 1.5000,
        fontFamily: 'Poppins',
      );
}

class _SystemBody2TextTheme extends TextScaleSet {
  const _SystemBody2TextTheme();

  @override
  double get fontSize => 14;
  @override
  double get height => 1.5714;
  @override
  TextStyle get regular => const TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 14,
        height: 1.5714,
        fontFamily: 'Poppins',
      );
  @override
  TextStyle get semibold => const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 14,
        height: 1.5714,
        fontFamily: 'Poppins',
      );
}

class _SystemMicroTextTheme extends TextScaleSet {
  const _SystemMicroTextTheme();

  @override
  double get fontSize => 10;
  @override
  double get height => 1.2000;
  @override
  TextStyle get regular => const TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 10,
        height: 1.2000,
        fontFamily: 'Poppins',
      );
  @override
  TextStyle get semibold => const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 10,
        height: 1.2000,
        fontFamily: 'Poppins',
      );
}

class _CaptionTextTheme extends TextScaleSet {
  const _CaptionTextTheme();

  @override
  double get fontSize => 12;
  @override
  double get height => 1.6667;
  @override
  TextStyle get regular => const TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 12,
        height: 1.6667,
        fontFamily: 'Poppins',
      );
  @override
  TextStyle get semibold => const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 12,
        height: 1.6667,
        fontFamily: 'Poppins',
      );
}

class _MobileCaptionLargeTextTheme extends TextScaleSet {
  const _MobileCaptionLargeTextTheme();

  @override
  double get fontSize => 14;
  @override
  double get height => 1.2857;
  @override
  TextStyle get regular => const TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 14,
        height: 1.2857,
        fontFamily: 'Poppins',
      );
  @override
  TextStyle get semibold => const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 14,
        height: 1.2857,
        fontFamily: 'Poppins',
      );
}

class _MobileBodyLargeTextTheme extends TextScaleSet {
  const _MobileBodyLargeTextTheme();

  @override
  double get fontSize => 16;
  @override
  double get height => 1.5000;
  @override
  TextStyle get regular => const TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 16,
        height: 1.5000,
        fontFamily: 'Poppins',
      );
  @override
  TextStyle get semibold => const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 16,
        height: 1.5000,
        fontFamily: 'Poppins',
      );
}

class _BrandH1TextTheme extends TextScaleSet {
  const _BrandH1TextTheme();

  @override
  double get fontSize => 20;
  @override
  double get height => 1.4000;
  @override
  TextStyle get regular => const TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 20,
        height: 1.4000,
        fontFamily: 'Poppins',
      );
  @override
  TextStyle get semibold => const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 20,
        height: 1.4000,
        fontFamily: 'Poppins',
      );
}

class _LabelTextTheme extends TextScaleSet {
  const _LabelTextTheme();

  @override
  double get fontSize => 10;
  @override
  double get height => 1.6000;
  @override
  TextStyle get regular => const TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 10,
        height: 1.6000,
        fontFamily: 'Poppins',
      );
  @override
  TextStyle get semibold => const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 10,
        height: 1.6000,
        fontFamily: 'Poppins',
      );
}

class _SubtextTextTheme extends TextScaleSet {
  const _SubtextTextTheme();

  @override
  double get fontSize => 10;
  @override
  double get height => 1.5000;
  @override
  TextStyle get regular => const TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 10,
        height: 1.5000,
        fontFamily: 'Poppins',
      );
  @override
  TextStyle get semibold => const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 10,
        height: 1.5000,
        fontFamily: 'Poppins',
      );
}

abstract class EvTextTheme {
  static const title = _TitleTextTheme();
  static const bodySmall = _BodySmallTextTheme();
  static const bodyLarge = _BodyLargeTextTheme();
  static const bodyTextBody2 = _BodyTextBody2TextTheme();
  static const systemSmall = _SystemSmallTextTheme();
  static const systemBody1 = _SystemBody1TextTheme();
  static const systemBody2 = _SystemBody2TextTheme();
  static const systemMicro = _SystemMicroTextTheme();
  static const caption = _CaptionTextTheme();
  static const mobileCaptionLarge = _MobileCaptionLargeTextTheme();
  static const mobileBodyLarge = _MobileBodyLargeTextTheme();
  static const headlineH6 = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 16,
    height: 1.5000,
    fontFamily: 'Poppins',
  );
  static const brandH1 = _BrandH1TextTheme();
  static const pageTitle = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 17,
    height: 1.4118,
    fontFamily: 'Poppins',
  );
  static const label = _LabelTextTheme();
  static const subtext = _SubtextTextTheme();
}
