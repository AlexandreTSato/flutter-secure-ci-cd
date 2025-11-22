import 'package:pix/core/results/result.dart';
import 'package:pix/envio/domain/contracts/pix_repository_contract.dart';
import 'package:pix/envio/domain/models/chave_pix.dart';
import 'package:pix/envio/domain/value_objects/cpf.dart';

class SubmitCpfUseCase {
  final PixRepositoryContract repository;

  SubmitCpfUseCase(this.repository);

  Future<Result<ChavePix>> call(String rawCpf) async {
    final cpfResult = Cpf.create(rawCpf);

    return switch (cpfResult) {
      Success(data: final cpf) => repository.fetchKey(cpf),

      Failure(error: final err) => Result.failure(err),
    };
  }
}
