import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'messaging_impl.dart';

class MessagingAndroid implements Messaging {

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

  @override
  Future<T?>? showDialogIfNotSupported<T>(BuildContext context, WidgetBuilder builder) {}
}

Messaging getMessaging() => MessagingAndroid();