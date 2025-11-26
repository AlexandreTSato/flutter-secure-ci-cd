import 'package:core_foundation/core_foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pix/envio/domain/value_objects/cpf.dart';

void main() {
  group('Cpf Value Object', () {
    test(
      'CPF válido deve retornar Success com valor formatado corretamente',
      () {
        // act
        final result = Cpf.create('111.444.777-35');

        // assert
        expect(result, isA<Success<Cpf>>());
        final cpf = (result as Success<Cpf>).data;

        expect(cpf.value, '11144477735');
      },
    );

    test('CPF inválido deve retornar Failure com ValidationFailure', () {
      // act
      final Result<Cpf> result = Cpf.create('123.456.789-00');

      // assert: é uma instância da subclasse Failure<T>
      expect(result, isA<ResultFailure<Cpf>>());

      // cast seguro para acessar o erro de domínio
      final failure = result as ResultFailure<Cpf>;

      // supondo que Failure tenha uma propriedade `error` do tipo FailureInfo/Failure
      expect(failure.error, isA<ValidationFailure>());
      expect(
        (failure.error as ValidationFailure).message,
        contains('CPF inválido'),
      );
    });
  });
}
