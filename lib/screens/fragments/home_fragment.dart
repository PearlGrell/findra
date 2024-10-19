import 'package:findra/assets/icons/model_icons.dart';
import 'package:findra/utils/constant.dart';
import 'package:flutter/material.dart';

class HomeFragment extends StatelessWidget {
  const HomeFragment({super.key});

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.labelMedium!;
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: Constants.height(context) * 0.16),
          Center(
            child: Icon(
              ModelIcons.logo,
              color: Theme.of(context).colorScheme.onSurface,
              size: Constants.width(context) * 0.15,
            ),
          ),
          SizedBox(height: Constants.height(context) * 0.05),
          Container(
            margin: EdgeInsets.symmetric(horizontal: Constants.width(context) * 0.1),
            child: RichText(
              text: TextSpan(
                text: '/set_theme <light/dark>: ',
                style: textStyle.copyWith(fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                    text: 'Change the theme from dark mode to light mode or light mode to dark mode\n\n',
                    style: textStyle,
                  ),
                  TextSpan(
                    text: '/set_model <gemini/llava/vision>: ',
                    style: textStyle.copyWith(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: 'Set the default model used for prompt response\n\n',
                    style: textStyle,
                  ),
                  TextSpan(
                    text: '/ask_<model> <prompt>: ',
                    style: textStyle.copyWith(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: 'Send that particular prompt to the model\n\n',
                    style: textStyle,
                  ),
                  TextSpan(
                    text: '/clear: ',
                    style: textStyle.copyWith(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: 'Start a new chat and clear history\n\n',
                    style: textStyle,
                  ),
                  TextSpan(
                    text: '/help: ',
                    style: textStyle.copyWith(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: 'Open Help page',
                    style: textStyle,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
