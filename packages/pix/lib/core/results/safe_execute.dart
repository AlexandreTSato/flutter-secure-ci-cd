import 'package:pix/core/errors/exceptios.dart';
import 'package:pix/core/errors/failures.dart';
import 'package:pix/core/results/result.dart';

/// Executa uma função assíncrona e converte exceções em [Result.failure].
Future<Result<T>> safeExecute<T>(Future<T> Function() action) async {
  try {
    final result = await action();
    return Result.success(result);
  } on NetworkException catch (e, st) {
    return Result.failure(NetworkFailure(e.message), st);
  } on ServerException catch (e, st) {
    return Result.failure(ServerFailure(e.message), st);
  } on ValidationException catch (e, st) {
    return Result.failure(ValidationFailure(e.message), st);
  } catch (e, st) {
    return Result.failure(UnknownFailure(e.toString()), st);
  }
}
