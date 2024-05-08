import 'dart:convert';

import 'package:peony/peony.dart';

//日志拦截器
class LoggingInterceptor extends Interceptor {
  late DateTime startTime;
  late DateTime endTime;

  //请求前
  @override
  onRequest(RequestOptions options, handler) {
    startTime = DateTime.now();
    Log.d("----------Start----------");
    if (options.queryParameters.isEmpty) {
      Log.i("RequestUrl: ${options.baseUrl}${options.path}");
    } else {
      Log.i("RequestUrl: ${options.baseUrl}${options.path}?${Transformer.urlEncodeMap(options.queryParameters)}");
    }
    Log.d("RequestMethod: ${options.method}");
    Log.d("RequestHeaders:${json.encode(options.headers)}");
    Log.d("RequestParams: ${json.encode(options.data)}");
    return handler.next(options);
  }

//响应后
  @override
  onResponse(Response response, handler) {
    endTime = DateTime.now();
    int duration = endTime.difference(startTime).inMilliseconds;
    Log.d("ResponseCode: ${response.statusCode}");
    // 输出结果
    Log.d('↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ${response.realUri} ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓');
    Log.json(response.data);
    Log.d("↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ End: $duration 毫秒 ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑");
    return handler.next(response);
  }

  @override
  onError(DioException err, handler) {
    Log.e("----------Error-----------${err.toString()}");
    return handler.next(err);
  }
}

/// 添加常用Header
class HeaderInterceptor extends InterceptorsWrapper {
  @override
  onRequest(RequestOptions options, handler) async {
    options.headers[Keys.auth] = Keys.authValue;
    return handler.next(options);
  }
}

class ErrorInterceptor extends Interceptor {
  late DateTime startTime;
  late DateTime endTime;

  String path = "";

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    startTime = DateTime.now();
    path = options.path;
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    endTime = DateTime.now();
    int duration = endTime.difference(startTime).inMilliseconds;
    Map<String, dynamic> map = {};
    map["type"] = "error";
    map["url"] = path;
    map["duration"] = duration;
    map["error"] = err.toString();
    map['errorMessage'] = err.message;
    map['errorType'] = err.type;
    map['stackTrace'] = err.stackTrace.toString();
    return handler.next(err);
  }
}
