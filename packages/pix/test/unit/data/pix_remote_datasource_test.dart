import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';

import 'package:pix/envio/data/datasources/pix_remote_datasource.dart';
import 'package:pix/envio/data/dto/pix_key_dto.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late PixRemoteDataSource dataSource;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    dataSource = PixRemoteDataSource(dio: mockDio);
  });

  group('PixRemoteDataSource', () {
    var userId = 1;

    test('✅ retorna PixKeyDto quando resposta for 200', () async {
      // arrange
      final mockResponse = Response(
        requestOptions: RequestOptions(path: '/users/$userId'),
        statusCode: 200,
        data: {
          "id": userId,
          "email": "alexandre.ts@gmail.com",
          "name": "Alexandre",
          "username": "alexandre.ts",
          "statusCode": "200",
        },
      );

      when(
        () => mockDio.get(
          '/users/$userId',
          queryParameters: {'include': 'metadata'},
        ),
      ).thenAnswer((_) async => mockResponse);

      // act
      final result = await dataSource.fetchKey(userId.toString());

      // assert
      expect(result, isA<PixKeyDto>());
      expect(result.id, equals(userId));
      verify(
        () => mockDio.get(
          '/users/$userId',
          queryParameters: {'include': 'metadata'},
        ),
      ).called(1);
    });

    test('🌐 lança DioException em erro de rede', () async {
      // arrange
      when(
        () =>
            mockDio.get(any(), queryParameters: any(named: 'queryParameters')),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/users/$userId'),
          type: DioExceptionType.connectionError,
        ),
      );

      // act
      Future<void> act() async => dataSource.fetchKey(userId.toString());

      // assert
      expect(act, throwsA(isA<DioException>()));
      verify(
        () =>
            mockDio.get(any(), queryParameters: any(named: 'queryParameters')),
      ).called(1);
    });

    test('💰 fetchAmount retorna PixKeyDto quando resposta for 200', () async {
      const amount = 123.45;
      final mockResponse = Response(
        requestOptions: RequestOptions(path: '/users/$userId'),
        statusCode: 200,
        data: {
          "id": userId,
          "email": "alexandre.ts@gmail.com",
          "name": "Alexandre",
          "username": "alexandre.ts",
          "statusCode": "200",
        },
      );

      when(
        () =>
            mockDio.get('/users/$userId', queryParameters: {'amount': amount}),
      ).thenAnswer((_) async => mockResponse);

      final result = await dataSource.fetchAmount(amount);

      expect(result, isA<PixKeyDto>());
      verify(
        () =>
            mockDio.get('/users/$userId', queryParameters: {'amount': amount}),
      ).called(1);
    });
  });
}
