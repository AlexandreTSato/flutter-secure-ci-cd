import '../dto/pix_key_dto.dart';

abstract class PixRemoteDataSourceContract {
  Future<PixKeyDto> fetchKey(String userId);
  Future<PixKeyDto> fetchAmount(double newAmount);
}
