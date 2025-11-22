import 'ui_command.dart'; // importa a base abstrata UiCommand

class SubmitCpfCommand extends UiCommand {
  final String rawCpf;
  SubmitCpfCommand(this.rawCpf);
}
