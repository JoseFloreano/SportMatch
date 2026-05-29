import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/profile_model.dart';
import '../../../data/providers/supabase_provider.dart';
import '../../sessions/widgets/level_selector.dart';
import '../providers/profile_provider.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  final _zoneController = TextEditingController();
  final Set<String> _sports = {};
  String _level = 'any';
  bool _womenMode = false;
  bool _whatsappOptin = true;
  String? _avatarUrl;
  bool _seeded = false;
  bool _uploadingAvatar = false;

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _zoneController.dispose();
    super.dispose();
  }

  void _seed(ProfileModel p) {
    if (_seeded) return;
    _seeded = true;
    _nameController.text = p.displayName;
    _bioController.text = p.bio ?? '';
    _zoneController.text = p.neighborhood ?? '';
    _sports.addAll(p.sports);
    _level = p.level ?? 'any';
    _womenMode = p.womenOnlyMode;
    _whatsappOptin = p.whatsappOptin;
    _avatarUrl = p.avatarUrl;
  }

  Future<void> _pickAvatar() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
    );
    if (picked == null) return;
    setState(() => _uploadingAvatar = true);
    try {
      final url = await ref
          .read(profileRepositoryProvider)
          .uploadAvatar(File(picked.path));
      if (mounted) setState(() => _avatarUrl = url);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo subir el avatar: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _uploadingAvatar = false);
    }
  }

  Future<void> _save(ProfileModel base) async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El nombre es obligatorio.')),
      );
      return;
    }
    final updated = base.copyWith(
      displayName: _nameController.text.trim(),
      bio: _bioController.text.trim(),
      neighborhood: _zoneController.text.trim(),
      sports: _sports.toList(),
      level: _level,
      womenOnlyMode: _womenMode,
      whatsappOptin: _whatsappOptin,
      avatarUrl: _avatarUrl,
    );
    final ok = await ref.read(profileControllerProvider.notifier).save(updated);
    if (!mounted) return;
    if (ok) {
      context.go('/');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo guardar el perfil.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(currentProfileProvider);
    final saving = ref.watch(profileControllerProvider).isLoading;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: Text('EDITAR PERFIL', style: AppTextStyles.headline3),
      ),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (profile) {
          final base = profile ??
              ProfileModel(
                id: ref.read(supabaseClientProvider).auth.currentUser?.id ?? '',
                displayName: '',
                phone: '',
                createdAt: DateTime.now(),
              );
          _seed(base);
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Center(child: _avatarPicker()),
              const SizedBox(height: 24),
              _label('Nombre'),
              TextField(
                controller: _nameController,
                decoration: _dec('¿Cómo te llamas?'),
              ),
              const SizedBox(height: 14),
              _label('Bio'),
              TextField(
                controller: _bioController,
                maxLines: 2,
                decoration: _dec('Cuéntale a la comunidad sobre ti'),
              ),
              const SizedBox(height: 14),
              _label('Colonia'),
              TextField(
                controller: _zoneController,
                decoration: _dec('Ej. La Condesa'),
              ),
              const SizedBox(height: 20),
              _label('Deportes'),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: AppConstants.sports.map((s) {
                  final selected = _sports.contains(s['id']);
                  return FilterChip(
                    label: Text('${s['emoji']} ${s['label']}'),
                    selected: selected,
                    selectedColor: AppColors.ink,
                    labelStyle: TextStyle(
                      color: selected ? AppColors.volt : AppColors.ink,
                    ),
                    onSelected: (v) => setState(() {
                      if (v) {
                        _sports.add(s['id']!);
                      } else {
                        _sports.remove(s['id']);
                      }
                    }),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              _label('Nivel principal'),
              LevelSelector(
                value: _level,
                onChanged: (v) => setState(() => _level = v),
              ),
              const SizedBox(height: 20),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Modo solo mujeres ♀'),
                subtitle: const Text('Requiere verificación INE'),
                value: _womenMode,
                activeThumbColor: AppColors.volt,
                activeTrackColor: AppColors.ink,
                onChanged: (v) => setState(() => _womenMode = v),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Notificaciones WhatsApp'),
                subtitle: const Text('Avisos de matches y recordatorios'),
                value: _whatsappOptin,
                activeThumbColor: AppColors.volt,
                activeTrackColor: AppColors.ink,
                onChanged: (v) => setState(() => _whatsappOptin = v),
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
                onPressed: saving ? null : () => _save(base),
                child: saving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(AppColors.volt),
                        ),
                      )
                    : Text('GUARDAR',
                        style: AppTextStyles.button
                            .copyWith(color: AppColors.volt)),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _avatarPicker() {
    return Stack(
      children: [
        CircleAvatar(
          radius: 44,
          backgroundColor: AppColors.teal,
          backgroundImage:
              _avatarUrl != null ? NetworkImage(_avatarUrl!) : null,
          child: _avatarUrl == null
              ? const Icon(Icons.person, color: Colors.white, size: 40)
              : null,
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: GestureDetector(
            onTap: _uploadingAvatar ? null : _pickAvatar,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: AppColors.ink,
                shape: BoxShape.circle,
              ),
              child: _uploadingAvatar
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(AppColors.volt),
                      ),
                    )
                  : const Icon(Icons.camera_alt,
                      color: AppColors.volt, size: 16),
            ),
          ),
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
