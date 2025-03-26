import 'dart:async';

import 'package:flutter/widgets.dart';

class DebounceTextController extends TextEditingController
    with DebounceNotifierMixin {
  DebounceTextController({
    super.text,
    this.debounceDuration = const Duration(milliseconds: 500),
  });

  @override
  final Duration debounceDuration;
}

///**不占用**[ChangeNotifier]原本的callback, 添加了
///[debounceCallback]，并对该`callback`的调用进行防抖
mixin DebounceNotifierMixin on ChangeNotifier {
  Duration get debounceDuration;

  late final _debouncer = Debouncer(delay: debounceDuration);

  VoidCallback? debounceCallback;

  @override
  void notifyListeners() {
    super.notifyListeners();
    if (debounceCallback != null) _debouncer.call(debounceCallback!);
  }

  @override
  void dispose() {
    debounceCallback = null;
    _debouncer.cancel();
    super.dispose();
  }
}

class Debouncer {
  Debouncer({this.delay});

  final Duration? delay;
  Timer? _timer;

  void call(void Function() action) {
    _timer?.cancel();
    _timer = Timer(delay!, action);
  }

  /// Notifies if the delayed call is active.
  bool get isRunning => _timer?.isActive ?? false;

  /// Cancel the current delayed call.
  void cancel() => _timer?.cancel();
}
