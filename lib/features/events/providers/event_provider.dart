import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/models/event_model.dart';
import '../../../data/providers/supabase_provider.dart';

part 'event_provider.g.dart';

/// Un evento por id.
@riverpod
Future<EventModel> eventById(Ref ref, String id) {
  return ref.watch(eventRepositoryProvider).getEventById(id);
}

/// Todos los eventos patrocinados próximos (para la pantalla de Eventos).
@riverpod
Future<List<EventModel>> upcomingEvents(Ref ref) {
  return ref.watch(eventRepositoryProvider).getUpcomingEvents();
}

@riverpod
class EventController extends _$EventController {
  @override
  FutureOr<void> build() {}

  /// Inscribe al usuario al evento en el nivel elegido.
  Future<bool> register(String eventId, String level) async {
    state = const AsyncLoading();
    final res = await AsyncValue.guard(
      () => ref.read(eventRepositoryProvider).registerForEvent(eventId, level),
    );
    state = res;
    return !res.hasError;
  }
}
