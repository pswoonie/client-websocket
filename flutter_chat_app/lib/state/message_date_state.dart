import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../model/message_model.dart';

class MessageDateTimeState with ChangeNotifier {
  List<MessageModel> _messages = [];
  List<MessageModel> get messages => _messages.toList();

  void initDateTime(DateTime param) {
    var newList = [
      MessageModel(
        id: '0',
        rid: 'rid',
        uid: 'senderId',
        content: 'testing',
        date: param.subtract(const Duration(minutes: 10)),
      ),
      MessageModel(
        id: '1',
        rid: 'rid',
        uid: 'senderId',
        content: 'testing long long long long message',
        date: param.subtract(const Duration(minutes: 5)),
      ),
      MessageModel(
        id: '2',
        rid: 'rid',
        uid: 'senderId',
        content: 'testing long long long long message',
        date: param.subtract(const Duration(minutes: 5)),
      ),
      MessageModel(
        id: '3',
        rid: 'rid',
        uid: 'senderId',
        content:
            'testing long long long long long long long long long long long long long message',
        date: param.subtract(const Duration(minutes: 1)),
      ),
      MessageModel(
        id: '4',
        rid: 'rid',
        uid: 'senderId',
        content: 'testing long long lonlong long long long message',
        date: param,
      ),
      MessageModel(
        id: '',
        rid: '',
        uid: '',
        content: '',
        date: DateTime(1, 1, 1, 1, 1, 1),
      ),
    ];
    _messages = [...newList];
    notifyListeners();
  }

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
    notifyListeners();
  }

  bool isSameDateTime(int now) {
    if (now == _messages.length - 1) {
      return true;
    }

    if (_messages[now].uid == _messages[now + 1].uid) {
      return _messages[now].date.compareTo(_messages[now + 1].date) == 0;
    }

    return false;
  }

  String parseDateTime(DateTime param) {
    return timeago.format(param, locale: 'en_short');
  }
}
