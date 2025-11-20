// ui_event.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'ui_event.freezed.dart';

@freezed
sealed class UiEvent with _$UiEvent {
  const factory UiEvent.showSnackbar({
    required String message,
    @Default(false) bool isError,
  }) = ShowSnackbar;
  // Outros eventos de UI (Ex: showDialog, navigateTo) podem ser adicionados aqui.
}
