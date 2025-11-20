import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Checa se o dispositivo está rootado.

class RootChecker {
  // A String DEVE ser a mesma definida no Kotlin:
  static const MethodChannel _platform = MethodChannel(
    'com.bancario.app/security',
  );

  /// Tenta chamar a função nativa 'isRooted' e retorna o status.
  Future<bool> isDeviceRooted() async {
    try {
      // 1. Invoca o método nativo
      final bool? isRooted = await _platform.invokeMethod<bool>('isRooted');

      // Retorna o resultado. Se o nativo retornar nulo, assumimos não-root.
      return isRooted ?? false;
    } on PlatformException catch (e) {
      // 2. Trata erros (ex: canal não configurado, método não existe)
      if (kDebugMode) {
        print("Falha ao checar status de Root: ${e.message}");
      }
      // Em caso de falha na checagem, você deve decidir sua política.
      // Por segurança extrema (fail-secure), alguns bancos retornariam 'true' (rooted) aqui.
      return false; // Retornando false para manter o fluxo normal
    }
  }
}
