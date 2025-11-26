import 'package:dio/dio.dart';
import 'dart:developer' as dev;

class LoggingInterceptor extends Interceptor {
  final bool logBody;
  final Set<String> redactedHeaders;

  LoggingInterceptor({
    this.logBody = false,
    this.redactedHeaders = const {'authorization', 'x-api-key'},
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final uri = options.uri;
    final method = options.method;
    final headers = Map.of(options.headers).map((k, v) {
      final key = k.toString();
      final redact = redactedHeaders.contains(key.toLowerCase());
      return MapEntry(key, redact ? '***REDACTED***' : v);
    });

    dev.log('➡️ [$method] $uri\nHeaders: $headers');
    if (logBody && options.data != null) {
      dev.log('📦 Request Body: ${_safeToString(options.data)}');
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final status = response.statusCode;
    dev.log('✅ [$status] ${response.requestOptions.uri}');
    if (logBody) {
      dev.log('📦 Response Body: ${_safeToString(response.data)}');
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final code = err.response?.statusCode;
    dev.log('❌ [$code] ${err.message} @ ${err.requestOptions.uri}');
    if (logBody && err.response?.data != null) {
      dev.log('📦 Error Body: ${_safeToString(err.response!.data)}');
    }
    super.onError(err, handler);
  }

  String _safeToString(Object? data) {
    try {
      return data.toString();
    } catch (_) {
      return '<non-serializable>';
    }
  }
}
