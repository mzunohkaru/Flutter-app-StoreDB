// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_data_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$appDataControllerHash() => r'edb0c142a2fc27f8a0266b2211e07162d6268471';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$AppDataController
    extends BuildlessAsyncNotifier<AppDataState> {
  late final Genre genre;

  FutureOr<AppDataState> build({
    required Genre genre,
  });
}

/// See also [AppDataController].
@ProviderFor(AppDataController)
const appDataControllerProvider = AppDataControllerFamily();

/// See also [AppDataController].
class AppDataControllerFamily extends Family<AsyncValue<AppDataState>> {
  /// See also [AppDataController].
  const AppDataControllerFamily();

  /// See also [AppDataController].
  AppDataControllerProvider call({
    required Genre genre,
  }) {
    return AppDataControllerProvider(
      genre: genre,
    );
  }

  @override
  AppDataControllerProvider getProviderOverride(
    covariant AppDataControllerProvider provider,
  ) {
    return call(
      genre: provider.genre,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'appDataControllerProvider';
}

/// See also [AppDataController].
class AppDataControllerProvider
    extends AsyncNotifierProviderImpl<AppDataController, AppDataState> {
  /// See also [AppDataController].
  AppDataControllerProvider({
    required Genre genre,
  }) : this._internal(
          () => AppDataController()..genre = genre,
          from: appDataControllerProvider,
          name: r'appDataControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$appDataControllerHash,
          dependencies: AppDataControllerFamily._dependencies,
          allTransitiveDependencies:
              AppDataControllerFamily._allTransitiveDependencies,
          genre: genre,
        );

  AppDataControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.genre,
  }) : super.internal();

  final Genre genre;

  @override
  FutureOr<AppDataState> runNotifierBuild(
    covariant AppDataController notifier,
  ) {
    return notifier.build(
      genre: genre,
    );
  }

  @override
  Override overrideWith(AppDataController Function() create) {
    return ProviderOverride(
      origin: this,
      override: AppDataControllerProvider._internal(
        () => create()..genre = genre,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        genre: genre,
      ),
    );
  }

  @override
  AsyncNotifierProviderElement<AppDataController, AppDataState>
      createElement() {
    return _AppDataControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AppDataControllerProvider && other.genre == genre;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, genre.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AppDataControllerRef on AsyncNotifierProviderRef<AppDataState> {
  /// The parameter `genre` of this provider.
  Genre get genre;
}

class _AppDataControllerProviderElement
    extends AsyncNotifierProviderElement<AppDataController, AppDataState>
    with AppDataControllerRef {
  _AppDataControllerProviderElement(super.provider);

  @override
  Genre get genre => (origin as AppDataControllerProvider).genre;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
