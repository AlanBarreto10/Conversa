import 'package:chat/global/environment.dart';
import 'package:chat/services/auth_service.dart';
import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus {
  Online,
  Offline,
  Connecting
}


class SocketService with ChangeNotifier {

  ServerStatus _serverStatus = ServerStatus.Connecting;
  IO.Socket? _socket;

  ServerStatus get serverStatus => _serverStatus;
  
  IO.Socket? get socket => _socket;
  Function? get emit => _socket?.emit;

  void connect() async {
    final token = await AuthService.getToken();
    
    print('Token enviado: $token');

    _socket = IO.io(Environment.socketUrl, {
      'transports': ['websocket'],
      'autoConnect': false,
      'reconnection': true,
      'extraHeaders': {
        'x-token': token 
      }
    });

    _socket?.connect();

    _socket?.on('connect', (_) {
      print('Conectado al servidor'); 
      _serverStatus = ServerStatus.Online;
      notifyListeners();
    });

    _socket?.on('connect_error', (data) {
    print('Error de conexión: $data');
    });

  _socket?.on('connect_timeout', (_) {
    print('Tiempo de espera agotado en la conexión.');
    });

  _socket?.on('disconnect', (reason) {
    print('Desconectado: $reason');
  });

  }

  void disconnect() {
    _socket?.disconnect();
  }

}