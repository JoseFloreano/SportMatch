import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../data/models/session_model.dart';

/// Burbuja de pin para una sesión en el mapa (emoji + hora).
/// Color: teal si es solo mujeres, ink en caso normal.
class SessionPin extends StatelessWidget {
  final SessionModel session;
  final VoidCallback? onTap;

  const SessionPin({super.key, required this.session, this.onTap});

  @override
  Widget build(BuildContext context) {
    final bg = session.womenOnly ? AppColors.purple : AppColors.ink;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
                bottomLeft: Radius.circular(4),
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x33000000),
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(session.sportEmoji, style: const TextStyle(fontSize: 13)),
                const SizedBox(width: 5),
                Text(
                  DateFormatter.time(session.scheduledAt),
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
