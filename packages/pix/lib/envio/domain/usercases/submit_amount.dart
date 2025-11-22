import 'package:pix/core/results/result.dart';
import 'package:pix/envio/domain/contracts/pix_repository_contract.dart';
import 'package:pix/envio/domain/models/chave_pix.dart';
import 'package:pix/envio/domain/value_objects/amount.dart';

class SubmitAmountUseCase {
  final PixRepositoryContract repository;

  SubmitAmountUseCase(this.repository);

  Future<Result<ChavePix>> call(double rawAmount) async {
    final amountResult = Amount.create(rawAmount);

    return switch (amountResult) {
      Success(data: final amount) => repository.fetchAmount(amount),

      Failure(error: final err) => Result.failure(err),
    };
  }
}
