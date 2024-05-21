import 'package:depanini/models/message.dart';
import 'package:depanini/models/user.dart';
import 'package:depanini/services/messageService.dart';
import 'package:flutter/material.dart';

import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ChatDetailScreen extends StatefulWidget {
  final User user;

  ChatDetailScreen({required this.user});

  @override
  _ChatDetailScreenState createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final MessageService _messageService = MessageService();
  final ImagePicker _imagePicker = ImagePicker();
  File? _selectedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.user.firstName} ${widget.user.lastName}"),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: _messageService.getMessages(senderId: 10, receiverId: widget.user.id), // Example senderId
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  List<Message> messages = snapshot.data as List<Message>;
                  return ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      Message message = messages[index];
                      bool isSentByMe = message.senderId == 10; // Replace with current user's id

                      return Align(
                        alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          decoration: BoxDecoration(
                            color: isSentByMe ? Colors.blue[300] : Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: isSentByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                            children: [
                              message.messageType == 'MEDIA'
                                  ? Image.file(File(message.content))
                                  : Text(message.content),
                              SizedBox(height: 5),
                              Text(
                                message.date.toString(),
                                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: () async {
              final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
              if (pickedFile != null) {
                setState(() {
                  _selectedImage = File(pickedFile.path);
                });
              }
            },
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }

  void _sendMessage() async {
    if (_messageController.text.isEmpty && _selectedImage == null) {
      return;
    }

    String content = _messageController.text;
    File? file = _selectedImage;

    try {
      await _messageService.sendMessage(
        senderId: 10, // Replace with current user's id
        receiverId: widget.user.id,
        content: content,
        messageType: file != null ? 'MEDIA' : 'TEXT',
        file: file,
      );

      setState(() {
        _messageController.clear();
        _selectedImage = null;
      });

      // Optionally, you can refresh the chat messages
    } catch (error) {
      // Handle the error
    }
  }
}
