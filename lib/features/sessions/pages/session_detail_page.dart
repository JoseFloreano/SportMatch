import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../data/models/session_model.dart';
import '../../../data/providers/supabase_provider.dart';
import '../../../data/repositories/session_repository.dart';
import '../../../shared/widgets/sport_match_badge.dart';
import '../../../shared/widgets/sport_match_button.dart';
import '../../ratings/providers/rating_provider.dart';
import '../providers/session_provider.dart';
import '../widgets/level_selector.dart';

/// Detalle de sesión. Sprint 2 completo: ver participantes, aceptar/rechazar
/// (host), abrir chat protegido y disparar la calificación cuando se completa.
class SessionDetailPage extends ConsumerWidget {
  final String sessionId;
  const SessionDetailPage({super.key, required this.sessionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionAsync = ref.watch(sessionByIdProvider(sessionId));

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: Text('SESIÓN', style: AppTextStyles.headline3),
      ),
      body: sessionAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'No se pudo cargar la sesión.\n$e',
              textAlign: TextAlign.center,
              style: AppTextStyles.body,
            ),
          ),
        ),
        data: (session) => _Body(sessionId: sessionId, session: session),
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  final String sessionId;
  final SessionModel session;

  const _Body({required this.sessionId, required this.session});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myId = ref.watch(supabaseClientProvider).auth.currentUser?.id;
    final isHost = myId != null && myId == session.hostId;
    final myStatus = ref.watch(myParticipationStatusProvider(sessionId));
    final controllerState = ref.watch(sessionControllerProvider);
    final completed = session.status == 'completed';

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _Header(session: session),
        const SizedBox(height: 12),
        _Badges(session: session),
        const SizedBox(height: 16),
        _InfoTile(icon: Icons.place_outlined, text: session.zoneName),
        if (session.host != null)
          _InfoTile(
            icon: Icons.person_outline,
            text:
                '${session.host!.displayName} · ★ ${session.host!.rating.toStringAsFixed(1)}',
          ),
        if (session.notes != null && session.notes!.isNotEmpty)
          _InfoTile(icon: Icons.notes_outlined, text: session.notes!),
        const SizedBox(height: 20),
        if (completed) _RateBanner(sessionId: sessionId),
        if (isHost)
          _HostActions(
            sessionId: sessionId,
            isCompleted: completed,
            isLoading: controllerState.isLoading,
          )
        else
          _ParticipantActions(
            sessionId: sessionId,
            session: session,
            myStatus: myStatus,
            controllerState: controllerState,
          ),
        const SizedBox(height: 16),
        _ParticipantsSection(sessionId: sessionId, isHost: isHost),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  final SessionModel session;
  const _Header({required this.session});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(session.sportEmoji, style: const TextStyle(fontSize: 32)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(session.sportLabel.toUpperCase(),
                  style: AppTextStyles.headline2),
              Text(DateFormatter.dayAndTime(session.scheduledAt),
                  style: AppTextStyles.body),
            ],
          ),
        ),
      ],
    );
  }
}

class _Badges extends StatelessWidget {
  final SessionModel session;
  const _Badges({required this.session});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        SportMatchBadge(
          label: session.level.toUpperCase(),
          variant: SmBadgeVariant.level,
          levelColor: LevelSelector.colorForLevel(session.level),
        ),
        SportMatchBadge(
          label: '${session.spotsAvailable} lugares',
          variant: SmBadgeVariant.opt,
        ),
        if (session.womenOnly)
          const SportMatchBadge(
            label: 'Solo mujeres ♀',
            variant: SmBadgeVariant.women,
          ),
        SportMatchBadge(
          label: session.status.toUpperCase(),
          variant: SmBadgeVariant.opt,
        ),
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoTile({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.slate),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: AppTextStyles.body)),
        ],
      ),
    );
  }
}

class _RateBanner extends ConsumerWidget {
  final String sessionId;
  const _RateBanner({required this.sessionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pending = ref.watch(hasPendingRatingProvider(sessionId));
    return pending.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (isPending) {
        if (!isPending) return const SizedBox.shrink();
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.volt.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.voltDark),
          ),
          child: Row(
            children: [
              const Icon(Icons.star_border, color: AppColors.voltDark),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Califica esta sesión. Ayuda a la comunidad.',
                  style: AppTextStyles.bodyMedium,
                ),
              ),
              TextButton(
                onPressed: () => context.push('/rate/$sessionId'),
                child: const Text('Calificar'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _HostActions extends ConsumerWidget {
  final String sessionId;
  final bool isCompleted;
  final bool isLoading;

  const _HostActions({
    required this.sessionId,
    required this.isCompleted,
    required this.isLoading,
  });

  Future<void> _openChat(BuildContext context, WidgetRef ref) async {
    try {
      final chatId = await ref
          .read(sessionRepositoryProvider)
          .getOrCreateChatForSession(sessionId);
      if (context.mounted) context.push('/chat/$chatId');
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo abrir el chat: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: SportMatchButton(
                label: 'Abrir chat',
                variant: SmButtonVariant.mist,
                onTap: () => _openChat(context, ref),
              ),
            ),
            if (!isCompleted) ...[
              const SizedBox(width: 10),
              Expanded(
                child: SportMatchButton(
                  label: 'Editar',
                  variant: SmButtonVariant.mist,
                  onTap: () => context.push('/session/$sessionId/edit'),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        if (!isCompleted)
          SportMatchButton(
            label: 'Marcar sesión como completada',
            variant: SmButtonVariant.ink,
            isLoading: isLoading,
            onTap: () async {
              final ok = await ref
                  .read(sessionControllerProvider.notifier)
                  .complete(sessionId);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      ok
                          ? 'Sesión marcada como completada.'
                          : 'No se pudo completar la sesión.',
                    ),
                  ),
                );
              }
            },
          ),
      ],
    );
  }
}

class _ParticipantActions extends ConsumerWidget {
  final String sessionId;
  final SessionModel session;
  final AsyncValue<String?> myStatus;
  final AsyncValue<void> controllerState;

  const _ParticipantActions({
    required this.sessionId,
    required this.session,
    required this.myStatus,
    required this.controllerState,
  });

  Future<void> _join(BuildContext context, WidgetRef ref) async {
    final ok = await ref
        .read(sessionControllerProvider.notifier)
        .join(sessionId);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            ok
                ? 'Solicitud enviada. El host te confirmará.'
                : 'No se pudo enviar la solicitud.',
          ),
        ),
      );
    }
  }

  Future<void> _openChat(BuildContext context, WidgetRef ref) async {
    try {
      final chatId = await ref
          .read(sessionRepositoryProvider)
          .getOrCreateChatForSession(sessionId);
      if (context.mounted) context.push('/chat/$chatId');
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo abrir el chat: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = controllerState.isLoading;
    return myStatus.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => SportMatchButton(
        label: 'Unirse',
        variant: SmButtonVariant.ink,
        isLoading: isLoading,
        onTap: session.isFull ? null : () => _join(context, ref),
      ),
      data: (status) {
        if (status == null) {
          return SportMatchButton(
            label: session.isFull ? 'Sesión llena' : 'Unirse',
            variant: SmButtonVariant.ink,
            isLoading: isLoading,
            onTap: session.isFull ? null : () => _join(context, ref),
          );
        }
        return Column(
          children: [
            SportMatchBadge(
              label: status == 'accepted'
                  ? 'Aceptado ✓'
                  : status == 'pending'
                      ? 'Pendiente'
                      : 'Rechazado',
              variant: status == 'accepted'
                  ? SmBadgeVariant.req
                  : SmBadgeVariant.opt,
            ),
            const SizedBox(height: 12),
            if (status == 'accepted')
              SportMatchButton(
                label: 'Abrir chat',
                variant: SmButtonVariant.ink,
                onTap: () => _openChat(context, ref),
              ),
          ],
        );
      },
    );
  }
}

class _ParticipantsSection extends ConsumerWidget {
  final String sessionId;
  final bool isHost;

  const _ParticipantsSection({
    required this.sessionId,
    required this.isHost,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final participantsAsync =
        ref.watch(sessionParticipantsProvider(sessionId));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('PARTICIPANTES', style: AppTextStyles.labelUppercase),
        const SizedBox(height: 8),
        participantsAsync.when(
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: LinearProgressIndicator(),
          ),
          error: (e, _) => Text('Error: $e', style: AppTextStyles.bodySmall),
          data: (list) {
            if (list.isEmpty) {
              return Text('Nadie se ha unido todavía.',
                  style: AppTextStyles.bodySmall);
            }
            return Column(
              children: list
                  .map((p) => _ParticipantTile(
                        sessionId: sessionId,
                        participant: p,
                        canModerate: isHost,
                      ))
                  .toList(),
            );
          },
        ),
      ],
    );
  }
}

class _ParticipantTile extends ConsumerWidget {
  final String sessionId;
  final SessionParticipant participant;
  final bool canModerate;

  const _ParticipantTile({
    required this.sessionId,
    required this.participant,
    required this.canModerate,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = participant.profile;
    final isLoading = ref.watch(sessionControllerProvider).isLoading;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.mist,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.teal,
            child: Text(
              profile.initials,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(profile.displayName, style: AppTextStyles.bodyMedium),
                Text(
                  '★ ${profile.rating.toStringAsFixed(1)} · ${profile.totalSessions} sesiones',
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
          ),
          if (canModerate && participant.status == 'pending') ...[
            IconButton(
              tooltip: 'Aceptar',
              icon: const Icon(Icons.check_circle, color: AppColors.green),
              onPressed: isLoading
                  ? null
                  : () => ref
                      .read(sessionControllerProvider.notifier)
                      .accept(sessionId: sessionId, userId: profile.id),
            ),
            IconButton(
              tooltip: 'Rechazar',
              icon: const Icon(Icons.cancel, color: AppColors.red),
              onPressed: isLoading
                  ? null
                  : () => ref
                      .read(sessionControllerProvider.notifier)
                      .reject(sessionId: sessionId, userId: profile.id),
            ),
          ] else
            SportMatchBadge(
              label: participant.status,
              variant: participant.status == 'accepted'
                  ? SmBadgeVariant.req
                  : SmBadgeVariant.opt,
            ),
        ],
      ),
    );
  }
}
