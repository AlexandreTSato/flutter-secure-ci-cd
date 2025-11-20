import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pix/envio/domain/models/chave_pix.dart';
import 'package:pix/envio/presentation/state/pix_session_provider.dart';

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer();
  });

  tearDown(() => container.dispose());

  test('✅ Deve iniciar com a sessão vazia', () {
    final state = container.read(pixSessionProvider);
    expect(state.chaveDestinatario, isNull);
    expect(state.valorTransferencia, equals(0.0));
  });

  test('✅ Deve armazenar a chave PIX na memória', () {
    final chave = ChavePix(
      id: 1,
      email: 'teste@pix.com',
      valor: null,
    ); // ChavePix._() exige todos param se não tiver default

    // Ação: Salva na sessão
    container.read(pixSessionProvider.notifier).setChaveEncontrada(chave);

    // Verificação: O estado atualizou?
    final state = container.read(pixSessionProvider);
    expect(state.chaveDestinatario, equals(chave));
    // Garante que o valor zerou (regra de negócio ao trocar chave)
    expect(state.valorTransferencia, equals(0.0));
  });

  test('✅ Deve acumular o valor monetário sobre a chave existente', () {
    // Arrange
    final chave = ChavePix(id: 1, email: 'teste@pix.com');
    final notifier = container.read(pixSessionProvider.notifier);

    notifier.setChaveEncontrada(chave);

    // Act
    notifier.setValor(150.00);

    // Assert
    final state = container.read(pixSessionProvider);
    expect(state.chaveDestinatario, equals(chave));
    expect(state.valorTransferencia, equals(150.00));
  });

  test('♻️ Reset deve limpar toda a memória da sessão', () {
    final notifier = container.read(pixSessionProvider.notifier);
    notifier.setChaveEncontrada(ChavePix(id: 1, email: 'a@b.com'));
    notifier.setValor(100);

    // Act
    notifier.resetSession();

    // Assert
    final state = container.read(pixSessionProvider);
    expect(state.chaveDestinatario, isNull);
    expect(state.valorTransferencia, equals(0.0));
  });
}
