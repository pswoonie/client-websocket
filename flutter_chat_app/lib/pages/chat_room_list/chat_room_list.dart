import 'package:flutter/material.dart';
import 'package:flutter_chat_app/state/chat_list_state.dart';
import 'package:go_router/go_router.dart';

import '../../model/room_model.dart';

class ChatRoomList extends StatelessWidget {
  final ChatRoomListState chatRoomListStateController;
  const ChatRoomList({super.key, required this.chatRoomListStateController});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: chatRoomListStateController,
      builder: (context, child) {
        switch (chatRoomListStateController.roomList.isEmpty) {
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
                  itemCount: chatRoomListStateController.roomList.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    RoomModel room =
                        chatRoomListStateController.roomList[index];
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
                      title: Text(
                        room.title,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        room.id,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Visibility(
                        visible: !room.isRead,
                        child: Container(
                          height: 16,
                          width: 16,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      onTap: () {
                        context.go('/room');
                        if (!room.isRead) {
                          room.isRead = true;
                          chatRoomListStateController.updateIsRead(
                            room: room,
                            index: index,
                          );
                        }
                      },
                    );
                  },
                ),
              ],
            );
        }
      },
    );
  }
}
