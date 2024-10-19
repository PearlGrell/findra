import 'package:flutter/material.dart';
import 'package:findra/components/message_bubbles/assistant_message_bubble.dart';
import 'package:findra/components/message_bubbles/system_message_bubble.dart';
import 'package:findra/components/message_bubbles/user_message_bubble.dart';
import 'package:findra/models/message.dart';

class ChatFragment extends StatefulWidget {
  final List<Message> messages;

  const ChatFragment({super.key, required this.messages});

  @override
  State<ChatFragment> createState() => _ChatFragmentState();
}

class _ChatFragmentState extends State<ChatFragment> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
      }
    });

    return ListView.builder(
      controller: _scrollController,
      itemCount: widget.messages.length,
      itemBuilder: (context, index) {
        final message = widget.messages[index];
        if (message.sender == "User") {
          return UserMessageBubble(message: message);
        } else if (message.sender == "Assistant") {
          return AssistantMessageBubble(message: message);
        } else {
          return SystemMessageBubble(message: message);
        }
      },
    );
  }
}
