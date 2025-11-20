import 'package:pix/core/results/result.dart';
import 'package:pix/envio/domain/value_objects/cpf.dart';
import 'ui_command.dart'; // importa a base abstrata UiCommand

///
class SubmitCpfCommand extends UiCommand {
  final Result<Cpf> cpf;

  /// Construtor: cria o ValueObject de forma segura
  SubmitCpfCommand(String rawCpf) : cpf = Cpf.create(rawCpf);
}
