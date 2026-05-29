import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/env/env.dart';
import '../../../core/utils/location_service.dart';
import '../../../data/models/event_model.dart';
import '../../../data/models/session_model.dart';
import '../../../data/providers/supabase_provider.dart';

part 'map_provider.g.dart';

const Object _sentinel = Object();

// Radio "gigante" para mostrar todas las sesiones del país sin filtrar distancia.
const double _allSessionsRadiusKm = 50000;

class MapState {
  final Position? userPosition;
  final List<SessionModel> sessions;
  final List<EventModel> events;
  final String? activeSportFilter;
  final double searchRadiusKm;
  final bool showAll;
  final bool isLoading;
  final String? error;

  const MapState({
    this.userPosition,
    this.sessions = const [],
    this.events = const [],
    this.activeSportFilter,
    this.searchRadiusKm = 3.0,
    this.showAll = false,
    this.isLoading = false,
    this.error,
  });

  /// Radio efectivo de la consulta: si "ver todas" está activo, ignora distancia.
  double get effectiveRadiusKm => showAll ? _allSessionsRadiusKm : searchRadiusKm;

  /// Coordenada activa: GPS del usuario o el centro default (La Condesa).
  double get lat => userPosition?.latitude ?? AppConstants.defaultLat;
  double get lng => userPosition?.longitude ?? AppConstants.defaultLng;

  /// Sesiones tras aplicar el filtro de deporte (filtrado en cliente).
  List<SessionModel> get visibleSessions {
    if (activeSportFilter == null) return sessions;
    if (activeSportFilter == 'eventos') return const [];
    return sessions.where((s) => s.sport == activeSportFilter).toList();
  }

  MapState copyWith({
    Object? userPosition = _sentinel,
    List<SessionModel>? sessions,
    List<EventModel>? events,
    Object? activeSportFilter = _sentinel,
    double? searchRadiusKm,
    bool? showAll,
    bool? isLoading,
    Object? error = _sentinel,
  }) {
    return MapState(
      userPosition: identical(userPosition, _sentinel)
          ? this.userPosition
          : userPosition as Position?,
      sessions: sessions ?? this.sessions,
      events: events ?? this.events,
      activeSportFilter: identical(activeSportFilter, _sentinel)
          ? this.activeSportFilter
          : activeSportFilter as String?,
      searchRadiusKm: searchRadiusKm ?? this.searchRadiusKm,
      showAll: showAll ?? this.showAll,
      isLoading: isLoading ?? this.isLoading,
      error: identical(error, _sentinel) ? this.error : error as String?,
    );
  }
}

@riverpod
class MapNotifier extends _$MapNotifier {
  @override
  MapState build() => MapState(searchRadiusKm: Env.defaultSearchRadiusKm);

  /// Carga inicial: ubicación del usuario + sesiones/eventos cercanos.
  Future<void> init() async {
    await loadUserLocation();
    await loadNearby();
  }

  Future<void> loadUserLocation() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final pos = await LocationService.getCurrentPosition();
      state = state.copyWith(userPosition: pos, isLoading: false);
      // Persiste la ubicación en mi perfil para que match-users pueda usarla.
      // Fire-and-forget: no bloquea la UI ni rompe si falla.
      unawaited(
        ref
            .read(profileRepositoryProvider)
            .setMyLocation(pos.latitude, pos.longitude)
            .catchError((_) {}),
      );
    } catch (e) {
      // Sin GPS usamos el centro default (Condesa) pero avisamos del error.
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> loadNearby() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final sessionRepo = ref.read(sessionRepositoryProvider);
      final eventRepo = ref.read(eventRepositoryProvider);
      final sessions = await sessionRepo.getNearbySessions(
        lat: state.lat,
        lng: state.lng,
        radiusKm: state.effectiveRadiusKm,
      );
      final events = await eventRepo.getNearbyEvents(
        lat: state.lat,
        lng: state.lng,
        radiusKm: state.effectiveRadiusKm,
      );
      state = state.copyWith(
        sessions: sessions,
        events: events,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Filtra el feed sin re-consultar al backend.
  void setFilter(String? sport) {
    state = state.copyWith(activeSportFilter: sport);
  }

  void setRadius(double km) {
    state = state.copyWith(searchRadiusKm: km);
  }

  /// Alterna entre "cerca de ti" y "todas" y recarga.
  Future<void> toggleShowAll() async {
    state = state.copyWith(showAll: !state.showAll);
    await loadNearby();
  }
}
