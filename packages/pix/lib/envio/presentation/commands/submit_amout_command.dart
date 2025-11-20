import 'package:pix/core/results/result.dart';
import 'package:pix/envio/domain/value_objects/amount.dart';
import 'package:pix/envio/presentation/commands/ui_command.dart';

class SubmitAmountCommand extends UiCommand {
  final Result<Amount> amount;

  SubmitAmountCommand(double amount) : amount = Amount.create(amount);
}
