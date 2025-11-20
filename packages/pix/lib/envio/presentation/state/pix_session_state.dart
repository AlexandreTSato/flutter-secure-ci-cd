import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pix/envio/domain/models/chave_pix.dart';

part 'pix_session_state.freezed.dart';

@freezed
abstract class PixSessionState with _$PixSessionState {
  // Estado inicial é um rascunho vazio, por isso os campos são Nullable (?)
  const factory PixSessionState({
    /// A chave Pix validada recuperada da API (Domínio)
    ChavePix? chaveDestinatario,

    /// O valor monetário que o usuário digitou (Input de UI/Regra de fluxo)
    @Default(0.0) double valorTransferencia,

    /// Mensagem opcional (Dado auxiliar)
    String? mensagem,

    /// Controla loading geral do fluxo se necessário
    @Default(false) bool isLoading,
  }) = _PixSessionState;
}
