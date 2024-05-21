
import 'package:depanini/models/message.dart';
import 'package:depanini/models/user.dart';
import 'package:depanini/services/messageService.dart';
import 'package:depanini/services/userService.dart';
import 'package:depanini/widgets/chatDetailScreen.dart';
import 'package:flutter/material.dart';


class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final MessageService messageService = MessageService();
  final UserService userService = UserService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('chat'),
      ),
      body: FutureBuilder(
        future: messageService.getMessages(senderId: 10, receiverId: 5), // Example senderId and receiverId
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Message> messages = snapshot.data as List<Message>;
            return FutureBuilder(
              future: _extractUsersFromMessages(messages),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (userSnapshot.hasError) {
                  return Center(child: Text('Error: ${userSnapshot.error}'));
                } else {
                  List<User> users = userSnapshot.data as List<User>;
                  return Column(
                    children: [
                      _buildHorizontalUserList(users),
                      Expanded(
                        child: _buildChatList(messages, users),
                      ),
                    ],
                  );
                }
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildHorizontalUserList(List<User> users) {
    return Container(
      height: 100.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: users.length,
        itemBuilder: (context, index) {
          User user = users[index];
          return GestureDetector(
            onTap: () {
              // Navigate to ChatDetailScreen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatDetailScreen(user: user),
                ),
              );
            },
            child: Padding(
             padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 30.0,
                    backgroundImage: NetworkImage(user.photoUrl),
                  ),
                  SizedBox(height: 5.0),
                  Text("${user.firstName}"),
                  
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildChatList(List<Message> messages, List<User> users) {
    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index) {
        Message message = messages[index];
        User user = users.firstWhere((u) => u.id == message.senderId || u.id == message.receiverId);

        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(user.photoUrl),
          ),
          title: Text("${user.firstName} ${user.lastName}"),
          subtitle: Text(message.content),
          onTap: () {
            // Navigate to ChatDetailScreen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatDetailScreen(user: user),
              ),
            );
          },
        );
      },
    );
  }

  Future<List<User>> _extractUsersFromMessages(List<Message> messages) async {
    List<User> users = [];
    Set<int> userIds = Set();

    for (Message message in messages) {
      if (!userIds.contains(message.senderId)) {
        User user = await userService.getUserById(message.senderId);
        users.add(user);
        userIds.add(message.senderId);
      }

      if (!userIds.contains(message.receiverId)) {
        User user = await userService.getUserById(message.receiverId);
        users.add(user);
        userIds.add(message.receiverId);
      }
    }

    return users;
  }
}
