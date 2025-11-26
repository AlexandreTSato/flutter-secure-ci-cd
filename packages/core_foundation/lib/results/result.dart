import '../errors/failures.dart';

sealed class Result<T> {
  const Result();
  const factory Result.success(T data) = Success<T>;
  const factory Result.failure(Failure error, [StackTrace? stackTrace]) =
      ResultFailure<T>;

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is ResultFailure<T>;
}

class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

class ResultFailure<T> extends Result<T> {
  final Failure error;
  final StackTrace? stackTrace;
  const ResultFailure(this.error, [this.stackTrace]);
}

typedef ResultAsync<T> = Future<Result<T>>;

extension ResultWhen<T> on Result<T> {
  R when<R>({
    required R Function(T data) success,
    required R Function(Failure error) failure,
  }) {
    final self = this;
    if (self is Success<T>) {
      return success(self.data);
    } else if (self is ResultFailure<T>) {
      return failure(self.error);
    } else {
      throw StateError('Unknown Result type: $self');
    }
  }
}
