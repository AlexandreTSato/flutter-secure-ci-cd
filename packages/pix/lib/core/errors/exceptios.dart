/// core/exceptions.dart
library;

/// Exceção lançada quando ocorre um erro de rede, como falha de conexão
/// ou timeout em uma requisição HTTP.
class NetworkException implements Exception {
  final String message;
  final int? statusCode;

  const NetworkException(this.message, {this.statusCode});

  @override
  String toString() => 'NetworkException($statusCode): $message';
}

/// Exceção lançada quando o servidor retorna um erro (status 5xx, 4xx).
class ServerException implements Exception {
  final String message;
  final int? statusCode;

  const ServerException(this.message, {this.statusCode});

  @override
  String toString() => 'ServerException($statusCode): $message';
}

/// Exceção lançada quando dados inválidos são detectados localmente ou remotamente.
class ValidationException implements Exception {
  final String message;

  const ValidationException(this.message);

  @override
  String toString() => 'ValidationException: $message';
}
