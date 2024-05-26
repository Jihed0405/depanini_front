import 'package:depanini/models/message.dart';
import 'package:depanini/models/user.dart';
import 'package:depanini/provider/provider.dart';
import 'package:depanini/services/messageService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:depanini/constants/color.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

class ChatDetailScreen extends ConsumerStatefulWidget {
  final User user;

  ChatDetailScreen({required this.user});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ChatDetailScreenState();
}

class _ChatDetailScreenState extends ConsumerState<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final MessageService _messageService = MessageService();
  final ImagePicker _imagePicker = ImagePicker();
  File? _selectedImage;
  List<Message> _messages = [];
  int? _selectedMessageIndex;
  bool _isLoading = true;
  late int currentUserId;

  @override
  void initState() {
    super.initState();
    _fetchMessagesWithDelay();
    _messageController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
  }

  void _updateButtonState() {
    setState(() {});
  }


Future<File> _compressImage(File imageFile) async {
  final tempDir = await getTemporaryDirectory();
  final uniqueFileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
final targetPath = path.join(tempDir.path, uniqueFileName);

  
  File image = File(imageFile.path);

 
  var result = await FlutterImageCompress.compressAndGetFile(
    image.absolute.path,
    targetPath,
    quality: 50,
  );

  File compressedFile = File(result!.path);

  return compressedFile;
 
}


  Future<void> _fetchMessages() async {
    try {
      List<Message> messages = await _messageService.getMessages(
          senderId: currentUserId, receiverId: widget.user.id);
      setState(() {
        _messages = messages..sort((a, b) => b.date!.compareTo(a.date!));
        _isLoading = false;
      });

       await _messageService.updateSeenDate(
      messageIds: _messages
          .where((message) => message.senderId == widget.user.id)
          .map((message) => message.id!)
          .toList(),
      userId: currentUserId,
    );
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _fetchMessagesWithDelay() {
    Future.delayed(Duration(milliseconds: 100), () {
      _fetchMessages();
    });
  }

  @override
  Widget build(BuildContext context) {
    currentUserId = ref.watch(userIdProvider);

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
                    reverse: true,
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      Message message = _messages[index];
                      bool isSentByMe = message.senderId == currentUserId;
                      bool isSelected = _selectedMessageIndex == index;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedMessageIndex = isSelected ? null : index;
                          });
                        },
                        child:
                            _buildMessageItem(message, isSentByMe, isSelected,index),
                      );
                    },
                  ),
          ),
          _buildOverlay(),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildOverlay() {
    return _selectedImage != null
        ? Container(
            height: 200,
            child: Stack(
              children: [
                Container(
                  width: 200,
                  height: 150,
                  child: Image.file(_selectedImage!), // Display selected image
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: Icon(Icons.cancel, color: Colors.red[600]),
                          onPressed: () {
                            setState(() {
                              _selectedImage = null;
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.send, color: selectedPageColor),
                          onPressed: () {
                            _sendMessage();
                            setState(() {
                              _selectedImage = null;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        : SizedBox.shrink();
  }

  Widget _buildMessageInput() {
    bool isMessageEmpty = _messageController.text.isEmpty;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.camera_alt, color: Color(0xFFebab01)),
            onPressed: () async {
              final pickedFile =
                  await _imagePicker.pickImage(source: ImageSource.gallery);
              if (pickedFile != null) {
                File selectedFile = File(pickedFile.path);
      File compressedFile = await _compressImage(selectedFile);
                setState(() {
                  _selectedImage = compressedFile;
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
            icon: Icon(
              isMessageEmpty ? Icons.thumb_up : Icons.send,
              color: selectedPageColor,
            ),
            onPressed: isMessageEmpty ? _likeMessage : _sendMessage,
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
        senderId: currentUserId,
        receiverId: widget.user.id,
        content: content,
        messageType: file != null ? 'MEDIA' : 'TEXT',
        file: file,
      );

      setState(() {
        _messageController.clear();
        _selectedImage = null;
      });

      _fetchMessages();
    } catch (error) {
      // Handle error
    }
  }

  void _likeMessage() async {
    try {
      await _messageService.sendMessage(
        senderId: currentUserId,
        receiverId: widget.user.id,
        content: "JAIME_ICON",
        messageType: 'TEXT',
      );
      _fetchMessages();
    } catch (error) {
      // Handle error
    }
  }
int _lastSeenIndexByOtherUser() {
  for (int i = 0; i<=_messages.length - 1 ; i++) {
    Message currentMessage = _messages[i];
    if (currentMessage.senderId == currentUserId && currentMessage.seenDate != null) {
      return i;
    }
  }
  return -1; // Indicates no message sent by the current user has been seen by the other user
}
  Widget _buildMessageItem(Message message, bool isSentByMe, bool isSelected,int index) {
  if (message.content == "JAIME_ICON") {
    return _buildLikeIcon(isSentByMe);
  } else if (message.messageType == 'MEDIA' && _isImageUrl(message.mediaUrl)) {
    return _buildMediaContent(message);
  } else {
    Widget messageWidget = _buildTextMessage(message, isSentByMe, isSelected);

    
 
  int lastSeenIndexByOtherUser = _lastSeenIndexByOtherUser();
  // Check if the last seen message is from the other user
  if (isSentByMe  && lastSeenIndexByOtherUser == index && message.seenDate != null) {
      messageWidget = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          messageWidget,
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(widget.user.photoUrl),
                radius: 10,
              ),
            ],
          ),
        ],
      );
    }

    return messageWidget;
  }
}

  Widget _buildLikeIcon(bool isSentByMe) {
    return Align(
      alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Icon(
          Icons.thumb_up,
          color: selectedPageColor, // Yellow color
        ),
      ),
    );
  }

  Widget _buildTextMessage(Message message, bool isSentByMe, bool isSelected) {
    return Column(
      crossAxisAlignment:
          isSentByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
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
          crossFadeState:
              isSelected ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: Duration(milliseconds: 300),
        ),
      ],
    );
  }

  Widget _buildMediaContent(Message message) {
    bool isSelected = _selectedMessageIndex == message.id;
    bool isSentByMe = message.senderId == currentUserId;

    return Column(
        crossAxisAlignment:
            isSentByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Align(
            alignment:
                isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        FullImageScreen(imageUrl: message.mediaUrl),
                  ),
                );
              },
              onDoubleTap: () {
                setState(() {
                  _selectedMessageIndex = isSelected ? null : message.id;
                });
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          message.mediaUrl,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
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
                    crossFadeState: isSelected
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: Duration(milliseconds: 300),
                  ),
                ],
              ),
            ),
          ),
        ]);
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
