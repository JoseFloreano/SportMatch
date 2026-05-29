import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

/// Selector de nivel: RX (rojo), Scaled (ámbar), Beginner (verde), Todos.
class LevelSelector extends StatelessWidget {
  final String? value;
  final ValueChanged<String> onChanged;
  final bool includeAny;

  const LevelSelector({
    super.key,
    required this.value,
    required this.onChanged,
    this.includeAny = true,
  });

  static Color colorForLevel(String id) {
    switch (id) {
      case 'rx':
        return AppColors.levelRx;
      case 'scaled':
        return AppColors.levelScaled;
      case 'beginner':
        return AppColors.levelBeginner;
      default:
        return AppColors.slate;
    }
  }

  @override
  Widget build(BuildContext context) {
    final levels = [
      {'id': 'rx', 'label': 'RX', 'desc': 'Competitivo'},
      {'id': 'scaled', 'label': 'Scaled', 'desc': 'Intermedio'},
      {'id': 'beginner', 'label': 'Beginner', 'desc': 'Iniciando'},
      if (includeAny) {'id': 'any', 'label': 'Todos', 'desc': 'Cualquiera'},
    ];

    return Row(
      children: levels.map((lvl) {
        final id = lvl['id']!;
        final selected = value == id;
        final color = colorForLevel(id);
        final accent = id == 'any' ? AppColors.ink : color;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () => onChanged(id),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                decoration: BoxDecoration(
                  color: selected
                      ? accent.withValues(alpha: 0.12)
                      : AppColors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: selected ? accent : AppColors.border,
                    width: 1.5,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      lvl['label']!.toUpperCase(),
                      style: AppTextStyles.sportTag,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      lvl['desc']!,
                      style: AppTextStyles.bodySmall.copyWith(fontSize: 10),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
