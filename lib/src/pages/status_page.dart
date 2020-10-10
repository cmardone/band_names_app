import 'package:band_names/src/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatusPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SocketService>(context);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Text(
              '${provider.socketStatus}',
              textAlign: TextAlign.center,
            ),
            width: double.infinity,
          ),
          FlatButton(
            onPressed: () {},
            // => provider.socketStatus == SocketStatus.Online
            //     ? provider.socket.emit('sendMessage', 'xxxx')
            //     : null,
            child: Text('Enviar'),
          )
        ],
      ),
    );
  }
}
