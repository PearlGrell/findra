
import 'package:flutter/services.dart';

class Message {
  final String content;
  final String sender;
  final DateTime timestamp;
  final String model;
  final List<Uint8List> images;

  Message({
    required this.content,
    required this.sender,
    DateTime? timestamp,
    String? model,
    List<Uint8List>? images,
  }) : timestamp = timestamp ?? DateTime.now(),model=model??"None",images=images??[];
}
