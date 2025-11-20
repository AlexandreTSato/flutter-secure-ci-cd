import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_ui/components/widgets/bank_icon_header.dart';
import 'package:shared_ui/components/widgets/glass_card.dart';
import 'package:shared_ui/components/widgets/pix_background.dart';
import 'package:shared_ui/components/widgets/primary_button.dart';
import 'package:shared_ui/components/widgets/section_title.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(title: const Text('flutterbank')),
      body: Stack(
        children: [
          const AppBackground(),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: GlassCard(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const BankIconHeader(),
                    const SizedBox(height: 16),
                    const SectionTitle(
                      title: 'Bem-vindo ao flutterbank!',
                      subtitle:
                          'Gerencie suas finanças com segurança, rapidez e inovação.',
                    ),
                    const SizedBox(height: 40),
                    PrimaryButton(
                      label: 'Acessar PIX',
                      icon: Icons.qr_code_2_rounded,
                      onPressed: () => context.go('/pix'),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Esta é a tela principal do app.\nAs features são módulos independentes.',
                      textAlign: TextAlign.center,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
