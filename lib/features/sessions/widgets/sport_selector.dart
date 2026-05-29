import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_text_styles.dart';

/// Grid 3 columnas de deportes, selección única.
class SportSelector extends StatelessWidget {
  final String? value;
  final ValueChanged<String> onChanged;

  const SportSelector({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 1.4,
      children: AppConstants.sports.map((sport) {
        final selected = value == sport['id'];
        return InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => onChanged(sport['id']!),
          child: Container(
            decoration: BoxDecoration(
              color: selected ? AppColors.ink : AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: selected ? AppColors.ink : AppColors.border,
                width: 1.5,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(sport['emoji']!, style: const TextStyle(fontSize: 22)),
                const SizedBox(height: 4),
                Text(
                  sport['label']!.toUpperCase(),
                  style: AppTextStyles.sportTag.copyWith(
                    fontSize: 12,
                    color: selected ? AppColors.volt : AppColors.ink,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
