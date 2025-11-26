import 'package:core_foundation/core_foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pix/envio/domain/models/chave_pix.dart';
import 'package:pix/envio/domain/usercases/submit_amount.dart';
import 'package:pix/envio/domain/usercases/submit_cpf.dart';
import 'package:pix/envio/domain/value_objects/amount.dart';
import 'package:pix/envio/domain/value_objects/cpf.dart';
import 'package:pix/envio/presentation/commands/submit_amout_command.dart';
import 'package:pix/envio/presentation/commands/submit_cpf_command.dart';
import 'package:pix/envio/presentation/events/ui_event.dart';
import 'package:pix/envio/presentation/events/ui_event_notifier.dart';
import 'package:pix/envio/presentation/state/pix_flow_state.dart';
import 'package:pix/envio/presentation/state/pix_session_provider.dart';
import 'package:pix/envio/presentation/viewmodels/pix_flow_view_model.dart';
import 'package:pix/pix_providers.dart';

// --------------------
// Mocks
// --------------------

class MockSubmitCpfUseCase extends Mock implements SubmitCpfUseCase {}

class MockSubmitAmountUseCase extends Mock implements SubmitAmountUseCase {}

// --------------------
// Fake Notifier real (a correção)
// --------------------

class FakeUiEventNotifier extends UiEventNotifier {
  final List<UiEvent> capturedEvents = [];

  @override
  void addEvent(UiEvent event) {
    capturedEvents.add(event);
  }
}

// --------------------
// Fakes para Value Objects
// --------------------

class FakeCpf extends Fake implements Cpf {}

class FakeAmmout extends Fake implements Amount {}

void main() {
  late MockSubmitCpfUseCase mockCpf;
  late MockSubmitAmountUseCase mockAmount;
  late FakeUiEventNotifier fakeUiEventNotifier;
  late ProviderContainer container;
  late PixFlowViewModel viewModel;

  setUpAll(() {
    registerFallbackValue(FakeCpf());
    registerFallbackValue(FakeAmmout());
    registerFallbackValue(const ShowSnackbar(message: '', isError: false));
  });

  setUp(() {
    mockCpf = MockSubmitCpfUseCase();
    mockAmount = MockSubmitAmountUseCase();
    fakeUiEventNotifier = FakeUiEventNotifier();

    container = ProviderContainer(
      overrides: [
        submitCpfUseCaseProvider.overrideWithValue(mockCpf),
        submitAmountUseCaseProvider.overrideWithValue(mockAmount),

        // ⭐ A correção importante:
        uiEventNotifierProvider.overrideWith(() => fakeUiEventNotifier),
      ],
    );

    viewModel = container.read(pixFlowViewModelProvider.notifier);
  });

  tearDown(() => container.dispose());

  test('✅ Sucesso no CPF deve popular o PixSessionProvider', () async {
    // Arrange
    final chavePix = ChavePix(id: 1, email: 'integration@pix.com');
    when(
      () => mockCpf.call(any()),
    ).thenAnswer((_) async => Result.success(chavePix));

    // Act
    await viewModel.handleCommand(SubmitCpfCommand('44892531090'));

    // Assert 1: Estado da View mudou para Success
    final viewState = container.read(pixFlowViewModelProvider);
    viewState.maybeWhen(
      success: (_) {},
      orElse: () => fail('ViewModel deveria estar em sucesso'),
    );

    // Assert 2 (O MAIS IMPORTANTE): O dado foi parar na Sessão Global?
    final sessionState = container.read(pixSessionProvider);
    expect(sessionState.chaveDestinatario, equals(chavePix));
    expect(
      sessionState.chaveDestinatario?.email,
      equals('integration@pix.com'),
    );
  });

  test('❌ CPF inválido emite SnackBar e deixa estado error', () async {
    // Arrange
    when(() => mockCpf.call(any())).thenAnswer(
      (_) async => Result.failure(
        const ValidationFailure('O CPF deve conter 11 dígitos.'),
      ),
    );

    // Act
    await viewModel.handleCommand(SubmitCpfCommand('123'));

    // Assert 1: UseCase chamado 1x
    verify(() => mockCpf.call('123')).called(1);

    // Assert 2: estado final é ERROR
    final state = container.read(pixFlowViewModelProvider);
    expect(state.maybeWhen(error: (_) => true, orElse: () => false), isTrue);

    // Assert 3: snackbar emitido
    expect(fakeUiEventNotifier.capturedEvents, hasLength(1));

    final event = fakeUiEventNotifier.capturedEvents.last as ShowSnackbar;
    expect(event.message, contains('O CPF deve conter 11 dígitos.'));
    expect(event.isError, isTrue);
  });

  test('✅ Valor válido muda estado para success', () async {
    final chavePix = ChavePix(id: 42, email: 'teste@pix.com');

    when(
      () => mockAmount.call(any()),
    ).thenAnswer((_) async => Result.success(chavePix));

    await viewModel.handleCommand(SubmitAmountCommand(10.0));

    final state = container.read(pixFlowViewModelProvider);

    state.maybeWhen(
      success: (chave) => expect(chave.email, equals('teste@pix.com')),
      orElse: () => fail('Estado não chegou a success'),
    );

    verify(() => mockAmount.call(any())).called(1);
  });

  test('❌ Valor inválido emite SnackBar e deixa estado error', () async {
    // Arrange: usecase será chamado mas retornará falha
    when(() => mockAmount.call(any())).thenAnswer(
      (_) async => Result.failure(
        const ValidationFailure('O Valor precisa ser maior que zero.'),
      ),
    );

    // Act
    await viewModel.handleCommand(SubmitAmountCommand(0.0));

    // Assert 1: UseCase é chamado uma vez
    verify(() => mockAmount.call(0.0)).called(1);

    // Assert 2: estado final agora é error()
    final state = container.read(pixFlowViewModelProvider);
    expect(state.maybeWhen(error: (_) => true, orElse: () => false), isTrue);

    // Assert 3: snackbar emitido
    expect(fakeUiEventNotifier.capturedEvents.length, 1);

    final event = fakeUiEventNotifier.capturedEvents.last as ShowSnackbar;
    expect(event.message, contains('O Valor precisa ser maior que zero.'));
    expect(event.isError, isTrue);
  });

  test(
    '💥 Falha de Use Case MUDA estado para error + exibe snackbar',
    () async {
      // arrange
      final errorMessage = 'Falha de serviço';

      when(() => mockCpf.call(any())).thenAnswer(
        (_) async => Result.failure(
          UnknownFailure(errorMessage), // Uso Failure, não Exception
        ),
      );

      // act
      await viewModel.handleCommand(SubmitCpfCommand('44892531090'));

      // assert: estado final é error
      final state = container.read(pixFlowViewModelProvider);

      state.maybeWhen(
        error: (msg) => expect(msg, contains(errorMessage)),
        orElse: () => fail('Estado deveria ser error, mas foi $state'),
      );

      // assert: um snackbar foi emitido
      expect(fakeUiEventNotifier.capturedEvents.length, 1);

      final event = fakeUiEventNotifier.capturedEvents.last as ShowSnackbar;
      expect(event.message, contains(errorMessage));
      expect(event.isError, isTrue);
    },
  );

  test('♻️ Reset volta para initial', () {
    viewModel.reset();
    expect(
      container.read(pixFlowViewModelProvider),
      const PixFlowState.initial(),
    );
  });
}
