// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentProfileHash() => r'0883f0712149f9dc1dcc653a356a589c8bed7807';

/// Perfil del usuario autenticado. Se refresca cuando cambia la sesión.
///
/// Copied from [currentProfile].
@ProviderFor(currentProfile)
final currentProfileProvider =
    AutoDisposeFutureProvider<ProfileModel?>.internal(
  currentProfile,
  name: r'currentProfileProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentProfileHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentProfileRef = AutoDisposeFutureProviderRef<ProfileModel?>;
String _$profileByIdHash() => r'74fdb14df4e3e89d41a93045657aca84b86e4643';

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

/// Perfil de cualquier usuario por id.
///
/// Copied from [profileById].
@ProviderFor(profileById)
const profileByIdProvider = ProfileByIdFamily();

/// Perfil de cualquier usuario por id.
///
/// Copied from [profileById].
class ProfileByIdFamily extends Family<AsyncValue<ProfileModel?>> {
  /// Perfil de cualquier usuario por id.
  ///
  /// Copied from [profileById].
  const ProfileByIdFamily();

  /// Perfil de cualquier usuario por id.
  ///
  /// Copied from [profileById].
  ProfileByIdProvider call(
    String userId,
  ) {
    return ProfileByIdProvider(
      userId,
    );
  }

  @override
  ProfileByIdProvider getProviderOverride(
    covariant ProfileByIdProvider provider,
  ) {
    return call(
      provider.userId,
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
  String? get name => r'profileByIdProvider';
}

/// Perfil de cualquier usuario por id.
///
/// Copied from [profileById].
class ProfileByIdProvider extends AutoDisposeFutureProvider<ProfileModel?> {
  /// Perfil de cualquier usuario por id.
  ///
  /// Copied from [profileById].
  ProfileByIdProvider(
    String userId,
  ) : this._internal(
          (ref) => profileById(
            ref as ProfileByIdRef,
            userId,
          ),
          from: profileByIdProvider,
          name: r'profileByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$profileByIdHash,
          dependencies: ProfileByIdFamily._dependencies,
          allTransitiveDependencies:
              ProfileByIdFamily._allTransitiveDependencies,
          userId: userId,
        );

  ProfileByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final String userId;

  @override
  Override overrideWith(
    FutureOr<ProfileModel?> Function(ProfileByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ProfileByIdProvider._internal(
        (ref) => create(ref as ProfileByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<ProfileModel?> createElement() {
    return _ProfileByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProfileByIdProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ProfileByIdRef on AutoDisposeFutureProviderRef<ProfileModel?> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _ProfileByIdProviderElement
    extends AutoDisposeFutureProviderElement<ProfileModel?>
    with ProfileByIdRef {
  _ProfileByIdProviderElement(super.provider);

  @override
  String get userId => (origin as ProfileByIdProvider).userId;
}

String _$profileControllerHash() => r'd644ba7c90544d7c28273ef0289c841142de2966';

/// See also [ProfileController].
@ProviderFor(ProfileController)
final profileControllerProvider =
    AutoDisposeAsyncNotifierProvider<ProfileController, void>.internal(
  ProfileController.new,
  name: r'profileControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$profileControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ProfileController = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
