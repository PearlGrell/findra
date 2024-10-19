import 'dart:ui';

import 'package:findra/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/message.dart';

class UserMessageBubble extends StatelessWidget {
  final Message message;

  const UserMessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (message.images.isNotEmpty)
            Container(
              margin: EdgeInsets.only(
                bottom: Constants.height(context) * 0.01,
                right: Constants.width(context) * 0.02,
              ),
              child: Wrap(
                spacing: Constants.width(context) * 0.02,
                runSpacing: Constants.height(context) * 0.01,
                children: message.images
                    .map(
                      (imageBytes) => GestureDetector(
                        onLongPress: () =>
                            _showImageEnlargedDialog(context, imageBytes),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                Constants.width(context) * 0.05),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                                Constants.width(context) * 0.05),
                            child: Image.memory(
                              imageBytes,
                              width: Constants.width(context) * 0.24,
                              height: Constants.height(context) * 0.12,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          Container(
            padding: EdgeInsets.symmetric(
              vertical: Constants.height(context) * 0.01,
              horizontal: Constants.width(context) * 0.04,
            ),
            margin: EdgeInsets.symmetric(
              vertical: Constants.height(context) * 0.01,
              horizontal: Constants.width(context) * 0.024,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius:
                  BorderRadius.circular(Constants.width(context) * 0.05),
            ),
            child: Text(
              message.content,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onPrimaryContainer
                        .withOpacity(0.8),
                  ),
            ),
          ),
        ],
      ),
    );
  }

  _showImageEnlargedDialog(BuildContext context, Uint8List imageBytes) {
    showDialog(
      context: context,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Dialog(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(Constants.width(context) * 0.05),
              child: Image.memory(
                imageBytes,
                fit: BoxFit.contain,
              ),
            ),
          ),
        );
      },
    );
  }
}
