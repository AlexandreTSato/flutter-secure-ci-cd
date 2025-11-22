import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pix/core/results/result.dart';
import 'package:pix/envio/domain/usercases/submit_amount.dart';
import 'package:pix/envio/domain/usercases/submit_cpf.dart';

import 'package:pix/envio/presentation/commands/submit_amout_command.dart';
import 'package:pix/envio/presentation/commands/submit_cpf_command.dart';
import 'package:pix/envio/presentation/commands/ui_command.dart';
import 'package:pix/envio/presentation/events/ui_event.dart';
import 'package:pix/envio/presentation/events/ui_event_notifier.dart';

import 'package:pix/envio/presentation/state/pix_flow_state.dart';
import 'package:pix/envio/presentation/state/pix_session_provider.dart';
import 'package:pix/pix_providers.dart';

/// ------------------------------------------------------------
/// VIEWMODEL MODERNA — RIVERPOD 3.x (NotifierProvider)
/// ------------------------------------------------------------
class PixFlowViewModel extends Notifier<PixFlowState> {
  late final SubmitCpfUseCase _submitCpf;
  late final SubmitAmountUseCase _submitAmount;
  late final UiEventNotifier _eventNotifier;

  @override
  PixFlowState build() {
    _submitCpf = ref.read(submitCpfUseCaseProvider);
    _submitAmount = ref.read(submitAmountUseCaseProvider);
    _eventNotifier = ref.read(uiEventNotifierProvider.notifier);

    return const PixFlowState.initial();
  }

  /// ----------------------------------------------------------------
  /// Handle: UI → Command → Action
  /// ----------------------------------------------------------------
  Future<void> handleCommand(UiCommand command) async {
    switch (command) {
      case SubmitCpfCommand(:final rawCpf):
        await _onSubmitCpf(rawCpf);
        break;

      case SubmitAmountCommand(:final rawAmount):
        await _onSubmitAmount(rawAmount);
        break;

      default:
        break;
    }
  }

  /// ----------------------------------------------------------------
  /// CPF FLOW
  /// ----------------------------------------------------------------
  Future<void> _onSubmitCpf(String rawCpf) async {
    state = const PixFlowState.loading();

    final result = await _submitCpf(rawCpf);

    switch (result) {
      case Success(data: final chave):
        // Atualiza sessão
        ref.read(pixSessionProvider.notifier).setChaveEncontrada(chave);

        state = PixFlowState.success(chave);
        break;

      case Failure(error: final err):
        _eventNotifier.addEvent(
          UiEvent.showSnackbar(message: err.toString(), isError: true),
        );

        state = PixFlowState.error(err.toString());
        break;
    }
  }

  /// ----------------------------------------------------------------
  /// AMOUNT FLOW
  /// ----------------------------------------------------------------
  Future<void> _onSubmitAmount(double rawAmount) async {
    state = const PixFlowState.loading();

    final result = await _submitAmount(rawAmount);

    switch (result) {
      case Success(data: final chave):
        ref.read(pixSessionProvider.notifier).setValor(rawAmount);

        state = PixFlowState.success(chave);
        break;

      case Failure(error: final err):
        _eventNotifier.addEvent(
          UiEvent.showSnackbar(message: err.toString(), isError: true),
        );

        state = PixFlowState.error(err.toString());
        break;
    }
  }

  /// ----------------------------------------------------------------
  /// Reset Flow
  /// ----------------------------------------------------------------
  void reset() => state = const PixFlowState.initial();
}
