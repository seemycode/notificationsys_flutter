import 'package:flutter/services.dart';
import 'package:grpc/grpc.dart';
import 'package:notificationsys/src/generated/sm.pbgrpc.dart';
import 'package:notificationsys/utils.dart';

mixin GRPCIntegration {
  late ClientChannel channel;

  Future<SimpleMessageClient> getStub() async {
    final envData = await Utils.readEnvData();
    channel = ClientChannel(envData[Utils.GCP_PROJECT_NAME]);
    final serviceAccountJson =
        await rootBundle.loadString(envData[Utils.GCP_SA_FILE_FOR_CLIENT]);
    final credentials = JwtServiceAccountAuthenticator(serviceAccountJson);
    final stub =
        SimpleMessageClient(channel, options: credentials.toCallOptions);
    return stub;
  }

  closeChannel() async {
    await channel.shutdown();
  }
}
