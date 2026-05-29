import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/profile_model.dart';
import '../../../shared/widgets/bottom_nav_bar.dart';
import '../../../shared/widgets/sport_match_badge.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/profile_provider.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(currentProfileProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      bottomNavigationBar: const BottomNavBar(),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text('No pudimos cargar tu perfil.\n$e',
                textAlign: TextAlign.center, style: AppTextStyles.body),
          ),
        ),
        data: (profile) {
          if (profile == null) {
            return const Center(child: Text('Sin perfil.'));
          }
          return _ProfileBody(profile: profile);
        },
      ),
    );
  }
}

class _ProfileBody extends ConsumerWidget {
  final ProfileModel profile;
  const _ProfileBody({required this.profile});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        _Hero(profile: profile),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _Stat(value: '${profile.totalSessions}', label: 'sesiones'),
                  const SizedBox(width: 8),
                  _Stat(
                      value: '${profile.attendanceRate.toStringAsFixed(0)}%',
                      label: 'asistencia'),
                  const SizedBox(width: 8),
                  _Stat(
                      value: profile.rating.toStringAsFixed(1),
                      label: 'rating'),
                ],
              ),
              const SizedBox(height: 20),
              if (profile.sports.isNotEmpty) ...[
                Text('DEPORTES', style: AppTextStyles.labelUppercase),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: profile.sports
                      .map((s) => Chip(
                            label: Text(s),
                            backgroundColor: AppColors.mist,
                          ))
                      .toList(),
                ),
                const SizedBox(height: 20),
              ],
              _WomenModeRow(profile: profile),
              const SizedBox(height: 20),
              OutlinedButton.icon(
                onPressed: () => context.push('/profile/edit'),
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Editar perfil'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  foregroundColor: AppColors.ink,
                  side: const BorderSide(color: AppColors.border),
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => ref.read(authControllerProvider.notifier).signOut(),
                child: Text('Cerrar sesión',
                    style: AppTextStyles.body.copyWith(color: AppColors.red)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Hero extends StatelessWidget {
  final ProfileModel profile;
  const _Hero({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.ink,
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  color: AppColors.teal,
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.center,
                child: Text(profile.initials,
                    style: AppTextStyles.headline2.copyWith(
                        color: AppColors.white, fontSize: 26)),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  SportMatchBadge(
                      label: 'INE verificada',
                      variant: SmBadgeVariant.ine,
                      icon: Icons.verified),
                  SizedBox(height: 4),
                  SportMatchBadge(
                      label: 'Teléfono',
                      variant: SmBadgeVariant.phone,
                      icon: Icons.check),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(profile.displayName.toUpperCase(),
              style: AppTextStyles.headline2.copyWith(color: AppColors.white)),
          if (profile.neighborhood != null)
            Text(profile.neighborhood!,
                style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.white.withValues(alpha: 0.5))),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.star, color: AppColors.volt, size: 18),
              const SizedBox(width: 6),
              Text(profile.rating.toStringAsFixed(1),
                  style: AppTextStyles.headline3.copyWith(
                      color: AppColors.white)),
              const SizedBox(width: 8),
              Text('· ${profile.totalSessions} sesiones',
                  style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.white.withValues(alpha: 0.4))),
            ],
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String value;
  final String label;
  const _Stat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.mist,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(value, style: AppTextStyles.bigNumber.copyWith(fontSize: 22)),
            const SizedBox(height: 3),
            Text(label, style: AppTextStyles.bodySmall.copyWith(fontSize: 10)),
          ],
        ),
      ),
    );
  }
}

class _WomenModeRow extends ConsumerWidget {
  final ProfileModel profile;
  const _WomenModeRow({required this.profile});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final saving = ref.watch(profileControllerProvider).isLoading;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.purpleLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.purple.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          const Text('♀', style: TextStyle(fontSize: 24)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('MODO SOLO MUJERES',
                    style: AppTextStyles.sportTag.copyWith(
                        color: const Color(0xFF6B1A6B))),
                Text('Solo apareces en sesiones de mujeres',
                    style: AppTextStyles.bodySmall.copyWith(
                        color: const Color(0xFF7A2A7A))),
              ],
            ),
          ),
          Switch(
            value: profile.womenOnlyMode,
            activeThumbColor: AppColors.volt,
            activeTrackColor: AppColors.ink,
            onChanged: saving
                ? null
                : (v) => ref.read(profileControllerProvider.notifier).save(
                      profile.copyWith(womenOnlyMode: v),
                    ),
          ),
        ],
      ),
    );
  }
}
