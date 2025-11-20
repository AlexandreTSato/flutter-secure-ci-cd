import 'package:dio/dio.dart';
import 'package:pix/envio/data/datasources/pix_repository_datasource_contract.dart';
import '../dto/pix_key_dto.dart';

class PixRemoteDataSource implements PixRemoteDataSourceContract {
  final Dio _dio;

  PixRemoteDataSource(this._dio);

  @override
  Future<PixKeyDto> fetchKey(String userId) async {
    //final response = await _dio.get('/users/$userId');
    final response = await _dio.get('/users/1');
    return PixKeyDto.fromJson(response.data);
  }

  @override
  Future<PixKeyDto> fetchAmount(double newAmount) async {
    //final response = await _dio.get('/users/$newCpf');
    final response = await _dio.get('/users/1');
    return PixKeyDto.fromJson(response.data);
  }
}
