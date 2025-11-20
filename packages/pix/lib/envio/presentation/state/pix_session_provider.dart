import 'package:pix/envio/presentation/state/pix_session_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:pix/envio/domain/models/chave_pix.dart';

// ⚠️ O nome do arquivo gerado deve ser igual ao nome deste arquivo + .g.dart
part 'pix_session_provider.g.dart';

// Use @Riverpod (maiúsculo) para passar configurações como keepAlive
@Riverpod(keepAlive: true)
class PixSession extends _$PixSession {
  @override
  PixSessionState build() {
    return const PixSessionState();
  }

  // Seus métodos...
  void setChaveEncontrada(ChavePix chave) {
    state = state.copyWith(chaveDestinatario: chave, valorTransferencia: 0.0);
  }

  void setValor(double valor) {
    state = state.copyWith(valorTransferencia: valor);
  }

  void resetSession() {
    state = const PixSessionState();
  }
}
