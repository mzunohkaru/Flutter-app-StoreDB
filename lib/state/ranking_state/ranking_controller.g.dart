// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ranking_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$rankingControllerHash() => r'4d2c4e0f67a4bc2ea144a6c13c048f9b0f120d3c';

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

abstract class _$RankingController
    extends BuildlessAsyncNotifier<RankingState> {
  late final Genre genre;
  late final String appId;

  FutureOr<RankingState> build({
    required Genre genre,
    required String appId,
  });
}

/// See also [RankingController].
@ProviderFor(RankingController)
const rankingControllerProvider = RankingControllerFamily();

/// See also [RankingController].
class RankingControllerFamily extends Family<AsyncValue<RankingState>> {
  /// See also [RankingController].
  const RankingControllerFamily();

  /// See also [RankingController].
  RankingControllerProvider call({
    required Genre genre,
    required String appId,
  }) {
    return RankingControllerProvider(
      genre: genre,
      appId: appId,
    );
  }

  @override
  RankingControllerProvider getProviderOverride(
    covariant RankingControllerProvider provider,
  ) {
    return call(
      genre: provider.genre,
      appId: provider.appId,
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
  String? get name => r'rankingControllerProvider';
}

/// See also [RankingController].
class RankingControllerProvider
    extends AsyncNotifierProviderImpl<RankingController, RankingState> {
  /// See also [RankingController].
  RankingControllerProvider({
    required Genre genre,
    required String appId,
  }) : this._internal(
          () => RankingController()
            ..genre = genre
            ..appId = appId,
          from: rankingControllerProvider,
          name: r'rankingControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$rankingControllerHash,
          dependencies: RankingControllerFamily._dependencies,
          allTransitiveDependencies:
              RankingControllerFamily._allTransitiveDependencies,
          genre: genre,
          appId: appId,
        );

  RankingControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.genre,
    required this.appId,
  }) : super.internal();

  final Genre genre;
  final String appId;

  @override
  FutureOr<RankingState> runNotifierBuild(
    covariant RankingController notifier,
  ) {
    return notifier.build(
      genre: genre,
      appId: appId,
    );
  }

  @override
  Override overrideWith(RankingController Function() create) {
    return ProviderOverride(
      origin: this,
      override: RankingControllerProvider._internal(
        () => create()
          ..genre = genre
          ..appId = appId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        genre: genre,
        appId: appId,
      ),
    );
  }

  @override
  AsyncNotifierProviderElement<RankingController, RankingState>
      createElement() {
    return _RankingControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RankingControllerProvider &&
        other.genre == genre &&
        other.appId == appId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, genre.hashCode);
    hash = _SystemHash.combine(hash, appId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin RankingControllerRef on AsyncNotifierProviderRef<RankingState> {
  /// The parameter `genre` of this provider.
  Genre get genre;

  /// The parameter `appId` of this provider.
  String get appId;
}

class _RankingControllerProviderElement
    extends AsyncNotifierProviderElement<RankingController, RankingState>
    with RankingControllerRef {
  _RankingControllerProviderElement(super.provider);

  @override
  Genre get genre => (origin as RankingControllerProvider).genre;
  @override
  String get appId => (origin as RankingControllerProvider).appId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
