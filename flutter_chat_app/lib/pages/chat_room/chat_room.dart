import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';

import '../../model/message_model.dart';
import '../../model/room_model.dart';

class ChatRoom extends StatefulWidget {
  final RoomModel? room;
  const ChatRoom({super.key, this.room});

  @override
  State<ChatRoom> createState() => _RoomState();
}

class _RoomState extends State<ChatRoom> {
  final _formKey = GlobalKey<FormState>();
  List<MessageModel> messages = [
    MessageModel(
      id: '0',
      content: 'testing',
      senderId: 'senderId',
      date: DateTime.now().subtract(const Duration(minutes: 10)),
    ),
    MessageModel(
      id: '1',
      content: 'testing long long long long message',
      senderId: 'senderId',
      date: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    MessageModel(
      id: '2',
      content:
          'testing long long long long long long long long long long long long long message',
      senderId: 'senderId',
      date: DateTime.now().subtract(const Duration(minutes: 1)),
    ),
  ];
  // final _channel = WebSocketChannel.connect(Uri.parse('ws://127.0.0.1:3000'));

  String text = '';

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
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: ListView(
              shrinkWrap: true,
              reverse: true,
              children: [
                // StreamBuilder(
                //   stream: _channel.stream,
                //   builder: (context, snapshot) {
                //     return Text(
                //       snapshot.hasData ? snapshot.data : '',
                //       style: Theme.of(context).textTheme.headlineMedium,
                //     );
                //   },
                // ),

                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var message = messages[index];
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Align(
                          alignment: (message.senderId == 'me')
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: BubbleSpecialThree(
                            text: message.content,
                            color: (message.senderId == 'me')
                                ? Colors.deepPurple.shade50
                                : Colors.deepPurple.shade100,
                            tail: true,
                            isSender: (message.senderId == 'me'),
                          ),
                        ),
                      ],
                    );
                  },
                ),
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
                          id: text,
                          content: str,
                          senderId: 'me',
                          date: DateTime.now(),
                        );
                        setState(() {
                          messages.add(message);
                        });
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
                        content: text,
                        senderId: 'me',
                        date: DateTime.now(),
                      );
                      setState(() {
                        messages.add(message);
                      });
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
    // _channel.sink.close();
    super.dispose();
  }
}
