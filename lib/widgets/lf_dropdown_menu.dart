import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

const Duration _kMenuDuration = Duration(milliseconds: 300);
const double _kMenuCloseIntervalEnd = 2.0 / 3.0;
const double _kMenuMaxWidth = 5.0 * _kMenuWidthStep;
const double _kMenuMinWidth = 2.0 * _kMenuWidthStep;
const double _kMenuWidthStep = 56.0;
const double _kMenuScreenPadding = 8.0;

class LFPopupMenuPointerIntercepted extends InheritedWidget {
  const LFPopupMenuPointerIntercepted({
    super.key,
    required super.child,
    required this.isPointerIntercepted,
  });

  static bool? maybeOf(BuildContext context) {
    return context
        .getInheritedWidgetOfExactType<LFPopupMenuPointerIntercepted>()
        ?.isPointerIntercepted;
  }

  final bool isPointerIntercepted;

  @override
  bool updateShouldNotify(LFPopupMenuPointerIntercepted oldWidget) => false;
}

/// Displays a menu when pressed and calls [onSelected] when the menu is dismissed
/// because an item was selected. The value passed to [onSelected] is the value of
/// the selected menu item.
///
/// One of [child] or [icon] may be provided, but not both. If [icon] is provided,
/// then [LFPopupMenuButton] behaves like an [IconButton].
///
/// If both are null, then a standard overflow icon is created (depending on the
/// platform).
///
/// /// ## Updating to [MenuAnchor]
///
/// There is a Material 3 component,
/// [MenuAnchor] that is preferred for applications that are configured
/// for Material 3 (see [ThemeData.useMaterial3]).
/// The [MenuAnchor] widget's visuals
/// are a little bit different, see the Material 3 spec at
/// <https://m3.material.io/components/menus/guidelines> for
/// more details.
///
/// The [MenuAnchor] widget's API is also slightly different.
/// [MenuAnchor]'s were built to be lower level interface for
/// creating menus that are displayed from an anchor.
///
/// There are a few steps you would take to migrate from
/// [LFPopupMenuButton] to [MenuAnchor]:
///
/// 1. Instead of using the [LFPopupMenuButton.itemBuilder] to build
/// a list of [PopupMenuEntry]s, you would use the [MenuAnchor.menuChildren]
/// which takes a list of [Widget]s. Usually, you would use a list of
/// [MenuItemButton]s as shown in the example below.
///
/// 2. Instead of using the [LFPopupMenuButton.onSelected] callback, you would
/// set individual callbacks for each of the [MenuItemButton]s using the
/// [MenuItemButton.onPressed] property.
///
/// 3. To anchor the [MenuAnchor] to a widget, you would use the [MenuAnchor.builder]
/// to return the widget of choice - usually a [TextButton] or an [IconButton].
///
/// 4. You may want to style the [MenuItemButton]s, see the [MenuItemButton]
/// documentation for details.
///
/// Use the sample below for an example of migrating from [LFPopupMenuButton] to
/// [MenuAnchor].
///
/// {@tool dartpad}
/// This example shows a menu with three items, selecting between an enum's
/// values and setting a `selectedMenu` field based on the selection.
///
/// ** See code in examples/api/lib/material/popup_menu/popup_menu.0.dart **
/// {@end-tool}
///
/// {@tool dartpad}
/// This example shows how to migrate the above to a [MenuAnchor].
///
/// ** See code in examples/api/lib/material/menu_anchor/menu_anchor.2.dart **
/// {@end-tool}
///
/// {@tool dartpad}
/// This sample shows the creation of a popup menu, as described in:
/// https://m3.material.io/components/menus/overview
///
/// ** See code in examples/api/lib/material/popup_menu/popup_menu.1.dart **
/// {@end-tool}
///
/// See also:
///
///  * [PopupMenuItem], a popup menu entry for a single value.
///  * [PopupMenuDivider], a popup menu entry that is just a horizontal line.
///  * [CheckedPopupMenuItem], a popup menu item with a checkmark.
///  * [lfShowMenu], a method to dynamically show a popup menu at a given location.
class LFPopupMenuButton<T> extends StatefulWidget {
  /// Creates a button that shows a popup menu.
  ///
  /// The [itemBuilder] argument must not be null.
  const LFPopupMenuButton({
    super.key,
    required this.itemBuilder,
    this.initialValue,
    this.onOpened,
    this.onSelected,
    this.onCanceled,
    this.tooltip,
    this.elevation,
    this.shadowColor,
    this.surfaceTintColor,
    this.borderRadius = const BorderRadius.all(Radius.circular(15)),
    this.padding = const EdgeInsets.all(8.0),
    this.text,
    this.icon,
    this.splashRadius,
    this.iconSize,
    this.offset = const Offset(0, 30),
    this.enabled = true,
    this.shape,
    this.color,
    this.enableFeedback,
    this.constraints,
    this.position,
    this.clipBehavior = Clip.none,
    this.buttonPadding =
        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    this.isPointerIntercepted,
  }) : assert(text != null || icon != null);

  /// Called when the button is pressed to create the items to show in the menu.
  final PopupMenuItemBuilder<T> itemBuilder;

  /// The value of the menu item, if any, that should be highlighted when the menu opens.
  final T? initialValue;

  /// Called when the popup menu is shown.
  final VoidCallback? onOpened;

  /// Called when the user selects a value from the popup menu created by this button.
  ///
  /// If the popup menu is dismissed without selecting a value, [onCanceled] is
  /// called instead.
  final PopupMenuItemSelected<T>? onSelected;

  /// Called when the user dismisses the popup menu without selecting an item.
  ///
  /// If the user selects a value, [onSelected] is called instead.
  final PopupMenuCanceled? onCanceled;

  /// Text that describes the action that will occur when the button is pressed.
  ///
  /// This text is displayed when the user long-presses on the button and is
  /// used for accessibility.
  final String? tooltip;

  /// The z-coordinate at which to place the menu when open. This controls the
  /// size of the shadow below the menu.
  ///
  /// Defaults to 8, the appropriate elevation for popup menus.
  final double? elevation;

  /// The color used to paint the shadow below the menu.
  ///
  /// If null then the ambient [PopupMenuThemeData.shadowColor] is used.
  /// If that is null too, then the overall theme's [ThemeData.shadowColor]
  /// (default black) is used.
  final Color? shadowColor;

  /// The color used as an overlay on [color] to indicate elevation.
  ///
  /// If null, [PopupMenuThemeData.surfaceTintColor] is used. If that
  /// is also null, the default value is [ColorScheme.surfaceTint].
  ///
  /// See [Material.surfaceTintColor] for more details on how this
  /// overlay is applied.
  final Color? surfaceTintColor;

  /// Matches IconButton's 8 dps padding by default. In some cases, notably where
  /// this button appears as the trailing element of a list item, it's useful to be able
  /// to set the padding to zero.
  final EdgeInsetsGeometry padding;

  /// The splash radius.
  ///
  /// If null, default splash radius of [InkWell] or [IconButton] is used.
  final double? splashRadius;

  /// The offset is applied relative to the initial position
  /// set by the [position].
  ///
  /// When not set, the offset defaults to [Offset.zero].
  final Offset offset;

  /// Whether this popup menu button is interactive.
  ///
  /// Must be non-null, defaults to `true`
  ///
  /// If `true` the button will respond to presses by displaying the menu.
  ///
  /// If `false`, the button is styled with the disabled color from the
  /// current [Theme] and will not respond to presses or show the popup
  /// menu and [onSelected], [onCanceled] and [itemBuilder] will not be called.
  ///
  /// This can be useful in situations where the app needs to show the button,
  /// but doesn't currently have anything to show in the menu.
  final bool enabled;

  /// If provided, the shape used for the menu.
  ///
  /// If this property is null, then [PopupMenuThemeData.shape] is used.
  /// If [PopupMenuThemeData.shape] is also null, then the default shape for
  /// [MaterialType.card] is used. This default shape is a rectangle with
  /// rounded edges of BorderRadius.circular(2.0).
  final ShapeBorder? shape;

  /// If provided, the background color used for the menu.
  ///
  /// If this property is null, then [PopupMenuThemeData.color] is used.
  /// If [PopupMenuThemeData.color] is also null, then
  /// Theme.of(context).cardColor is used.
  final Color? color;

  /// Whether detected gestures should provide acoustic and/or haptic feedback.
  ///
  /// For example, on Android a tap will produce a clicking sound and a
  /// long-press will produce a short vibration, when feedback is enabled.
  ///
  /// See also:
  ///
  ///  * [Feedback] for providing platform-specific feedback to certain actions.
  final bool? enableFeedback;

  /// If provided, the size of the [Icon].
  ///
  /// If this property is null, then [IconThemeData.size] is used.
  /// If [IconThemeData.size] is also null, then
  /// default size is 24.0 pixels.
  final double? iconSize;

  /// Optional size constraints for the menu.
  ///
  /// When unspecified, defaults to:
  /// ```dart
  /// const BoxConstraints(
  ///   minWidth: 2.0 * 56.0,
  ///   maxWidth: 5.0 * 56.0,
  /// )
  /// ```
  ///
  /// The default constraints ensure that the menu width matches maximum width
  /// recommended by the Material Design guidelines.
  /// Specifying this parameter enables creation of menu wider than
  /// the default maximum width.
  final BoxConstraints? constraints;

  /// Whether the popup menu is positioned over or under the popup menu button.
  ///
  /// [offset] is used to change the position of the popup menu relative to the
  /// position set by this parameter.
  ///
  /// If this property is `null`, then [PopupMenuThemeData.position] is used. If
  /// [PopupMenuThemeData.position] is also `null`, then the position defaults
  /// to [PopupMenuPosition.over] which makes the popup menu appear directly
  /// over the button that was used to create it.
  final PopupMenuPosition? position;

  /// {@macro flutter.material.Material.clipBehavior}
  ///
  /// The [clipBehavior] argument is used the clip shape of the menu.
  ///
  /// Defaults to [Clip.none], and must not be null.
  final Clip clipBehavior;

  final BorderRadius borderRadius;

  final String? text;
  final Widget? icon;
  final EdgeInsetsGeometry buttonPadding;

  /// Whether the popup menu is pointer intercepted.
  ///
  /// If true, the popup menu will be pointer intercepted.
  /// Defaults to false.
  final bool? isPointerIntercepted;

  @override
  LFPopupMenuButtonState<T> createState() => LFPopupMenuButtonState<T>();
}

/// The [State] for a [LFPopupMenuButton].
///
/// See [showButtonMenu] for a way to programmatically open the popup menu
/// of your button state.
class LFPopupMenuButtonState<T> extends State<LFPopupMenuButton<T>> {
  /// A method to show a popup menu with the items supplied to
  /// [LFPopupMenuButton.itemBuilder] at the position of your [LFPopupMenuButton].
  ///
  /// By default, it is called when the user taps the button and [LFPopupMenuButton.enabled]
  /// is set to `true`. Moreover, you can open the button by calling the method manually.
  ///
  /// You would access your [LFPopupMenuButtonState] using a [GlobalKey] and
  /// show the menu of the button with `globalKey.currentState.showButtonMenu`.
  void showButtonMenu() {
    final PopupMenuThemeData popupMenuTheme = PopupMenuTheme.of(context);
    final RenderBox button = context.findRenderObject()! as RenderBox;
    final RenderBox overlay =
        Navigator.of(context).overlay!.context.findRenderObject()! as RenderBox;
    final PopupMenuPosition popupMenuPosition =
        widget.position ?? popupMenuTheme.position ?? PopupMenuPosition.over;
    late Offset offset;
    switch (popupMenuPosition) {
      case PopupMenuPosition.over:
        offset = widget.offset;
      case PopupMenuPosition.under:
        offset = Offset(0.0, button.size.height) + widget.offset;
        offset -= Offset(0.0, widget.padding.vertical / 2);
    }
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(offset, ancestor: overlay),
        button.localToGlobal(
          button.size.bottomRight(Offset.zero) + offset,
          ancestor: overlay,
        ),
      ),
      Offset.zero & overlay.size,
    );
    final List<PopupMenuEntry<T>> items = widget.itemBuilder(context);
    // Only show the menu if there is something to show
    if (items.isNotEmpty) {
      widget.onOpened?.call();
      lfShowMenu<T?>(
        context: context,
        elevation: widget.elevation ?? popupMenuTheme.elevation,
        shadowColor: widget.shadowColor ?? popupMenuTheme.shadowColor,
        surfaceTintColor:
            widget.surfaceTintColor ?? popupMenuTheme.surfaceTintColor,
        items: items,
        initialValue: widget.initialValue,
        position: position,
        shape: widget.shape ?? popupMenuTheme.shape,
        color: widget.color ?? popupMenuTheme.color,
        constraints: widget.constraints,
        clipBehavior: widget.clipBehavior,
        isPointerIntercepted: widget.isPointerIntercepted ??
            LFPopupMenuPointerIntercepted.maybeOf(context) ??
            false,
      ).then<void>((T? newValue) {
        if (!mounted) {
          return null;
        }
        if (newValue == null) {
          widget.onCanceled?.call();
          return null;
        }
        widget.onSelected?.call(newValue);
      });
    }
  }

  bool get _canRequestFocus {
    final NavigationMode mode =
        MediaQuery.maybeNavigationModeOf(context) ?? NavigationMode.traditional;
    switch (mode) {
      case NavigationMode.traditional:
        return widget.enabled;
      case NavigationMode.directional:
        return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final text = widget.text;
    final icon = widget.icon;

    final bool enableFeedback = widget.enableFeedback ??
        PopupMenuTheme.of(context).enableFeedback ??
        true;

    assert(debugCheckHasMaterialLocalizations(context));

    Widget content = InkWell(
      onTap: widget.enabled ? showButtonMenu : null,
      canRequestFocus: _canRequestFocus,
      radius: widget.splashRadius,
      borderRadius: widget.borderRadius,
      enableFeedback: enableFeedback,
      child: Padding(
        padding: widget.buttonPadding,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (text != null)
              Text(
                text,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            if (text != null && icon != null) const SizedBox(width: 8),
            if (icon != null) icon,
          ],
        ),
      ),
    );

    if (widget.tooltip != null) {
      content = Tooltip(
        message: widget.tooltip,
        child: content,
      );
    }

    return content;
  }
}

Future<T?> lfShowMenu<T>({
  required BuildContext context,
  required RelativeRect position,
  required List<PopupMenuEntry<T>> items,
  T? initialValue,
  double? elevation,
  Color? shadowColor,
  Color? surfaceTintColor,
  String? semanticLabel,
  ShapeBorder? shape,
  EdgeInsetsGeometry? menuPadding,
  Color? color,
  bool useRootNavigator = false,
  BoxConstraints? constraints,
  Clip clipBehavior = Clip.none,
  RouteSettings? routeSettings,
  AnimationStyle? popUpAnimationStyle,
  bool isPointerIntercepted = false,
}) {
  assert(items.isNotEmpty);
  assert(debugCheckHasMaterialLocalizations(context));

  switch (Theme.of(context).platform) {
    case TargetPlatform.iOS:
    case TargetPlatform.macOS:
      break;
    case TargetPlatform.android:
    case TargetPlatform.fuchsia:
    case TargetPlatform.linux:
    case TargetPlatform.windows:
      semanticLabel ??= MaterialLocalizations.of(context).popupMenuLabel;
  }

  final List<GlobalKey> menuItemKeys =
      List<GlobalKey>.generate(items.length, (int index) => GlobalKey());
  final NavigatorState navigator =
      Navigator.of(context, rootNavigator: useRootNavigator);
  return navigator.push(
    _PopupMenuRoute<T>(
      position: position,
      items: items,
      itemKeys: menuItemKeys,
      initialValue: initialValue,
      elevation: elevation,
      shadowColor: shadowColor,
      surfaceTintColor: surfaceTintColor,
      semanticLabel: semanticLabel,
      barrierLabel: MaterialLocalizations.of(context).menuDismissLabel,
      shape: shape,
      menuPadding: menuPadding,
      color: color,
      capturedThemes:
          InheritedTheme.capture(from: context, to: navigator.context),
      constraints: constraints,
      clipBehavior: clipBehavior,
      settings: routeSettings,
      popUpAnimationStyle: popUpAnimationStyle,
      isPointerIntercepted: isPointerIntercepted,
    ),
  );
}

class _PopupMenuRoute<T> extends PopupRoute<T> {
  _PopupMenuRoute({
    required this.position,
    required this.items,
    required this.itemKeys,
    this.initialValue,
    this.elevation,
    this.surfaceTintColor,
    this.shadowColor,
    required this.barrierLabel,
    this.semanticLabel,
    this.shape,
    this.menuPadding,
    this.color,
    required this.capturedThemes,
    this.constraints,
    required this.clipBehavior,
    super.settings,
    this.popUpAnimationStyle,
    required this.isPointerIntercepted,
  })  : itemSizes = List<Size?>.filled(items.length, null),
        // Menus always cycle focus through their items irrespective of the
        // focus traversal edge behavior set in the Navigator.
        super(traversalEdgeBehavior: TraversalEdgeBehavior.closedLoop);

  final RelativeRect position;
  final List<PopupMenuEntry<T>> items;
  final List<GlobalKey> itemKeys;
  final List<Size?> itemSizes;
  final T? initialValue;
  final double? elevation;
  final Color? surfaceTintColor;
  final Color? shadowColor;
  final String? semanticLabel;
  final ShapeBorder? shape;
  final EdgeInsetsGeometry? menuPadding;
  final Color? color;
  final CapturedThemes capturedThemes;
  final BoxConstraints? constraints;
  final Clip clipBehavior;
  final AnimationStyle? popUpAnimationStyle;
  final bool isPointerIntercepted;

  CurvedAnimation? _animation;

  @override
  Animation<double> createAnimation() {
    if (popUpAnimationStyle != AnimationStyle.noAnimation) {
      return _animation ??= CurvedAnimation(
        parent: super.createAnimation(),
        curve: popUpAnimationStyle?.curve ?? Curves.linear,
        reverseCurve: popUpAnimationStyle?.reverseCurve ??
            const Interval(0.0, _kMenuCloseIntervalEnd),
      );
    }
    return super.createAnimation();
  }

  void scrollTo(int selectedItemIndex) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (itemKeys[selectedItemIndex].currentContext != null) {
        Scrollable.ensureVisible(itemKeys[selectedItemIndex].currentContext!);
      }
    });
  }

  @override
  Widget buildModalBarrier() {
    final content = super.buildModalBarrier();
    if (isPointerIntercepted) {
      return PointerInterceptor(child: content);
    }
    return content;
  }

  @override
  Duration get transitionDuration =>
      popUpAnimationStyle?.duration ?? _kMenuDuration;

  @override
  bool get barrierDismissible => true;

  @override
  Color? get barrierColor => null;

  @override
  final String barrierLabel;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    int? selectedItemIndex;
    if (initialValue != null) {
      for (int index = 0;
          selectedItemIndex == null && index < items.length;
          index += 1) {
        if (items[index].represents(initialValue)) {
          selectedItemIndex = index;
        }
      }
    }
    if (selectedItemIndex != null) {
      scrollTo(selectedItemIndex);
    }

    final Widget menu = _PopupMenu<T>(
      route: this,
      itemKeys: itemKeys,
      semanticLabel: semanticLabel,
      constraints: constraints,
      clipBehavior: clipBehavior,
    );
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeBottom: true,
      removeLeft: true,
      removeRight: true,
      child: Builder(
        builder: (BuildContext context) {
          return CustomSingleChildLayout(
            delegate: _PopupMenuRouteLayout(
              position,
              itemSizes,
              selectedItemIndex,
              Directionality.of(context),
              mediaQuery.padding,
              _avoidBounds(mediaQuery),
            ),
            child: capturedThemes.wrap(menu),
          );
        },
      ),
    );
  }

  Set<Rect> _avoidBounds(MediaQueryData mediaQuery) {
    return DisplayFeatureSubScreen.avoidBounds(mediaQuery).toSet();
  }

  @override
  void dispose() {
    _animation?.dispose();
    super.dispose();
  }
}

class _PopupMenuRouteLayout extends SingleChildLayoutDelegate {
  _PopupMenuRouteLayout(
    this.position,
    this.itemSizes,
    this.selectedItemIndex,
    this.textDirection,
    this.padding,
    this.avoidBounds,
  );

  // Rectangle of underlying button, relative to the overlay's dimensions.
  final RelativeRect position;

  // The sizes of each item are computed when the menu is laid out, and before
  // the route is laid out.
  List<Size?> itemSizes;

  // The index of the selected item, or null if PopupMenuButton.initialValue
  // was not specified.
  final int? selectedItemIndex;

  // Whether to prefer going to the left or to the right.
  final TextDirection textDirection;

  // The padding of unsafe area.
  EdgeInsets padding;

  // List of rectangles that we should avoid overlapping. Unusable screen area.
  final Set<Rect> avoidBounds;

  // We put the child wherever position specifies, so long as it will fit within
  // the specified parent size padded (inset) by 8. If necessary, we adjust the
  // child's position so that it fits.

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    // The menu can be at most the size of the overlay minus 8.0 pixels in each
    // direction.
    return BoxConstraints.loose(constraints.biggest).deflate(
      const EdgeInsets.all(_kMenuScreenPadding) + padding,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final double y = position.top;

    // Find the ideal horizontal position.
    // size: The size of the overlay.
    // childSize: The size of the menu, when fully open, as determined by
    // getConstraintsForChild.
    double x;
    if (position.left > position.right) {
      // Menu button is closer to the right edge, so grow to the left, aligned to the right edge.
      x = size.width - position.right - childSize.width;
    } else if (position.left < position.right) {
      // Menu button is closer to the left edge, so grow to the right, aligned to the left edge.
      x = position.left;
    } else {
      // Menu button is equidistant from both edges, so grow in reading direction.
      x = switch (textDirection) {
        TextDirection.rtl => size.width - position.right - childSize.width,
        TextDirection.ltr => position.left,
      };
    }
    final Offset wantedPosition = Offset(x, y);
    final Offset originCenter = position.toRect(Offset.zero & size).center;
    final Iterable<Rect> subScreens =
        DisplayFeatureSubScreen.subScreensInBounds(
      Offset.zero & size,
      avoidBounds,
    );
    final Rect subScreen = _closestScreen(subScreens, originCenter);
    return _fitInsideScreen(subScreen, childSize, wantedPosition);
  }

  Rect _closestScreen(Iterable<Rect> screens, Offset point) {
    Rect closest = screens.first;
    for (final Rect screen in screens) {
      if ((screen.center - point).distance <
          (closest.center - point).distance) {
        closest = screen;
      }
    }
    return closest;
  }

  Offset _fitInsideScreen(Rect screen, Size childSize, Offset wantedPosition) {
    double x = wantedPosition.dx;
    double y = wantedPosition.dy;
    // Avoid going outside an area defined as the rectangle 8.0 pixels from the
    // edge of the screen in every direction.
    if (x < screen.left + _kMenuScreenPadding + padding.left) {
      x = screen.left + _kMenuScreenPadding + padding.left;
    } else if (x + childSize.width >
        screen.right - _kMenuScreenPadding - padding.right) {
      x = screen.right - childSize.width - _kMenuScreenPadding - padding.right;
    }
    if (y < screen.top + _kMenuScreenPadding + padding.top) {
      y = _kMenuScreenPadding + padding.top;
    } else if (y + childSize.height >
        screen.bottom - _kMenuScreenPadding - padding.bottom) {
      y = screen.bottom -
          childSize.height -
          _kMenuScreenPadding -
          padding.bottom;
    }

    return Offset(x, y);
  }

  @override
  bool shouldRelayout(_PopupMenuRouteLayout oldDelegate) {
    // If called when the old and new itemSizes have been initialized then
    // we expect them to have the same length because there's no practical
    // way to change length of the items list once the menu has been shown.
    assert(itemSizes.length == oldDelegate.itemSizes.length);

    return position != oldDelegate.position ||
        selectedItemIndex != oldDelegate.selectedItemIndex ||
        textDirection != oldDelegate.textDirection ||
        !listEquals(itemSizes, oldDelegate.itemSizes) ||
        padding != oldDelegate.padding ||
        !setEquals(avoidBounds, oldDelegate.avoidBounds);
  }
}

class _PopupMenu<T> extends StatefulWidget {
  const _PopupMenu({
    super.key,
    required this.itemKeys,
    required this.route,
    required this.semanticLabel,
    this.constraints,
    required this.clipBehavior,
  });

  final List<GlobalKey> itemKeys;
  final _PopupMenuRoute<T> route;
  final String? semanticLabel;
  final BoxConstraints? constraints;
  final Clip clipBehavior;

  @override
  State<_PopupMenu<T>> createState() => _PopupMenuState<T>();
}

class _PopupMenuState<T> extends State<_PopupMenu<T>> {
  List<CurvedAnimation> _opacities = const <CurvedAnimation>[];

  @override
  void initState() {
    super.initState();
    _setOpacities();
  }

  @override
  void didUpdateWidget(covariant _PopupMenu<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.route.items.length != widget.route.items.length ||
        oldWidget.route.animation != widget.route.animation) {
      _setOpacities();
    }
  }

  void _setOpacities() {
    for (final CurvedAnimation opacity in _opacities) {
      opacity.dispose();
    }
    final List<CurvedAnimation> newOpacities = <CurvedAnimation>[];
    final double unit = 1.0 /
        (widget.route.items.length +
            1.5); // 1.0 for the width and 0.5 for the last item's fade.
    for (int i = 0; i < widget.route.items.length; i += 1) {
      final double start = (i + 1) * unit;
      final double end = clampDouble(start + 1.5 * unit, 0.0, 1.0);
      final CurvedAnimation opacity = CurvedAnimation(
        parent: widget.route.animation!,
        curve: Interval(start, end),
      );
      newOpacities.add(opacity);
    }
    _opacities = newOpacities;
  }

  @override
  void dispose() {
    for (final CurvedAnimation opacity in _opacities) {
      opacity.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double unit = 1.0 /
        (widget.route.items.length +
            1.5); // 1.0 for the width and 0.5 for the last item's fade.
    final List<Widget> children = <Widget>[];
    final PopupMenuThemeData popupMenuTheme = PopupMenuTheme.of(context);
    final PopupMenuThemeData defaults = _PopupMenuDefaultsM3(context);

    for (int i = 0; i < widget.route.items.length; i += 1) {
      final CurvedAnimation opacity = _opacities[i];
      Widget item = widget.route.items[i];
      if (widget.route.initialValue != null &&
          widget.route.items[i].represents(widget.route.initialValue)) {
        item = ColoredBox(
          color: Theme.of(context).highlightColor,
          child: item,
        );
      }
      children.add(
        _MenuItem(
          onLayout: (Size size) {
            widget.route.itemSizes[i] = size;
          },
          child: FadeTransition(
            key: widget.itemKeys[i],
            opacity: opacity,
            child: item,
          ),
        ),
      );
    }

    final CurveTween opacity =
        CurveTween(curve: const Interval(0.0, 1.0 / 3.0));
    final CurveTween width = CurveTween(curve: Interval(0.0, unit));
    final CurveTween height =
        CurveTween(curve: Interval(0.0, unit * widget.route.items.length));

    final Widget child = ConstrainedBox(
      constraints: widget.constraints ??
          const BoxConstraints(
            minWidth: _kMenuMinWidth,
            maxWidth: _kMenuMaxWidth,
          ),
      child: IntrinsicWidth(
        stepWidth: _kMenuWidthStep,
        child: Semantics(
          scopesRoute: true,
          namesRoute: true,
          explicitChildNodes: true,
          label: widget.semanticLabel,
          child: SingleChildScrollView(
            padding: widget.route.menuPadding ??
                popupMenuTheme.menuPadding ??
                defaults.menuPadding,
            child: ListBody(children: children),
          ),
        ),
      ),
    );

    return AnimatedBuilder(
      animation: widget.route.animation!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: opacity.animate(widget.route.animation!),
          child: Material(
            shape: widget.route.shape ?? popupMenuTheme.shape ?? defaults.shape,
            color: widget.route.color ?? popupMenuTheme.color ?? defaults.color,
            clipBehavior: widget.clipBehavior,
            type: MaterialType.card,
            elevation: widget.route.elevation ??
                popupMenuTheme.elevation ??
                defaults.elevation!,
            shadowColor: widget.route.shadowColor ??
                popupMenuTheme.shadowColor ??
                defaults.shadowColor,
            surfaceTintColor: widget.route.surfaceTintColor ??
                popupMenuTheme.surfaceTintColor ??
                defaults.surfaceTintColor,
            child: Align(
              alignment: AlignmentDirectional.topEnd,
              widthFactor: width.evaluate(widget.route.animation!),
              heightFactor: height.evaluate(widget.route.animation!),
              child: child,
            ),
          ),
        );
      },
      child: child,
    );
  }
}

class _PopupMenuDefaultsM3 extends PopupMenuThemeData {
  _PopupMenuDefaultsM3(this.context) : super(elevation: 3.0);

  final BuildContext context;
  late final ThemeData _theme = Theme.of(context);
  late final ColorScheme _colors = _theme.colorScheme;
  late final TextTheme _textTheme = _theme.textTheme;

  @override
  WidgetStateProperty<TextStyle?>? get labelTextStyle {
    return WidgetStateProperty.resolveWith((Set<WidgetState> states) {
      final TextStyle style = _textTheme.labelLarge!;
      if (states.contains(WidgetState.disabled)) {
        return style.apply(color: _colors.onSurface.withValues(alpha: 0.38));
      }
      return style.apply(color: _colors.onSurface);
    });
  }

  @override
  Color? get color => _colors.surfaceContainer;

  @override
  Color? get shadowColor => _colors.shadow;

  @override
  Color? get surfaceTintColor => Colors.transparent;

  @override
  ShapeBorder? get shape => const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
      );

  @override
  EdgeInsets? get menuPadding => const EdgeInsets.symmetric(vertical: 8.0);
}

class _MenuItem extends SingleChildRenderObjectWidget {
  const _MenuItem({
    required this.onLayout,
    required super.child,
  });

  final ValueChanged<Size> onLayout;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderMenuItem(onLayout);
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant _RenderMenuItem renderObject,
  ) {
    renderObject.onLayout = onLayout;
  }
}

class _RenderMenuItem extends RenderShiftedBox {
  _RenderMenuItem(this.onLayout, [RenderBox? child]) : super(child);

  ValueChanged<Size> onLayout;

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    return child?.getDryLayout(constraints) ?? Size.zero;
  }

  @override
  double? computeDryBaseline(
    covariant BoxConstraints constraints,
    TextBaseline baseline,
  ) {
    return child?.getDryBaseline(constraints, baseline);
  }

  @override
  void performLayout() {
    if (child == null) {
      size = Size.zero;
    } else {
      child!.layout(constraints, parentUsesSize: true);
      size = constraints.constrain(child!.size);
      final BoxParentData childParentData = child!.parentData! as BoxParentData;
      childParentData.offset = Offset.zero;
    }
    onLayout(size);
  }
}
