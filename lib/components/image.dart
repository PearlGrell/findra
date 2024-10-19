
import 'package:findra/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ImageField extends StatelessWidget {
  final Uint8List? image;
  final Function(Uint8List)? onDelete;

  const ImageField({super.key, this.image, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Constants.width(context) * 0.02),
      height: Constants.height(context) * 0.126,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Constants.width(context) * 0.05),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(Constants.width(context) * 0.05),
            child: Image.memory(
              image!,
              fit: BoxFit.cover,
              height: Constants.height(context) * 0.126,
              width: Constants.height(context) * 0.126,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.error, size: Constants.width(context) * 0.1, color: Theme.of(context).colorScheme.onError);
              },
            ),
          ),
          Positioned(
            top: -Constants.width(context) * 0.03,
            right: -Constants.width(context) * 0.03,
            child: IconButton.filledTonal(
              iconSize: Constants.width(context) * 0.042,
              visualDensity: VisualDensity.compact,
              onPressed: () => onDelete?.call(image!),  // Fix: Correctly call onDelete when pressed
              icon: const Icon(
                Icons.delete,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
