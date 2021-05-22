import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class Messaging {

  static late CollectionReference devs;

  static initMessagingManager(User user) {
    devs = FirebaseFirestore.instance.collection('devices/').doc('${user.uid}').collection('devices/');
  }

  static Future<void> registerDevice(String token) {
    return devs.add({
      'token': token
    });
  }

  static Future<void> removeDevice(String token) {
    String? id;
    devs.where('token', isEqualTo: token).snapshots().first.then((value) =>
    id = value.docs.first.id
    );
    return devs.doc(id).delete();
  }

  /*
  static Future<void>? subscribeNotifications(User? user)
    => user != null
      ? FirebaseMessaging.instance.subscribeToTopic(user.uid)
      : null;
  */

  /*
  static Future<void>? unsubscribeNotifications(User? user)
    => user != null
      ? FirebaseMessaging.instance.unsubscribeFromTopic(user.uid)
      : null;
  */
}