import 'package:dio/dio.dart';
import 'package:fin_commons/fin_commons.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../common/app_config.dart';

class ApiService {
  final Logger? logger;
  final Talker? talker;
  final String? accessToken;

  ApiService({
    this.logger,
    this.talker,
    this.accessToken,
  });

  Future<Dio> launchDio({bool? isMultiform = false}) async {
    Dio dio = Dio();
    dio.interceptors.add(LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
      logPrint: (value) {
        if (kDebugMode) {
          logger?.d('LogInterceptor => $value');
        }
      },
    ));
    dio.interceptors.add(TalkerDioLogger(talker: talker));
    dio.options.headers['Content-Type'] =
        isMultiform == true ? 'multipart/form-data' : 'application/json';
    dio.options.headers["accept"] = 'application/json';
    dio.options.headers["Authorization"] = 'Bearer $accessToken';

    dio.options.followRedirects = false;
    dio.options.validateStatus = (status) {
      if (status != null) {
        return status < 500;
      } else {
        return false;
      }
    };
    return dio;
  }

  Future<RequestResponse> get({required String endPoint, params}) async {
    Dio dio = await launchDio();
    try {
      var url = sanitizeUrl('${AppConfig.baseUrl}/$endPoint');
      final response = await dio.get(url, queryParameters: params);

      if (response.statusCode == 200) {
        return RequestResponse.fromJson(response.data);
      } else if (response.statusCode == 500) {
        return RequestResponse(false, message: 'Server Error');
      } else {
        return RequestResponse(false, message: 'Network Error');
      }
    } on DioException catch (e) {
      return DioErrorHandle.handleError(e.type);
    } catch (e) {
      return RequestResponse(false, message: 'Unknown Error');
    }
  }

  Future<RequestResponse> post(
      {required String endPoint,
      dynamic data,
      bool? isMultiform = false}) async {
    Dio dio = await launchDio(isMultiform: isMultiform);
    try {
      final response =
          await dio.post('${AppConfig.baseUrl}/$endPoint', data: data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return RequestResponse.fromJson(response.data);
      } else if (response.statusCode == 500) {
        return RequestResponse(false,
            message: response.data['message'] ?? 'Server Error');
      } else {
        return RequestResponse(false,
            message: response.data['message'] ?? 'Network Error');
      }
    } on DioException catch (e) {
      return DioErrorHandle.handleError(e.type);
    } catch (e) {
      return RequestResponse(false, message: 'Unknown Error');
    }
  }

  Future<RequestResponse> put(
      {required String endPoint, data, bool? isMultiform = false}) async {
    Dio dio = await launchDio(isMultiform: isMultiform);
    try {
      final response =
          await dio.put('${AppConfig.baseUrl}/$endPoint', data: data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return RequestResponse.fromJson(response.data);
      } else if (response.statusCode == 500) {
        return RequestResponse(false, message: 'Server Error');
      } else {
        return RequestResponse(false, message: 'Network Error');
      }
    } on DioException catch (e) {
      return DioErrorHandle.handleError(e.type);
    } catch (e) {
      return RequestResponse(false, message: 'Unknown Error');
    }
  }

  Future<RequestResponse> delete({required String endPoint, params}) async {
    Dio dio = await launchDio();
    try {
      final response = await dio.delete('${AppConfig.baseUrl}/$endPoint',
          queryParameters: params);
      if (response.statusCode == 200) {
        return RequestResponse.fromJson(response.data);
      } else if (response.statusCode == 500) {
        return RequestResponse(false, message: 'Server Error');
      } else {
        return RequestResponse(false, message: 'Network Error');
      }
    } on DioException catch (e) {
      return DioErrorHandle.handleError(e.type);
    } catch (e) {
      return RequestResponse(false, message: 'Unknown Error');
    }
  }
}

String sanitizeUrl(String url) {
  url = url
      .replaceAll(":", "__cln__")
      . // replace the : with __cln__
      replaceAll("/", "__fwd__")
      . // replace the / with __fwd__
      replaceAll("?", "__qs__")
      . // replace the ? with __qs__
      replaceAll(".", "__dot__")
      . // replace the . with __dot__
      replaceAll("=", "__eql__")
      . // replace the = with __eql__
      replaceAll(",", "__cma__")
      . // replace the , with __cma__
      replaceAll(";", "__scln__")
      . // replace the ; with __scln__
      replaceAll("&", "__amp__")
      . // replace the & with __amp__
      replaceAll("%2F", "");
  return url;
}

class DioErrorHandle {
  static RequestResponse handleError(DioExceptionType error) {
    switch (error) {
      case DioExceptionType.connectionTimeout:
        return RequestResponse(false, message: 'Connection Timeout');
      case DioExceptionType.sendTimeout:
        return RequestResponse(false, message: 'Send Timeout');
      case DioExceptionType.receiveTimeout:
        return RequestResponse(false, message: 'Receive Timeout');
      case DioExceptionType.cancel:
        return RequestResponse(false, message: 'Request Cancelled');
      case DioExceptionType.badResponse:
        return RequestResponse(false, message: 'Response Error');
      case DioExceptionType.unknown:
        return RequestResponse(false, message: 'Unknown Error');
      case DioExceptionType.connectionError:
        return RequestResponse(false, message: 'Connection Error');
      default:
        return RequestResponse(false, message: 'Unknown Error');
    }
  }
}
