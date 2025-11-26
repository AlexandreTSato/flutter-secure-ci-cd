import 'package:dio/dio.dart';
import 'package:core_foundation/core_foundation.dart';

/// Converte DioException → Failure padronizado.
Failure mapDioError(DioException e) {
  final st = e.stackTrace;

  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.connectionError:
      return NetworkFailure.timeout(st);

    case DioExceptionType.cancel:
      return NetworkFailure.cancelled(st);

    case DioExceptionType.badResponse:
      final status = e.response?.statusCode ?? 0;
      if (status == 401) return AuthFailure.unauthorized(st);
      if (status == 403) return AuthFailure.forbidden(st);
      if (status == 404) return NetworkFailure.notFound(st);
      if (status >= 500) return NetworkFailure.server(st);
      return NetworkFailure.badResponse(st);

    default:
      return NetworkFailure.unknown(st);
  }
}
