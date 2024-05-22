import 'package:depanini/constants/const.dart';
import 'package:path/path.dart' as path;

class Message {
  final int id;
  final int senderId;
  final int receiverId;
  final String content;
  final String messageType;
  final DateTime? date;
  Message({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.messageType,
    this.date
  });
String get mediaUrl => "$ipAddress/api/messages/files/${senderId}_$receiverId/${path.basename(content)}";


  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      senderId: json['sender']['id'],
      receiverId: json['receiver']['id'],
      content: json['content'],
      date:DateTime.parse(json['timestamp']),
      messageType: json['messageType'],
    );
  }
}