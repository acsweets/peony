import 'package:flutter/widgets.dart';

///可以动态控制是否启用的callback
class EnabledableCallbackAction<T extends Intent> extends CallbackAction<T> {
  EnabledableCallbackAction({
    required super.onInvoke,
    this.enabled = true,
  });

  bool enabled;

  @override
  bool isEnabled(covariant T intent) => enabled;

  @override
  bool consumesKey(covariant T intent) => enabled;
}
