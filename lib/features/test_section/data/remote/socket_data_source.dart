import 'dart:convert';
import 'package:dapple/core/error/exceptions.dart';
import 'package:encrypt_shared_preferences/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:web_socket_channel/io.dart';

abstract class SocketDataSource {
  Future<void> initSocket();

  Future<void> sendImage(String image, String questionId, String sessionId);

  Future<void> sendAnswer(String answer, String questionId, String sessionId);

  // Future<void> closeConnection();

  Future<void> retryAnswer(String questionId, String sessionId);

  Stream<String> get messages;
}

class SocketDataSourceImpl implements SocketDataSource {
  IOWebSocketChannel? _channel;
  final EncryptedSharedPreferences sharedPreferences;
  final serverUrl = "ws://${dotenv.env['BACKEND_URL']!.substring(7)}/api/ws";

  SocketDataSourceImpl(this.sharedPreferences);

  @override
  Future<void> initSocket() async {
    if (_channel != null) return;

    final token = sharedPreferences.getString('token');

    try {
      debugPrint("Starting WebSocket Connection... at $serverUrl");
      _channel = IOWebSocketChannel.connect(
        Uri.parse(serverUrl),
        headers: {'Authorization': 'Bearer $token'},
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
    debugPrint("Channel is ${_channel.toString()}");
    await _waitForAck();
  }

  @override
  Stream<String> get messages =>
      _channel!.stream.map((event) => event.toString())
        ..listen(
          (message) => debugPrint(
              "===================================\nReceived from server: $message"),
          onError: (error) => debugPrint(
              "=================================\nWebSocket Error: $error"),
          onDone: () {
            debugPrint(
                "===================================================\nWebSocket Closed");
            // _channel = null;
          },
        );

  Future<bool> _waitForAck() async {
    try {
      final message =
          await _channel!.stream.first.timeout(Duration(seconds: 5));
      debugPrint("=============");
      debugPrint(message.toString());
      final decoded = jsonDecode(message);
      if (decoded['status'] == 'success') {
        return true;
      } else {
        throw ServerException(decoded['message'] ?? 'Operation failed');
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<void> _ensureSocketConnected() async {
    if (_channel == null) {
      debugPrint("WebSocket was null, reconnecting...");
      await initSocket(); // reconnect if needed
    }
  }

  @override
  Future<void> sendImage(
      String image, String questionId, String sessionId) async {
    debugPrint(_channel.toString());

    if (_channel == null) await _ensureSocketConnected();
    final data = {
      'event': 'image',
      'imageUrl': image,
      'questionId': questionId,
      'sessionId': sessionId,
    };
    try {
      _channel!.sink.add(jsonEncode(data));
    } catch (e) {
      throw ServerException(e.toString());
    }
    await _waitForAck();
  }

  @override
  Future<void> sendAnswer(
      String answer, String questionId, String sessionId) async {
    if (_channel == null) await _ensureSocketConnected();
    final data = {
      'event': 'text',
      'answer': answer,
      'questionId': questionId,
      'sessionId': sessionId,
    };
    try {
      _channel!.sink.add(jsonEncode(data));
    } catch (e) {
      throw ServerException(e.toString());
    }
    await _waitForAck();
  }

  // @override
  // Future<void> closeConnection() async {
  //   try {
  //     _channel?.sink.close(status.normalClosure);
  //     _channel = null;
  //   } catch (e) {
  //     debugPrint("Error closing WebSocket: $e");
  //   }
  //   await _waitForAck();
  // }

  @override
  Future<void> retryAnswer(String questionId, String sessionId) async {
    if (_channel == null) throw ServerException("WebSocket is not connected!");
    try {
      _channel!.sink.add(jsonEncode({
        'type': 'retry',
        'questionId': questionId,
        'sessionId': sessionId,
      }));
    } catch (e) {
      throw ServerException(e.toString());
    }
    await _waitForAck();
  }
}
