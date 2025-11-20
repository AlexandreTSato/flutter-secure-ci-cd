import 'package:go_router/go_router.dart';
import 'pix_routes.dart';

// Exporta o provedor do repositório para que o aplicativo principal (appbank)
// possa injetá-lo no seu Graph de Dependências.
// Isso permite que o appbank chame o provedor sem precisar importar pix_providers.dart.
//export 'pix_providers.dart' show pixRepositoryProvider;

/// Lista de rotas do módulo PIX.
/// Esta lista será combinada no GoRouter principal no appbank.
final List<GoRoute> pixRoutes = [
  // Importa a rota principal definida em pix_routes.dart
  pixHomeRoute,
  pixValorRoute,
  pixSuccessRoute,
];
