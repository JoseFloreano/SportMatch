import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../data/models/session_model.dart';
import '../../../shared/widgets/sport_match_button.dart';

/// Bottom sheet con el resumen de una sesión al tocar su pin en el mapa.
class SessionBottomSheet extends StatelessWidget {
  final SessionModel session;
  final VoidCallback onViewDetail;
  final VoidCallback onJoin;

  const SessionBottomSheet({
    super.key,
    required this.session,
    required this.onViewDetail,
    required this.onJoin,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: 20 + MediaQuery.of(context).viewPadding.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(session.sportEmoji, style: const TextStyle(fontSize: 28)),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      session.sportLabel.toUpperCase(),
                      style: AppTextStyles.headline3,
                    ),
                    Text(
                      DateFormatter.dayAndTime(session.scheduledAt),
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '${session.zoneName} · ${session.spotsAvailable} lugares disponibles',
            style: AppTextStyles.body,
          ),
          if (session.notes != null && session.notes!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(session.notes!, style: AppTextStyles.bodySmall),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: SportMatchButton(
                  label: 'Unirse',
                  variant: SmButtonVariant.ink,
                  onTap: onJoin,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SportMatchButton(
                  label: 'Ver detalle',
                  variant: SmButtonVariant.mist,
                  onTap: onViewDetail,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
