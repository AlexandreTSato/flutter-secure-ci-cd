import 'package:appbank/home_view.dart';
import 'package:appbank/security/root_checker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pix/pix_module.dart';

// --- 1. Definição do Roteador Global ---
final homeRoute = GoRoute(
  path: '/',
  pageBuilder: (context, state) {
    return MaterialPage(key: state.pageKey, child: const HomeView());
  },
);

final _router = GoRouter(
  initialLocation: '/',
  routes: [homeRoute, ...pixRoutes],
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final checker = RootChecker();
  final isRooted = await checker.isDeviceRooted();

  if (isRooted) {
    if (kDebugMode) {
      print("⚠️ ALERTA DE SEGURANÇA: Dispositivo Rooted detectado.");
    }
    SystemNavigator.pop();
  } else {
    runApp(const ProviderScope(child: AppbankApp()));
  }
}

// --- 2. UI Shell (Tema e Router) ---
class AppbankApp extends StatelessWidget {
  const AppbankApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'flutterbank',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF5F6FA),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          bodyMedium: TextStyle(color: Colors.black54),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.black87,
          centerTitle: true,
          titleTextStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
        ),
      ),
      routerConfig: _router,
    );
  }
}
