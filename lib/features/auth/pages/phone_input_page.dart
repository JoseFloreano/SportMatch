import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/sport_match_button.dart';
import '../providers/auth_provider.dart';

class PhoneInputPage extends ConsumerStatefulWidget {
  const PhoneInputPage({super.key});

  @override
  ConsumerState<PhoneInputPage> createState() => _PhoneInputPageState();
}

class _PhoneInputPageState extends ConsumerState<PhoneInputPage> {
  final _controller = TextEditingController();
  String? _localError;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final raw = _controller.text.trim();
    if (raw.replaceAll(RegExp(r'[^0-9]'), '').length < 10) {
      setState(() => _localError = 'Ingresa un número de 10 dígitos.');
      return;
    }
    setState(() => _localError = null);
    final phone = '+${AppConstants.formatMxPhone(raw)}';
    final ok = await ref.read(authControllerProvider.notifier).sendOtp(phone);
    if (ok && mounted) {
      context.push('/auth/otp', extra: phone);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.isLoading;
    final serverError = authState.hasError ? authState.error.toString() : null;

    return Scaffold(
      backgroundColor: AppColors.ink,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              RichText(
                text: TextSpan(
                  style: AppTextStyles.headline1.copyWith(
                    color: AppColors.white,
                    fontSize: 44,
                  ),
                  children: const [
                    TextSpan(text: 'SPORT'),
                    TextSpan(
                      text: 'MATCH',
                      style: TextStyle(color: AppColors.volt),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Encuentra con quién entrenar cerca de ti.',
                style: AppTextStyles.body.copyWith(
                  color: Colors.white.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 40),
              Text(
                'TU TELÉFONO',
                style: AppTextStyles.labelUppercase.copyWith(
                  color: AppColors.volt,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _controller,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9 ]')),
                ],
                style: AppTextStyles.headline3.copyWith(color: AppColors.white),
                decoration: InputDecoration(
                  prefixText: '+52  ',
                  prefixStyle:
                      AppTextStyles.headline3.copyWith(color: AppColors.volt),
                  hintText: '55 1234 5678',
                  hintStyle: AppTextStyles.headline3.copyWith(
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                  filled: true,
                  fillColor: AppColors.inkMid,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              if (_localError != null || serverError != null) ...[
                const SizedBox(height: 10),
                Text(
                  _localError ?? serverError!,
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.red),
                ),
              ],
              const SizedBox(height: 24),
              SportMatchButton(
                label: 'Enviar código',
                variant: SmButtonVariant.volt,
                isLoading: isLoading,
                onTap: _submit,
              ),
              const SizedBox(height: 12),
              Text(
                'Te enviaremos un código por SMS para verificar tu número.',
                style: AppTextStyles.bodySmall.copyWith(
                  color: Colors.white.withValues(alpha: 0.4),
                ),
              ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
