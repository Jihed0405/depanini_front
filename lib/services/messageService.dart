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
    required File? file,
  }) async {
    var url = Uri.parse(baseUrl);
    var request = http.MultipartRequest('POST', url);

    request.fields.addAll({
      'messageDTO': jsonEncode({
        'senderId': senderId,
        'receiverId': receiverId,
        'content': content,
        'messageType': messageType,
      }),
    });

    if (file != null) {
      var fileStream = http.ByteStream(file.openRead());
      var fileLength = await file.length();

      var multipartFile = http.MultipartFile(
        'file',
        fileStream,
        fileLength,
        filename: file.path.split('/').last,
      );

      request.files.add(multipartFile);
    }

    var response = await http.Response.fromStream(await request.send());
    if (response.statusCode != 201) {
      throw Exception('Failed to send message');
    }
  }

  Future<List<Message>> getMessages({required int senderId, required int receiverId}) async {
    var url = Uri.parse('$baseUrl?senderId=$senderId&receiverId=$receiverId');
    var response = await http.get(url);
  print("the messages are $response");
    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((e) => Message.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load messages');
    }
  }
}