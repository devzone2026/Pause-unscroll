
import 'package:flutter/cupertino.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  final String socketBaseUrl;
  late IO.Socket socket;

  SocketService({required this.socketBaseUrl}){
    socketInitialize();
  }

  socketInitialize() {
    socket = IO.io(socketBaseUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
      'reconnection': true, // Auto-reconnect on disconnection
      'reconnectionAttempts': 5, // Try 5 times before giving up
      'reconnectionDelay': 2000, // Wait 2 seconds before retrying
    });
  }


  connect() {
    if (!socket.connected) { socket.connect();}
    socket.onConnect((data) => debugPrint('✅ Connected to the serve :: $data'));
    socket.onDisconnect((data) => debugPrint('❌ Disconnected from the server :: $data'));
    socket.onError((data) => debugPrint('❌ Disconnected from the server :: $data'));
  }


  addEmitter(String event, Map<String, dynamic> mapData) {
    debugPrint('📤 Emit event to $event: $mapData');
    socket.emit(event, mapData);
  }

  addListener(String event, Function(dynamic) callback) {
    debugPrint('add listener receive :: $event');
    socket.on(event, callback);
  }

  removeListener(String event) {
    socket.off(event);
    debugPrint('socket off :: $event');
  }

  disconnect() {
    socket.disconnect();
    reConnectSocket();
    debugPrint('🛑 Socket disconnected');
  }

  reConnectSocket() {
    if(!socket.connected){
      socket.connect();
    }
  }
}