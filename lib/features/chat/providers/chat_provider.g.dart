// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$myChatsHash() => r'e47415f50eba440bfc1cc544cb7d61a0fc73f4c2';

/// Bandeja de chats del usuario actual.
///
/// Copied from [myChats].
@ProviderFor(myChats)
final myChatsProvider = AutoDisposeFutureProvider<List<ChatSummary>>.internal(
  myChats,
  name: r'myChatsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$myChatsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MyChatsRef = AutoDisposeFutureProviderRef<List<ChatSummary>>;
String _$chatMessagesHash() => r'f3f7d7300a1cee84cde4a142b1c14f428138dab6';

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

/// Stream Realtime de mensajes de un chat, ordenados cronológicamente.
/// (Sprint 2: la UI de chat consume este stream.)
///
/// Copied from [chatMessages].
@ProviderFor(chatMessages)
const chatMessagesProvider = ChatMessagesFamily();

/// Stream Realtime de mensajes de un chat, ordenados cronológicamente.
/// (Sprint 2: la UI de chat consume este stream.)
///
/// Copied from [chatMessages].
class ChatMessagesFamily extends Family<AsyncValue<List<MessageModel>>> {
  /// Stream Realtime de mensajes de un chat, ordenados cronológicamente.
  /// (Sprint 2: la UI de chat consume este stream.)
  ///
  /// Copied from [chatMessages].
  const ChatMessagesFamily();

  /// Stream Realtime de mensajes de un chat, ordenados cronológicamente.
  /// (Sprint 2: la UI de chat consume este stream.)
  ///
  /// Copied from [chatMessages].
  ChatMessagesProvider call(
    String chatId,
  ) {
    return ChatMessagesProvider(
      chatId,
    );
  }

  @override
  ChatMessagesProvider getProviderOverride(
    covariant ChatMessagesProvider provider,
  ) {
    return call(
      provider.chatId,
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
  String? get name => r'chatMessagesProvider';
}

/// Stream Realtime de mensajes de un chat, ordenados cronológicamente.
/// (Sprint 2: la UI de chat consume este stream.)
///
/// Copied from [chatMessages].
class ChatMessagesProvider
    extends AutoDisposeStreamProvider<List<MessageModel>> {
  /// Stream Realtime de mensajes de un chat, ordenados cronológicamente.
  /// (Sprint 2: la UI de chat consume este stream.)
  ///
  /// Copied from [chatMessages].
  ChatMessagesProvider(
    String chatId,
  ) : this._internal(
          (ref) => chatMessages(
            ref as ChatMessagesRef,
            chatId,
          ),
          from: chatMessagesProvider,
          name: r'chatMessagesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$chatMessagesHash,
          dependencies: ChatMessagesFamily._dependencies,
          allTransitiveDependencies:
              ChatMessagesFamily._allTransitiveDependencies,
          chatId: chatId,
        );

  ChatMessagesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.chatId,
  }) : super.internal();

  final String chatId;

  @override
  Override overrideWith(
    Stream<List<MessageModel>> Function(ChatMessagesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ChatMessagesProvider._internal(
        (ref) => create(ref as ChatMessagesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        chatId: chatId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<MessageModel>> createElement() {
    return _ChatMessagesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChatMessagesProvider && other.chatId == chatId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, chatId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ChatMessagesRef on AutoDisposeStreamProviderRef<List<MessageModel>> {
  /// The parameter `chatId` of this provider.
  String get chatId;
}

class _ChatMessagesProviderElement
    extends AutoDisposeStreamProviderElement<List<MessageModel>>
    with ChatMessagesRef {
  _ChatMessagesProviderElement(super.provider);

  @override
  String get chatId => (origin as ChatMessagesProvider).chatId;
}

String _$chatControllerHash() => r'b7e16549c83f8d99d7f7c893d62cb5c95104aa91';

/// See also [ChatController].
@ProviderFor(ChatController)
final chatControllerProvider =
    AutoDisposeNotifierProvider<ChatController, void>.internal(
  ChatController.new,
  name: r'chatControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$chatControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ChatController = AutoDisposeNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
