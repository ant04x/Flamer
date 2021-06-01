import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'messaging_impl.dart';

/// Implementación de la clase [Messaging] para Android.
class MessagingAndroid implements Messaging {

  /// Registra el dispositivo actual en el canal de notificaciones del usuario
  /// correspondiente al [uid] en Android.
  @override
  Future<void> start(String uid) async {
    NotificationSettings settings = await FirebaseMessaging.instance.getNotificationSettings();
    if (settings.authorizationStatus != AuthorizationStatus.authorized) {
      await FirebaseMessaging.instance.requestPermission();
    } else {
      await FirebaseMessaging.instance.getToken().then((token) {
        if (token != null) {
          Messaging.initMessagingManager(uid);
          Messaging.registerDevice(token);
        }
      });
    }
  }

  /// Elimina el registro del dispositivo actual de las notificaciones del
  /// usuario correspondiente al [uid] en Android.
  @override
  Future<void> stop(String uid) async {
    NotificationSettings settings = await FirebaseMessaging.instance.getNotificationSettings();
    if (!kIsWeb || settings.authorizationStatus == AuthorizationStatus.authorized) {
      await FirebaseMessaging.instance.getToken().then((token) async {
        if (token != null) {
          await Messaging.initMessagingManager(uid);
          await Messaging.removeDevice(token);
        }
      });
    }
  }

  /// Muestra un diálogo si la plataforma no está soportada.
  @override
  Future<T?>? showDialogIfNotSupported<T>(BuildContext context, WidgetBuilder builder) {}
}

/// Función para la implementación del Factory de [Messaging].
Messaging getMessaging() => MessagingAndroid();