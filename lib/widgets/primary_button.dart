import 'package:flutter/material.dart';
import 'package:university_management_system/assets/app_assets.dart';

class PrimaryButton extends StatelessWidget {
  double height;
  double width;
  String buttonText;
  var buttonMargin;
  var buttonPadding;
  TextStyle buttonTextStyle;
  Color shadowColor;
  BorderRadius buttonRadius;
  Function onPress;
  PrimaryButton({required this.width, required this.height, required this.buttonMargin, required this.buttonPadding, required this.buttonText, required this.buttonTextStyle, required this.shadowColor, required this.buttonRadius, required this.onPress, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPress();
      },
      child: Container(
        width: width,
        height: height,
        margin: buttonMargin,
        padding: buttonPadding,
        decoration: BoxDecoration(
          color: AppAssets.primaryColor,
          borderRadius: buttonRadius,
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              spreadRadius: 8,
              blurRadius: 8,
              offset: Offset(3, 3),
            )],
        ),
        child: Center(child: Text(buttonText, style: buttonTextStyle, maxLines: 1, overflow: TextOverflow.ellipsis,)),
      ),
    );
  }
}
