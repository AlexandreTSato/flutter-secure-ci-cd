import 'package:pix/core/results/result.dart';
import 'package:pix/envio/domain/models/chave_pix.dart';
import 'package:pix/envio/domain/value_objects/amount.dart';
import 'package:pix/envio/domain/value_objects/cpf.dart';

/// O Contrato define a interface do repositório PIX.
/// Esta abstração garante o baixo acoplamento e o tratamento uniforme de erros.
abstract class PixRepositoryContract {
  ResultAsync<ChavePix> fetchKey(Cpf cpf);

  ResultAsync<ChavePix> fetchAmount(Amount amount);
}
