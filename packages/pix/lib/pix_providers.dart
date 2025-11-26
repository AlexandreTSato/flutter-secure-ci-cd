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
import 'package:core_networking/core_networking.dart';

// ------------------------------------------------------------
// Networking (usa dioProvider do core_networking)
// ------------------------------------------------------------

/// DataSource remoto (injeção do Dio configurado no core_networking)
final pixRemoteDataSourceProvider = Provider<PixRemoteDataSourceContract>((
  ref,
) {
  final dio = ref.read(dioProvider); // vem de core_networking
  return PixRemoteDataSource(dio: dio);
});

/// Repository (usa DataSource)
final pixRepositoryProvider = Provider<PixRepositoryContract>((ref) {
  final remoteDataSource = ref.read(pixRemoteDataSourceProvider);
  return PixRepository(remoteDataSource);
});

// ------------------------------------------------------------
// ViewModel (fluxo transacional) - autoDispose recomendado
// ------------------------------------------------------------
final pixFlowViewModelProvider =
    NotifierProvider.autoDispose<PixFlowViewModel, PixFlowState>(
      PixFlowViewModel.new,
    );

// ------------------------------------------------------------
// UseCases
// ------------------------------------------------------------
final submitCpfUseCaseProvider = Provider<SubmitCpfUseCase>((ref) {
  final repository = ref.read(pixRepositoryProvider);
  return SubmitCpfUseCase(repository);
});

final submitAmountUseCaseProvider = Provider<SubmitAmountUseCase>((ref) {
  final repository = ref.read(pixRepositoryProvider);
  return SubmitAmountUseCase(repository);
});

// ------------------------------------------------------------
// Eventos de UI (one-shot)
// ------------------------------------------------------------
/// Notifier que emite eventos (Snackbar, navegação, etc.)
final uiEventNotifierProvider = NotifierProvider<UiEventNotifier, void>(
  UiEventNotifier.new,
);

/// Stream de eventos (autoDispose conserva até fim do frame; ref.keepAlive opcional)
final uiEventStreamProvider = StreamProvider.autoDispose<UiEvent>((ref) {
  // Se quiser manter ativa enquanto navega entre telas, descomente:
  // ref.keepAlive();
  return ref.watch(uiEventNotifierProvider.notifier).events;
});
