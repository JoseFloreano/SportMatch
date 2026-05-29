// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$myNotificationsHash() => r'0bc248bd37601307573abd6af624f9e07ebde94d';

/// Stream Realtime de mis notificaciones (50 más recientes).
///
/// Copied from [myNotifications].
@ProviderFor(myNotifications)
final myNotificationsProvider =
    AutoDisposeStreamProvider<List<NotificationModel>>.internal(
  myNotifications,
  name: r'myNotificationsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$myNotificationsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MyNotificationsRef
    = AutoDisposeStreamProviderRef<List<NotificationModel>>;
String _$unreadNotificationCountHash() =>
    r'0ad6c0af453b18f3ac2ab373378e7891f3f98c91';

/// Cantidad de notificaciones sin leer (derivada del stream anterior).
///
/// Copied from [unreadNotificationCount].
@ProviderFor(unreadNotificationCount)
final unreadNotificationCountProvider = AutoDisposeProvider<int>.internal(
  unreadNotificationCount,
  name: r'unreadNotificationCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$unreadNotificationCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UnreadNotificationCountRef = AutoDisposeProviderRef<int>;
String _$notificationControllerHash() =>
    r'17d947a6886b33315f3f9baeac8c99823cc61196';

/// See also [NotificationController].
@ProviderFor(NotificationController)
final notificationControllerProvider =
    AutoDisposeAsyncNotifierProvider<NotificationController, void>.internal(
  NotificationController.new,
  name: r'notificationControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notificationControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$NotificationController = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
