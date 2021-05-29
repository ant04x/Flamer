// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import 'messaging_impl.dart';

class MessagingWeb implements Messaging {

  @override
  Future<void> start(String uid) async {
    if (Notification.supported) {
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

  @override
  Future<void> stop(String uid) async {
    if (Notification.supported) {
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
}

Messaging getMessaging() => MessagingWeb();