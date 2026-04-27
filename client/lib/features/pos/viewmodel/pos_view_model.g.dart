// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pos_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PosViewModel)
final posViewModelProvider = PosViewModelProvider._();

final class PosViewModelProvider
    extends $NotifierProvider<PosViewModel, PosState> {
  PosViewModelProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'posViewModelProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$posViewModelHash();

  @$internal
  @override
  PosViewModel create() => PosViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PosState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PosState>(value),
    );
  }
}

String _$posViewModelHash() => r'5304dbb46a579acf3ddc6448606879ad7b1c05e0';

abstract class _$PosViewModel extends $Notifier<PosState> {
  PosState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<PosState, PosState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<PosState, PosState>, PosState, Object?, Object?>;
    element.handleCreate(ref, build);
  }
}
