import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:pix/envio/data/dto/pix_key_dto.dart';
import 'package:pix/envio/data/services/pix_repository.dart';
import 'package:pix/envio/domain/models/chave_pix.dart';
import 'package:pix/envio/data/datasources/pix_remote_datasource.dart';
import 'package:pix/core/results/result.dart';
import 'package:pix/envio/domain/value_objects/cpf.dart';

class MockPixRemoteDataSource extends Mock implements PixRemoteDataSource {}

void main() {
  late MockPixRemoteDataSource mockDataSource;
  late PixRepository repository;

  setUp(() {
    mockDataSource = MockPixRemoteDataSource();
    repository = PixRepository(mockDataSource);
  });

  group('PixRepository', () {
    final userCPF = (Cpf.create('44892531090') as Success<Cpf>).data;

    final dto = PixKeyDto(id: 1, email: "alexandre.ts@gmail.com");

    test(
      '✅ deve retornar Success<ChavePix> ao chamar fetchKey com sucesso',
      () async {
        // arrange
        when(
          () => mockDataSource.fetchKey(userCPF.value),
        ).thenAnswer((_) async => dto);

        // act
        final result = await repository.fetchKey(userCPF);

        // assert
        expect(result, isA<Success<ChavePix>>());
        final chave = (result as Success<ChavePix>).data;
        expect(chave.id, equals(dto.id));
        expect(chave.email, equals(dto.email));

        verify(() => mockDataSource.fetchKey(userCPF.value)).called(1);
      },
    );

    test(
      '✅ deve retornar Success<ChavePix> ao chamar fetchKey com sucesso',
      () async {
        // arrange
        when(
          () => mockDataSource.fetchKey(userCPF.value),
        ).thenAnswer((_) async => dto);

        // act
        final result = await repository.fetchKey(userCPF);

        // assert
        expect(result, isA<Success<ChavePix>>());
        final chave = (result as Success<ChavePix>).data;
        expect(chave.id, equals(dto.id));
        expect(chave.email, equals(dto.email));

        verify(() => mockDataSource.fetchKey(userCPF.value)).called(1);
      },
    );
  });
}
