import 'package:dio/dio.dart';
import 'package:pix/envio/data/datasources/pix_repository_datasource_contract.dart';
import '../dto/pix_key_dto.dart';

class PixRemoteDataSource implements PixRemoteDataSourceContract {
  final Dio _dio;
  PixRemoteDataSource({required Dio dio}) : _dio = dio;

  @override
  Future<PixKeyDto> fetchKey(String userId) async {
    // Exemplo: GET /users/{id}/pix-key
    final resp = await _dio.get(
      '/users/1',
      // '/users/$userId',
      queryParameters: {'include': 'metadata'},
    );
    final data = resp.data;
    if (data is Map<String, dynamic>) {
      return PixKeyDto.fromJson(data);
    }
    throw const FormatException('Unexpected response format (fetchKey)');
  }

  @override
  Future<PixKeyDto> fetchAmount(double newAmount) async {
    // Exemplo: GET /pix/preview?amount=123.45
    final resp = await _dio.get(
      '/users/1',
      queryParameters: {'amount': newAmount},
    );
    final data = resp.data;
    if (data is Map<String, dynamic>) {
      return PixKeyDto.fromJson(data);
    }
    throw const FormatException('Unexpected response format (fetchAmount)');
  }
}
