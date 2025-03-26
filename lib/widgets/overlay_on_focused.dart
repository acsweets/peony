import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef FocusableViewBuilder = Widget Function(
  BuildContext context,
  OverlayFocusNode focusNode,
);

///在获得焦点时显示[Overlay]，失去焦点时移除
class OverlayOnFocused extends StatefulWidget {
  const OverlayOnFocused({
    super.key,
    required this.focusableViewBuilder,
    this.focusNode,
    required this.overlay,
    this.followerAnchor = Alignment.topRight,
    this.targetAnchor = Alignment.bottomRight,
    this.offset = const Offset(0, 6),
  });

  ///负责获得焦点的组件, 通常为[TextField]
  final FocusableViewBuilder focusableViewBuilder;
  final OverlayFocusNode? focusNode;
  final FocusableViewBuilder overlay;
  final Alignment targetAnchor;
  final Alignment followerAnchor;
  final Offset offset;

  @override
  State<OverlayOnFocused> createState() => _OverlayOnFocusedState();
}

class _OverlayOnFocusedState extends State<OverlayOnFocused> {
  late OverlayFocusNode _focusNode;
  FocusScopeNode? _scopeNode;

  OverlayEntry? _overlayEntry;
  final _optionsLayerLink = LayerLink();

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? OverlayFocusNode();
    _focusNode.addListener(_toggleOverlay);
    _focusNode._dismissOverlay = _dismiss;
  }

  @override
  void didUpdateWidget(OverlayOnFocused oldWidget) {
    super.didUpdateWidget(oldWidget);

    final old = oldWidget.focusNode;
    final current = widget.focusNode;
    if ((old == null && current == null) || old == current) {
      return;
    }
    if (old == null) {
      _focusNode.removeListener(_toggleOverlay);
      _focusNode._dismissOverlay = null;
      _focusNode.dispose();
      _focusNode = current!;
    } else if (current == null) {
      _focusNode.removeListener(_toggleOverlay);
      _focusNode._dismissOverlay = null;
      _focusNode = OverlayFocusNode();
    } else {
      _focusNode.removeListener(_toggleOverlay);
      _focusNode._dismissOverlay = null;
      _focusNode = current;
    }
    _focusNode.addListener(_toggleOverlay);
    _focusNode._dismissOverlay = _dismiss;

    // if (widget.overlay != oldWidget.overlay) {
    //   _overlayEntry?.remove();
    //   _overlayEntry = null;
    // }
  }

  void _removeOverlayWhenScopeNotFocus() {
    if (_scopeNode!.focusedChild == null && !_scopeNode!.hasFocus) {
      _overlayEntry?.remove();
      _overlayEntry?.dispose();
      _overlayEntry = null;
    }
  }

  void _showOverlay() {
    if (_scopeNode != null) {
      _scopeNode?.removeListener(_removeOverlayWhenScopeNotFocus);
      _scopeNode?.dispose();
      _scopeNode = null;
      _overlayEntry?.dispose();
      _overlayEntry = null;
    }
    _scopeNode = FocusScopeNode();
    _scopeNode!.addListener(_removeOverlayWhenScopeNotFocus);
    _overlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        return CompositedTransformFollower(
          link: _optionsLayerLink,
          showWhenUnlinked: false,
          targetAnchor: widget.targetAnchor,
          followerAnchor: widget.followerAnchor,
          offset: widget.offset,
          child: TapRegion(
            groupId: OverlayOnFocused,
            child: Align(
              alignment: widget.followerAnchor,
              child: CallbackShortcuts(
                bindings: {
                  const SingleActivator(LogicalKeyboardKey.escape): () {
                    final fisrtFocused = _scopeNode?.children.firstWhereOrNull(
                      (e) => e.hasFocus,
                    );
                    if (fisrtFocused == null) {
                      _focusNode.unfocus();
                      _scopeNode?.unfocus();
                      _removeOverlay();
                    } else {
                      fisrtFocused.unfocus();
                    }
                  },
                },
                child: FocusScope(
                  node: _scopeNode,
                  child: widget.overlay(context, _focusNode),
                ),
              ),
            ),
          ),
        );
      },
    );
    Overlay.of(context, rootOverlay: true, debugRequiredFor: widget)
        .insert(_overlayEntry!);
  }

  void _dismiss() {
    _scopeNode?.unfocus();
    _removeOverlay();
  }

  void _removeOverlay() {
    _focusNode.unfocus();
    _scopeNode?.removeListener(_removeOverlayWhenScopeNotFocus);
    _scopeNode?.dispose();
    _scopeNode = null;
    _overlayEntry?.remove();
    _overlayEntry?.dispose();
    _overlayEntry = null;
  }

  void _toggleOverlay() {
    if (_focusNode.hasFocus) {
      _showOverlay();
    } else {
      if (primaryFocus?.ancestors.contains(_scopeNode) == false) {
        _removeOverlay();
      }
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_toggleOverlay);
    _focusNode._dismissOverlay = null;
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    _scopeNode?.dispose();
    _overlayEntry?.remove();
    _overlayEntry = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TapRegion(
      groupId: OverlayOnFocused,
      onTapOutside: (e) {
        _focusNode.unfocus();
        _scopeNode?.unfocus();
        _removeOverlay();
      },
      child: CallbackShortcuts(
        bindings: {
          const SingleActivator(LogicalKeyboardKey.escape): () {
            _focusNode.unfocus();
            _scopeNode?.unfocus();
          },
        },
        child: CompositedTransformTarget(
          link: _optionsLayerLink,
          child: widget.focusableViewBuilder(context, _focusNode),
        ),
      ),
    );
  }
}

///配合[OverlayOnFocused]使用，可以主动调用[dismissOverlay]关闭[Overlay]
class OverlayFocusNode extends FocusNode {
  VoidCallback? _dismissOverlay;
  void dismissOverlay() {
    _dismissOverlay!.call();
  }
}
