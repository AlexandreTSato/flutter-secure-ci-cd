import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'dio_client.dart';

// Base URL (pode ser sobrescrito por overrides em testes ou env)
final baseUrlProvider = Provider<String>(
  (ref) => 'https://jsonplaceholder.typicode.com/',
);

// Config agregada
final dioConfigProvider = Provider<DioConfig>((ref) {
  return DioConfig(
    baseUrl: ref.watch(baseUrlProvider),
    enableLogging: true,
    logBody: false,
  );
});

// Dio principal
final dioProvider = Provider<Dio>((ref) {
  final cfg = ref.watch(dioConfigProvider);
  return buildDio(config: cfg);
});
