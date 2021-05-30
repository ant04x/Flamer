import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'messaging_stub.dart'
if (dart.library.io) 'messaging.dart'
if (dart.library.html) 'messaging_web.dart';

abstract class Messaging {

  factory Messaging() => getMessaging();

  static late CollectionReference devs;

  static initMessagingManager(String uid) {
    devs = FirebaseFirestore.instance.collection('devices/').doc('$uid').collection('devices/');
  }

  static Future<DocumentReference<Object?>> registerDevice(String token) async {
    return devs.add({
      'token': token,
      'created': Timestamp.now(),
    });
  }

  static Future<void> removeDevice(String token) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    print('==>> BORRANDO TOKEN <<== $token');
    return devs.where('token', isEqualTo: token).get().then((querySnap) {
      querySnap.docs.forEach((document) {
        batch.delete(document.reference);
      });
      return batch.commit();
    });
  }

  Future<void> start(String uid) async {}

  Future<void> stop(String uid) async {}

  Future<T?>? showDialogIfNotSupported<T>(BuildContext context, WidgetBuilder builder) {}
}