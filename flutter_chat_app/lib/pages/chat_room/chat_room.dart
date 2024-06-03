import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/state/message_date_state.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import '../../model/message_model.dart';
import '../../model/room_model.dart';
import '../../state/login_state.dart';

class StreamSocket {
  final _socketResponse = StreamController<String>();

  void Function(String) get addResponse => _socketResponse.sink.add;

  Stream<String> get getResponse => _socketResponse.stream;

  void dispose() {
    _socketResponse.close();
  }
}

class ChatRoom extends StatefulWidget {
  final RoomModel? room;
  final LoginState controller;
  const ChatRoom({super.key, this.room, required this.controller});

  @override
  State<ChatRoom> createState() => _RoomState();
}

class _RoomState extends State<ChatRoom> {
  final _formKey = GlobalKey<FormState>();

  StreamSocket streamSocket = StreamSocket();

  final MessageDateTimeState _messageDateTimeStateController =
      MessageDateTimeState();

  late String uid;

  late io.Socket socket;

  String text = '';

  @override
  void initState() {
    super.initState();
    uid = widget.controller.user.id;
    if (Platform.isAndroid) {
      socket = io.io(
        'http://10.0.2.2:3000',
        io.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .build(),
      );
    } else if (Platform.isIOS) {
      socket = io.io(
        'http://127.0.0.1:3000',
        io.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .build(),
      );
    }

    socket.connect();

    socket.onConnect((_) {
      // Sending initial message to save roomId and userId
      var message = MessageModel(
        id: DateTime.now().toIso8601String(),
        rid: widget.room!.id,
        uid: uid,
        content: 'Connected',
        date: DateTime.now(),
      );

      socket.emit('JOIN_ROOM', message.toJson());
    });

    socket.on('CONNECTED', (data) {
      messageToString(data);
    });

    socket.on('FROM_SERVER', (data) {
      messageToString(data);
    });

    socket.onDisconnect((_) => debugPrint('disconnect'));

    var now = DateTime.now();
    var curr = DateTime(now.year, now.month, now.day, now.hour, now.minute);
    _messageDateTimeStateController.initDateTime(curr);
  }

  void messageToString(Map<String, dynamic> data) {
    var message = MessageModel.fromJson(data);
    var jsonMsg = jsonEncode(message);
    streamSocket.addResponse(jsonMsg);
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
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.person_add_alt_rounded),
          ),
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: ListView(
              shrinkWrap: true,
              reverse: true,
              children: [
                StreamBuilder(
                  stream: streamSocket.getResponse,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const SizedBox();
                    }

                    var data = snapshot.data as String;
                    var messageMap = jsonDecode(data) as Map<String, dynamic>;
                    var message = MessageModel.fromJson(messageMap);

                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) {
                        _messageDateTimeStateController.addNewMessage(message);
                      }
                    });

                    return const SizedBox();
                  },
                ),
                ListenableBuilder(
                    listenable: _messageDateTimeStateController,
                    builder: (context, child) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount:
                            _messageDateTimeStateController.messages.length,
                        itemBuilder: (context, index) {
                          var message =
                              _messageDateTimeStateController.messages[index];
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Visibility(
                                visible: !(index ==
                                    _messageDateTimeStateController
                                            .messages.length -
                                        1),
                                child: Align(
                                  alignment: (message.uid == uid)
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                                  child: BubbleSpecialThree(
                                    text: message.content,
                                    color: (message.uid == uid)
                                        ? Colors.deepPurple.shade50
                                        : Colors.deepPurple.shade100,
                                    tail: true,
                                    isSender: (message.uid == uid),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: !_messageDateTimeStateController
                                    .isSameDateTime(index),
                                child: Align(
                                  alignment: (message.uid == uid)
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                                  child: Padding(
                                    padding: (message.uid == uid)
                                        ? const EdgeInsets.fromLTRB(
                                            0, 0, 25, 25)
                                        : const EdgeInsets.fromLTRB(
                                            25, 0, 0, 25),
                                    child: Text(
                                      _messageDateTimeStateController
                                          .parseDateTime(message.date),
                                      style: TextStyle(
                                          color: Colors.deepPurple[100],
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    }),
              ],
            ),
          ),
          Container(
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.deepPurple[200],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.add,
                    size: 40,
                    color: Colors.deepPurple[50],
                  ),
                ),
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      onSaved: (str) {
                        if (str != null) {
                          text = str;
                        }
                      },
                      validator: (str) {
                        return null;
                      },
                      onFieldSubmitted: (str) {
                        if (str.isEmpty) return;
                        var message = MessageModel(
                          id: str,
                          rid: widget.room!.id,
                          uid: uid,
                          content: str,
                          date: DateTime.now(),
                        );
                        // TODO: modify here
                        socket.emit('FROM_CLIENT', message.toJson());
                        _messageDateTimeStateController.addNewMessage(message);
                        _formKey.currentState?.reset();
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        filled: true,
                        fillColor: Colors.deepPurple[50],
                        hintText: 'Aa',
                        suffixIcon: Icon(
                          Icons.emoji_emotions_outlined,
                          size: 35,
                          color: Colors.deepPurple[400],
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() != null &&
                        _formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      var message = MessageModel(
                        id: text,
                        rid: widget.room!.id,
                        uid: uid,
                        content: text,
                        date: DateTime.now(),
                      );
                      // TODO: modify here
                      socket.emit('FROM_CLIENT', message.toJson());
                      _messageDateTimeStateController.addNewMessage(message);
                      _formKey.currentState?.reset();
                    }
                  },
                  icon: Icon(
                    Icons.arrow_circle_up,
                    size: 40,
                    color: Colors.deepPurple[50],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    socket.disconnect();
    socket.dispose();
    super.dispose();
  }
}
