import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pix/envio/domain/models/chave_pix.dart';

part 'pix_key_dto.freezed.dart';
part 'pix_key_dto.g.dart';

/// DTO (Data Transfer Object) - Representa o dado recebido da API ou do DB.
/// Usa Freezed para garantir imutabilidade, igualdade e serialização automática.
@freezed
abstract class PixKeyDto with _$PixKeyDto {
  const factory PixKeyDto({required num id, required String email}) =
      _PixKeyDto;

  factory PixKeyDto.fromJson(Map<String, dynamic> json) =>
      _$PixKeyDtoFromJson(json);
}

extension PixKeyDtoMapper on PixKeyDto {
  /// Mapper DTO → Domain
  ChavePix toDomain() => ChavePix(id: id, email: email);

  /// Mapper Domain → DTO (útil para persistência ou APIs de envio)
  Map<String, dynamic> toJson() => _$PixKeyDtoToJson(this as _PixKeyDto);
}
