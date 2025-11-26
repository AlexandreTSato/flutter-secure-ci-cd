import 'package:core_foundation/errors/exceptios.dart';

import '../errors/failures.dart';

import 'result.dart';

/// Executa [action] capturando exceções e mapeando para [Result.failure].
/// Opcional: [onMap] permite sobrepor o mapeamento padrão de exceções -> Failure.
Future<Result<T>> safeExecute<T>(
  Future<T> Function() action, {
  Failure Function(Object error, StackTrace stack)? onMap,
}) async {
  try {
    final value = await action();
    return Result.success(value);
  } catch (e, st) {
    final failure = onMap != null ? onMap(e, st) : _defaultMap(e, st);
    return Result.failure(failure, st);
  }
}

/// Mapeamento padrão de exceções conhecidas para Failures.
/// Ajuste conforme sua hierarquia real de Exceptions.
Failure _defaultMap(Object error, StackTrace st) {
  // Validation -> ValidationFailure
  if (error is ValidationException) {
    return ValidationFailure(error.message, st);
  }

  // Network genérico -> NetworkFailure.unknown (ou refine se tiver tipos internos)
  if (error is NetworkException) {
    // Se NetworkException possuir código/status, você pode diferenciar aqui.
    return NetworkFailure.unknown(st);
  }

  // Server explícito -> NetworkFailure.server
  if (error is ServerException) {
    return NetworkFailure.server(st);
  }

  // Domínio específico
  // if (error is DomainException) {
  //   return DomainFailure(error.message, st);
  // }

  // Cancelamento explícito de requisição
  // if (error is RequestCancelledException) {
  //   return NetworkFailure.cancelled(st);
  // }

  // Fallback genérico
  return DomainFailure(error.toString(), st);
}
