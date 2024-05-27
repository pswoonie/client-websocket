import 'package:flutter/material.dart';

import '../model/room_model.dart';

class ChatRoomListState with ChangeNotifier {
  final List<RoomModel> _roomList = <RoomModel>[];
  List<RoomModel> get roomList => _roomList.toList();

  int _unread = 0;
  int get unread => _unread;

  void setUnreadCounts() {
    var count = 0;

    for (RoomModel room in _roomList) {
      if (!room.isRead) {
        count += 1;
      }
    }

    _unread = count;
    notifyListeners();
  }

  void addRoom(RoomModel room) {
    _roomList.add(room);
    notifyListeners();
  }

  void updateIsRead({required RoomModel room, required int index}) {
    _roomList[index] = room;
    notifyListeners();
  }
}
