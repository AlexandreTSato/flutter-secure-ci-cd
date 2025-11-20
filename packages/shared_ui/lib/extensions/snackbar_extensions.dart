// context_extensions.dart

import 'package:flutter/material.dart';

/// Extensões para BuildContext focadas em funcionalidades de UI reutilizáveis.
extension SnackBarExtensions on BuildContext {
  /// Exibe uma SnackBar padronizada para feedback ao usuário.
  ///
  /// É seguro contra erros de BuildContext, checando se o Widget está montado.
  void showAppSnackBar(String message, {bool isError = false}) {
    // Verifica se o widget ainda está na árvore para evitar erros.
    if (!mounted) return;

    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: isError ? Colors.redAccent : Colors.green,
        // Duração padrão para feedback momentâneo
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
