import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:findra/components/image.dart';
import 'package:findra/components/text_field.dart';
import 'package:findra/providers/gemini_provider.dart';
import 'package:findra/screens/fragments/chat_fragment.dart';
import 'package:findra/screens/fragments/home_fragment.dart';
import 'package:findra/utils/constant.dart';
import '../assets/icons/model_icons.dart';
import '../models/message.dart';

class ChatScreen extends StatefulWidget {
  final Function(BuildContext, String) setThemeMode;
  final Function(String) changeDefaultModel;
  final String selectedModel;

  const ChatScreen({
    super.key,
    required this.setThemeMode,
    required this.changeDefaultModel,
    required this.selectedModel,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String selectedModel = "gemini";
  List<Message> messages = [];
  List<Uint8List> images = [];

  @override
  void initState() {
    super.initState();
    selectedModel = widget.selectedModel;
  }

  @override
  void didUpdateWidget(ChatScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedModel != widget.selectedModel) {
      setState(() {
        selectedModel = widget.selectedModel;
      });
    }
  }

  void sendMessage(String messageContent, {String sender = "User", String model = "none"}) async {
    List<Uint8List> promptImages = List.from(images);
    setState(() {
      messages.add(Message(
        content: messageContent,
        sender: sender,
        model: model,
        images: promptImages,
      ));
    });
    images.clear();
    if (sender == "User") {
      if (selectedModel == "gemini" || model == "gemini") {
        String response = await GeminiProvider.generateText(messages);
        setState(() {
          messages.add(Message(
            content: response,
            sender: "Assistant",
            model: "gemini",
            images: [],
          ));
        });
      } else {
        for (Message pro in messages) {
          log('${pro.content}: ${pro.sender}: ${pro.model}: ${pro.images}');
        }
      }
    }
  }

  void addImage(Uint8List imageBytes) {
    setState(() {
      images.add(imageBytes);
    });
  }

  void clearMessages() {
    setState(() {
      messages.clear();
    });
    log(messages.toString());
  }

  void clearImages(Uint8List imageBytes) { // Accept Uint8List instead of File
    setState(() {
      images.remove(imageBytes);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<ButtonSegment<String>> segmentButtons = [
      segmentButton("gemini", ModelIcons.gemini, "Gemini"),
      segmentButton("llava", ModelIcons.llama, "Llava"),
      segmentButton("vision", ModelIcons.logo, "VisionAI"),
    ];

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: Constants.height(context) * 0.1,
        centerTitle: true,
        title: SegmentedButton<String>(
          segments: segmentButtons,
          onSelectionChanged: (Set<String> newSelection) {
            setState(() {
              selectedModel = newSelection.isNotEmpty ? newSelection.first : "gemini";
            });
            widget.changeDefaultModel(selectedModel);
          },
          selected: {selectedModel},
          showSelectedIcon: false,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: messages.isEmpty
                ? const HomeFragment()
                : ChatFragment(messages: messages),
          ),
          const Divider(),
          Row(
            children: [
              for (Uint8List imageBytes in images)
                ImageField(
                  image: imageBytes, // Update to accept Uint8List
                  onDelete: clearImages,
                ),
            ],
          ),
          SizedBox(
            child: MaterialTextField(
              selectedModel: selectedModel,
              setThemeMode: widget.setThemeMode,
              changeModel: widget.changeDefaultModel,
              onSend: sendMessage,
              onClear: clearMessages,
              onSendImage: addImage,
            ),
          ),
        ],
      ),
    );
  }

  ButtonSegment<String> segmentButton(String value, IconData icon, String label) {
    return ButtonSegment(
      value: value,
      icon: Icon(icon),
      label: Flex(
        direction: Axis.horizontal,
        children: [
          Expanded(
            child: Text(
              label,
              textAlign: TextAlign.center,
              softWrap: false,
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ),
        ],
      ),
    );
  }
}
