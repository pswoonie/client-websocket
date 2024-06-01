class RoomModel {
  String title;
  String id;
  List members;
  bool isRead;

  RoomModel({
    required this.title,
    required this.id,
    required this.members,
    this.isRead = true,
  });

  RoomModel.fromJson(Map<String, dynamic> json)
      : title = json['title'] as String,
        id = json['id'] as String,
        members = json['members'] as List,
        isRead = json['isRead'] as bool;

  Map<String, dynamic> toJson() => {
        'title': title,
        'id': id,
        'members': members,
        'isRead': isRead,
      };
}
