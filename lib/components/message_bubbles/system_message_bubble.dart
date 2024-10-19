import 'package:findra/models/message.dart';
import 'package:flutter/material.dart';
import 'package:findra/utils/constant.dart';

class SystemMessageBubble extends StatelessWidget {
  final Message message;

  const SystemMessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(
          color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.8),
          thickness: 1.5,
        ),
        Align(
          alignment: Alignment.center,
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: Constants.height(context) * 0.01,
              horizontal: Constants.width(context) * 0.04,
            ),
            margin: EdgeInsets.symmetric(
              vertical: Constants.height(context) * 0.005,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer,
              borderRadius:
              BorderRadius.circular(Constants.width(context) * 0.05),
            ),
            child: Text(
              message.content,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: Theme.of(context).colorScheme.onSecondaryContainer.withOpacity(0.8),
              ),
            ),
          ),
        ),
        Divider(
          color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.8),
          thickness: 1.5,
        ),
      ],
    );
  }
}
