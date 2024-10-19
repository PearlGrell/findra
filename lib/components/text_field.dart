import 'package:findra/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class MaterialTextField extends StatefulWidget {
  final String selectedModel;
  final Function(BuildContext, String) setThemeMode;
  final Function(String) changeModel;
  final Function(String, {String sender, String model}) onSend;
  final Function(Uint8List) onSendImage;
  final VoidCallback onClear;

  const MaterialTextField({
    super.key,
    required this.setThemeMode,
    required this.changeModel,
    required this.onSend,
    required this.onClear,
    required this.onSendImage,
    required this.selectedModel,
  });

  @override
  State<MaterialTextField> createState() => _MaterialTextFieldState();
}

class _MaterialTextFieldState extends State<MaterialTextField> {
  final TextEditingController controller = TextEditingController();
  String message = "";

  @override
  Widget build(BuildContext context) {
    IconData floatingActionButtonIcon =
        message.isEmpty ? Icons.camera : Icons.arrow_upward_rounded;
    return SizedBox(
      height: Constants.height(context) * 0.1,
      child: Row(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(
                  horizontal: Constants.width(context) * 0.024),
              child: TextField(
                controller: controller,
                style: Theme.of(context).textTheme.labelMedium,
                onChanged: (value) {
                  setState(() {
                    message = value;
                  });
                },
                onSubmitted: (value) {
                  _handleSend();
                },
                decoration: InputDecoration(
                  hintText: "Type a message",
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(Constants.width(context) * 0.032),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).scaffoldBackgroundColor,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: Constants.width(context) * 0.06,
                    vertical: Constants.height(context) * 0.02,
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: Constants.width(context) * 0.024),
            child: FloatingActionButton(
              onPressed: message.isEmpty ? _handleImage : _handleSend,
              child: Icon(floatingActionButtonIcon),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleImage() async {
    showDialog(context: context, builder: (context) => _buildImageDialog());
  }

  void _handleSend() {
    if (message.isNotEmpty) {
      if (message.startsWith("/set_theme")) {
        _setThemeCommand();
      } else if (message.startsWith("/set_model")) {
        _setModelCommand();
      } else if (message.startsWith('/clear')) {
        _clearChatCommand();
      } else if (message.startsWith('/help')) {
        _help();
      } else if (message.startsWith('/ask_')) {
        _askModel();
      } else if (message.startsWith('/lorem_ipsum')) {
        widget.onSend(
            "Lorem Ipsum Dolor Si Amet Lorem Ipsum Dolor Si Amet Lorem Ipsum Dolor Si Amet Lorem Ipsum Dolor Si Amet Lorem Ipsum Dolor Si Amet Lorem Ipsum Dolor Si Amet Lorem Ipsum Dolor Si Amet",
            sender: "Assistant",
            model: message.split(" ")[1].trim().toLowerCase()
        );
      } else if (message.startsWith("/")) {
        _showInvalidCommandMessage();
      } else {
        widget.onSend(message, model: widget.selectedModel);
      }
      controller.text="";
      setState(() {
        message = "";
      });
    }
  }

  void _setThemeCommand() {
    List<String> parts = message.split(" ");
    if (parts.length > 1) {
      String theme = parts[1].trim().toLowerCase();
      if (theme == "dark" || theme == "light") {
        widget.setThemeMode(context, theme);
        widget.onSend(
            "Theme mode set to $theme",
            sender: "System");
      } else {
        _showUsageMessage("Usage: /set_theme <dark|light>");
      }
    } else {
      _showUsageMessage("Usage: /set_theme <dark|light>");
    }
  }

  void _setModelCommand() {
    List<String> parts = message.split(" ");
    if (parts.length > 1) {
      String model = parts[1].trim().toLowerCase();
      if (model == "gemini" || model == "llava" || model == "vision") {
        widget.changeModel(model);
        model = model == 'gemini'
            ? "Gemini"
            : model == 'llava'
                ? "Llava-13B"
                : "Object Detection";
        widget.onSend("Default model set to $model", sender: "System");
      } else {
        _showUsageMessage("Usage: /set_model <gemini|llava|vision>");
      }
    } else {
      _showUsageMessage("Usage: /set_model <gemini|llava|vision>");
    }
  }

  void _clearChatCommand() {
    widget.onClear();
    widget.onSend("Chat history cleared", sender: "System");
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Chat cleared")));
  }

  void _askModel() {
    List<String> parts = message.split(" ");
    if (parts.isEmpty) {
      _showUsageMessage("Usage: /ask_<model> <prompt>");
      return;
    }
    String modelPart = parts[0];
    if (!modelPart.startsWith('/ask_')) {
      _showUsageMessage("Usage: /ask_<model> <prompt>");
      return;
    }
    String model = modelPart.substring(5).trim();
    String prompt = message.substring(modelPart.length).trim();
    if (prompt.isNotEmpty) {
      widget.onSend(prompt, sender: "User", model: model);
    } else {
      _showUsageMessage("Usage: /ask_<model> <prompt>");
    }
  }

  void _help() {
    _showUsageMessage(
      "Commands:\n"
      "/set_theme <dark|light>: Change the theme mode.\n"
      "/set_model <gemini|llava|vision>: Set the default model used for prompt response.\n"
      "/clear: Start a new chat and clear history.\n"
      "/help: Show this help message.\n"
      "/ask_<model> <prompt>: Ask a question to a specific model.",
    );
  }

  void _showInvalidCommandMessage() {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Invalid command")));
  }

  void _showUsageMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _buildImageDialog() {
    return AlertDialog(
      title: const Text("Select Image Source"),
      content: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton.filled(
            onPressed: () {
              Navigator.pop(context);
              _handleImageSource(ImageSource.camera);
            },
            iconSize: Constants.width(context) * 0.06,
            padding: EdgeInsets.all(Constants.width(context) * 0.032),
            icon: const Icon(Icons.camera_alt),
          ),
          IconButton.filled(
            onPressed: () {
              Navigator.pop(context);
              _handleImageSource(ImageSource.gallery);
            },
            iconSize: Constants.width(context) * 0.06,
            padding: EdgeInsets.all(Constants.width(context) * 0.032),
            icon: const Icon(Icons.photo_library),
          ),
        ],
      ),
    );
  }

  void _handleImageSource(ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source);
    if (image != null) {
      widget.onSendImage(await image.readAsBytes());
    }
  }
}
