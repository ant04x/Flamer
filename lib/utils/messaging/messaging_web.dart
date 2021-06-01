// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:platform_detect/platform_detect.dart';

import 'messaging_impl.dart';

/// Implementación de la clase [Messaging] para Web.
class MessagingWeb implements Messaging {

  /// Registra el dispositivo actual en el canal de notificaciones del usuario
  /// correspondiente al [uid] en Web.
  @override
  Future<void> start(String uid) async {
    if (html.Notification.supported) {
      print('Navegador SOPORTADO.');
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
    } else {
      print('Navegador NO SOPORTADO.');
    }
  }

  /// Elimina el registro del dispositivo actual de las notificaciones del
  /// usuario correspondiente al [uid] en Web.
  @override
  Future<void> stop(String uid) async {
    if (html.Notification.supported) {
      print('Navegador SOPORTADO.');
      NotificationSettings settings = await FirebaseMessaging.instance.getNotificationSettings();
      if (!kIsWeb || settings.authorizationStatus == AuthorizationStatus.authorized) {
        await FirebaseMessaging.instance.getToken().then((token) async {
          if (token != null) {
            await Messaging.initMessagingManager(uid);
            await Messaging.removeDevice(token);
          }
        });
      }
    } else {
      print('Navegador NO SOPORTADO.');
    }
  }

  /// Muestra un diálogo si la plataforma no está soportada en el [context] y
  /// mediante un [builder].
  @override
  Future<T?>? showDialogIfNotSupported<T>(BuildContext context, WidgetBuilder builder) {
    if (browser.isSafari || browser.isInternetExplorer || browser.isWKWebView)
      return showDialog(
          context: context,
          builder: builder
      );
  }
}

/// Función para la implementación del Factory de [Messaging].
Messaging getMessaging() => MessagingWeb();