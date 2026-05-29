import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/utils/location_service.dart';
import '../../../data/models/session_model.dart';
import '../providers/session_provider.dart';
import '../widgets/level_selector.dart';
import '../widgets/sport_selector.dart';

/// Edición de una sesión propia. El cupo no se edita (rompería la contabilidad
/// de lugares). Incluye eliminar (soft-delete → cancelada).
class EditSessionPage extends ConsumerWidget {
  final String sessionId;
  const EditSessionPage({super.key, required this.sessionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionAsync = ref.watch(sessionByIdProvider(sessionId));
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: Text('EDITAR SESIÓN', style: AppTextStyles.headline3),
      ),
      body: sessionAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (session) => _Form(sessionId: sessionId, session: session),
      ),
    );
  }
}

class _Form extends ConsumerStatefulWidget {
  final String sessionId;
  final SessionModel session;
  const _Form({required this.sessionId, required this.session});

  @override
  ConsumerState<_Form> createState() => _FormState();
}

class _FormState extends ConsumerState<_Form> {
  late String _sport = widget.session.sport;
  late String _level = widget.session.level;
  late DateTime _scheduledAt = widget.session.scheduledAt;
  late final TextEditingController _zoneController =
      TextEditingController(text: widget.session.zoneName);
  late final TextEditingController _notesController =
      TextEditingController(text: widget.session.notes ?? '');
  late bool _womenOnly = widget.session.womenOnly;
  late final String _originalZone = widget.session.zoneName;

  @override
  void dispose() {
    _zoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _scheduledAt.isBefore(DateTime.now())
          ? DateTime.now()
          : _scheduledAt,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 60)),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_scheduledAt),
    );
    if (time == null) return;
    setState(() {
      _scheduledAt =
          DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  Future<void> _save() async {
    final zoneText = _zoneController.text.trim();
    if (zoneText.isEmpty) {
      _toast('Indica la zona o colonia.');
      return;
    }

    var lat = widget.session.lat;
    var lng = widget.session.lng;
    if (zoneText.toLowerCase() != _originalZone.toLowerCase()) {
      final coords = await LocationService.coordsFromAddress(zoneText);
      if (coords != null) {
        lat = coords.lat;
        lng = coords.lng;
      } else if (mounted) {
        _toast('No ubicamos "$zoneText"; mantengo la ubicación anterior.');
      }
    }

    final ok = await ref.read(sessionControllerProvider.notifier).edit(
          sessionId: widget.sessionId,
          sport: _sport,
          level: _level,
          scheduledAt: _scheduledAt,
          zoneName: zoneText,
          lat: lat,
          lng: lng,
          notes: _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
          womenOnly: _womenOnly,
        );
    if (!mounted) return;
    if (ok) {
      _toast('Sesión actualizada.');
      context.pop();
    } else {
      _toast('No se pudo guardar.');
    }
  }

  Future<void> _delete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('¿Eliminar sesión?'),
        content: const Text(
            'Se quitará del mapa y nadie podrá unirse. No se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar',
                style: TextStyle(color: AppColors.red)),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    final ok = await ref
        .read(sessionControllerProvider.notifier)
        .remove(widget.sessionId);
    if (!mounted) return;
    if (ok) {
      _toast('Sesión eliminada.');
      context.go('/');
    } else {
      _toast('No se pudo eliminar.');
    }
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(sessionControllerProvider).isLoading;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _label('¿Qué deporte?'),
        SportSelector(value: _sport, onChanged: (v) => setState(() => _sport = v)),
        const SizedBox(height: 20),
        _label('Cuándo'),
        InkWell(
          onTap: _pickDateTime,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.mist,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(DateFormatter.dayAndTime(_scheduledAt),
                    style: AppTextStyles.sportTag.copyWith(fontSize: 17)),
                const Icon(Icons.calendar_today_outlined, size: 18),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        _label('Zona'),
        TextField(controller: _zoneController, decoration: _dec('Ej. Roma Norte')),
        const SizedBox(height: 20),
        _label('Nivel'),
        LevelSelector(value: _level, onChanged: (v) => setState(() => _level = v)),
        const SizedBox(height: 20),
        _label('Notas (opcional)'),
        TextField(
            controller: _notesController,
            maxLines: 2,
            decoration: _dec('Ej. Llevar liga y kettlebell')),
        const SizedBox(height: 12),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Solo mujeres ♀'),
          value: _womenOnly,
          activeThumbColor: AppColors.volt,
          activeTrackColor: AppColors.ink,
          onChanged: (v) => setState(() => _womenOnly = v),
        ),
        const SizedBox(height: 8),
        Text('El cupo (${widget.session.maxSpots} personas) no se edita.',
            style: AppTextStyles.bodySmall),
        const SizedBox(height: 24),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.ink,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14)),
          ),
          onPressed: isLoading ? null : _save,
          child: isLoading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(AppColors.volt),
                  ),
                )
              : Text('GUARDAR CAMBIOS',
                  style: AppTextStyles.button.copyWith(color: AppColors.volt)),
        ),
        const SizedBox(height: 8),
        TextButton.icon(
          onPressed: isLoading ? null : _delete,
          icon: const Icon(Icons.delete_outline, color: AppColors.red),
          label: Text('Eliminar sesión',
              style: AppTextStyles.body.copyWith(color: AppColors.red)),
        ),
      ],
    );
  }

  Widget _label(String t) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(t.toUpperCase(), style: AppTextStyles.labelUppercase),
      );

  InputDecoration _dec(String hint) => InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: AppColors.mist,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      );
}
