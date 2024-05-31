import 'dart:convert';

import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/state/message_date_state.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../model/message_model.dart';
import '../../model/room_model.dart';
import '../../state/login_state.dart';

class ChatRoom extends StatefulWidget {
  final RoomModel? room;
  final LoginState controller;
  const ChatRoom({super.key, this.room, required this.controller});

  @override
  State<ChatRoom> createState() => _RoomState();
}

class _RoomState extends State<ChatRoom> {
  final _formKey = GlobalKey<FormState>();
  final MessageDateTimeState _messageDateTimeStateController =
      MessageDateTimeState();

  late String uid;

  final _channel = WebSocketChannel.connect(Uri.parse('ws://127.0.0.1:3000'));

  String text = '';

  @override
  void initState() {
    super.initState();
    uid = widget.controller.user.id;
    var now = DateTime.now();
    var curr = DateTime(now.year, now.month, now.day, now.hour, now.minute);
    _messageDateTimeStateController.initDateTime(curr);
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
                  stream: _channel.stream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const SizedBox();
                    }

                    var data = snapshot.data;
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
                        _channel.sink.add(jsonEncode(message));
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
                      _channel.sink.add(jsonEncode(message));
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
    _channel.sink.close();
    super.dispose();
  }
}
