abstract class AppException implements Exception {
  final String? message;
  const AppException([this.message]);

  @override
  String toString() => message ?? runtimeType.toString();
}

class ServerException extends AppException {
  final int? statusCode;
  final dynamic data;
  const ServerException([super.message, this.statusCode, this.data]);
}

class NetworkException extends AppException {
  const NetworkException([super.message]);
}

class TimeoutException extends AppException {
  const TimeoutException([super.message]);
}

class CacheException extends AppException {
  const CacheException([super.message]);
}

class UnknownException extends AppException {
  const UnknownException([super.message]);
}
