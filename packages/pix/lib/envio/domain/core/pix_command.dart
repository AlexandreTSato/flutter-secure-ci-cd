import 'package:pix/core/results/result.dart';

/// Contract for domain use cases (commands that execute business logic).
abstract class UseCase<Input, Output> {
  Future<Result<Output>> execute(Input input);
}
