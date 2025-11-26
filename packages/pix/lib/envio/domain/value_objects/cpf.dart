import 'package:core_foundation/core_foundation.dart';

class Cpf {
  final String value;

  const Cpf._(this.value);

  static Result<Cpf> create(String raw) {
    final sanitized = raw.replaceAll(RegExp(r'\D'), '');

    if (sanitized.isEmpty) {
      return Result.failure(ValidationFailure('O CPF não pode estar vazio.'));
    }

    if (sanitized.length != 11) {
      return Result.failure(ValidationFailure('O CPF deve conter 11 dígitos.'));
    }

    if (!_isValidCpf(sanitized)) {
      return Result.failure(ValidationFailure('CPF inválido.'));
    }

    return Result.success(Cpf._(sanitized));
  }

  static bool _isValidCpf(String cpf) {
    if (cpf.length != 11) return false;
    if (RegExp(r'^(\d)\1*$').hasMatch(cpf)) {
      return false; // evita CPFs tipo 11111111111
    }

    List<int> numbers = cpf.split('').map(int.parse).toList();

    // primeiro dígito verificador
    int sum1 = 0;
    for (int i = 0; i < 9; i++) {
      sum1 += numbers[i] * (10 - i);
    }
    int firstVerifier = (sum1 * 10) % 11;
    if (firstVerifier == 10) firstVerifier = 0;
    if (firstVerifier != numbers[9]) return false;

    // segundo dígito verificador
    int sum2 = 0;
    for (int i = 0; i < 10; i++) {
      sum2 += numbers[i] * (11 - i);
    }
    int secondVerifier = (sum2 * 10) % 11;
    if (secondVerifier == 10) secondVerifier = 0;
    if (secondVerifier != numbers[10]) return false;

    return true;
  }
}
