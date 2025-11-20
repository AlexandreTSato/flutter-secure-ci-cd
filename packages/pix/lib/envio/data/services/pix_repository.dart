import 'package:pix/core/results/result.dart';
import 'package:pix/core/results/safe_execute.dart';
import 'package:pix/envio/data/dto/pix_key_dto.dart';
import 'package:pix/envio/data/datasources/pix_repository_datasource_contract.dart';
import 'package:pix/envio/domain/value_objects/amount.dart';
import 'package:pix/envio/domain/value_objects/cpf.dart';

import '../../domain/contracts/pix_repository_contract.dart';
import '../../domain/models/chave_pix.dart';

class PixRepository implements PixRepositoryContract {
  final PixRemoteDataSourceContract _remoteDataSource;

  PixRepository(this._remoteDataSource);

  @override
  ResultAsync<ChavePix> fetchKey(Cpf cpf) => safeExecute(() async {
    // Extrai o valor do Value Object apenas na borda do domínio
    final dto = await _remoteDataSource.fetchKey(cpf.value);

    // Converte o DTO da camada de dados para o modelo de domínio
    return dto.toDomain();
  });

  @override
  ResultAsync<ChavePix> fetchAmount(Amount amount) => safeExecute(() async {
    // Extrai o valor do Value Object apenas na borda do domínio
    final dto = await _remoteDataSource.fetchAmount(amount.value);

    // Converte o DTO da camada de dados para o modelo de domínio
    return dto.toDomain();
  });
}
