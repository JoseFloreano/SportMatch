import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';

/// Barra de navegación inferior con 4 tabs. Resalta el tab activo según la
/// ruta actual (ink + volt).
class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  static const _items = [
    (route: '/', label: 'Mapa', icon: Icons.map_outlined),
    (route: '/events', label: 'Eventos', icon: Icons.emoji_events_outlined),
    (route: '/chats', label: 'Chats', icon: Icons.chat_bubble_outline),
    (route: '/profile', label: 'Perfil', icon: Icons.person_outline),
  ];

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      child: SafeArea(
        top: false,
        child: Row(
          children: _items.map((item) {
            final active = item.route == '/'
                ? location == '/'
                : location.startsWith(item.route);
            return Expanded(
              child: InkWell(
                onTap: () => context.go(item.route),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: active ? 14 : 0,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: active ? AppColors.ink : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        item.icon,
                        size: 20,
                        color: active ? AppColors.volt : AppColors.slate,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      item.label,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: active ? AppColors.ink : AppColors.slate,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
