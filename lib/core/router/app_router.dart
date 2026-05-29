import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/providers/supabase_provider.dart';
import '../../features/auth/pages/otp_verify_page.dart';
import '../../features/auth/pages/phone_input_page.dart';
import '../../features/chat/pages/chat_page.dart';
import '../../features/chat/pages/chats_list_page.dart';
import '../../features/events/pages/event_detail_page.dart';
import '../../features/events/pages/events_list_page.dart';
import '../../features/map/pages/map_page.dart';
import '../../features/notifications/pages/notifications_page.dart';
import '../../features/profile/pages/edit_profile_page.dart';
import '../../features/profile/pages/profile_page.dart';
import '../../features/ratings/pages/rating_page.dart';
import '../../features/sessions/pages/edit_session_page.dart';
import '../../features/sessions/pages/publish_page.dart';
import '../../features/sessions/pages/session_detail_page.dart';

part 'app_router.g.dart';

/// Convierte un Stream en un Listenable para refrescar GoRouter cuando cambia
/// el estado de autenticación.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

@Riverpod(keepAlive: true)
GoRouter goRouter(Ref ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  final refresh = GoRouterRefreshStream(authRepo.authStateChanges);
  ref.onDispose(refresh.dispose);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: refresh,
    redirect: (context, state) {
      final loggedIn = Supabase.instance.client.auth.currentSession != null;
      final goingToAuth = state.matchedLocation.startsWith('/auth');
      if (!loggedIn && !goingToAuth) return '/auth/phone';
      if (loggedIn && goingToAuth) return '/';
      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (_, __) => const MapPage()),
      GoRoute(
        path: '/auth/phone',
        builder: (_, __) => const PhoneInputPage(),
      ),
      GoRoute(
        path: '/auth/otp',
        builder: (_, state) =>
            OtpVerifyPage(phone: (state.extra as String?) ?? ''),
      ),
      GoRoute(path: '/publish', builder: (_, __) => const PublishPage()),
      GoRoute(path: '/events', builder: (_, __) => const EventsListPage()),
      GoRoute(path: '/chats', builder: (_, __) => const ChatsListPage()),
      GoRoute(
        path: '/session/:id',
        builder: (_, state) =>
            SessionDetailPage(sessionId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/session/:id/edit',
        builder: (_, state) =>
            EditSessionPage(sessionId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/event/:id',
        builder: (_, state) =>
            EventDetailPage(eventId: state.pathParameters['id']!),
      ),
      GoRoute(path: '/profile', builder: (_, __) => const ProfilePage()),
      GoRoute(
        path: '/profile/edit',
        builder: (_, __) => const EditProfilePage(),
      ),
      GoRoute(
        path: '/notifications',
        builder: (_, __) => const NotificationsPage(),
      ),
      GoRoute(
        path: '/chat/:chatId',
        builder: (_, state) =>
            ChatPage(chatId: state.pathParameters['chatId']!),
      ),
      GoRoute(
        path: '/rate/:sessionId',
        builder: (_, state) =>
            RatingPage(sessionId: state.pathParameters['sessionId']!),
      ),
    ],
  );
}
