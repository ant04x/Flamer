import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class Messaging {

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
}