import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pix/envio/presentation/view/pix_home_screen.dart';
import 'package:pix/envio/presentation/view/pix_success.dart';
import 'package:pix/envio/presentation/view/pix_amount_screen.dart';

// Rota para a tela principal do PIX
final pixHomeRoute = GoRoute(
  path: '/pix', // Caminho URL para esta rota
  pageBuilder: (context, state) {
    return MaterialPage(
      key: state.pageKey,
      // A View é o Widget de entrada desta rota
      child: PixHomeView(),
    );
  },
);

// Rota para a tela principal do PIX
final pixValorRoute = GoRoute(
  path: '/pix_valor', // Caminho URL para esta rota
  pageBuilder: (context, state) {
    return MaterialPage(
      key: state.pageKey,
      // A View é o Widget de entrada desta rota
      child: PixValorView(),
    );
  },
);

// Rota para a tela principal do PIX
final pixSuccessRoute = GoRoute(
  path: '/pix_success', // Caminho URL para esta rota
  pageBuilder: (context, state) {
    return MaterialPage(
      key: state.pageKey,
      // A View é o Widget de entrada desta rota
      child: PixSuccessView(),
    );
  },
);
