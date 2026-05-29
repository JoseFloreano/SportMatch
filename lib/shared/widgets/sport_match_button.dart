import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

enum SmButtonVariant { ink, volt, mist, amber, red }

class SportMatchButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final SmButtonVariant variant;
  final bool fullWidth;
  final bool isLoading;
  final IconData? icon;

  const SportMatchButton({
    super.key,
    required this.label,
    this.onTap,
    this.variant = SmButtonVariant.ink,
    this.fullWidth = true,
    this.isLoading = false,
    this.icon,
  });

  ({Color bg, Color fg}) get _colors {
    switch (variant) {
      case SmButtonVariant.ink:
        return (bg: AppColors.ink, fg: AppColors.volt);
      case SmButtonVariant.volt:
        return (bg: AppColors.volt, fg: AppColors.ink);
      case SmButtonVariant.mist:
        return (bg: AppColors.mist, fg: AppColors.ink);
      case SmButtonVariant.amber:
        return (bg: AppColors.amber, fg: AppColors.ink);
      case SmButtonVariant.red:
        return (bg: AppColors.red, fg: AppColors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = _colors;
    final disabled = onTap == null || isLoading;
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      child: Material(
        color: disabled ? c.bg.withValues(alpha: 0.6) : c.bg,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: disabled ? null : onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
            child: Row(
              mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isLoading) ...[
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(c.fg),
                    ),
                  ),
                  const SizedBox(width: 10),
                ] else if (icon != null) ...[
                  Icon(icon, size: 18, color: c.fg),
                  const SizedBox(width: 8),
                ],
                Text(
                  label.toUpperCase(),
                  style: AppTextStyles.button.copyWith(color: c.fg),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
