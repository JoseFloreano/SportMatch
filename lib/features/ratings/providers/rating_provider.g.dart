// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rating_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$hasPendingRatingHash() => r'6eb6765e5b429858b42c4aa86da64902ed99336b';

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

/// True si todavía no he calificado esa sesión.
///
/// Copied from [hasPendingRating].
@ProviderFor(hasPendingRating)
const hasPendingRatingProvider = HasPendingRatingFamily();

/// True si todavía no he calificado esa sesión.
///
/// Copied from [hasPendingRating].
class HasPendingRatingFamily extends Family<AsyncValue<bool>> {
  /// True si todavía no he calificado esa sesión.
  ///
  /// Copied from [hasPendingRating].
  const HasPendingRatingFamily();

  /// True si todavía no he calificado esa sesión.
  ///
  /// Copied from [hasPendingRating].
  HasPendingRatingProvider call(
    String sessionId,
  ) {
    return HasPendingRatingProvider(
      sessionId,
    );
  }

  @override
  HasPendingRatingProvider getProviderOverride(
    covariant HasPendingRatingProvider provider,
  ) {
    return call(
      provider.sessionId,
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
  String? get name => r'hasPendingRatingProvider';
}

/// True si todavía no he calificado esa sesión.
///
/// Copied from [hasPendingRating].
class HasPendingRatingProvider extends AutoDisposeFutureProvider<bool> {
  /// True si todavía no he calificado esa sesión.
  ///
  /// Copied from [hasPendingRating].
  HasPendingRatingProvider(
    String sessionId,
  ) : this._internal(
          (ref) => hasPendingRating(
            ref as HasPendingRatingRef,
            sessionId,
          ),
          from: hasPendingRatingProvider,
          name: r'hasPendingRatingProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$hasPendingRatingHash,
          dependencies: HasPendingRatingFamily._dependencies,
          allTransitiveDependencies:
              HasPendingRatingFamily._allTransitiveDependencies,
          sessionId: sessionId,
        );

  HasPendingRatingProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.sessionId,
  }) : super.internal();

  final String sessionId;

  @override
  Override overrideWith(
    FutureOr<bool> Function(HasPendingRatingRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: HasPendingRatingProvider._internal(
        (ref) => create(ref as HasPendingRatingRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        sessionId: sessionId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<bool> createElement() {
    return _HasPendingRatingProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is HasPendingRatingProvider && other.sessionId == sessionId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, sessionId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin HasPendingRatingRef on AutoDisposeFutureProviderRef<bool> {
  /// The parameter `sessionId` of this provider.
  String get sessionId;
}

class _HasPendingRatingProviderElement
    extends AutoDisposeFutureProviderElement<bool> with HasPendingRatingRef {
  _HasPendingRatingProviderElement(super.provider);

  @override
  String get sessionId => (origin as HasPendingRatingProvider).sessionId;
}

String _$ratingControllerHash() => r'58bce409adc5bd40a8ca5c21dfecde4c235cbaa5';

/// Maneja el envío de calificaciones post-sesión (Sprint 2).
///
/// Copied from [RatingController].
@ProviderFor(RatingController)
final ratingControllerProvider =
    AutoDisposeAsyncNotifierProvider<RatingController, void>.internal(
  RatingController.new,
  name: r'ratingControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$ratingControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$RatingController = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
