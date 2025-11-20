import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pix/envio/presentation/commands/submit_amout_command.dart';
import 'package:pix/envio/presentation/state/pix_flow_state.dart';
import 'package:pix/envio/presentation/state/pix_session_provider.dart'; // Import do Session Provider
import 'package:pix/envio/presentation/state/pix_session_state.dart'; // Import do Session State
import 'package:pix/envio/presentation/viewmodels/pix_flow_view_model.dart';
import 'package:pix/pix_providers.dart';
import 'package:pix/pix_routes.dart';
import 'package:shared_ui/components/widgets/pix_app_bar.dart';
import 'package:shared_ui/components/widgets/pix_background.dart';
import 'package:shared_ui/components/widgets/pix_hero_header.dart';
import 'package:shared_ui/components/widgets/pix_primary_button.dart';
import 'package:shared_ui/components/widgets/pix_text_field.dart';

class PixValorView extends ConsumerStatefulWidget {
  const PixValorView({super.key});

  @override
  ConsumerState<PixValorView> createState() => _PixValorViewState();
}

class _PixValorViewState extends ConsumerState<PixValorView> {
  final TextEditingController _pixAmountController = TextEditingController();

  @override
  void dispose() {
    _pixAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 1. ViewModel: Controla APENAS o estado da ação atual (Loading/Success/Error do envio do valor)
    final pixState = ref.watch(pixFlowViewModelProvider);
    final viewModel = ref.read(pixFlowViewModelProvider.notifier);

    // 2. Session: É a "Single Source of Truth" dos dados acumulados (Chave Pix encontrada)
    final session = ref.watch(pixSessionProvider);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: const PixAppBar(title: 'Enviar valor do Pix'),
      body: Stack(
        children: [
          const AppBackground(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: pixState.when(
                // ESTADO INICIAL → mostra o formulário preenchido com dados da sessão
                initial: () => _buildForm(context, viewModel, session),

                // ESTADO CARREGANDO → mostra indicador central
                loading: () => const Center(child: CircularProgressIndicator()),

                // ESTADO SUCESSO → Apenas navega. O dado já foi salvo na sessão pelo ViewModel antes de chegar aqui.
                success: (_) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (context.mounted) {
                      viewModel.reset();
                      context.go(pixSuccessRoute.path);
                    }
                  });
                  return const SizedBox.shrink();
                },

                // ESTADO ERRO → mostra o formulário com mensagem de erro, mas mantendo os dados da sessão visíveis
                error: (msg) =>
                    _buildForm(context, viewModel, session, errorMessage: msg),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Formulário desacoplado do estado do ViewModel anterior
  Widget _buildForm(
    BuildContext context,
    PixFlowViewModel viewModel,
    PixSessionState session, { // ✅ Recebe a sessão como parâmetro
    String? errorMessage,
  }) {
    // Recupera a chave segura da sessão
    final chave = session.chaveDestinatario;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
          const PixHeroHeader(
            title: "Transferência PIX",
            subtitle: "Informe o valor da transferência",
            icon: Icons.currency_exchange_rounded,
          ),
          const SizedBox(height: 20),

          // ✅ SEÇÃO DE DADOS DO DESTINATÁRIO
          // Agora lemos diretamente do objeto 'session', não do 'pixState' antigo
          if (chave != null) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Destinatário:',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    chave.email,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'ID da Transação: ${chave.id}',
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],

          PixTextField(
            controller: _pixAmountController,
            labelText: "Valor Pix",
            hintText: "Ex: R\$ 10,00",
            icon: Icons.money,
            keyboardType: TextInputType.number,
            enabled: true,
          ),
          const SizedBox(height: 20),

          if (errorMessage != null) ...[
            Text(
              errorMessage,
              style: const TextStyle(color: Colors.redAccent, fontSize: 14),
            ),
            const SizedBox(height: 10),
          ],

          PixPrimaryButton(
            text: "Processar PIX",
            onPressed: () async {
              final input = _pixAmountController.text.trim();

              if (input.isEmpty) {
                _showSnackBar(
                  context,
                  "Informe um valor válido.",
                  isError: true,
                );
                return;
              }

              await viewModel.handleCommand(
                SubmitAmountCommand(double.parse(input)),
              );
            },
          ),

          const SizedBox(height: 50),
          TextButton(
            onPressed: () => context.go('/'),
            child: const Text(
              "Voltar ao início",
              style: TextStyle(color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(
    BuildContext context,
    String message, {
    bool isError = false,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: isError ? Colors.redAccent : Colors.green,
      ),
    );
  }
}
