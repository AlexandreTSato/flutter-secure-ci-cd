// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pix_session_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PixSession)
const pixSessionProvider = PixSessionProvider._();

final class PixSessionProvider
    extends $NotifierProvider<PixSession, PixSessionState> {
  const PixSessionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pixSessionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pixSessionHash();

  @$internal
  @override
  PixSession create() => PixSession();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PixSessionState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PixSessionState>(value),
    );
  }
}

String _$pixSessionHash() => r'b7b7e4263a19f2120a378ae7f6e0e7cbdd74abb6';

abstract class _$PixSession extends $Notifier<PixSessionState> {
  PixSessionState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<PixSessionState, PixSessionState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PixSessionState, PixSessionState>,
              PixSessionState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
