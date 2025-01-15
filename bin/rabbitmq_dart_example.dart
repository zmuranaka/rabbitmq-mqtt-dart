import 'dart:io';

import 'package:mqtt5_client/mqtt5_client.dart';
import 'package:mqtt5_client/mqtt5_server_client.dart';

final client = MqttServerClient('localhost', 'mqtt-client')
  ..port = 1883
  ..onSubscribed = onSubscribed
  ..onDisconnected = onDisconnected
  ..onConnected = onConnected
  ..pongCallback = pong;
bool topicNotified = false;
const pubTopic = 'Dart/RabbitMQ/testtopic';
final builder = MqttPayloadBuilder();

void main(List<String> arguments) async {
  client.logging(on: false);
  final connMess = MqttConnectMessage()
      .withClientIdentifier('MQTT5DartClient')
      .startClean()
      .authenticateAs('admin', 'sneaky');
  client.connectionMessage = connMess;
  try {
    await client.connect();
  } catch (e) {
    stderr.writeln('Exception: $e');
    client.disconnect();
    return;
  }
}

void onSubscribed(MqttSubscription subscription) {
  stdout.writeln(
    'Subscription confirmed for topic ${subscription.topic.rawTopic}',
  );

  if (subscription.topic.rawTopic == pubTopic) {
    builder.addString('Hello from mqtt5_client');
    stdout.writeln('EXAMPLE::Publishing our topic now we are subscribed');
    client.publishMessage(pubTopic, MqttQos.exactlyOnce, builder.payload!);
  }
}

void onDisconnected() {
  stdout.writeln('OnDisconnected client callback - Client disconnection');

  if (client.connectionStatus!.disconnectionOrigin ==
      MqttDisconnectionOrigin.solicited) {
    if (topicNotified) {
      stdout.writeln('onDisconnected callback solicited, topic notified');
    } else {
      stderr.writeln(
        'ERROR! OnDisconnected callback solicited, topic NOT notified',
      );
    }
  }
}

void onConnected() {
  stdout.writeln('OnConnected client callback - Client connection sucessful');
}

void pong() {
  stdout.writeln('Ping response client callback invoked');
}
