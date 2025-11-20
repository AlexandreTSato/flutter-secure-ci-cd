// pix_home_screen.dart (Refatorado Final)

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pix/envio/presentation/commands/submit_cpf_command.dart';
import 'package:pix/envio/presentation/events/ui_event.dart';
// Importa o sistema de eventos
import 'package:pix/envio/presentation/state/pix_flow_state.dart';
import 'package:pix/envio/presentation/viewmodels/pix_flow_view_model.dart';
import 'package:pix/pix_providers.dart';
import 'package:pix/pix_routes.dart';
import 'package:shared_ui/components/widgets/pix_app_bar.dart';
import 'package:shared_ui/components/widgets/pix_background.dart';
import 'package:shared_ui/components/widgets/pix_hero_header.dart';
import 'package:shared_ui/components/widgets/pix_primary_button.dart';
import 'package:shared_ui/components/widgets/pix_text_field.dart';
// NOVO: Importa a extensão para reutilização do SnackBar
import 'package:shared_ui/extensions/snackbar_extensions.dart';

class PixHomeView extends ConsumerStatefulWidget {
  const PixHomeView({super.key});

  @override
  ConsumerState<PixHomeView> createState() => _PixHomeViewState();
}

class _PixHomeViewState extends ConsumerState<PixHomeView> {
  final TextEditingController _pixKeyController = TextEditingController();
  ProviderSubscription? _uiEventSub;

  @override
  void dispose() {
    _uiEventSub?.close();
    _pixKeyController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // OUVIR EVENTOS DE UI IMEDIATAMENTE
    Future.microtask(() {
      _uiEventSub = ref.listenManual<AsyncValue<UiEvent>>(
        uiEventStreamProvider,
        (prev, next) {
          next.whenData((event) {
            if (event case ShowSnackbar(
              message: final m,
              isError: final isErr,
            )) {
              if (context.mounted) {
                context.showAppSnackBar(m, isError: isErr);
              }
            }
          });
        },
      );
    });
  }

  // O método _showSnackBar foi REMOVIDO daqui.
  // A responsabilidade de exibição está agora em context_extensions.dart.

  @override
  Widget build(BuildContext context) {
    // // ==========================================
    // // LISTEN DE EVENTOS DE UI — CORRETO
    // // ==========================================
    // _uiEventSub ??= ref.listenManual(uiEventStreamProvider, (previous, next) {
    //   next.whenData((event) {
    //     if (event case ShowSnackbar(message: final m, isError: final isErr)) {
    //       context.showAppSnackBar(m, isError: isErr);
    //     }
    //   });
    // });
    // // ==========================================

    final pixState = ref.watch(pixFlowViewModelProvider);
    final viewModel = ref.read(pixFlowViewModelProvider.notifier);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: const PixAppBar(title: 'Enviar PIX'),
      body: Stack(
        children: [
          const AppBackground(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: pixState.when(
                initial: () => _buildForm(context, viewModel),
                loading: () => const Center(child: CircularProgressIndicator()),
                success: (chave) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    viewModel.reset();
                    if (context.mounted) context.go(pixValorRoute.path);
                  });
                  return const SizedBox.shrink();
                },
                // ESTADO ERRO: Exibe erro de NEGÓCIO (vindo do Use Case) no formulário
                error: (msg) =>
                    _buildForm(context, viewModel, errorMessage: msg),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Formulário reutilizável
  Widget _buildForm(
    BuildContext context,
    PixFlowViewModel viewModel, {
    String? errorMessage,
  }) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
          const PixHeroHeader(
            title: "Transferência PIX",
            subtitle: "Informe a chave do destinatário (CPF)",
            icon: Icons.currency_exchange_rounded,
          ),
          const SizedBox(height: 40),

          /// Campo de entrada da chave PIX
          PixTextField(
            controller: _pixKeyController,
            labelText: "Chave PIX (CPF)",
            hintText: "Ex: 000.000.000-00",
            icon: Icons.vpn_key_rounded,
            keyboardType: TextInputType.number,
            enabled: true,
          ),
          const SizedBox(height: 20),

          /// Mensagem de erro (se houver) - Erro de FLUXO/NEGÓCIO
          if (errorMessage != null) ...[
            Text(
              errorMessage,
              style: const TextStyle(color: Colors.redAccent, fontSize: 14),
            ),
            const SizedBox(height: 10),
          ],

          /// Botão principal
          PixPrimaryButton(
            text: "Continuar",
            onPressed: () async {
              final input = _pixKeyController.text.trim();

              if (input.isEmpty) {
                // Validação de Input BÁSICA: Usa a extensão global
                context.showAppSnackBar(
                  "Informe uma chave PIX válida.",
                  isError: true,
                );
                return;
              }

              // Envia o comando para o ViewModel
              await viewModel.handleCommand(SubmitCpfCommand(input));
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
}
