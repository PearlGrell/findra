import 'package:findra/assets/icons/model_icons.dart';
import 'package:findra/models/message.dart';
import 'package:findra/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:clipboard/clipboard.dart';

class AssistantMessageBubble extends StatefulWidget {
  final Message message;

  const AssistantMessageBubble({super.key, required this.message});

  @override
  AssistantMessageBubbleState createState() => AssistantMessageBubbleState();
}

class AssistantMessageBubbleState extends State<AssistantMessageBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late String displayedText = '';
  late List<String> words;
  int wordIndex = 0;
  bool isAnimating = false;

  @override
  void initState() {
    super.initState();
    words = widget.message.content.split(' ');
    _controller = AnimationController(
      duration: Duration(milliseconds: words.length * 500),
      vsync: this,
    );

    _controller.addListener(() {
      if (wordIndex < words.length) {
        setState(() {
          displayedText += (wordIndex == 0 ? '' : ' ') + words[wordIndex];
          wordIndex++;
        });
      }
    });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reset();
        Future.delayed(const Duration(seconds: 1), () {
          if (!isAnimating) {
            _controller.forward();
          }
        });
      }
    });

    startAnimation();
  }

  void startAnimation() {
    isAnimating = true;
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    IconData model = widget.message.model == 'gemini'
        ? ModelIcons.gemini
        : widget.message.model == 'llava'
            ? ModelIcons.llama
            : ModelIcons.logo;
    DateTime time = widget.message.timestamp;

    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: Constants.height(context) * 0.01,
              horizontal: Constants.width(context) * 0.04,
            ),
            margin: EdgeInsets.symmetric(
              horizontal: Constants.width(context) * 0.024,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.tertiaryContainer,
              borderRadius:
                  BorderRadius.circular(Constants.width(context) * 0.05),
            ),
            child: Text(
              displayedText,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onTertiaryContainer
                        .withOpacity(0.8),
                  ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(
              left: Constants.width(context) * 0.024,
              right: Constants.width(context) * 0.05,
              bottom: Constants.height(context) * 0.014),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    tooltip: widget.message.model[0].toUpperCase() +
                        widget.message.model.substring(1),
                    visualDensity: VisualDensity.compact,
                    icon: Icon(
                      model,
                      size: Constants.width(context) * 0.036,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    visualDensity: VisualDensity.compact,
                    icon: Icon(
                      Icons.volume_up_outlined,
                      size: Constants.width(context) * 0.036,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      FlutterClipboard.copy(widget.message.content);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                            "Copied to clipboard",
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: Constants.width(context) * 0.048,
                            vertical: Constants.height(context) * 0.012,
                          ),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              Constants.width(context) * 0.05,
                            ),
                          ),
                        ),
                      );
                    },
                    visualDensity: VisualDensity.compact,
                    icon: Icon(
                      Icons.copy,
                      size: Constants.width(context) * 0.036,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                ],
              ),
              Text(
                "${time.hour}:${time.minute < 10 ? "0${time.minute}" : "${time.minute}"}",
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
