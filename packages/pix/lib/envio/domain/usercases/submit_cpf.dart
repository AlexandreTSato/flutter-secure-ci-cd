import 'package:pix/core/results/result.dart';
import 'package:pix/envio/domain/contracts/pix_repository_contract.dart';
import 'package:pix/envio/domain/core/pix_command.dart';
import 'package:pix/envio/domain/models/chave_pix.dart';
import 'package:pix/envio/domain/value_objects/cpf.dart';

/// ✅ Caso de uso responsável por enviar o CPF e obter a chave PIX.
///
/// Segue o padrão oficial do Google para camadas de domínio.
/// - Não conhece Dio, HTTP, ou UI.
/// - Recebe um Value Object (`Cpf`) em vez de String.
/// - Retorna um `ResultAsync<ChavePix>` (Result ou Failure).

// submit_cpf.dart
class SubmitCpfUseCase implements UseCase<Cpf, ChavePix> {
  final PixRepositoryContract repository;
  SubmitCpfUseCase(this.repository);

  @override
  Future<Result<ChavePix>> execute(Cpf cpf) {
    return repository.fetchKey(cpf);
  }

  Future<Result<ChavePix>> call(Cpf cpf) => execute(cpf);
}
