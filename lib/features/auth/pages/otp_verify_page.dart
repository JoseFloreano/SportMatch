import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/providers/supabase_provider.dart';
import '../../../shared/widgets/sport_match_button.dart';
import '../providers/auth_provider.dart';

class OtpVerifyPage extends ConsumerStatefulWidget {
  final String phone;
  const OtpVerifyPage({super.key, required this.phone});

  @override
  ConsumerState<OtpVerifyPage> createState() => _OtpVerifyPageState();
}

class _OtpVerifyPageState extends ConsumerState<OtpVerifyPage> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    final token = _controller.text.trim();
    if (token.length < 6) return;

    final ok = await ref.read(authControllerProvider.notifier).verifyOtp(
          phone: widget.phone,
          token: token,
        );
    if (!ok || !mounted) return;

    // Si el perfil aún no tiene nombre, mandamos a completarlo.
    final profile = await ref.read(profileRepositoryProvider).getCurrentProfile();
    if (!mounted) return;
    if (profile == null || profile.displayName.trim().isEmpty) {
      context.go('/profile/edit');
    } else {
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.isLoading;
    final error = authState.hasError ? authState.error.toString() : null;

    return Scaffold(
      backgroundColor: AppColors.ink,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'VERIFICA TU\nNÚMERO',
                style: AppTextStyles.headline2.copyWith(color: AppColors.white),
              ),
              const SizedBox(height: 8),
              Text(
                'Ingresa el código que enviamos a ${widget.phone}',
                style: AppTextStyles.body.copyWith(
                  color: Colors.white.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _controller,
                keyboardType: TextInputType.number,
                maxLength: 6,
                textAlign: TextAlign.center,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                style: AppTextStyles.headline1.copyWith(
                  color: AppColors.volt,
                  letterSpacing: 12,
                  fontSize: 36,
                ),
                decoration: InputDecoration(
                  counterText: '',
                  hintText: '••••••',
                  hintStyle: AppTextStyles.headline1.copyWith(
                    color: Colors.white.withValues(alpha: 0.2),
                    letterSpacing: 12,
                    fontSize: 36,
                  ),
                  filled: true,
                  fillColor: AppColors.inkMid,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (v) {
                  if (v.length == 6) _verify();
                },
              ),
              if (error != null) ...[
                const SizedBox(height: 10),
                Text(
                  'Código incorrecto o expirado. Intenta de nuevo.',
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.red),
                ),
              ],
              const SizedBox(height: 24),
              SportMatchButton(
                label: 'Verificar',
                variant: SmButtonVariant.volt,
                isLoading: isLoading,
                onTap: _verify,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
