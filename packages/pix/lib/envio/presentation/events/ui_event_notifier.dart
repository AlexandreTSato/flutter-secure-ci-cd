// ui_event_notifier.dart

import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'ui_event.dart'; // Importa a definição do evento

/// Este Notifier é responsável por emitir eventos de uso único (One-Time Events)
/// que a UI deve consumir (ex: SnackBar, Navegação, Diálogos).
class UiEventNotifier extends Notifier<void> {
  // 1. Definição Correta do StreamController
  // Este objeto permite que o Notifier emita eventos (add) e a UI os escute (stream).
  late final StreamController<UiEvent> _eventController;

  @override
  void build() {
    _eventController = StreamController<UiEvent>.broadcast();

    // Sempre feche o controller quando o Notifier for descartado
    ref.onDispose(() => _eventController.close());
  }

  // 2. Método para o ViewModel adicionar um novo evento
  // Esta é a interface que o ViewModel utilizará.
  void addEvent(UiEvent event) {
    if (!_eventController.isClosed) {
      _eventController.add(event);
    }
  }

  // 3. Exposição do Stream para a View
  // A View (Widget) usará este stream para se inscrever e reagir aos eventos.
  Stream<UiEvent> get events => _eventController.stream;
}
