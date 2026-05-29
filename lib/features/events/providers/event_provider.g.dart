// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$eventByIdHash() => r'a947e7a3a8c8e540d4e4986331c106d53829dcb8';

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

/// Un evento por id.
///
/// Copied from [eventById].
@ProviderFor(eventById)
const eventByIdProvider = EventByIdFamily();

/// Un evento por id.
///
/// Copied from [eventById].
class EventByIdFamily extends Family<AsyncValue<EventModel>> {
  /// Un evento por id.
  ///
  /// Copied from [eventById].
  const EventByIdFamily();

  /// Un evento por id.
  ///
  /// Copied from [eventById].
  EventByIdProvider call(
    String id,
  ) {
    return EventByIdProvider(
      id,
    );
  }

  @override
  EventByIdProvider getProviderOverride(
    covariant EventByIdProvider provider,
  ) {
    return call(
      provider.id,
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
  String? get name => r'eventByIdProvider';
}

/// Un evento por id.
///
/// Copied from [eventById].
class EventByIdProvider extends AutoDisposeFutureProvider<EventModel> {
  /// Un evento por id.
  ///
  /// Copied from [eventById].
  EventByIdProvider(
    String id,
  ) : this._internal(
          (ref) => eventById(
            ref as EventByIdRef,
            id,
          ),
          from: eventByIdProvider,
          name: r'eventByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$eventByIdHash,
          dependencies: EventByIdFamily._dependencies,
          allTransitiveDependencies: EventByIdFamily._allTransitiveDependencies,
          id: id,
        );

  EventByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    FutureOr<EventModel> Function(EventByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: EventByIdProvider._internal(
        (ref) => create(ref as EventByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<EventModel> createElement() {
    return _EventByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is EventByIdProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin EventByIdRef on AutoDisposeFutureProviderRef<EventModel> {
  /// The parameter `id` of this provider.
  String get id;
}

class _EventByIdProviderElement
    extends AutoDisposeFutureProviderElement<EventModel> with EventByIdRef {
  _EventByIdProviderElement(super.provider);

  @override
  String get id => (origin as EventByIdProvider).id;
}

String _$upcomingEventsHash() => r'c60a03614536b0146eff54aeb487fb82e6571cf9';

/// Todos los eventos patrocinados próximos (para la pantalla de Eventos).
///
/// Copied from [upcomingEvents].
@ProviderFor(upcomingEvents)
final upcomingEventsProvider =
    AutoDisposeFutureProvider<List<EventModel>>.internal(
  upcomingEvents,
  name: r'upcomingEventsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$upcomingEventsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UpcomingEventsRef = AutoDisposeFutureProviderRef<List<EventModel>>;
String _$eventControllerHash() => r'73b0237a372dda2fc434f0183b2b11a339d7399b';

/// See also [EventController].
@ProviderFor(EventController)
final eventControllerProvider =
    AutoDisposeAsyncNotifierProvider<EventController, void>.internal(
  EventController.new,
  name: r'eventControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$eventControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$EventController = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
