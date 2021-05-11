import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class Messaging {

  static Future<void>? subscribeNotifications(User? user)
    => user != null
      ? FirebaseMessaging.instance.subscribeToTopic(user.uid)
      : null;

  static Future<void>? unsubscribeNotifications(User? user)
    => user != null
      ? FirebaseMessaging.instance.unsubscribeFromTopic(user.uid)
      : null;

}