import 'dart:math';
import 'package:dio/dio.dart';

class RetryInterceptor extends Interceptor {
  final int maxAttempts;
  final Duration baseDelay;
  final Duration maxDelay;
  final Set<int> retryOnStatuses;
  final Set<String> idempotentMethods;

  RetryInterceptor({
    this.maxAttempts = 3,
    this.baseDelay = const Duration(milliseconds: 300),
    this.maxDelay = const Duration(seconds: 2),
    this.retryOnStatuses = const {408, 429, 500, 502, 503, 504},
    this.idempotentMethods = const {'GET', 'HEAD', 'OPTIONS'},
  });

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final req = err.requestOptions;
    final attempt = (req.extra['retry_attempt'] as int?) ?? 0;

    final shouldRetry = _shouldRetry(err, attempt, req.method);
    if (!shouldRetry) {
      return handler.next(err);
    }

    final nextAttempt = attempt + 1;
    final delay = _computeBackoff(nextAttempt);

    await Future<void>.delayed(delay);

    final newOptions = Options(
      method: req.method,
      headers: req.headers,
      responseType: req.responseType,
      contentType: req.contentType,
      followRedirects: req.followRedirects,
      receiveDataWhenStatusError: req.receiveDataWhenStatusError,
      extra: {...req.extra, 'retry_attempt': nextAttempt},
    );

    try {
      final dio =
          err.requestOptions.cancelToken?.requestOptions?.extra['dio'] as Dio?;
      // Fallback ao client associado ao request (se você injetar o dio via extra)
      final client = dio ?? (err.requestOptions as dynamic).dio as Dio?;
      final response = await (client ?? _resolveDioFrom(err)).request<dynamic>(
        req.path,
        data: req.data,
        queryParameters: req.queryParameters,
        options: newOptions,
      );
      return handler.resolve(response);
    } catch (e) {
      return handler.next(err);
    }
  }

  bool _shouldRetry(DioException err, int attempt, String method) {
    if (attempt >= maxAttempts) return false;

    // Só para métodos idempotentes por padrão
    if (!idempotentMethods.contains(method.toUpperCase())) return false;

    // Erros sem resposta (timeout, network)
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.connectionError) {
      return true;
    }

    final status = err.response?.statusCode;
    return status != null && retryOnStatuses.contains(status);
  }

  Duration _computeBackoff(int attempt) {
    final exp = baseDelay.inMilliseconds * pow(2, attempt - 1);
    final jitter = Random().nextInt(150); // jitter até 150ms
    final total = min(exp.toInt() + jitter, maxDelay.inMilliseconds);
    return Duration(milliseconds: total);
  }

  // Se necessário, injete Dio no extra ao enviar requests e remova este fallback
  Dio _resolveDioFrom(DioException err) {
    // Em muitos casos não é possível resolver o Dio aqui.
    // Se quiser robustez total, injete o Dio em requestOptions.extra['dio'] na fábrica.
    throw StateError(
      'Dio instance not available for retry. Inject via extra["dio"].',
    );
  }
}
