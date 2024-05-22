import 'dart:convert';
import 'dart:io';

import 'package:depanini/constants/const.dart';
import 'package:depanini/models/message.dart';
import 'package:http/http.dart' as http;

class MessageService {
  final String baseUrl = '$ipAddress/api/messages';
Future<void> sendMessage({
  required int senderId,
  required int receiverId,
  required String content,
  required String messageType,
  File? file,
}) async {
  var url = Uri.parse(baseUrl);
  var request = http.MultipartRequest('POST', url);

  // Create a map containing the message data
  Map<String, dynamic> messageData = {
    'senderId': senderId,
    'receiverId': receiverId,
    'content': content,
    'messageType': messageType,
  };

  // Convert the map to a JSON string
  String messageDataJson = jsonEncode(messageData);

  // Add the JSON data as a field
  request.fields['messageDTO'] = messageDataJson;
print(request.fields['messageDTO']);
  if (file != null) {
  String filename = file.path.replaceAll('\\', '/').split('/').last;
request.files.add(await http.MultipartFile.fromPath(
  'file',
  file.path,
  filename: filename,
));
  print( "hi thisis ${file.path}");
  print( "hi this is jihed name file ${filename}"); 
  }

  print("Sending message...");

  try {
    var response = await request.send();
    if (response.statusCode == 201) {
      print('Message sent successfully');
    } else {
      print('Failed to send message. Status code: ${response.headers}');
      throw Exception('Failed to send message');
    }
  } catch (e) {
    print('Failed to send message: $e');
    throw Exception('Failed to send message: $e');
  }
}



  Future<List<Message>> getMessages({required int senderId, required int receiverId}) async {
    var url = Uri.parse('$baseUrl?senderId=$senderId&receiverId=$receiverId');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((e) => Message.fromJson(e)).toList();
    } else {
      print('Failed to load messages. Status code: ${response.statusCode}');
      throw Exception('Failed to load messages');
    }
  }
}
