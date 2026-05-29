import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../data/models/event_model.dart';
import '../../../shared/widgets/sport_match_button.dart';
import '../../sessions/widgets/level_selector.dart';
import '../providers/event_provider.dart';

/// Detalle de evento patrocinado. Sprint 2: inscripción funcional por nivel.
class EventDetailPage extends ConsumerStatefulWidget {
  final String eventId;
  const EventDetailPage({super.key, required this.eventId});

  @override
  ConsumerState<EventDetailPage> createState() => _EventDetailPageState();
}

class _EventDetailPageState extends ConsumerState<EventDetailPage> {
  String _level = 'rx';

  @override
  Widget build(BuildContext context) {
    final eventAsync = ref.watch(eventByIdProvider(widget.eventId));
    final controllerState = ref.watch(eventControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: eventAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'No se pudo cargar el evento.\n$e',
              textAlign: TextAlign.center,
              style: AppTextStyles.body,
            ),
          ),
        ),
        data: (event) => _Body(
          event: event,
          selectedLevel: _level,
          onLevelChanged: (v) => setState(() => _level = v),
          isLoading: controllerState.isLoading,
          onRegister: () async {
            final ok = await ref
                .read(eventControllerProvider.notifier)
                .register(widget.eventId, _level);
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  ok
                      ? '¡Inscrito! El gimnasio te confirmará por WhatsApp.'
                      : 'No se pudo completar la inscripción.',
                ),
              ),
            );
            if (ok) context.go('/');
          },
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final EventModel event;
  final String selectedLevel;
  final ValueChanged<String> onLevelChanged;
  final bool isLoading;
  final VoidCallback onRegister;

  const _Body({
    required this.event,
    required this.selectedLevel,
    required this.onLevelChanged,
    required this.isLoading,
    required this.onRegister,
  });

  int _spotsFor(String level) {
    switch (level) {
      case 'rx':
        return event.spotsRx;
      case 'scaled':
        return event.spotsScaled;
      case 'beginner':
        return event.spotsBeginner;
      default:
        return event.spotsAvailable;
    }
  }

  @override
  Widget build(BuildContext context) {
    final spots = _spotsFor(selectedLevel);
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        _Hero(event: event),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _Stat(value: '${event.maxCapacity}', label: 'cupos'),
                  const SizedBox(width: 8),
                  _Stat(value: '${event.spotsAvailable}', label: 'libres'),
                  const SizedBox(width: 8),
                  _Stat(value: event.priceLabel, label: 'costo'),
                ],
              ),
              const SizedBox(height: 20),
              if (event.description != null && event.description!.isNotEmpty)
                Text(event.description!, style: AppTextStyles.body),
              if (event.wodDescription.isNotEmpty) ...[
                const SizedBox(height: 20),
                Text('WOD DEL EVENTO',
                    style: AppTextStyles.labelUppercase),
                const SizedBox(height: 8),
                _WodList(items: event.wodDescription),
              ],
              const SizedBox(height: 20),
              Text('ELIGE TU NIVEL', style: AppTextStyles.labelUppercase),
              const SizedBox(height: 10),
              LevelSelector(
                value: selectedLevel,
                onChanged: onLevelChanged,
                includeAny: false,
              ),
              const SizedBox(height: 6),
              Text(
                spots > 0
                    ? '$spots lugar(es) disponible(s) en ${selectedLevel.toUpperCase()}'
                    : 'Sin lugares en ${selectedLevel.toUpperCase()}',
                style: AppTextStyles.bodySmall,
              ),
              const SizedBox(height: 20),
              SportMatchButton(
                label: spots > 0
                    ? 'Inscribirme al evento'
                    : 'Sin lugares en este nivel',
                variant: SmButtonVariant.amber,
                isLoading: isLoading,
                onTap: spots > 0 ? onRegister : null,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Hero extends StatelessWidget {
  final EventModel event;
  const _Hero({required this.event});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.ink,
      padding: const EdgeInsets.fromLTRB(20, 48, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const BackButton(color: Colors.white),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.amber.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                      color: AppColors.amber.withValues(alpha: 0.4)),
                ),
                child: Text('🏆 Evento patrocinado',
                    style: AppTextStyles.bodySmall
                        .copyWith(color: AppColors.amber)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(event.title.toUpperCase(),
              style: AppTextStyles.headline2.copyWith(color: AppColors.white)),
          const SizedBox(height: 4),
          Text(
            '${DateFormatter.dayAndTime(event.scheduledAt)} · ${event.venueName}',
            style: AppTextStyles.bodySmall
                .copyWith(color: Colors.white.withValues(alpha: 0.55)),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String value;
  final String label;
  const _Stat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.mist,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(value, style: AppTextStyles.bigNumber.copyWith(fontSize: 20)),
            const SizedBox(height: 3),
            Text(label, style: AppTextStyles.bodySmall.copyWith(fontSize: 10)),
          ],
        ),
      ),
    );
  }
}

class _WodList extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  const _WodList({required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items.map((item) {
        final reps = item['reps']?.toString() ?? '';
        final name = item['name']?.toString() ?? '';
        final note = item['note']?.toString();
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 40,
                child: Text(reps,
                    style: AppTextStyles.bigNumber.copyWith(fontSize: 18)),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: AppTextStyles.bodyMedium),
                    if (note != null && note.isNotEmpty)
                      Text(note, style: AppTextStyles.bodySmall),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
