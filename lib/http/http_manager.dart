import 'package:flutter/cupertino.dart';
import 'package:peony/peony.dart';

class DioManager {
  late Dio _dio;
  static DioManager? _instance;
  BaseOptions? _baseOptions;

  static Future<DioManager?> getInstance() async {
    _instance ??= DioManager();
    return _instance;
  }

  DioManager() {
    _baseOptions = BaseOptions(
        // baseUrl: Api.Base_Url,
        connectTimeout: const Duration(milliseconds: 5000),
        receiveTimeout: const Duration(milliseconds: 5000),
        contentType: "application/json; charset=utf-8");

    _dio = Dio(_baseOptions);
    _dio.interceptors
      ..add(HeaderInterceptor())
      ..add(LoggingInterceptor()); //添加cookieJar  拦截器也可以在这里添加
  }

  /// get请求
  Future<Map<String, dynamic>?> get(url, {data, options, withLoading = true}) async {
    Log.d('getRequest:==>path:$url   params:$data');
    Response? response;
    try {
      response = await _dio.get(url, queryParameters: data, options: options);
      Log.d('getResponse==>:${response.data}');
    } on DioException catch (e) {
      Log.d('getError:==>errorType:${e.type}   errorMsg:${e.message}');
    }

    ///response.data  请求成功是一个map最终需要将map进行转换 , 请求失败直接返回null
    ///map:转换 ,将List中的每一个条目执行 map方法参数接收的这个方法,这个方法返回T类型，
    ///map方法最终会返回一个  Iterable<T>
    return response?.data;
  }

  /// Post请求
  Future<Map<String, dynamic>?> post(url,
      {Map<String, dynamic>? parameters, dynamic data, Options? options, withLoading = true}) async {
    Log.d('postRequest:==>path:$url   params:$data');
    Response? response;
    try {
      response = await _dio.post(url, queryParameters: parameters, data: data, options: options);
      debugPrint('postResponse==>:${response.data}');
    } on DioException catch (e) {
      Log.d('postError:==>errorType:${e.type}   errorMsg:${e.message}');
    }

    ///response.data  请求成功是一个map最终需要将map进行转换 , 请求失败直接返回null
    ///map:转换 ,将List中的每一个条目执行 map方法参数接收的这个方法,这个方法返回T类型，
    ///map方法最终会返回一个  Iterable<T>
    return response?.data;
  }

  /// Put请求
  Future<Map<String, dynamic>?> put(url,
      {Map<String, dynamic>? parameters, dynamic data, Options? options, withLoading = true}) async {
    Log.d('postRequest:==>path:$url   params:$data');
    Response? response;
    try {
      response = await _dio.put(url, queryParameters: parameters, data: data, options: options);
      debugPrint('postResponse==>:${response.data}');
    } on DioException catch (e) {
      Log.d('postError:==>errorType:${e.type}   errorMsg:${e.message}');
    }

    ///response.data  请求成功是一个map最终需要将map进行转换 , 请求失败直接返回null
    ///map:转换 ,将List中的每一个条目执行 map方法参数接收的这个方法,这个方法返回T类型，
    ///map方法最终会返回一个  Iterable<T>
    return response?.data;
  }


}
