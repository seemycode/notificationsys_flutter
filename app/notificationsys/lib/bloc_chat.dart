import 'dart:async';

import 'package:notificationsys/remote.dart';
import 'package:notificationsys/src/generated/sm.pbgrpc.dart';
import 'package:notificationsys/utils.dart';

class BlocChat with GRPCIntegration {
  final _sendMessageController = StreamController<StandardResponse>();
  Stream<StandardResponse> get sendRequest => _sendMessageController.stream;

  void sendMessage(String fcmToken, String msg) async {
    try {
      var stub = await getStub();

      // Log a device
      var device1 = Device();
      device1.userId = await Utils.getDeviceId();
      device1.fcmId = fcmToken;
      device1.platform = Utils.getPlatform();

      var logDevice1Response = await stub.logDevice(device1);
      print(logDevice1Response);

      // Send simple message
      var userId = await Utils.getDeviceId();
      var message = Message();
      message.recipients.addAll([userId]);
      message.message = msg;
      var sendMessageResponse = await stub.sendMessage(message);
      print(sendMessageResponse);

      _sendMessageController.add(sendMessageResponse);
    } catch (e) {
      print(e);
    } finally {
      await closeChannel();
    }
  }

  void closeStream() {
    _sendMessageController.close();
  }
}
