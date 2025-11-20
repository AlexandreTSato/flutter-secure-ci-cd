import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pix/envio/data/datasources/pix_remote_datasource.dart';
import 'package:pix/envio/data/services/pix_repository.dart';
import 'package:pix/envio/domain/contracts/pix_repository_contract.dart';
import 'package:pix/envio/data/datasources/pix_repository_datasource_contract.dart';
import 'package:pix/envio/domain/usercases/submit_amount.dart';
import 'package:pix/envio/domain/usercases/submit_cpf.dart';
import 'package:pix/envio/presentation/events/ui_event.dart';
import 'package:pix/envio/presentation/events/ui_event_notifier.dart';
import 'package:pix/envio/presentation/state/pix_flow_state.dart';
import 'package:pix/envio/presentation/viewmodels/pix_flow_view_model.dart';

/// Provider global do Dio configurado com interceptors
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://jsonplaceholder.typicode.com',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
    ),
  );

  dio.interceptors.addAll([
    LogInterceptor(responseBody: true, requestBody: true),
    InterceptorsWrapper(
      onRequest: (options, handler) {
        // Exemplo de cabeçalhos comuns
        options.headers['Content-Type'] = 'application/json';
        return handler.next(options);
      },
      onError: (e, handler) {
        // Log customizado de erros
        //print('Erro na requisição PIX: ${e.message}');
        return handler.next(e);
      },
    ),
  ]);

  return dio;
});

/// Provider do DataSource remoto (injeção de Dio)
final pixRemoteDataSourceProvider = Provider<PixRemoteDataSourceContract>((
  ref,
) {
  final dio = ref.watch(dioProvider);
  return PixRemoteDataSource(dio);
});

/// Provider do Repository (injeção de DataSource)
final pixRepositoryProvider = Provider<PixRepositoryContract>((ref) {
  final remoteDataSource = ref.watch(pixRemoteDataSourceProvider);
  return PixRepository(remoteDataSource);
});

/// ✅ ViewModel Provider — forma correta e definitiva
final pixFlowViewModelProvider =
    NotifierProvider<PixFlowViewModel, PixFlowState>(PixFlowViewModel.new);

/// Provider do UseCase SubmitCpf
final submitCpfUseCaseProvider = Provider<SubmitCpfUseCase>((ref) {
  final repository = ref.watch(pixRepositoryProvider);
  return SubmitCpfUseCase(repository);
});

/// Provider do UseCase SubmitCpf
final submitAmountUseCaseProvider = Provider<SubmitAmountUseCase>((ref) {
  final repository = ref.watch(pixRepositoryProvider);
  return SubmitAmountUseCase(repository);
});

// 4. Provider do Notifier (para que outros possam acessá-lo) - ordem é relevante
final uiEventNotifierProvider = NotifierProvider<UiEventNotifier, void>(
  () => UiEventNotifier(),
);

//autodispose mantem os eventos? - ordem é relevante
final uiEventStreamProvider = StreamProvider.autoDispose<UiEvent>((ref) {
  final _ = ref.keepAlive(); //👈 evita destruir no meio do frame

  return ref.watch(uiEventNotifierProvider.notifier).events;
});
