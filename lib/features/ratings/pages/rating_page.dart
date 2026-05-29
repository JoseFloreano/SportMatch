import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/sport_match_button.dart';
import '../../sessions/providers/session_provider.dart';
import '../providers/rating_provider.dart';

/// Calificación post-sesión (Sprint 2): puntualidad, nivel y respeto.
class RatingPage extends ConsumerStatefulWidget {
  final String sessionId;
  const RatingPage({super.key, required this.sessionId});

  @override
  ConsumerState<RatingPage> createState() => _RatingPageState();
}

class _RatingPageState extends ConsumerState<RatingPage> {
  int _punctuality = 5;
  int _levelAccuracy = 5;
  int _respect = 5;
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sessionAsync = ref.watch(sessionByIdProvider(widget.sessionId));
    final submitting = ref.watch(ratingControllerProvider).isLoading;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: Text('CALIFICAR', style: AppTextStyles.headline3),
      ),
      body: sessionAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (session) {
          final ratedId = session.host?.id ?? session.hostId;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                '¿Cómo estuvo tu sesión de ${session.sportLabel}?',
                style: AppTextStyles.headline3,
              ),
              const SizedBox(height: 20),
              _StarRow(
                label: 'Puntualidad',
                hint: '¿Llegó a tiempo?',
                value: _punctuality,
                onChanged: (v) => setState(() => _punctuality = v),
              ),
              _StarRow(
                label: 'Nivel declarado',
                hint: '¿Correspondía al perfil?',
                value: _levelAccuracy,
                onChanged: (v) => setState(() => _levelAccuracy = v),
              ),
              _StarRow(
                label: 'Respeto y trato',
                hint: '¿Fue una experiencia segura?',
                value: _respect,
                onChanged: (v) => setState(() => _respect = v),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _commentController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Comentario (opcional)',
                  filled: true,
                  fillColor: AppColors.mist,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SportMatchButton(
                label: 'Enviar calificación',
                variant: SmButtonVariant.ink,
                isLoading: submitting,
                onTap: () async {
                  final ok = await ref
                      .read(ratingControllerProvider.notifier)
                      .submit(
                        sessionId: widget.sessionId,
                        ratedId: ratedId,
                        punctuality: _punctuality,
                        levelAccuracy: _levelAccuracy,
                        respect: _respect,
                        comment: _commentController.text.trim().isEmpty
                            ? null
                            : _commentController.text.trim(),
                      );
                  if (!context.mounted) return;
                  if (ok) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            '¡Gracias! Tu calificación ayuda a la comunidad.'),
                      ),
                    );
                    context.go('/');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('No se pudo enviar la calificación.')),
                    );
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class _StarRow extends StatelessWidget {
  final String label;
  final String hint;
  final int value;
  final ValueChanged<int> onChanged;

  const _StarRow({
    required this.label,
    required this.hint,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.sportTag),
          Text(hint, style: AppTextStyles.bodySmall),
          const SizedBox(height: 6),
          Row(
            children: List.generate(5, (i) {
              final filled = i < value;
              return IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => onChanged(i + 1),
                icon: Icon(
                  filled ? Icons.star : Icons.star_border,
                  color: AppColors.volt,
                  size: 32,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
