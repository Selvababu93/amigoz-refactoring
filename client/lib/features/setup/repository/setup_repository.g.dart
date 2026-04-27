// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setup_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(setupRepository)
final setupRepositoryProvider = SetupRepositoryProvider._();

final class SetupRepositoryProvider extends $FunctionalProvider<SetupRepository,
    SetupRepository, SetupRepository> with $Provider<SetupRepository> {
  SetupRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'setupRepositoryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$setupRepositoryHash();

  @$internal
  @override
  $ProviderElement<SetupRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SetupRepository create(Ref ref) {
    return setupRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SetupRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SetupRepository>(value),
    );
  }
}

String _$setupRepositoryHash() => r'b79b85a74af260f4ebf6635364d37f377fee91fc';
