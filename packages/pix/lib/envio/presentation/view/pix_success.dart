import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pix/pix_providers.dart';
import 'package:shared_ui/components/widgets/pix_app_bar.dart';
import 'package:shared_ui/components/widgets/pix_background.dart';
import 'package:shared_ui/components/widgets/pix_hero_header.dart';

class PixSuccessView extends ConsumerStatefulWidget {
  const PixSuccessView({super.key});

  @override
  ConsumerState<PixSuccessView> createState() => _PixSuccessViewState();
}

class _PixSuccessViewState extends ConsumerState<PixSuccessView>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeIn;

  late AnimationController _checkController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _circlePulse;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeIn = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOutExpo,
    );

    _checkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _checkController,
      curve: Curves.elasticOut,
    );
    _circlePulse = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _checkController, curve: Curves.easeOut));

    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _checkController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _checkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.read(pixFlowViewModelProvider.notifier);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const PixAppBar(title: 'Pix Enviado'),
      body: Stack(
        children: [
          const AppBackground(),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32.0,
                  vertical: 24,
                ),
                physics: const BouncingScrollPhysics(),
                child: FadeTransition(
                  opacity: _fadeIn,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const PixHeroHeader(
                        title: "Transferência PIX",
                        subtitle: "Transação concluída com sucesso",
                        icon: Icons.currency_exchange_rounded,
                      ),
                      const SizedBox(height: 48),

                      // 🔹 Animação de sucesso nativa refinada
                      AnimatedBuilder(
                        animation: _checkController,
                        builder: (context, child) {
                          return SizedBox(
                            height: 150,
                            width: 150,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Transform.scale(
                                  scale: 1.0 + (_circlePulse.value * 0.35),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.green.withValues(
                                        alpha: 0.25 * (1 - _circlePulse.value),
                                      ),
                                    ),
                                  ),
                                ),
                                ScaleTransition(
                                  scale: _scaleAnimation,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.green,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 15,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.check_rounded,
                                        color: Colors.white,
                                        size: 70,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 36),

                      Text(
                        'Pix realizado com sucesso!',
                        textAlign: TextAlign.center,
                        style: textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.3,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Seu dinheiro foi transferido instantaneamente.',
                        textAlign: TextAlign.center,
                        style: textTheme.bodyMedium?.copyWith(
                          color: Colors.white70,
                          height: 1.4,
                        ),
                      ),

                      const SizedBox(height: 48),

                      // 🔸 Botão principal
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 6,
                            shadowColor: Colors.greenAccent.withValues(
                              alpha: 0.4,
                            ),
                          ),
                          onPressed: () => context.go('/'),
                          child: const Text(
                            "Voltar ao início",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // 🔹 Botão secundário
                      TextButton(
                        onPressed: () => viewModel.reset(),
                        child: const Text(
                          "Fazer novo Pix",
                          style: TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
