import 'package:pix/core/results/result.dart';
import 'package:pix/envio/domain/contracts/pix_repository_contract.dart';
import 'package:pix/envio/domain/core/pix_command.dart';
import 'package:pix/envio/domain/models/chave_pix.dart';
import 'package:pix/envio/domain/value_objects/amount.dart';

/// ✅ Caso de uso responsável por enviar o CPF e obter a chave PIX.
///
/// Segue o padrão oficial do Google para camadas de domínio.
/// - Não conhece Dio, HTTP, ou UI.
/// - Recebe um Value Object (`Cpf`) em vez de String.
/// - Retorna um `ResultAsync<ChavePix>` (Result ou Failure).

// submit_cpf.dart
class SubmitAmountUseCase implements UseCase<Amount, ChavePix> {
  final PixRepositoryContract repository;
  SubmitAmountUseCase(this.repository);

  @override
  Future<Result<ChavePix>> execute(Amount amount) {
    return repository.fetchAmount(amount);
  }

  Future<Result<ChavePix>> call(Amount amount) => execute(amount);
}
