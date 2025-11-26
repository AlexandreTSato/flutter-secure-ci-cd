// Base sealed de falhas de domínio / infraestrutura.
sealed class Failure {
  final String message;
  final StackTrace? stackTrace;
  const Failure(this.message, [this.stackTrace]);
  @override
  String toString() => '$runtimeType(message: $message)';
}

// Falhas de validação de dados de entrada / regras de negócio.
class ValidationFailure extends Failure {
  const ValidationFailure(super.message, [super.st]);
}

// Falhas ligadas a rede / transporte HTTP.
class NetworkFailure extends Failure {
  final NetworkFailureType type;

  const NetworkFailure._(this.type, String message, [StackTrace? st])
    : super(message, st);

  // Construtores nomeados solicitados
  const NetworkFailure.timeout([StackTrace? st])
    : this._(NetworkFailureType.timeout, 'Timeout', st);

  const NetworkFailure.notFound([StackTrace? st])
    : this._(NetworkFailureType.notFound, 'Not found', st);

  const NetworkFailure.unknown([StackTrace? st])
    : this._(NetworkFailureType.unknown, 'Unknown network error', st);

  const NetworkFailure.cancelled([StackTrace? st])
    : this._(NetworkFailureType.cancelled, 'Request cancelled', st);

  const NetworkFailure.badResponse([StackTrace? st])
    : this._(NetworkFailureType.badResponse, 'Bad response', st);

  const NetworkFailure.server([StackTrace? st])
    : this._(NetworkFailureType.server, 'Server error', st);

  // Se precisar diferenciar 429 etc, adicione novos construtores aqui.
}

enum NetworkFailureType {
  timeout,
  notFound,
  unknown,
  cancelled,
  badResponse,
  server,
}

// Falhas de autenticação/autorização.
class AuthFailure extends Failure {
  final AuthFailureType type;

  const AuthFailure._(this.type, String message, [StackTrace? st])
    : super(message, st);

  const AuthFailure.unauthorized([StackTrace? st])
    : this._(AuthFailureType.unauthorized, 'Unauthorized', st);

  const AuthFailure.forbidden([StackTrace? st])
    : this._(AuthFailureType.forbidden, 'Forbidden', st);
}

enum AuthFailureType { unauthorized, forbidden }

// Falhas de domínio genéricas (regras de negócio não atendidas).
class DomainFailure extends Failure {
  const DomainFailure(super.message, [super.st]);
}

class UnknownFailure extends Failure {
  const UnknownFailure(super.message, [super.st]);
}

// Helper de criação para mapear mensagens arbitrárias (opcional).
Failure toNetworkFailure(
  NetworkFailureType type, {
  String? customMessage,
  StackTrace? stackTrace,
}) {
  switch (type) {
    case NetworkFailureType.timeout:
      return NetworkFailure.timeout(stackTrace);
    case NetworkFailureType.notFound:
      return NetworkFailure.notFound(stackTrace);
    case NetworkFailureType.unknown:
      return NetworkFailure.unknown(stackTrace);
    case NetworkFailureType.cancelled:
      return NetworkFailure.cancelled(stackTrace);
    case NetworkFailureType.badResponse:
      return NetworkFailure.badResponse(stackTrace);
    case NetworkFailureType.server:
      return NetworkFailure.server(stackTrace);
  }
}
