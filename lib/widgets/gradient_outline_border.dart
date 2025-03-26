import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';

const _kGapPadding = 4;

///渐变色Border
class GradientOutlineBorder extends InputBorder {
  const GradientOutlineBorder({
    super.borderSide = const BorderSide(),
    this.borderRadius = const BorderRadius.all(Radius.circular(4.0)),
    this.borderGradient = const LinearGradient(
      colors: [Colors.red, Colors.orange],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  });

  static bool _cornersAreCircular(BorderRadius borderRadius) {
    return borderRadius.topLeft.x == borderRadius.topLeft.y &&
        borderRadius.bottomLeft.x == borderRadius.bottomLeft.y &&
        borderRadius.topRight.x == borderRadius.topRight.y &&
        borderRadius.bottomRight.x == borderRadius.bottomRight.y;
  }

  final BorderRadius borderRadius;
  final LinearGradient borderGradient;

  @override
  GradientOutlineBorder copyWith({
    BorderSide? borderSide,
    BorderRadius? borderRadius,
    LinearGradient? borderGradient,
  }) {
    return GradientOutlineBorder(
      borderSide: borderSide ?? this.borderSide,
      borderRadius: borderRadius ?? this.borderRadius,
      borderGradient: borderGradient ?? this.borderGradient,
    );
  }

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(borderSide.width);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..addRRect(
        borderRadius
            .resolve(textDirection)
            .toRRect(rect)
            .deflate(borderSide.width),
      );
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return Path()..addRRect(borderRadius.resolve(textDirection).toRRect(rect));
  }

  @override
  void paintInterior(
    Canvas canvas,
    Rect rect,
    Paint paint, {
    TextDirection? textDirection,
  }) {
    canvas.drawRRect(borderRadius.resolve(textDirection).toRRect(rect), paint);
  }

  @override
  bool get preferPaintInterior => true;

  Path _gapBorderPath(
    Canvas canvas,
    RRect center,
    double start,
    double extent,
  ) {
    // When the corner radii on any side add up to be greater than the
    // given height, each radius has to be scaled to not exceed the
    // size of the width/height of the RRect.
    final RRect scaledRRect = center.scaleRadii();

    final Rect tlCorner = Rect.fromLTWH(
      scaledRRect.left,
      scaledRRect.top,
      scaledRRect.tlRadiusX * 2.0,
      scaledRRect.tlRadiusY * 2.0,
    );
    final Rect trCorner = Rect.fromLTWH(
      scaledRRect.right - scaledRRect.trRadiusX * 2.0,
      scaledRRect.top,
      scaledRRect.trRadiusX * 2.0,
      scaledRRect.trRadiusY * 2.0,
    );
    final Rect brCorner = Rect.fromLTWH(
      scaledRRect.right - scaledRRect.brRadiusX * 2.0,
      scaledRRect.bottom - scaledRRect.brRadiusY * 2.0,
      scaledRRect.brRadiusX * 2.0,
      scaledRRect.brRadiusY * 2.0,
    );
    final Rect blCorner = Rect.fromLTWH(
      scaledRRect.left,
      scaledRRect.bottom - scaledRRect.blRadiusY * 2.0,
      scaledRRect.blRadiusX * 2.0,
      scaledRRect.blRadiusY * 2.0,
    );

    // This assumes that the radius is circular (x and y radius are equal).
    // Currently, BorderRadius only supports circular radii.
    const double cornerArcSweep = math.pi / 2.0;
    final Path path = Path();

    // Top left corner
    if (scaledRRect.tlRadius != Radius.zero) {
      final double tlCornerArcSweep =
          math.acos(clampDouble(1 - start / scaledRRect.tlRadiusX, 0.0, 1.0));
      path.addArc(tlCorner, math.pi, tlCornerArcSweep);
    } else {
      // Because the path is painted with Paint.strokeCap = StrokeCap.butt, horizontal coordinate is moved
      // to the left using borderSide.width / 2.
      path.moveTo(scaledRRect.left - borderSide.width / 2, scaledRRect.top);
    }

    // Draw top border from top left corner to gap start.
    if (start > scaledRRect.tlRadiusX) {
      path.lineTo(scaledRRect.left + start, scaledRRect.top);
    }

    // Draw top border from gap end to top right corner and draw top right corner.
    const double trCornerArcStart = (3 * math.pi) / 2.0;
    const double trCornerArcSweep = cornerArcSweep;
    if (start + extent < scaledRRect.width - scaledRRect.trRadiusX) {
      path.moveTo(scaledRRect.left + start + extent, scaledRRect.top);
      path.lineTo(scaledRRect.right - scaledRRect.trRadiusX, scaledRRect.top);
      if (scaledRRect.trRadius != Radius.zero) {
        path.addArc(trCorner, trCornerArcStart, trCornerArcSweep);
      }
    } else if (start + extent < scaledRRect.width) {
      final double dx = scaledRRect.width - (start + extent);
      final double sweep =
          math.asin(clampDouble(1 - dx / scaledRRect.trRadiusX, 0.0, 1.0));
      path.addArc(trCorner, trCornerArcStart + sweep, trCornerArcSweep - sweep);
    }

    // Draw right border and bottom right corner.
    if (scaledRRect.brRadius != Radius.zero) {
      path.moveTo(scaledRRect.right, scaledRRect.top + scaledRRect.trRadiusY);
    }
    path.lineTo(scaledRRect.right, scaledRRect.bottom - scaledRRect.brRadiusY);
    if (scaledRRect.brRadius != Radius.zero) {
      path.addArc(brCorner, 0.0, cornerArcSweep);
    }

    // Draw bottom border and bottom left corner.
    path.lineTo(scaledRRect.left + scaledRRect.blRadiusX, scaledRRect.bottom);
    if (scaledRRect.blRadius != Radius.zero) {
      path.addArc(blCorner, math.pi / 2.0, cornerArcSweep);
    }

    // Draw left border
    path.lineTo(scaledRRect.left, scaledRRect.top + scaledRRect.tlRadiusY);

    return path;
  }

  @override
  bool get isOutline => true;

  @override
  void paint(
    Canvas canvas,
    Rect rect, {
    double? gapStart,
    double gapExtent = 0.0,
    double gapPercentage = 0.0,
    TextDirection? textDirection,
  }) {
    assert(gapPercentage >= 0.0 && gapPercentage <= 1.0);
    assert(_cornersAreCircular(borderRadius));

    final RRect outer = borderRadius.toRRect(rect);
    final Paint paint = borderSide.toPaint()
      ..shader = borderGradient.createShader(outer.outerRect);
    final RRect center = outer.deflate(borderSide.width / 2.0);
    if (gapStart == null || gapExtent <= 0.0 || gapPercentage == 0.0) {
      canvas.drawRRect(center, paint);
    } else {
      final double extent =
          lerpDouble(0.0, gapExtent + _kGapPadding * 2.0, gapPercentage)!;
      switch (textDirection!) {
        case TextDirection.rtl:
          final Path path = _gapBorderPath(
            canvas,
            center,
            math.max(0.0, gapStart + _kGapPadding - extent),
            extent,
          );
          canvas.drawPath(path, paint);

        case TextDirection.ltr:
          final Path path = _gapBorderPath(
            canvas,
            center,
            math.max(0.0, gapStart - _kGapPadding),
            extent,
          );
          canvas.drawPath(path, paint);
      }
    }
  }

  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) {
    if (a is GradientOutlineBorder) {
      final GradientOutlineBorder outline = a;
      return GradientOutlineBorder(
        borderRadius: BorderRadius.lerp(outline.borderRadius, borderRadius, t)!,
        borderSide: BorderSide.lerp(outline.borderSide, borderSide, t),
        borderGradient: LinearGradient.lerp(
          outline.borderGradient,
          borderGradient,
          t,
        )!,
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  ShapeBorder? lerpTo(ShapeBorder? b, double t) {
    if (b is GradientOutlineBorder) {
      final GradientOutlineBorder outline = b;
      return GradientOutlineBorder(
        borderRadius: BorderRadius.lerp(borderRadius, outline.borderRadius, t)!,
        borderSide: BorderSide.lerp(borderSide, outline.borderSide, t),
        borderGradient: LinearGradient.lerp(
          borderGradient,
          outline.borderGradient,
          t,
        )!,
      );
    }
    return super.lerpTo(b, t);
  }

  @override
  GradientOutlineBorder scale(double t) {
    return GradientOutlineBorder(
      borderSide: borderSide.scale(t),
      borderRadius: borderRadius * t,
      borderGradient: borderGradient,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is GradientOutlineBorder &&
        other.borderSide == borderSide &&
        other.borderRadius == borderRadius &&
        other.borderGradient == borderGradient;
  }

  @override
  int get hashCode => Object.hash(borderSide, borderRadius);
}
