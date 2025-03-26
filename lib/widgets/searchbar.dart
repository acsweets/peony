import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:peony/widgets/searchbar_filter_predicate.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

import 'debounce_notifier.dart';
import 'gradient_outline_border.dart';
import 'lf_dropdown_menu.dart';
import 'overlay_on_focused.dart';
import 'searchbar_overlay.dart';

const _kTFBoder = GradientOutlineBorder(
  borderSide: BorderSide(width: 1.5),
  borderRadius: BorderRadius.all(Radius.circular(23)),
  borderGradient: LinearGradient(
    colors: [Color(0xFFDCE2EE), Color(0xFFDCE2EE)],
  ),
);

class Searchbar extends StatefulWidget {
  const Searchbar({
    super.key,
    this.forgroundColor,
    this.shadowColor,
    this.fontFamily,
    this.fontFamilyFallback,
    required this.predicateList,
  });

  final Color? forgroundColor;
  final Color? shadowColor;
  final String? fontFamily;
  final List<String>? fontFamilyFallback;
  final List<SearchbarFilterPredicate> predicateList;

  static DebounceTextController? _controller;

  static DebounceTextController? get controller => _controller;

  static OverlayFocusNode? _focusNode;

  static OverlayFocusNode? get focusNode => _focusNode;

  static SearchbarState of(BuildContext context) =>
      context.findAncestorStateOfType<SearchbarState>()!;

  @override
  State<Searchbar> createState() => SearchbarState();
}

class SearchbarState extends State<Searchbar> {
  final ValueNotifier<double> _width = ValueNotifier(0);
  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    Searchbar._controller = DebounceTextController(
      debounceDuration: const Duration(milliseconds: 333),
    );
    Searchbar._focusNode = OverlayFocusNode();
    Searchbar.focusNode!.addListener(clear);
  }

  @override
  void dispose() {
    isLoading.dispose();
    Searchbar.focusNode!.removeListener(clear);
    Searchbar.focusNode!.dispose();
    Searchbar.controller!.dispose();
    super.dispose();
    Searchbar._focusNode = null;
    Searchbar._controller = null;
  }

  void clear() {
    if (!Searchbar.focusNode!.hasFocus) {
      isLoading.value = false;
      Searchbar.controller!.clear();
    }
  }

  static const Map<ShortcutActivator, Intent> _shortcuts =
  <ShortcutActivator, Intent>{
    SingleActivator(LogicalKeyboardKey.arrowUp):
    AutocompletePreviousOptionIntent(),
    SingleActivator(LogicalKeyboardKey.arrowDown):
    AutocompleteNextOptionIntent(),
    SingleActivator(LogicalKeyboardKey.enter): ConfirmHighlightOptionIntent(),
  };
  late final Map<Type, Action<Intent>> actionMap = <Type, Action<Intent>>{};

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget overlay = _AnimatedWhenShow(
      child: Material(
        color: const Color(0xFFFFFFFD),
        elevation: 6,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(14)),
        ),
        shadowColor: widget.shadowColor,
        clipBehavior: Clip.hardEdge,
        child: ListTileTheme(
          data: theme.listTileTheme.copyWith(
            contentPadding: const EdgeInsets.symmetric(horizontal: 6),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            titleTextStyle: theme.listTileTheme.titleTextStyle
                ?.merge(const TextStyle(fontSize: 14, height: 1)) ??
                const TextStyle(fontSize: 14, height: 1),
            selectedTileColor: Theme
                .of(context)
                .colorScheme
                .primary,
            selectedColor: Colors.white,
            textColor: widget.forgroundColor,
          ),
          child: TextFieldTapRegion(
            child: ValueListenableBuilder(
              valueListenable: _width,
              builder: (context, value, child) =>
                  SizedBox(width: value, child: child),
              child: MPSearchbarOverlay(barState: this),
            ),
          ),
        ),
      ),
    );

    if (LFPopupMenuPointerIntercepted.maybeOf(context) == true) {
      overlay = PointerInterceptor(child: overlay);
    }

    return _IsLoadingInherited(
      isLoadingNotifier: isLoading,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: OverlayOnFocused(
          focusNode: Searchbar.focusNode,
          overlay: (context, focusNode) {
            return ValueListenableBuilder(
              valueListenable: _width,
              builder: (context, value, child) =>
                  SizedBox(width: value, child: child),
              child: overlay,
            );
          },
          focusableViewBuilder: (context, focusNode) {
            final content = Shortcuts(
              shortcuts: _shortcuts,
              child: Actions(
                actions: actionMap,
                child: TextField(
                  focusNode: focusNode,
                  controller: Searchbar.controller,
                  style: const TextStyle(fontSize: 14),
                  textInputAction: TextInputAction.continueAction,
                  decoration: InputDecoration(
                    hintText:
                    '${MaterialLocalizations
                        .of(context)
                        .searchFieldLabel}...',
                    contentPadding: const EdgeInsets.only(
                      top: 14,
                      bottom: 15,
                      right: 20,
                    ),
                    hintStyle: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFFC4C8D7),
                    ),
                    fillColor: const Color(0x66FFFFFF),
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(left: 16, right: 8),
                      child: _SearchbarLeadingIndicator(),
                    ),
                    constraints: const BoxConstraints(
                      minHeight: 45,
                      maxHeight: 45,
                    ),
                    border: _kTFBoder,
                    enabledBorder: _kTFBoder,
                    errorBorder: _kTFBoder.copyWith(
                      borderGradient: LinearGradient(
                        colors: [
                          theme.colorScheme.primary,
                          theme.colorScheme.primary,
                        ],
                      ),
                    ),
                    focusedErrorBorder: _kTFBoder.copyWith(
                      borderGradient: LinearGradient(
                        colors: [
                          theme.colorScheme.secondary,
                          theme.colorScheme.secondary,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    focusedBorder: _kTFBoder.copyWith(
                      borderGradient: LinearGradient(
                        colors: [
                          theme.colorScheme.primary,
                          theme.colorScheme.secondary,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                ),
              ),
            );
            return LayoutBuilder(
              builder: (context, constraints) {
                SchedulerBinding.instance.addPostFrameCallback((_) {
                  _width.value = constraints.maxWidth;
                });
                return content;
              },
            );
          },
        ),
      ),
    );
  }
}

class _SearchbarLeadingIndicator extends StatelessWidget {
  const _SearchbarLeadingIndicator();

  ///[flutter issue #121336](https://github.com/flutter/flutter/issues/121336)
  ///源码中简单使用child的key来判断了child的切换，并不完全等价，去除key判断作为临时解决方案，等待fluter修复
  static Widget _defaultTransitionBuilder(Widget child,
      Animation<double> animation,) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      switchInCurve: Curves.easeIn,
      switchOutCurve: Curves.easeOut,
      duration: const Duration(milliseconds: 266),
      transitionBuilder: _defaultTransitionBuilder,
      child: _IsLoadingInherited.of(context)
          ? const SizedBox(
        width: 22,
        height: 22,
        child: Padding(
          padding: EdgeInsets.all(3),
          child: CupertinoActivityIndicator(),
        ),
      )
          : const Icon(
        Icons.search,
        color: Color(0xFF707891),
        size: 22,
      ),
    );
  }
}

class _IsLoadingInherited extends InheritedNotifier<ValueNotifier<bool>> {
  const _IsLoadingInherited({
    required ValueNotifier<bool> isLoadingNotifier,
    required super.child,
  }) : super(notifier: isLoadingNotifier);

  static bool of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_IsLoadingInherited>()!
        .notifier!
        .value;
  }
}

class _AnimatedWhenShow extends StatefulWidget {
  const _AnimatedWhenShow({required this.child});

  final Widget child;

  @override
  State<_AnimatedWhenShow> createState() => _AnimatedWhenShowState();
}

class _AnimatedWhenShowState extends State<_AnimatedWhenShow> {
  int? _flag = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
          (_) => setState(() => _flag = null),
    );
  }

  @override
  Widget build(BuildContext context) {
    final needShown = _flag == null;

    return _AnimatedOverlay(
      opacity: needShown ? 1 : 0,
      scale: needShown ? Offset.zero : const Offset(0, -0.1),
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 266),
      alignment: const Alignment(0.0, -3.0),
      child: widget.child,
    );
  }
}

class _AnimatedOverlay extends ImplicitlyAnimatedWidget {
  const _AnimatedOverlay({
    this.child,
    required this.alignment,
    required this.opacity,
    required this.scale,
    super.curve,
    required super.duration,
  }) : assert(opacity >= 0.0 && opacity <= 1.0);

  final Widget? child;
  final double opacity;
  final Alignment alignment;
  final Offset scale;

  @override
  ImplicitlyAnimatedWidgetState<_AnimatedOverlay> createState() =>
      _AnimatedOverlayState();
}

class _AnimatedOverlayState
    extends ImplicitlyAnimatedWidgetState<_AnimatedOverlay> {
  Tween<double>? _opacity;
  late Animation<double> _opacityAnimation;
  Tween<Offset>? _scale;
  late Animation<Offset> _scaleAnimation;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _opacity = visitor(
      _opacity,
      widget.opacity,
          (dynamic value) => Tween<double>(begin: value as double),
    ) as Tween<double>?;
    _scale = visitor(
      _scale,
      widget.scale,
          (dynamic value) => Tween<Offset>(begin: value as Offset),
    ) as Tween<Offset>?;
  }

  @override
  void didUpdateTweens() {
    _opacityAnimation = animation.drive(_opacity!);
    _scaleAnimation = animation.drive(_scale!);
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacityAnimation,
      child: SlideTransition(
        position: _scaleAnimation,
        child: widget.child,
      ),
    );
  }
}

class ConfirmHighlightOptionIntent extends Intent {
  const ConfirmHighlightOptionIntent();
}


extension TextEditingControllerUpdate on TextEditingController {
  ///为了解决直接使用[TextEditingController.text]更新文本时，光标会跑到最前面的问题
  void updateText(String? text) {
    if (text == null || text.isEmpty) {
      clear();
      return;
    }
    value = TextEditingValue(
      selection: TextSelection.collapsed(offset: text.length),
      text: text,
    );
  }
}