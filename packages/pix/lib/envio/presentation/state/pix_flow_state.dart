import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pix/envio/domain/models/chave_pix.dart';

part 'pix_flow_state.freezed.dart';

@freezed
sealed class PixFlowState with _$PixFlowState {
  const factory PixFlowState.initial() = _Initial;
  const factory PixFlowState.loading() = _Loading;
  const factory PixFlowState.success(ChavePix chave) = _Success;
  const factory PixFlowState.error(String message) = _Error;
}
