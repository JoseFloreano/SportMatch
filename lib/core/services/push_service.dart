import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

/// Handler de mensajes en background. Debe ser top-level y anotada con
/// @pragma('vm:entry-point') para que el isolate de background pueda llamarla.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // No hace falta inicializar Firebase aquí: el isolate ya está aislado y
  // FCM se encarga de mostrar la notificación en la barra. Solo logueamos.
  debugPrint('FCM background: ${message.messageId} ${message.data}');
}

/// Wrapper sobre Firebase + FirebaseMessaging. Maneja init, permisos y token.
class PushService {
  /// Inicializa Firebase Core. Devuelve true si quedó listo, false si no
  /// estaba configurado (ej. falta google-services.json) — la app sigue
  /// funcionando sin push en ese caso.
  static Future<bool> initFirebase() async {
    try {
      await Firebase.initializeApp();
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
      return true;
    } catch (e) {
      debugPrint('Firebase init falló (¿falta google-services.json?): $e');
      return false;
    }
  }

  /// Pide permiso de notificaciones y devuelve el token FCM (o null si fallo).
  static Future<String?> requestPermissionAndGetToken() async {
    try {
      final messaging = FirebaseMessaging.instance;
      final settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        debugPrint('Permiso de notificaciones denegado.');
        return null;
      }
      return await messaging.getToken();
    } catch (e) {
      debugPrint('No se pudo obtener token FCM: $e');
      return null;
    }
  }

  /// Stream de cambios del token (Firebase puede rotarlo). El listener debe
  /// re-subirlo al backend cada vez que cambie.
  static Stream<String> get onTokenRefresh =>
      FirebaseMessaging.instance.onTokenRefresh;

  /// Mensajes recibidos con la app en foreground.
  static Stream<RemoteMessage> get onMessage => FirebaseMessaging.onMessage;

  /// Notificaciones tocadas mientras la app estaba en background.
  static Stream<RemoteMessage> get onMessageOpenedApp =>
      FirebaseMessaging.onMessageOpenedApp;

  /// Notificación que abrió la app (cold start). Null si no aplica.
  static Future<RemoteMessage?> getInitialMessage() =>
      FirebaseMessaging.instance.getInitialMessage();
}
