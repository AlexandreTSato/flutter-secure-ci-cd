import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pix/core/errors/failures.dart' hide Failure;
import 'package:pix/core/results/result.dart';
import 'package:pix/envio/domain/usercases/submit_amount.dart';
import 'package:pix/envio/domain/usercases/submit_cpf.dart';

import 'package:pix/envio/domain/value_objects/amount.dart';
import 'package:pix/envio/domain/value_objects/cpf.dart';
import 'package:pix/envio/presentation/commands/submit_amout_command.dart';
import 'package:pix/envio/presentation/commands/submit_cpf_command.dart';
import 'package:pix/envio/presentation/commands/ui_command.dart';
import 'package:pix/envio/presentation/events/ui_event.dart';

import 'package:pix/envio/presentation/state/pix_flow_state.dart';
import 'package:pix/pix_providers.dart';

// ✅ IMPORTE O PROVIDER DA SESSÃO
import 'package:pix/envio/presentation/state/pix_session_provider.dart';

class PixFlowViewModel extends Notifier<PixFlowState> {
  late final SubmitCpfUseCase _submitCpf;
  late final SubmitAmountUseCase _submitAmount;

  @override
  PixFlowState build() {
    // injeta casos de uso via providers — mantém testabilidade
    _submitCpf = ref.read(submitCpfUseCaseProvider);
    _submitAmount = ref.read(submitAmountUseCaseProvider);

    // estado inicial declarativo
    return const PixFlowState.initial();
  }

  /// Trata comandos vindos da UI (UiCommand deve ser a hierarquia da camada presentation)
  Future<void> handleCommand(UiCommand command) async {
    switch (command) {
      case SubmitCpfCommand(:final cpf):
        await _onSubmitCpf(cpf);
        break;
      case SubmitAmountCommand(:final amount):
        await _onSubmitAmount(amount);
        break;
      default:
        // caso a hierarquia seja extensível, emite um error ou ignora;
        // aqui deixamos sem ação para não interromper fluxo em runtime.
        break;
    }
  }

  /// Processa o comando de CPF (recebe Result<>)
  Future<void> _onSubmitCpf(Result<Cpf> cpfResult) async {
    //final eventNotifier = ref.watch(uiEventNotifierProvider.notifier);
    final Cpf cpf;

    // 1. Trata o Result do ValueObject (Validação de Input)
    switch (cpfResult) {
      case Success(data: final c):
        cpf = c;
        break;
      case Failure(error: final e):
        // Falha de Validação do ValueObject (Input Inválido)
        final message = e is ValidationFailure ? e.message : e.toString();

        // Emite evento de UI para a View mostrar a SnackBar
        // eventNotifier.addEvent(
        //   UiEvent.showSnackbar(message: message, isError: true),
        // );

        ref
            .read(uiEventNotifierProvider.notifier)
            .addEvent(UiEvent.showSnackbar(message: message, isError: true));

        return; // Retorna: Não prossegue com o Use Case
    }

    // estado de carregamento
    state = const PixFlowState.loading();

    // executa caso de uso
    final result = await _submitCpf(cpf);

    // atualiza estado conforme resultado
    // result.when(
    //   success: (chave) => state = PixFlowState.success(chave),
    //   failure: (err) => state = PixFlowState.error(err.toString()),
    // );

    result.when(
      success: (chave) {
        // ✅ Atualiza o ESTADO DA SESSÃO (compartilhado)
        ref.read(pixSessionProvider.notifier).setChaveEncontrada(chave);

        state = PixFlowState.success(chave);
        // A View observa o sucesso e navega para a próxima tela
      },
      failure: (err) => state = PixFlowState.error(err.toString()),
    );
  }

  /// Processa o comando de valor (recebe Result<>)
  Future<void> _onSubmitAmount(Result<Amount> amountResult) async {
    final eventNotifier = ref.read(uiEventNotifierProvider.notifier);

    // 1. Trata o Result do ValueObject usando pattern matching
    final Amount amount;
    switch (amountResult) {
      case Success(
        data: final a,
      ): // Desestrutura o Success e atribui o dado à 'a'
        amount = a;
        break;
      case Failure(error: final e):
        // Falha de Validação do ValueObject (Input Inválido)
        final message = e is ValidationFailure ? e.message : e.toString();

        // Emite evento de UI para a View mostrar a SnackBar
        eventNotifier.addEvent(
          UiEvent.showSnackbar(message: message, isError: true),
        );
        return; // Retorna: Não prossegue com o Use Case
    }

    state = const PixFlowState.loading();

    final result = await _submitAmount(amount);

    result.when(
      success: (chave) {
        // ✅ Atualiza o ESTADO DA SESSÃO (compartilhado)
        ref.read(pixSessionProvider.notifier).setValor(amount.value);

        state = PixFlowState.success(chave);
        // A View observa o sucesso e navega para a próxima tela
      },
      failure: (err) => state = PixFlowState.error(err.toString()),
    );
  }

  /// Reseta o fluxo para o estado inicial
  void reset() => state = const PixFlowState.initial();
}
