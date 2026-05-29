import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../data/models/session_model.dart';
import '../../../shared/widgets/sport_match_badge.dart';
import 'level_selector.dart';

/// Tarjeta horizontal de sesión para el feed bajo el mapa.
class SessionCard extends StatelessWidget {
  final SessionModel session;
  final VoidCallback? onTap;
  final VoidCallback? onJoin;
  final bool isOwn;

  const SessionCard({
    super.key,
    required this.session,
    this.onTap,
    this.onJoin,
    this.isOwn = false,
  });

  @override
  Widget build(BuildContext context) {
    final women = session.womenOnly;
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isOwn
              ? AppColors.volt.withValues(alpha: 0.12)
              : women
                  ? AppColors.purpleLight
                  : AppColors.mist,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isOwn
                ? AppColors.voltDark
                : women
                    ? AppColors.purple
                    : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar deporte
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.tealLight,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Text(
                session.sportEmoji,
                style: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(width: 10),
            // Cuerpo
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    session.sportLabel.toUpperCase(),
                    style: AppTextStyles.sportTag.copyWith(fontSize: 15),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    [
                      session.zoneName,
                      if (session.distanceLabel != null) session.distanceLabel,
                      if (session.host != null)
                        '${session.host!.displayName} ★${session.host!.rating.toStringAsFixed(1)}',
                    ].whereType<String>().join(' · '),
                    style: AppTextStyles.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: [
                      if (isOwn)
                        const SportMatchBadge(
                          label: 'TU SESIÓN',
                          variant: SmBadgeVariant.ine,
                        ),
                      if (!isOwn &&
                          session.host?.rating != null &&
                          session.host!.rating > 0)
                        const SportMatchBadge(
                          label: 'INE ✓',
                          variant: SmBadgeVariant.req,
                        ),
                      if (women)
                        const SportMatchBadge(
                          label: 'Solo mujeres ♀',
                          variant: SmBadgeVariant.women,
                        ),
                      SportMatchBadge(
                        label: session.level.toUpperCase(),
                        variant: SmBadgeVariant.level,
                        levelColor: LevelSelector.colorForLevel(session.level),
                      ),
                      SportMatchBadge(
                        label: '${session.spotsAvailable} lugares',
                        variant: SmBadgeVariant.opt,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Lado derecho: hora + botón
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  DateFormatter.time(session.scheduledAt),
                  style: AppTextStyles.time.copyWith(fontSize: 16),
                ),
                Text(
                  DateFormatter.relativeDay(session.scheduledAt),
                  style: AppTextStyles.bodySmall.copyWith(fontSize: 11),
                ),
                const SizedBox(height: 6),
                _JoinButton(onTap: onJoin, isOwn: isOwn),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _JoinButton extends StatelessWidget {
  final VoidCallback? onTap;
  final bool isOwn;
  const _JoinButton({this.onTap, this.isOwn = false});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isOwn ? AppColors.mist : AppColors.ink,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          child: Text(
            isOwn ? 'GESTIONAR' : 'UNIRSE',
            style: AppTextStyles.button.copyWith(
              fontSize: 11,
              color: isOwn ? AppColors.ink : AppColors.volt,
            ),
          ),
        ),
      ),
    );
  }
}
