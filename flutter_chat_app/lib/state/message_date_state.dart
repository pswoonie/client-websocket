import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../model/message_model.dart';

class MessageDateTimeState with ChangeNotifier {
  // DateTime _prev = DateTime(1, 1, 1);
  // DateTime get prev => _prev;

  // DateTime _recent = DateTime(1, 1, 1);
  // DateTime get recent => _recent;

  List<MessageModel> _messages = [];
  List<MessageModel> get messages => _messages.toList();

  void initDateTime(DateTime param) {
    var newList = [
      MessageModel(
        id: '0',
        content: 'testing',
        senderId: 'senderId',
        date: param.subtract(const Duration(minutes: 10)),
      ),
      MessageModel(
        id: '1',
        content: 'testing long long long long message',
        senderId: 'senderId',
        date: param.subtract(const Duration(minutes: 5)),
      ),
      MessageModel(
        id: '2',
        content: 'testing long long long long message',
        senderId: 'senderId',
        date: param.subtract(const Duration(minutes: 5)),
      ),
      MessageModel(
        id: '3',
        content:
            'testing long long long long long long long long long long long long long message',
        senderId: 'senderId',
        date: param.subtract(const Duration(minutes: 1)),
      ),
      MessageModel(
        id: '4',
        content: 'testing long long lonlong long long long message',
        senderId: 'senderId',
        date: param,
      ),
      MessageModel(
        id: '',
        content: '',
        senderId: '',
        date: DateTime(1, 1, 1, 1, 1, 1),
      ),
    ];
    _messages = [...newList];
    notifyListeners();
  }

  // void setDateTime(DateTime param) {
  //   // _prev = recent;
  //   _recent = param;
  //   notifyListeners();
  // }

  void addNewMessage(MessageModel param) {
    var date = DateTime(
      param.date.year,
      param.date.month,
      param.date.day,
      param.date.hour,
      param.date.minute,
    );
    var model = param;
    model.date = date;
    _messages.insert(_messages.length - 1, model);
    for (MessageModel mes in _messages) {
      debugPrint(mes.date.toString());
    }
    notifyListeners();
  }

  bool isSameDateTime(int now) {
    if (now == _messages.length - 1) {
      return true;
    }

    if (_messages[now].senderId == _messages[now + 1].senderId) {
      return _messages[now].date.compareTo(_messages[now + 1].date) == 0;
    }

    return false;
  }

  String parseDateTime(DateTime param) {
    return timeago.format(param, locale: 'en_short');
  }
}
