import 'package:depanini/models/message.dart';
import 'package:depanini/models/user.dart';
import 'package:depanini/provider/provider.dart';
import 'package:depanini/services/messageService.dart';
import 'package:depanini/services/userService.dart';
import 'package:depanini/widgets/chatDetailScreen.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatView extends ConsumerStatefulWidget {
  const ChatView({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatViewState();
}

class _ChatViewState extends ConsumerState<ChatView> {
  final MessageService messageService = MessageService();
  final UserService userService = UserService();
  late Future<List<Message>> _messagesFuture;
  late int currentUserId;
  bool _isMessagesFutureInitialized = false; 

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    currentUserId = ref.watch(userIdProvider);
    _fetchMessages();
    // Listen for route changes
    ModalRoute.of(context)!.addScopedWillPopCallback(() async {
      // Call _fetchMessages() when the route is popped
      await _fetchMessages();
      return true;
    });
  }

  Future<void> _fetchMessages() async {
    try {
      if (currentUserId != null) {
        _messagesFuture = messageService.getUserMessages(currentUserId);
        await _messagesFuture;
        _isMessagesFutureInitialized = true;
        setState(() {});
      }
    } catch (e) {
      print('Error fetching messages: $e');
      // Handle the error appropriately
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch messages. Please try again later.')),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: FutureBuilder<List<Message>>(
        future: _messagesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting && !_isMessagesFutureInitialized) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            List<Message> messages = snapshot.data!;
            if (messages.isEmpty) {
              return Center(
                child: Text(
                  'No chat messages available',
                  style: TextStyle(fontSize: 18),
                ),
              );
            }
            return FutureBuilder<List<User>>(
              future: _extractUsersFromMessages(messages),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting && !_isMessagesFutureInitialized) {
                  return Center(child: CircularProgressIndicator());
                } else if (userSnapshot.hasError) {
                  return Center(child: Text('Error: ${userSnapshot.error}'));
                } else if (userSnapshot.hasData) {
                  List<User> users = userSnapshot.data!;
                  return Column(
                    children: [
                      _buildHorizontalUserList(users),
                      Expanded(
                        child: _buildChatList(messages, users),
                      ),
                    ],
                  );
                }
                return Container();
              },
            );
          }
          return Container();
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
          if (user.id == currentUserId) {
            return Container(); // Skip the current user
          }
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatDetailScreen(user: user),
                ),
              ).then((_) {
                _fetchMessages();
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 30.0,
                    backgroundImage: CachedNetworkImageProvider(user.photoUrl),
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
    Map<int, List<Message>> messagesByUser = {};
    messages.forEach((message) {
      int userId = message.senderId == currentUserId ? message.receiverId : message.senderId;
      messagesByUser[userId] ??= [];
      messagesByUser[userId]!.add(message);
    });

    List<MapEntry<int, List<Message>>> sortedEntries = messagesByUser.entries.toList()
      ..sort((a, b) {
        DateTime aDate = a.value.map((message) => message.date!).reduce((value, element) => value.isAfter(element) ? value : element);
        DateTime bDate = b.value.map((message) => message.date!).reduce((value, element) => value.isAfter(element) ? value : element);
        return bDate.compareTo(aDate); // Sort in descending order (most recent first)
      });

    return ListView.builder(
      itemCount: sortedEntries.length,
      itemBuilder: (context, index) {
        int userId = sortedEntries[index].key;
        User user = users.firstWhere((u) => u.id == userId);
        List<Message> userMessages = sortedEntries[index].value;

        // Choose the most recent message to display in the chat list
        Message lastMessage = userMessages.reduce((current, next) => current.date!.isAfter(next.date!) ? current : next);
        String senderPrefix = lastMessage.senderId == currentUserId ? "You: " : "${user.firstName}";
        String messageContent;
        if (lastMessage.content == "JAIME_ICON") {
          senderPrefix = lastMessage.senderId == currentUserId ? "You: " : "";
          messageContent = " 👍";
        } else if (lastMessage.messageType == 'MEDIA') {
          senderPrefix = lastMessage.senderId == currentUserId ? "You " : "${user.firstName}";
          messageContent = "sent a photo.";
        } else {
          messageContent = lastMessage.content;
          senderPrefix = lastMessage.senderId == currentUserId ? "You: " : "";
        }

        // Format the date
        String formattedDate = _formatDate(lastMessage.date!);
        String subtitleText = "$senderPrefix $messageContent      $formattedDate";
        bool isLastSentMessageSeen = lastMessage.senderId == currentUserId && lastMessage.seenDate != null;
        bool isNewMessageUnseen = lastMessage.receiverId == currentUserId && lastMessage.seenDate == null;

        return ListTile(
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(user.photoUrl),
          ),
          title: Text("${user.firstName} ${user.lastName}"),
          subtitle: Row(
            children: [
              Expanded(
                child: Text(
                  subtitleText,
                  style: isNewMessageUnseen ? TextStyle(fontWeight: FontWeight.bold) : TextStyle(fontWeight: FontWeight.normal),
                ),
              ),
              if (isLastSentMessageSeen)
                CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(user.photoUrl),
                  radius: 10,
                ),
            ],
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatDetailScreen(user: user),
              ),
            ).then((_) {
              _fetchMessages();
            });
          },
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    DateTime now = DateTime.now();
    String dayOrTime;
    if (date.year == now.year && date.month == now.month && date.day == now.day) {
      dayOrTime = "${date.hour}:${date.minute.toString().padLeft(2, '0')}";
    } else {
      dayOrTime = _dayOfWeek(date.weekday);
    }
    return dayOrTime;
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
