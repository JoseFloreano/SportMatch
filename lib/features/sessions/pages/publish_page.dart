import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/utils/location_service.dart';
import '../../map/providers/map_provider.dart';
import '../providers/session_provider.dart';
import '../widgets/level_selector.dart';
import '../widgets/sport_selector.dart';

class PublishPage extends ConsumerStatefulWidget {
  const PublishPage({super.key});

  @override
  ConsumerState<PublishPage> createState() => _PublishPageState();
}

class _PublishPageState extends ConsumerState<PublishPage> {
  String? _sport;
  String _level = 'any';
  DateTime _scheduledAt = DateTime.now().add(const Duration(hours: 12));
  final _zoneController = TextEditingController();
  final _notesController = TextEditingController();
  int _maxSpots = 4;
  bool _womenOnly = false;
  bool _whatsappNotify = true;

  // Colonia autodetectada por GPS. Si el usuario la cambia, geocodificamos el
  // texto nuevo para que la sesión caiga en ESA colonia, no en su ubicación.
  String _prefilledZone = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _prefillZone());
  }

  Future<void> _prefillZone() async {
    final state = ref.read(mapNotifierProvider);
    final zone = await LocationService.getNeighborhood(state.lat, state.lng);
    if (mounted && _zoneController.text.isEmpty) {
      _zoneController.text = zone;
      _prefilledZone = zone;
    }
  }

  @override
  void dispose() {
    _zoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _scheduledAt,
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

  Future<void> _publish() async {
    if (_sport == null) {
      _toast('Elige un deporte.');
      return;
    }
    if (_zoneController.text.trim().isEmpty) {
      _toast('Indica la zona o colonia.');
      return;
    }
    if (_scheduledAt.isBefore(DateTime.now())) {
      _toast('La hora debe ser futura.');
      return;
    }

    final mapState = ref.read(mapNotifierProvider);
    final zoneText = _zoneController.text.trim();

    // Por defecto la sesión cae en tu GPS (más preciso). Pero si cambiaste la
    // colonia respecto a la autodetectada, geocodificamos ese texto para que
    // el pin caiga en la colonia escrita.
    var lat = mapState.lat;
    var lng = mapState.lng;
    if (zoneText.toLowerCase() != _prefilledZone.toLowerCase()) {
      final coords = await LocationService.coordsFromAddress(zoneText);
      if (coords != null) {
        lat = coords.lat;
        lng = coords.lng;
      } else if (mounted) {
        _toast('No ubicamos "$zoneText"; uso tu ubicación actual.');
      }
    }

    final session = await ref.read(sessionControllerProvider.notifier).create(
          sport: _sport!,
          level: _level,
          scheduledAt: _scheduledAt,
          durationMin: 60,
          maxSpots: _maxSpots,
          zoneName: zoneText,
          lat: lat,
          lng: lng,
          notes: _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
          womenOnly: _womenOnly,
        );

    if (!mounted) return;
    if (session != null) {
      // Refresca el mapa para que la nueva sesión aparezca.
      ref.read(mapNotifierProvider.notifier).loadNearby();
      _toast('¡Sesión publicada!');
      context.go('/');
    } else {
      final err = ref.read(sessionControllerProvider).error;
      _toast('No se pudo publicar. ${err ?? ''}');
    }
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(sessionControllerProvider).isLoading;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: Text('PUBLICAR SESIÓN', style: AppTextStyles.headline3),
        leading: const BackButton(color: AppColors.ink),
      ),
      body: ListView(
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
                  Text(
                    DateFormatter.dayAndTime(_scheduledAt),
                    style: AppTextStyles.sportTag.copyWith(fontSize: 17),
                  ),
                  const Icon(Icons.calendar_today_outlined, size: 18),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          _label('Zona'),
          TextField(
            controller: _zoneController,
            decoration: _fieldDecoration('Ej. Roma Norte, Parque México'),
          ),
          const SizedBox(height: 20),
          _label('Nivel'),
          LevelSelector(value: _level, onChanged: (v) => setState(() => _level = v)),
          const SizedBox(height: 20),
          _label('Cupo máximo: $_maxSpots personas'),
          Slider(
            value: _maxSpots.toDouble(),
            min: 1,
            max: 8,
            divisions: 7,
            activeColor: AppColors.ink,
            label: '$_maxSpots',
            onChanged: (v) => setState(() => _maxSpots = v.round()),
          ),
          const SizedBox(height: 8),
          _label('Notas (opcional)'),
          TextField(
            controller: _notesController,
            maxLines: 2,
            decoration: _fieldDecoration('Ej. Llevar liga y kettlebell de 16kg'),
          ),
          const SizedBox(height: 20),
          _ToggleRow(
            title: 'Solo mujeres ♀',
            subtitle: 'Requiere verificación INE',
            value: _womenOnly,
            onChanged: (v) => setState(() => _womenOnly = v),
          ),
          _ToggleRow(
            title: 'Notificar por WhatsApp',
            subtitle: 'Avisa cuando alguien se une',
            value: _whatsappNotify,
            onChanged: (v) => setState(() => _whatsappNotify = v),
          ),
          const SizedBox(height: 24),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.ink,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: isLoading ? null : _publish,
            child: isLoading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(AppColors.volt),
                    ),
                  )
                : Text(
                    '⚡ PUBLICAR EN EL MAPA',
                    style: AppTextStyles.button.copyWith(color: AppColors.volt),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(text.toUpperCase(),
            style: AppTextStyles.labelUppercase),
      );

  InputDecoration _fieldDecoration(String hint) => InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: AppColors.mist,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      );
}

class _ToggleRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleRow({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.mist,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.bodyMedium),
                Text(subtitle, style: AppTextStyles.bodySmall),
              ],
            ),
          ),
          Switch(
            value: value,
            activeThumbColor: AppColors.volt,
            activeTrackColor: AppColors.ink,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
