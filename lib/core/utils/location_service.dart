import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  static Future<Position> getCurrentPosition() async {
    final enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) {
      throw LocationException('Activa los servicios de ubicación en tu dispositivo.');
    }

    var perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
      if (perm == LocationPermission.denied) {
        throw LocationException('SportMatch necesita tu ubicación para encontrar sesiones cercanas.');
      }
    }
    if (perm == LocationPermission.deniedForever) {
      throw LocationException('Permiso de ubicación bloqueado. Ve a Configuración → SportMatch → Ubicación.');
    }

    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
  }

  static Future<String> getNeighborhood(double lat, double lng) async {
    try {
      await setLocaleIdentifier('es_MX');
      final placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        final parts = [p.subLocality, p.locality]
            .where((s) => s != null && s.isNotEmpty)
            .toList();
        if (parts.isNotEmpty) return parts.join(', ');
      }
    } catch (_) {
      // Geocoding puede fallar sin red; devolvemos un default.
    }
    return 'CDMX';
  }

  /// Geocodificación directa: convierte una colonia/dirección a coordenadas.
  /// Devuelve null si no se pudo ubicar (sin red, dirección ambigua, etc.).
  /// Se le agrega ", CDMX, México" para acotar la búsqueda a la ciudad.
  static Future<({double lat, double lng})?> coordsFromAddress(
    String address,
  ) async {
    final query = address.trim();
    if (query.isEmpty) return null;
    try {
      await setLocaleIdentifier('es_MX');
      final results = await locationFromAddress('$query, CDMX, México');
      if (results.isNotEmpty) {
        return (lat: results.first.latitude, lng: results.first.longitude);
      }
    } catch (_) {
      // Sin red o dirección no encontrada → null (el caller decide fallback).
    }
    return null;
  }

  static Stream<Position> getStream({int distanceFilterMeters = 50}) {
    return Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: distanceFilterMeters,
      ),
    );
  }

  /// Convierte coordenadas a WKT para PostGIS.
  static String toWkt(double lat, double lng) => 'POINT($lng $lat)';
}

class LocationException implements Exception {
  final String message;
  LocationException(this.message);
  @override
  String toString() => message;
}
