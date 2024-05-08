import 'dart:convert' as convert;
import 'package:flutter/foundation.dart';

/// 输出Log工具类
class Log {
  static d(Object msg, {eventName = 'LOG', action = '   d   '}) {
    _print(msg, eventName: eventName, action: action);
  }

  static i(String msg, {eventName = 'LOG', action = '   i   '}) {
    _print(msg, eventName: eventName, action: action);
  }

  static e(String msg, {eventName = 'LOG', action = '   e   '}) {
    _print(msg, eventName: eventName, action: action);
  }

  static json(Map<String, dynamic> msg, {eventName = 'WHY-LOG', action = '   json   '}) {
    _print(convert.json.encode(msg), eventName: eventName, action: action);
  }

  static _print(Object? msg, {eventName = 'X-LOG', action = '   v   '}) {
    /// 单元测试不必初始化Log工具类，直接使用print输出。
    if (kDebugMode && msg != null) {
      String message = msg.toString();
      if (message.isNotEmpty && message.length > 512) {
        debugPrint("$eventName $action ${message.substring(0, 512)}");
        message = message.substring(512, message.length);
        while (message.isNotEmpty) {
          if (message.length > 512) {
            debugPrint(message.substring(0, 512));
            message = message.substring(512, message.length);
          } else {
            debugPrint(message.toString());
            message = "";
          }
        }
      } else {
        debugPrint("$eventName $action $message");
      }
    }
  }




}