import 'package:flutter/material.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pix/core/results/result.dart';
import 'package:pix/envio/domain/models/chave_pix.dart';
import 'package:pix/envio/domain/usercases/submit_cpf.dart';

import 'package:pix/envio/domain/value_objects/cpf.dart';
import 'package:pix/envio/presentation/view/pix_home_screen.dart';
import 'package:pix/envio/presentation/state/pix_flow_state.dart';
import 'package:pix/pix_providers.dart';

import 'package:pix/pix_routes.dart';

/// 🔄 Um ChangeNotifier que faz o GoRouter reagir a mudanças em um provider.
/// Use como `refreshListenable` no GoRouter.
///
/// Exemplo:
/// ```dart
/// final router = GoRouter(
///   initialLocation: '/',
///   refreshListenable: RiverpodChangeNotifier(container, pixFlowViewModelProvider),
///   routes: [...],
/// );
/// ```
class RiverpodChangeNotifier extends ChangeNotifier {
  late final ProviderSubscription _subscription;

  RiverpodChangeNotifier(
    ProviderContainer container,
    ProviderListenable provider,
  ) {
    _subscription = container.listen(provider, (previous, next) {
      notifyListeners(); // informa ao GoRouter que algo mudou
    });
  }

  @override
  void dispose() {
    _subscription.close(); // encerra o listener
    super.dispose();
  }
}

/// Mock do UseCase de envio de CPF
class MockSubmitCpfUseCase extends Mock implements SubmitCpfUseCase {}

void main() {
  late MockSubmitCpfUseCase mockUseCase;

  setUpAll(() {
    final validCpf = (Cpf.create('44892531090') as Success<Cpf>).data;
    registerFallbackValue(validCpf);
  });

  setUp(() {
    mockUseCase = MockSubmitCpfUseCase();
  });

  testWidgets('✅ Deve chamar SubmitCpfUseCase e navegar ao sucesso', (
    WidgetTester tester,
  ) async {
    // Mock
    when(() => mockUseCase.call(any())).thenAnswer(
      (_) async => Result.success(ChavePix(id: 99, email: 'mock@pix.com')),
    );

    final container = ProviderContainer(
      overrides: [submitCpfUseCaseProvider.overrideWithValue(mockUseCase)],
    );

    final router = GoRouter(
      initialLocation: '/',
      refreshListenable: RiverpodChangeNotifier(
        container,
        pixFlowViewModelProvider,
      ),
      routes: [
        GoRoute(path: '/', builder: (_, _) => const PixHomeView()),
        GoRoute(
          path: '/pix/valor',
          builder: (_, _) =>
              const Scaffold(body: Center(child: Text('Tela Valor PIX'))),
        ),
      ],
    );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(routerConfig: router),
      ),
    );

    // Simula entrada válida
    await tester.enterText(find.byType(TextField), '44892531090');
    await tester.pump();

    // Clica no botão "Continuar"
    await tester.tap(find.text('Continuar'));
    await tester.pump(); // primeiro frame → estado loading()

    // Aguarda callback e rebuild
    await tester.runAsync(() async {
      await Future<void>.delayed(const Duration(milliseconds: 400));
    });
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // ✅ Verifica se o caso de uso foi chamado
    verify(() => mockUseCase.call(any())).called(1);

    // ✅ Verifica que o GoRouter navegou para a rota esperada
    final location = router.routerDelegate.currentConfiguration.uri.toString();

    expect(location, equals(pixValorRoute.path));

    // ✅ Estado final resetado
    final state = container.read(pixFlowViewModelProvider);
    state.when(
      initial: () => debugPrint('✅ Estado resetado corretamente.'),
      loading: () => fail('Ainda está em loading'),
      success: (_) => fail('Estado não foi resetado.'),
      error: (_) => fail('Não deve estar em erro'),
    );
  });

  testWidgets('❌ Deve exibir erro se CPF for inválido', (
    WidgetTester tester,
  ) async {
    // Caso de uso não deve ser chamado
    when(
      () => mockUseCase.call(any()),
    ).thenAnswer((_) async => Result.failure(Exception('não deve chamar')));

    final container = ProviderContainer(
      overrides: [submitCpfUseCaseProvider.overrideWithValue(mockUseCase)],
    );

    final router = GoRouter(
      initialLocation: '/',
      refreshListenable: RiverpodChangeNotifier(
        container,
        pixFlowViewModelProvider,
      ),
      routes: [
        GoRoute(path: '/', builder: (_, _) => const PixHomeView()),
        GoRoute(
          path: '/pix/valor',
          builder: (_, _) => const Scaffold(
            body: Center(child: Text('O CPF deve conter 11 dígitos.')),
          ),
        ),
      ],
    );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(routerConfig: router),
      ),
    );

    // Insere CPF inválido
    await tester.enterText(find.byType(TextField), '123');
    await tester.tap(find.text('Continuar'));
    await tester.pump();

    // ✅ Deve mostrar snackbar de erro
    expect(
      find.textContaining('O CPF deve conter 11 dígitos.'),
      findsOneWidget,
    );

    // ✅ Caso de uso não chamado
    verifyNever(() => mockUseCase.call(any()));
  });
}
