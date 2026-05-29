import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/constants/app_colors.dart';
import 'core/router/app_router.dart';
import 'core/services/push_service.dart';
import 'data/providers/supabase_provider.dart';

class SportMatchApp extends ConsumerStatefulWidget {
  const SportMatchApp({super.key});

  @override
  ConsumerState<SportMatchApp> createState() => _SportMatchAppState();
}

class _SportMatchAppState extends ConsumerState<SportMatchApp> {
  StreamSubscription<AuthState>? _authSub;
  StreamSubscription<String>? _tokenSub;
  StreamSubscription<RemoteMessage>? _openedSub;
  bool _initialMessageHandled = false;

  @override
  void initState() {
    super.initState();
    _wireAuthListener();
    _wirePushHandlers();
  }

  @override
  void dispose() {
    _authSub?.cancel();
    _tokenSub?.cancel();
    _openedSub?.cancel();
    super.dispose();
  }

  void _wireAuthListener() {
    final repo = ref.read(authRepositoryProvider);
    _authSub = repo.authStateChanges.listen((state) {
      if (state.session != null) {
        _registerPushToken();
      }
    });
    // Si ya hay sesión activa al arrancar, registra el token de una vez.
    if (repo.isAuthenticated) {
      _registerPushToken();
    }
  }

  Future<void> _registerPushToken() async {
    final token = await PushService.requestPermissionAndGetToken();
    if (token == null) return;
    try {
      await ref.read(notificationRepositoryProvider).registerPushToken(token);
    } catch (e) {
      debugPrint('No se pudo subir token FCM: $e');
    }
    // Suscribirse a refreshes (Firebase puede rotar el token).
    _tokenSub?.cancel();
    _tokenSub = PushService.onTokenRefresh.listen((t) async {
      try {
        await ref.read(notificationRepositoryProvider).registerPushToken(t);
      } catch (e) {
        debugPrint('Token refresh upload falló: $e');
      }
    });
  }

  void _wirePushHandlers() {
    // Tap sobre la notificación con la app en background.
    _openedSub = PushService.onMessageOpenedApp.listen(_handleOpenedMessage);
    // Cold-start desde notificación: se procesa una vez ya que el router está listo.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (_initialMessageHandled) return;
      _initialMessageHandled = true;
      final initial = await PushService.getInitialMessage();
      if (initial != null) _handleOpenedMessage(initial);
    });
  }

  void _handleOpenedMessage(RemoteMessage message) {
    final route = message.data['route'] as String?;
    if (route == null || route.isEmpty) return;
    final router = ref.read(goRouterProvider);
    router.push(route);
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(goRouterProvider);
    return MaterialApp.router(
      title: 'SportMatch',
      debugShowCheckedModeBanner: false,
      theme: AppColors.lightTheme,
      routerConfig: router,
    );
  }
}
