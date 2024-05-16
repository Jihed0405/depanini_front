import 'package:flutter/material.dart';

class MessageView extends StatefulWidget {
  const MessageView({super.key});

  @override
  State<MessageView> createState() => _MessageViewState();
}

class _MessageViewState extends State<MessageView> {
  @override
  Widget build(BuildContext context) {
 return Scaffold(appBar: AppBar(
           centerTitle: true,
          title: Text('Message ',
             style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ))
        ),body: Center(child: Text('Message  View')),);
  }
}