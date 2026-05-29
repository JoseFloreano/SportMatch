import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

enum SmCardVariant { defaultCard, event, women, ink }

class SportMatchCard extends StatelessWidget {
  final Widget child;
  final SmCardVariant variant;
  final EdgeInsetsGeometry padding;
  final double radius;
  final VoidCallback? onTap;

  const SportMatchCard({
    super.key,
    required this.child,
    this.variant = SmCardVariant.defaultCard,
    this.padding = const EdgeInsets.all(16),
    this.radius = 20,
    this.onTap,
  });

  ({Color bg, Color border}) get _colors {
    switch (variant) {
      case SmCardVariant.defaultCard:
        return (bg: AppColors.white, border: AppColors.border);
      case SmCardVariant.event:
        return (bg: AppColors.amberLight, border: AppColors.amber);
      case SmCardVariant.women:
        return (bg: AppColors.purpleLight, border: AppColors.purple);
      case SmCardVariant.ink:
        return (bg: AppColors.ink, border: AppColors.ink);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = _colors;
    final card = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: c.bg,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: c.border, width: 1),
      ),
      child: child,
    );
    if (onTap == null) return card;
    return InkWell(
      borderRadius: BorderRadius.circular(radius),
      onTap: onTap,
      child: card,
    );
  }
}
