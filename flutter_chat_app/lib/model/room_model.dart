class RoomModel {
  String title;
  String id;
  List members;
  bool isRead;

  RoomModel({
    required this.title,
    required this.id,
    required this.members,
    this.isRead = false,
  });
}
