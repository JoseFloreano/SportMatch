import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/session_model.dart';
import '../../../data/providers/supabase_provider.dart';
import '../../../shared/widgets/bottom_nav_bar.dart';
import '../../notifications/providers/notification_provider.dart';
import '../../sessions/widgets/session_card.dart';
import '../providers/map_provider.dart';
import '../widgets/event_pin.dart';
import '../widgets/session_bottom_sheet.dart';
import '../widgets/session_pin.dart';

// Filtros horizontales: null = Todo, 'eventos' = solo eventos.
const _filters = <({String? id, String label, String emoji})>[
  (id: null, label: 'Todo', emoji: '📍'),
  (id: 'crossfit', label: 'CrossFit', emoji: '💪'),
  (id: 'gym', label: 'Gym', emoji: '🏋️'),
  (id: 'calistenia', label: 'Calistenia', emoji: '🤸'),
  (id: 'hiit', label: 'HIIT', emoji: '⚡'),
  (id: 'eventos', label: 'Eventos', emoji: '🏆'),
];

class MapPage extends ConsumerStatefulWidget {
  const MapPage({super.key});

  @override
  ConsumerState<MapPage> createState() => _MapPageState();
}

class _MapPageState extends ConsumerState<MapPage> {
  final _mapController = MapController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(mapNotifierProvider.notifier).init();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(mapNotifierProvider);

    // Recentrar la cámara cuando llega la ubicación del usuario.
    ref.listen(mapNotifierProvider, (prev, next) {
      if (next.userPosition != null &&
          prev?.userPosition != next.userPosition) {
        _mapController.move(LatLng(next.lat, next.lng), AppConstants.defaultZoom);
      }
    });

    return Scaffold(
      backgroundColor: AppColors.white,
      bottomNavigationBar: const BottomNavBar(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.volt,
        foregroundColor: AppColors.ink,
        onPressed: () => context.push('/publish'),
        child: const Icon(Icons.add, size: 28),
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _Header(),
            SizedBox(
              height: 280,
              child: _buildMap(state),
            ),
            _buildFilters(state),
            Expanded(child: _buildFeed(state)),
          ],
        ),
      ),
    );
  }

  Widget _buildMap(MapState state) {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: LatLng(state.lat, state.lng),
        initialZoom: AppConstants.defaultZoom,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.sportmatch.sportmatch',
        ),
        MarkerLayer(
          markers: [
            // Ubicación del usuario
            Marker(
              point: LatLng(state.lat, state.lng),
              width: 24,
              height: 24,
              child: const _UserDot(),
            ),
            // Pins de sesiones
            ...state.sessions.map(
              (s) => Marker(
                point: LatLng(s.lat, s.lng),
                width: 120,
                height: 44,
                alignment: Alignment.topCenter,
                child: SessionPin(
                  session: s,
                  onTap: () => _showSessionSheet(s),
                ),
              ),
            ),
            // Pins de eventos
            ...state.events.map(
              (e) => Marker(
                point: LatLng(e.lat, e.lng),
                width: 80,
                height: 44,
                alignment: Alignment.topCenter,
                child: EventPin(
                  event: e,
                  onTap: () => context.push('/event/${e.id}'),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFilters(MapState state) {
    return SizedBox(
      height: 50,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        itemCount: _filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final f = _filters[i];
          final active = state.activeSportFilter == f.id;
          return GestureDetector(
            onTap: () =>
                ref.read(mapNotifierProvider.notifier).setFilter(f.id),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: active ? AppColors.ink : AppColors.white,
                borderRadius: BorderRadius.circular(99),
                border: Border.all(
                  color: active ? AppColors.ink : AppColors.border,
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  Text(f.emoji, style: const TextStyle(fontSize: 13)),
                  const SizedBox(width: 5),
                  Text(
                    f.label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: active ? AppColors.volt : AppColors.slate,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeed(MapState state) {
    if (state.isLoading && state.sessions.isEmpty && state.events.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    // Filtro "Eventos": mostramos eventos como lista, con el mismo toggle
    // "Cerca de ti / Todas" que las sesiones.
    if (state.activeSportFilter == 'eventos') {
      final eventCountLabel = state.showAll
          ? 'Todos · ${state.events.length} eventos'
          : 'Cerca de ti · ${state.events.length} eventos';
      return RefreshIndicator(
        onRefresh: () => ref.read(mapNotifierProvider.notifier).loadNearby(),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          children: [
            _FeedHeader(
              text: eventCountLabel,
              showAll: state.showAll,
              onToggle: () =>
                  ref.read(mapNotifierProvider.notifier).toggleShowAll(),
            ),
            if (state.events.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 36),
                child: Text(
                  state.showAll
                      ? 'No hay eventos patrocinados por ahora.'
                      : 'Nada cerca. Toca "Ver todas" para ver todo CDMX.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body,
                ),
              )
            else
              ...state.events.map(
                (e) => Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: Text(e.sportEmoji,
                        style: const TextStyle(fontSize: 24)),
                    title: Text(e.title, style: AppTextStyles.sportTag),
                    subtitle:
                        Text(e.venueName, style: AppTextStyles.bodySmall),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push('/event/${e.id}'),
                  ),
                ),
              ),
          ],
        ),
      );
    }

    final sessions = state.visibleSessions;
    final myId = ref.watch(supabaseClientProvider).auth.currentUser?.id;
    final countLabel = state.showAll
        ? 'Todas · ${sessions.length} sesiones'
        : 'Cerca de ti · ${sessions.length} sesiones';

    return RefreshIndicator(
      onRefresh: () => ref.read(mapNotifierProvider.notifier).loadNearby(),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        children: [
          _FeedHeader(
            text: countLabel,
            showAll: state.showAll,
            onToggle: () =>
                ref.read(mapNotifierProvider.notifier).toggleShowAll(),
          ),
          if (sessions.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 36),
              child: Text(
                state.error != null
                    ? 'No pudimos cargar sesiones.\n${state.error}'
                    : state.showAll
                        ? 'No hay sesiones para este filtro todavía.'
                        : 'Nada cerca. Toca "Ver todas" para ampliar.',
                textAlign: TextAlign.center,
                style: AppTextStyles.body,
              ),
            )
          else
            ...sessions.map(
              (s) => SessionCard(
                session: s,
                isOwn: myId != null && s.hostId == myId,
                onTap: () => context.push('/session/${s.id}'),
                onJoin: () => context.push('/session/${s.id}'),
              ),
            ),
        ],
      ),
    );
  }

  void _showSessionSheet(SessionModel session) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => SessionBottomSheet(
        session: session,
        onViewDetail: () {
          Navigator.of(context).pop();
          context.push('/session/${session.id}');
        },
        onJoin: () {
          Navigator.of(context).pop();
          context.push('/session/${session.id}');
        },
      ),
    );
  }
}

class _Header extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unread = ref.watch(unreadNotificationCountProvider);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RichText(
            text: TextSpan(
              style: AppTextStyles.headline3.copyWith(fontSize: 22),
              children: const [
                TextSpan(text: 'Sport'),
                TextSpan(
                  text: 'Match',
                  style: TextStyle(color: AppColors.voltDark),
                ),
              ],
            ),
          ),
          Row(
            children: [
              _IconBox(
                icon: Icons.notifications_none,
                badge: unread,
                onTap: () => context.push('/notifications'),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () => context.go('/profile'),
                child: const CircleAvatar(
                  radius: 17,
                  backgroundColor: AppColors.teal,
                  child: Icon(Icons.person, color: Colors.white, size: 18),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _IconBox extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final int badge;
  const _IconBox({required this.icon, required this.onTap, this.badge = 0});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppColors.mist,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: AppColors.ink),
          ),
          if (badge > 0)
            Positioned(
              top: -4,
              right: -4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(
                  color: AppColors.red,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.white, width: 1.5),
                ),
                constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                alignment: Alignment.center,
                child: Text(
                  badge > 9 ? '9+' : '$badge',
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _UserDot extends StatelessWidget {
  const _UserDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.teal,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.white, width: 3),
        boxShadow: [
          BoxShadow(
            color: AppColors.teal.withValues(alpha: 0.5),
            blurRadius: 8,
          ),
        ],
      ),
    );
  }
}

/// Encabezado del feed con toggle "Cerca de ti" / "Todas".
class _FeedHeader extends StatelessWidget {
  final String text;
  final bool showAll;
  final VoidCallback onToggle;

  const _FeedHeader({
    required this.text,
    required this.showAll,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              text.toUpperCase(),
              style: AppTextStyles.labelUppercase.copyWith(fontSize: 14),
            ),
          ),
          GestureDetector(
            onTap: onToggle,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: showAll ? AppColors.ink : AppColors.white,
                borderRadius: BorderRadius.circular(99),
                border: Border.all(
                  color: showAll ? AppColors.ink : AppColors.border,
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    showAll ? Icons.public : Icons.near_me,
                    size: 13,
                    color: showAll ? AppColors.volt : AppColors.slate,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    showAll ? 'Todas' : 'Ver todas',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: showAll ? AppColors.volt : AppColors.slate,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

