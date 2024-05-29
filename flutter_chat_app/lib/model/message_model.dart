class MessageModel {
  String id;
  String content;
  String senderId;
  DateTime date;

  MessageModel({
    required this.id,
    required this.content,
    required this.senderId,
    required this.date,
  });

  MessageModel.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        content = json['content'] as String,
        senderId = json['senderId'] as String,
        date = json['date'] as DateTime;

  Map<String, dynamic> toJson() => {
        'id': id,
        'content': content,
        'senderId': senderId,
        'date': date,
      };
}
