import 'dart:typed_data';
import 'package:findra/models/message.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiProvider {
  static final model = GenerativeModel(
    model: 'gemini-1.5-flash-latest',
    apiKey: "AIzaSyAWORqUZ4H0qyi3kI2EbvwX-fNzTSncCgg",
    systemInstruction: Content.system(
        "Don't include the sender role in output text, it is only for clear input. Don't include **text** as it cannot be understood, answer plain text without bold. Include bullets wherever necessary"),
  );

  static Future<String> generateText(List<Message> messages) async {
    String messagesText = '';
    List<Uint8List> images = [];

    for (Message message in messages) {
      if (message.sender == 'User') {
        messagesText += 'User: ${message.content}\n';
        images.addAll(message.images);
      } else if (message.sender == 'Assistant') {
        messagesText += 'Assistant: ${message.content}\n';
      }
    }

    Content content;
    if (images.isNotEmpty) {
      List<DataPart> imageParts = images.map((imageBytes) {
        return DataPart('image/jpeg', imageBytes);
      }).toList();

      content = Content.multi([
        TextPart(messagesText),
        ...imageParts,
      ]);
    } else {
      content = Content.multi([TextPart(messagesText)]);
    }

    final response = await model.generateContent([content]);
    try {
      return response.text!.trim();
    } catch (e) {
      return 'Sorry, I am unable to generate a response at the moment.';
    }
  }
}
