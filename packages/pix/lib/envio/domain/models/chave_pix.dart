import 'package:freezed_annotation/freezed_annotation.dart';

part 'chave_pix.freezed.dart';

@freezed
abstract class ChavePix with _$ChavePix {
  const factory ChavePix({
    required num id,
    required String email,
    String? valor,
  }) = _ChavePix;

  // 🔒 Construtor privado habilita a adição de regras e métodos
  const ChavePix._();

  /// 🧠 Regra de negócio: valida formato da chave
  bool get isValida {
    final trimmedValue = valor?.trim();
    return trimmedValue != null && trimmedValue.length >= 5;
  }

  /// 🔁 Regra de negócio: cria uma cópia com o email formatado
  ChavePix formatarEmail() {
    return copyWith(email: email.trim().toUpperCase());
  }
}
