/// Adapted from https://pub.dev/packages/firebase_messaging/example
///...
import 'dart:async';
import 'package:async/async.dart' show StreamGroup;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class BlocFirebase {
  final _tokenController = StreamController<String>();
  // Stream<String> get token => _tokenController.stream;

  final _responsePayloadController = StreamController<String>();
  // Stream<String> get responsePayload => _responsePayloadController.stream;

  Stream<String> get firebaseEcho => StreamGroup.merge(
      [_tokenController.stream, _responsePayloadController.stream]);

  static initFirebase() async {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(
        BlocFirebase.listenToMessageWhenTerminated);
  }

  /// Use the push to put app in a specific state
  void getInitialMessage() {
    FirebaseMessaging.instance.getInitialMessage().then((value) => null);
  }

  void getToken() {
    FirebaseMessaging.instance.getToken().then((value) {
      _tokenController.add(value!);
      print('FCM token is ${value}');
    });
  }

  /// Receive push notification from top-level when background/terminated
  static Future<void> listenToMessageWhenTerminated(
      RemoteMessage message) async {
    await Firebase.initializeApp();
    print('Handling a background message ${message.messageId}');
  }

  void listenToMessageInForeground() {
    FirebaseMessaging.onMessage.listen((event) {
      _responsePayloadController.add(
          'message received when in foreground! ${event.notification!.body}');
      print('Payload received on onMessage');
    });
  }

  void listenToMessageInBackground() {
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      _responsePayloadController.add(
          'message received when in background! ${event.notification!.body}');
      print('Payload received on onMessageOpenedApp');
    });
  }

  void closeStream() {
    _tokenController.close();
    _responsePayloadController.close();
  }
}
