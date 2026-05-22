import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../config/app_config.dart';
import '../constants/app_constants.dart';
import '../errors/exceptions.dart';

class DioClient {
  late final Dio _dio;

  DioClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.instance.baseUrl,
        connectTimeout: AppConstants.connectTimeout,
        receiveTimeout: AppConstants.receiveTimeout,
        headers: {'Content-Type': 'application/json'},
      ),
    );

    // Always append key param — even if empty, so the URL is visible in logs
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (AppConfig.instance.hasApiKey) {
            options.queryParameters['key'] = AppConfig.instance.apiKey;
          }
          handler.next(options);
        },
      ),
    );

    // Retry on 429 / 503 with exponential backoff (max 3 attempts)
    _dio.interceptors.add(_RetryInterceptor(dio: _dio));

    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(requestBody: false, responseBody: false),
      );
    }
  }

  Dio get dio => _dio;

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _mapDioError(e);
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  AppException _mapDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException('Request timed out. Please try again.');
      case DioExceptionType.connectionError:
        return NetworkException('No internet connection.');
      case DioExceptionType.badResponse:
        final code = error.response?.statusCode;
        String msg;
        switch (code) {
          case 400:
            msg = 'Bad request. Check your search query.';
          case 403:
            msg = 'API key missing or invalid (403). '
                'Run with --dart-define=BOOKS_API_KEY=your_key';
          case 429:
            msg = 'Rate limit reached (429). '
                'Add a valid API key to get a higher quota.';
          default:
            msg = error.response?.statusMessage ?? 'Server error ($code)';
        }
        return ServerException(msg, code, error.response?.data);
      case DioExceptionType.cancel:
        return UnknownException('Request cancelled.');
      case DioExceptionType.unknown:
        if (error.message?.contains('SocketException') ?? false) {
          return NetworkException('No internet connection.');
        }
        return UnknownException(error.message ?? 'Unknown error occurred.');
      default:
        return UnknownException(error.message ?? 'Unknown error occurred.');
    }
  }
}

// Retries 429 / 503 responses with exponential backoff.
// Delay schedule: 2 s → 4 s → 8 s (max 3 retries).
class _RetryInterceptor extends Interceptor {
  final Dio dio;
  static const int _maxRetries = 3;
  static const String _retryKey = '_retry_count';

  const _RetryInterceptor({required this.dio});

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final code = err.response?.statusCode;
    if (code != 429 && code != 503) {
      return handler.next(err);
    }

    final retryCount = (err.requestOptions.extra[_retryKey] as int?) ?? 0;
    if (retryCount >= _maxRetries) {
      return handler.next(err);
    }

    final delaySeconds = pow(2, retryCount + 1).toInt(); // 2, 4, 8
    if (kDebugMode) {
      // ignore: avoid_print
      print('[$_retryKey] 429 received — retry ${retryCount + 1}/$_maxRetries '
          'after ${delaySeconds}s');
    }

    await Future.delayed(Duration(seconds: delaySeconds));

    final retryOptions = err.requestOptions
      ..extra[_retryKey] = retryCount + 1;

    try {
      final response = await dio.fetch(retryOptions);
      return handler.resolve(response);
    } on DioException catch (e) {
      return handler.next(e);
    }
  }
}
