import 'package:dio/dio.dart';

import '../types.dart';

class AuthInterceptor extends Interceptor {
  final TokenSupplier tokenSupplier;

  AuthInterceptor({required this.tokenSupplier});

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await tokenSupplier();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }
}
