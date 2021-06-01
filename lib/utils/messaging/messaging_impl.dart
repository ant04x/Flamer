import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'messaging_stub.dart'
  if (dart.library.io) 'messaging_android.dart'
  if (dart.library.html) 'messaging_web.dart';

/// Clase abstracta para administrar notifiaciones del usuario.
abstract class Messaging {

  /// Registro de la función constructora sobre la plataforma.
  factory Messaging() => getMessaging();

  /// Colección de dispositivos del usuario.
  static late CollectionReference devs;

  /// Inicialización de variables de [Messaging].
  static initMessagingManager(String uid) {
    devs = FirebaseFirestore.instance.collection('devices/').doc('$uid').collection('devices/');
  }

  /// Registra un dispositivo del usuario mediante el [token] del dispositivo.
  static Future<DocumentReference<Object?>> registerDevice(String token) async {
    return devs.add({
      'token': token,
      'created': Timestamp.now(),
    });
  }

  /// Elimina un dispositivo del usuario mediante el [token] del dispositivo.
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

  /// Registra el dispositivo actual en el canal de notificaciones del usuario
  /// correspondiente al [uid].
  Future<void> start(String uid) async {}

  /// Elimina el registro del dispositivo actual de las notificaciones del
  /// usuario correspondiente al [uid].
  Future<void> stop(String uid) async {}

  /// Muestra un diálogo si la plataforma no está soportada.
  Future<T?>? showDialogIfNotSupported<T>(BuildContext context, WidgetBuilder builder) {}
}