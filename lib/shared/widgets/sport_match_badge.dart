import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

enum SmBadgeVariant { ine, phone, event, women, req, opt, level }

class SportMatchBadge extends StatelessWidget {
  final String label;
  final SmBadgeVariant variant;
  final IconData? icon;
  final Color? levelColor; // usado cuando variant == level

  const SportMatchBadge({
    super.key,
    required this.label,
    this.variant = SmBadgeVariant.opt,
    this.icon,
    this.levelColor,
  });

  ({Color bg, Color fg}) get _colors {
    switch (variant) {
      case SmBadgeVariant.ine:
        return (bg: AppColors.ink, fg: AppColors.volt);
      case SmBadgeVariant.phone:
        return (bg: AppColors.tealLight, fg: AppColors.teal);
      case SmBadgeVariant.event:
        return (bg: AppColors.amberLight, fg: const Color(0xFF7A4100));
      case SmBadgeVariant.women:
        return (bg: AppColors.purpleLight, fg: const Color(0xFF6B1A6B));
      case SmBadgeVariant.req:
        return (bg: AppColors.greenLight, fg: const Color(0xFF1A6B3E));
      case SmBadgeVariant.opt:
        return (bg: AppColors.mist, fg: AppColors.inkMid);
      case SmBadgeVariant.level:
        final color = levelColor ?? AppColors.slate;
        return (bg: color.withValues(alpha: 0.12), fg: color);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = _colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: c.bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: c.fg),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: c.fg,
            ),
          ),
        ],
      ),
    );
  }
}
