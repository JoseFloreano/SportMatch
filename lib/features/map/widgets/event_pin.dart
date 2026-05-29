import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../data/models/event_model.dart';

/// Pin diferenciado para eventos patrocinados (ámbar + trofeo).
class EventPin extends StatelessWidget {
  final EventModel event;
  final VoidCallback? onTap;

  const EventPin({super.key, required this.event, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.amber,
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
            const Text('🏆', style: TextStyle(fontSize: 13)),
            const SizedBox(width: 5),
            Text(event.sportEmoji, style: const TextStyle(fontSize: 13)),
          ],
        ),
      ),
    );
  }
}
