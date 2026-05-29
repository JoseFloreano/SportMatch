import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../data/models/event_model.dart';
import '../../../shared/widgets/bottom_nav_bar.dart';
import '../providers/event_provider.dart';

/// Bandeja de eventos patrocinados de CDMX.
class EventsListPage extends ConsumerWidget {
  const EventsListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(upcomingEventsProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      bottomNavigationBar: const BottomNavBar(),
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: Text('EVENTOS', style: AppTextStyles.headline3),
      ),
      body: eventsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'No pudimos cargar los eventos.\n$e',
              textAlign: TextAlign.center,
              style: AppTextStyles.body,
            ),
          ),
        ),
        data: (events) {
          if (events.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('🏆', style: TextStyle(fontSize: 48)),
                    const SizedBox(height: 12),
                    Text('Sin eventos por ahora',
                        style: AppTextStyles.headline3,
                        textAlign: TextAlign.center),
                    const SizedBox(height: 6),
                    Text(
                      'Los gimnasios y marcas publican eventos patrocinados aquí.',
                      style: AppTextStyles.body,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(upcomingEventsProvider),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: events.length,
              itemBuilder: (_, i) => _EventCard(event: events[i]),
            ),
          );
        },
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  final EventModel event;
  const _EventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => context.push('/event/${event.id}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.amberLight,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.amber, width: 1.5),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.ink,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Text(event.sportEmoji,
                  style: const TextStyle(fontSize: 22)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.amber,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text('🏆 PATROCINADO',
                            style: AppTextStyles.labelUppercase.copyWith(
                                fontSize: 9, color: AppColors.ink)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(event.title.toUpperCase(),
                      style: AppTextStyles.sportTag.copyWith(fontSize: 15)),
                  Text(event.venueName, style: AppTextStyles.bodySmall),
                  const SizedBox(height: 4),
                  Text(
                    '${DateFormatter.dayAndTime(event.scheduledAt)} · ${event.priceLabel} · ${event.spotsAvailable} libres',
                    style: AppTextStyles.bodySmall.copyWith(fontSize: 11),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.slate),
          ],
        ),
      ),
    );
  }
}
