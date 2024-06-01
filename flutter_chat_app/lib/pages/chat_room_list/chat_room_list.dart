import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:encrypt/encrypt.dart' as aes;

import '../../Encryption/encryption_key.dart';
import '../../model/room_model.dart';
import '../../state/chat_list_state.dart';

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
                        if (!room.isRead) {
                          room.isRead = true;
                          chatRoomListStateController.updateIsRead(
                            room: room,
                            index: index,
                          );
                        }
                        var str = jsonEncode(room);
                        var key = aes.Key.fromUtf8(EncryptionKey.encryptionKey);
                        // var iv = aes.IV.fromLength(16);
                        var iv = aes.IV(Uint8List(16));
                        var encrypter = aes.Encrypter(aes.AES(key));
                        var encrypted = encrypter.encrypt(str, iv: iv);
                        var param = Uri.encodeComponent(encrypted.base64);
                        context.go('/landing/room?name=$param');
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
