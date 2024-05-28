import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../model/room_model.dart';

class ChatRoom extends StatefulWidget {
  final RoomModel? room;
  const ChatRoom({super.key, this.room});

  @override
  State<ChatRoom> createState() => _RoomState();
}

class _RoomState extends State<ChatRoom> {
  final _channel = WebSocketChannel.connect(Uri.parse('ws://127.0.0.1:3000'));

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.room == null) {
      return const Center(
        child: Icon(
          color: Colors.deepPurple,
          size: 100,
          Icons.auto_awesome_mosaic,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.room!.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            StreamBuilder(
              stream: _channel.stream,
              builder: (context, snapshot) {
                return Text(
                  snapshot.hasData ? snapshot.data : '',
                  style: Theme.of(context).textTheme.headlineMedium,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }
}
