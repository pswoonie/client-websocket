class MessageModel {
  String id;
  String rid;
  String uid;
  String content;
  DateTime date;

  MessageModel({
    required this.id,
    required this.rid,
    required this.uid,
    required this.content,
    required this.date,
  });

  MessageModel.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        rid = json['rid'] as String,
        uid = json['uid'] as String,
        content = json['content'] as String,
        date = DateTime.parse(json['date']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'rid': rid,
        'uid': uid,
        'content': content,
        'date': date.toIso8601String(),
      };
}
