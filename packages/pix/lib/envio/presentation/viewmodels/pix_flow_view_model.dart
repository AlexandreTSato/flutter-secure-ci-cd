import 'package:core_foundation/core_foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pix/envio/domain/models/chave_pix.dart';
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

  // Novo: sequência para descartar respostas obsoletas
  int _opSeq = 0;

  @override
  PixFlowState build() {
    _submitCpf = ref.read(submitCpfUseCaseProvider);
    _submitAmount = ref.read(submitAmountUseCaseProvider);
    _eventNotifier = ref.read(uiEventNotifierProvider.notifier);

    return const PixFlowState.initial();
  }

  Future<void> _execute<T>({
    required Future<Result<T>> Function() task,
    required void Function(T data) onSuccess,
    bool showLoading = true,
    PixFlowState Function(T data)? mapToState,
  }) async {
    final mySeq = ++_opSeq;

    if (showLoading) {
      state = const PixFlowState.loading();
    }

    final result = await task();

    if (mySeq != _opSeq) return;

    switch (result) {
      case Success<T>(data: final data):
        onSuccess(data);
        if (mapToState != null) {
          state = mapToState(data);
        }
        break;

      case ResultFailure<T>(error: final err):
        _eventNotifier.addEvent(
          UiEvent.showSnackbar(message: err.toString(), isError: true),
        );
        state = PixFlowState.error(err.message);
        break;
    }
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
    await _execute<ChavePix>(
      task: () => _submitCpf(rawCpf),
      onSuccess: (chave) {
        ref.read(pixSessionProvider.notifier).setChaveEncontrada(chave);
      },
      showLoading: true,
      mapToState: PixFlowState.success, // publica success(ChavePix)
    );
  }

  /// ----------------------------------------------------------------
  /// AMOUNT FLOW
  /// ----------------------------------------------------------------
  Future<void> _onSubmitAmount(double rawAmount) async {
    await _execute<ChavePix>(
      task: () => _submitAmount(rawAmount),
      onSuccess: (_) {
        ref.read(pixSessionProvider.notifier).setValor(rawAmount);
      },
      showLoading: false, // sem flicker se não houver IO pesado
      mapToState: PixFlowState.success, // teste exige success aqui também
    );
  }

  /// ----------------------------------------------------------------
  /// Reset Flow
  /// ----------------------------------------------------------------
  void reset() => state = const PixFlowState.initial();
}
