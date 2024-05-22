import 'package:depanini/models/message.dart';
import 'package:depanini/models/user.dart';
import 'package:depanini/services/messageService.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

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
  List<Message> _messages = [];
  int? _selectedMessageIndex;
  bool _isLoading = true;
 final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _fetchMessages();
    
  }

  Future<void> _fetchMessages() async {
    try {
      List<Message> messages = await _messageService.getMessages(senderId: 10, receiverId: widget.user.id);
      setState(() {
        _messages = messages;
        _isLoading = false;
      });
      
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      
      // Handle error appropriately
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.user.photoUrl),
            ),
            SizedBox(width: 10),
            Text("${widget.user.firstName} ${widget.user.lastName}"),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                  controller: _scrollController,
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      Message message = _messages[index];
                      bool isSentByMe = message.senderId == 10; // Replace with current user's id
                      bool isSelected = _selectedMessageIndex == index;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedMessageIndex = isSelected ? null : index;
                          });
                        },
                        child: Column(
                          crossAxisAlignment: isSentByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                          children: [
                            if (message.messageType == 'MEDIA' && _isImageUrl(message.mediaUrl))
                              _buildMediaContent(message),
                            if (message.messageType != 'MEDIA')
                              Align(
                                alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                  decoration: BoxDecoration(
                                    color: isSentByMe ? Color(0xFF7945ff) : Colors.grey,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    message.content,
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            AnimatedCrossFade(
                              firstChild: SizedBox.shrink(),
                              secondChild: Container(
                                margin: EdgeInsets.only(left: 10, right: 10),
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(
                                  _formatDate(message.date!),
                                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                ),
                              ),
                              crossFadeState: isSelected ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                              duration: Duration(milliseconds: 300),
                            ),
                          ],
                        ),
                      );
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
            icon: Icon(Icons.camera_alt, color: Color(0xFFebab01)),
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
            icon: Icon(Icons.send, color: Color(0xFFebab01)),
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

      _fetchMessages(); // Optionally, you can refresh the chat messages
    } catch (error) {
      // Handle the error
    }
  }

  Widget _buildMediaContent(Message message) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FullImageScreen(imageUrl: message.mediaUrl),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            message.mediaUrl,
            width: 100, // Adjust the size of the thumbnail
            height: 100,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  bool _isImageUrl(String url) {
    String fileExtension = path.extension(url).toLowerCase();
    return ['.jpg', '.jpeg', '.png', '.gif'].contains(fileExtension);
  }

  String _formatDate(DateTime date) {
    return "${_dayOfWeek(date.weekday)} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}";
  }

  String _dayOfWeek(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return "Mon";
      case DateTime.tuesday:
        return "Tue";
      case DateTime.wednesday:
        return "Wed";
      case DateTime.thursday:
        return "Thu";
      case DateTime.friday:
        return "Fri";
      case DateTime.saturday:
        return "Sat";
      case DateTime.sunday:
        return "Sun";
      default:
        return "";
    }
  }
}

class FullImageScreen extends StatelessWidget {
  final String imageUrl;

  FullImageScreen({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Image.network(imageUrl),
      ),
    );
  }
}
