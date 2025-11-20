import 'package:pix/core/errors/failures.dart';
import 'package:pix/core/results/result.dart';

class Amount {
  final double value;

  const Amount._(this.value);

  static Result<Amount> create(double value) {
    if (value <= 0) {
      return Result.failure(
        ValidationFailure('O Valor precisa ser maior que zero.'),
      );
    }

    return Result.success(Amount._(value));
  }
}
