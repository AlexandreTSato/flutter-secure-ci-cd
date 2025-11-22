import 'package:pix/envio/presentation/commands/ui_command.dart';

class SubmitAmountCommand extends UiCommand {
  final double rawAmount;
  SubmitAmountCommand(this.rawAmount);
}
