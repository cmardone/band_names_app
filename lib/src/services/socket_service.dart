import 'package:band_names/src/models/band.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService with ChangeNotifier {
  SocketStatus _socketStatus = SocketStatus.Connecting;
  IO.Socket _socket;
  List<Band> _bands = [];

  SocketService() {
    _initConfig();
  }

  _initConfig() {
    // Dart client
    _socket = IO.io('http://localhost:3000', {
      'transports': ['websocket'],
      'autoConnect': true,
    });
    _socket.on('connect', (_) {
      print('connected to server');
      _socketStatus = SocketStatus.Online;
      notifyListeners();
    });
    _socket.on('disconnect', (_) {
      print('disconnected from server');
      _socketStatus = SocketStatus.Offline;
      notifyListeners();
    });
    _socket.on('newMessage', (payload) {
      print('new message from server: $payload');
    });
    _socket.on('activeBands', (payload) {
      print('bands received from server: ${payload.length}');
      _bands = (payload as List).map((item) => (Band.fromMap(item))).toList();
      notifyListeners();
    });
  }

  SocketStatus get socketStatus => _socketStatus;

  List<Band> get bands => _bands;

  void addVote(String id) {
    _socket.emit('addVote', id);
  }

  void deleteBand(String id) {
    _socket.emit('deleteBand', id);
  }

  void addBand(String name) {
    _socket.emit('addBand', name);
  }

/*   sendMessage() {
    print('sending message');
    _socket.emit('sendMessage', 'xxx');
    //{'mensaje': 'Mensaje desde Flutter', 'nombre': 'Cristóbal'});
  } */
}

enum SocketStatus { Online, Offline, Connecting }
