import 'package:core_networking/core_networking.dart';
import 'package:dio/dio.dart';

class DioConfig {
  final String baseUrl;
  final Duration connectTimeout;
  final Duration receiveTimeout;
  final Duration sendTimeout;
  final bool enableLogging;
  final bool logBody;
  final Map<String, String> defaultHeaders;
  final List<Interceptor> extraInterceptors;

  const DioConfig({
    required this.baseUrl,
    this.connectTimeout = const Duration(seconds: 10),
    this.receiveTimeout = const Duration(seconds: 20),
    this.sendTimeout = const Duration(seconds: 20),
    this.enableLogging = true,
    this.logBody = false,
    this.defaultHeaders = const {},
    this.extraInterceptors = const [],
  });
}

Dio buildDio({
  required DioConfig config,
  TokenSupplier? tokenSupplier,
  List<Interceptor> Function(Dio dio)? interceptorsBuilder,
}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: config.baseUrl,
      connectTimeout: config.connectTimeout,
      receiveTimeout: config.receiveTimeout,
      sendTimeout: config.sendTimeout,
      headers: {'Content-Type': 'application/json', ...config.defaultHeaders},
      responseType: ResponseType.json,
    ),
  );

  // Interceptors padrão
  final interceptors = <Interceptor>[];

  // Auth (opcional)
  if (tokenSupplier != null) {
    interceptors.add(AuthInterceptor(tokenSupplier: tokenSupplier));
  }

  // Logging
  if (config.enableLogging) {
    interceptors.add(LoggingInterceptor(logBody: config.logBody));
  }

  // Retry
  interceptors.add(
    RetryInterceptor(
      maxAttempts: 3,
      baseDelay: const Duration(milliseconds: 300),
      maxDelay: const Duration(seconds: 2),
      retryOnStatuses: const {408, 429, 500, 502, 503, 504},
    ),
  );

  // Extras
  interceptors.addAll(config.extraInterceptors);

  // Custom builder (permite interceptors que dependem do dio)
  if (interceptorsBuilder != null) {
    interceptors.addAll(interceptorsBuilder(dio));
  }

  dio.interceptors.addAll(interceptors);
  return dio;
}
