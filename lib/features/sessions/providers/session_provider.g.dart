// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sessionByIdHash() => r'900d5fa76b32f40499e770ffb37168ae997c4f5d';

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

/// Una sesión individual por id (con host embebido).
///
/// Copied from [sessionById].
@ProviderFor(sessionById)
const sessionByIdProvider = SessionByIdFamily();

/// Una sesión individual por id (con host embebido).
///
/// Copied from [sessionById].
class SessionByIdFamily extends Family<AsyncValue<SessionModel>> {
  /// Una sesión individual por id (con host embebido).
  ///
  /// Copied from [sessionById].
  const SessionByIdFamily();

  /// Una sesión individual por id (con host embebido).
  ///
  /// Copied from [sessionById].
  SessionByIdProvider call(
    String id,
  ) {
    return SessionByIdProvider(
      id,
    );
  }

  @override
  SessionByIdProvider getProviderOverride(
    covariant SessionByIdProvider provider,
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
  String? get name => r'sessionByIdProvider';
}

/// Una sesión individual por id (con host embebido).
///
/// Copied from [sessionById].
class SessionByIdProvider extends AutoDisposeFutureProvider<SessionModel> {
  /// Una sesión individual por id (con host embebido).
  ///
  /// Copied from [sessionById].
  SessionByIdProvider(
    String id,
  ) : this._internal(
          (ref) => sessionById(
            ref as SessionByIdRef,
            id,
          ),
          from: sessionByIdProvider,
          name: r'sessionByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$sessionByIdHash,
          dependencies: SessionByIdFamily._dependencies,
          allTransitiveDependencies:
              SessionByIdFamily._allTransitiveDependencies,
          id: id,
        );

  SessionByIdProvider._internal(
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
    FutureOr<SessionModel> Function(SessionByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SessionByIdProvider._internal(
        (ref) => create(ref as SessionByIdRef),
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
  AutoDisposeFutureProviderElement<SessionModel> createElement() {
    return _SessionByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SessionByIdProvider && other.id == id;
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
mixin SessionByIdRef on AutoDisposeFutureProviderRef<SessionModel> {
  /// The parameter `id` of this provider.
  String get id;
}

class _SessionByIdProviderElement
    extends AutoDisposeFutureProviderElement<SessionModel> with SessionByIdRef {
  _SessionByIdProviderElement(super.provider);

  @override
  String get id => (origin as SessionByIdProvider).id;
}

String _$sessionParticipantsHash() =>
    r'8c5f862eb7b45b82080776cbb927e52fca969305';

/// Participantes de una sesión (con estado).
///
/// Copied from [sessionParticipants].
@ProviderFor(sessionParticipants)
const sessionParticipantsProvider = SessionParticipantsFamily();

/// Participantes de una sesión (con estado).
///
/// Copied from [sessionParticipants].
class SessionParticipantsFamily
    extends Family<AsyncValue<List<SessionParticipant>>> {
  /// Participantes de una sesión (con estado).
  ///
  /// Copied from [sessionParticipants].
  const SessionParticipantsFamily();

  /// Participantes de una sesión (con estado).
  ///
  /// Copied from [sessionParticipants].
  SessionParticipantsProvider call(
    String id,
  ) {
    return SessionParticipantsProvider(
      id,
    );
  }

  @override
  SessionParticipantsProvider getProviderOverride(
    covariant SessionParticipantsProvider provider,
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
  String? get name => r'sessionParticipantsProvider';
}

/// Participantes de una sesión (con estado).
///
/// Copied from [sessionParticipants].
class SessionParticipantsProvider
    extends AutoDisposeFutureProvider<List<SessionParticipant>> {
  /// Participantes de una sesión (con estado).
  ///
  /// Copied from [sessionParticipants].
  SessionParticipantsProvider(
    String id,
  ) : this._internal(
          (ref) => sessionParticipants(
            ref as SessionParticipantsRef,
            id,
          ),
          from: sessionParticipantsProvider,
          name: r'sessionParticipantsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$sessionParticipantsHash,
          dependencies: SessionParticipantsFamily._dependencies,
          allTransitiveDependencies:
              SessionParticipantsFamily._allTransitiveDependencies,
          id: id,
        );

  SessionParticipantsProvider._internal(
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
    FutureOr<List<SessionParticipant>> Function(SessionParticipantsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SessionParticipantsProvider._internal(
        (ref) => create(ref as SessionParticipantsRef),
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
  AutoDisposeFutureProviderElement<List<SessionParticipant>> createElement() {
    return _SessionParticipantsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SessionParticipantsProvider && other.id == id;
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
mixin SessionParticipantsRef
    on AutoDisposeFutureProviderRef<List<SessionParticipant>> {
  /// The parameter `id` of this provider.
  String get id;
}

class _SessionParticipantsProviderElement
    extends AutoDisposeFutureProviderElement<List<SessionParticipant>>
    with SessionParticipantsRef {
  _SessionParticipantsProviderElement(super.provider);

  @override
  String get id => (origin as SessionParticipantsProvider).id;
}

String _$myParticipationStatusHash() =>
    r'd3331ce8793d56728c10e874ccb1a0ab499ab0c0';

/// Estado de mi participación en la sesión (null si no me uní).
///
/// Copied from [myParticipationStatus].
@ProviderFor(myParticipationStatus)
const myParticipationStatusProvider = MyParticipationStatusFamily();

/// Estado de mi participación en la sesión (null si no me uní).
///
/// Copied from [myParticipationStatus].
class MyParticipationStatusFamily extends Family<AsyncValue<String?>> {
  /// Estado de mi participación en la sesión (null si no me uní).
  ///
  /// Copied from [myParticipationStatus].
  const MyParticipationStatusFamily();

  /// Estado de mi participación en la sesión (null si no me uní).
  ///
  /// Copied from [myParticipationStatus].
  MyParticipationStatusProvider call(
    String sessionId,
  ) {
    return MyParticipationStatusProvider(
      sessionId,
    );
  }

  @override
  MyParticipationStatusProvider getProviderOverride(
    covariant MyParticipationStatusProvider provider,
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
  String? get name => r'myParticipationStatusProvider';
}

/// Estado de mi participación en la sesión (null si no me uní).
///
/// Copied from [myParticipationStatus].
class MyParticipationStatusProvider extends AutoDisposeFutureProvider<String?> {
  /// Estado de mi participación en la sesión (null si no me uní).
  ///
  /// Copied from [myParticipationStatus].
  MyParticipationStatusProvider(
    String sessionId,
  ) : this._internal(
          (ref) => myParticipationStatus(
            ref as MyParticipationStatusRef,
            sessionId,
          ),
          from: myParticipationStatusProvider,
          name: r'myParticipationStatusProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$myParticipationStatusHash,
          dependencies: MyParticipationStatusFamily._dependencies,
          allTransitiveDependencies:
              MyParticipationStatusFamily._allTransitiveDependencies,
          sessionId: sessionId,
        );

  MyParticipationStatusProvider._internal(
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
    FutureOr<String?> Function(MyParticipationStatusRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MyParticipationStatusProvider._internal(
        (ref) => create(ref as MyParticipationStatusRef),
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
  AutoDisposeFutureProviderElement<String?> createElement() {
    return _MyParticipationStatusProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MyParticipationStatusProvider &&
        other.sessionId == sessionId;
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
mixin MyParticipationStatusRef on AutoDisposeFutureProviderRef<String?> {
  /// The parameter `sessionId` of this provider.
  String get sessionId;
}

class _MyParticipationStatusProviderElement
    extends AutoDisposeFutureProviderElement<String?>
    with MyParticipationStatusRef {
  _MyParticipationStatusProviderElement(super.provider);

  @override
  String get sessionId => (origin as MyParticipationStatusProvider).sessionId;
}

String _$chatIdForSessionHash() => r'ca877092d5251077ce757d427f11f651e70be5c8';

/// chat_id de la sesión (lo crea si no existe).
///
/// Copied from [chatIdForSession].
@ProviderFor(chatIdForSession)
const chatIdForSessionProvider = ChatIdForSessionFamily();

/// chat_id de la sesión (lo crea si no existe).
///
/// Copied from [chatIdForSession].
class ChatIdForSessionFamily extends Family<AsyncValue<String>> {
  /// chat_id de la sesión (lo crea si no existe).
  ///
  /// Copied from [chatIdForSession].
  const ChatIdForSessionFamily();

  /// chat_id de la sesión (lo crea si no existe).
  ///
  /// Copied from [chatIdForSession].
  ChatIdForSessionProvider call(
    String sessionId,
  ) {
    return ChatIdForSessionProvider(
      sessionId,
    );
  }

  @override
  ChatIdForSessionProvider getProviderOverride(
    covariant ChatIdForSessionProvider provider,
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
  String? get name => r'chatIdForSessionProvider';
}

/// chat_id de la sesión (lo crea si no existe).
///
/// Copied from [chatIdForSession].
class ChatIdForSessionProvider extends AutoDisposeFutureProvider<String> {
  /// chat_id de la sesión (lo crea si no existe).
  ///
  /// Copied from [chatIdForSession].
  ChatIdForSessionProvider(
    String sessionId,
  ) : this._internal(
          (ref) => chatIdForSession(
            ref as ChatIdForSessionRef,
            sessionId,
          ),
          from: chatIdForSessionProvider,
          name: r'chatIdForSessionProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$chatIdForSessionHash,
          dependencies: ChatIdForSessionFamily._dependencies,
          allTransitiveDependencies:
              ChatIdForSessionFamily._allTransitiveDependencies,
          sessionId: sessionId,
        );

  ChatIdForSessionProvider._internal(
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
    FutureOr<String> Function(ChatIdForSessionRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ChatIdForSessionProvider._internal(
        (ref) => create(ref as ChatIdForSessionRef),
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
  AutoDisposeFutureProviderElement<String> createElement() {
    return _ChatIdForSessionProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChatIdForSessionProvider && other.sessionId == sessionId;
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
mixin ChatIdForSessionRef on AutoDisposeFutureProviderRef<String> {
  /// The parameter `sessionId` of this provider.
  String get sessionId;
}

class _ChatIdForSessionProviderElement
    extends AutoDisposeFutureProviderElement<String> with ChatIdForSessionRef {
  _ChatIdForSessionProviderElement(super.provider);

  @override
  String get sessionId => (origin as ChatIdForSessionProvider).sessionId;
}

String _$sessionControllerHash() => r'b7612c82e3a53c8df42fc8aba5d0118367fac7c1';

/// Controla publicar / unirse / aceptar / rechazar / completar sesiones.
/// Estado `AsyncValue` para la UI.
///
/// Copied from [SessionController].
@ProviderFor(SessionController)
final sessionControllerProvider =
    AutoDisposeAsyncNotifierProvider<SessionController, void>.internal(
  SessionController.new,
  name: r'sessionControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$sessionControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SessionController = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
