import 'package:core_foundation/core_foundation.dart';
import 'package:core_foundation/results/safe_execute.dart';
import 'package:core_networking/core_networking.dart'; // mapDioError
import 'package:dio/dio.dart'; // DioException
import 'package:pix/envio/data/datasources/pix_repository_datasource_contract.dart';
import 'package:pix/envio/data/dto/pix_key_dto.dart';
import 'package:pix/envio/domain/value_objects/amount.dart';
import 'package:pix/envio/domain/value_objects/cpf.dart';

import '../../domain/contracts/pix_repository_contract.dart';
import '../../domain/models/chave_pix.dart';

class PixRepository implements PixRepositoryContract {
  final PixRemoteDataSourceContract _remoteDataSource;

  PixRepository(this._remoteDataSource);

  @override
  ResultAsync<ChavePix> fetchKey(Cpf cpf) => safeExecute(
    () async {
      // Extrai VO na borda e chama datasource (Dio com interceptors/retry)
      final dto = await _remoteDataSource.fetchKey(cpf.value);
      return dto.toDomain();
    },
    onMap: (error, st) {
      if (error is DioException) return mapDioError(error);
      if (error is FormatException) return NetworkFailure.badResponse(st);
      return DomainFailure(error.toString(), st);
    },
  );

  @override
  ResultAsync<ChavePix> fetchAmount(Amount amount) => safeExecute(
    () async {
      final dto = await _remoteDataSource.fetchAmount(amount.value);
      return dto.toDomain();
    },
    onMap: (error, st) {
      if (error is DioException) return mapDioError(error);
      if (error is FormatException) return NetworkFailure.badResponse(st);
      return DomainFailure(error.toString(), st);
    },
  );
}
