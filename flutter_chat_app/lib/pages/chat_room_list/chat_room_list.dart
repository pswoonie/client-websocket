import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RoomObject {
  String title;
  String id;
  List members;

  RoomObject({
    required this.title,
    required this.id,
    required this.members,
  });
}

class ChatRoomList extends StatefulWidget {
  final List<RoomObject> rooms;
  const ChatRoomList({super.key, required this.rooms});

  @override
  State<ChatRoomList> createState() => _ChatRoomListState();
}

class _ChatRoomListState extends State<ChatRoomList> {
  @override
  Widget build(BuildContext context) {
    switch (widget.rooms.isEmpty) {
      case true:
        return const Center(
          child: Icon(
            color: Colors.deepPurple,
            size: 100,
            Icons.auto_awesome_mosaic,
          ),
        );
      case false:
        return ListView(
          shrinkWrap: true,
          children: [
            ListView.builder(
              itemCount: widget.rooms.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return ListTile(
                  minTileHeight: 60,
                  leading: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.deepPurple[200],
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.person),
                  ),
                  title: const Text(
                    'hi hi hi hi h i hi hi h i hi h i hi hi h ii i h ih ih ih i hi hi ',
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: const Text(
                    'hello hello hello hello hello hello hello hello hleloo hello ehleoo',
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: const Text('hi'),
                  onTap: () {
                    context.go('/room');
                  },
                );
              },
            ),
          ],
        );
    }
  }
}
