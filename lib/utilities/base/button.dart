import 'package:flutter/material.dart';
import 'package:university_management_system/assets/app_assets.dart';
class AppButton extends StatefulWidget {
  final String text;
  final Function press;
  AppButton({Key? key,required this.text,required this.press}) : super(key: key);

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 15,right: 15),
      width: MediaQuery.of(context).size.width,
      height: 40,
      child: ElevatedButton(onPressed: widget.press(),style: ElevatedButton.styleFrom(primary: AppAssets.buttonPrimaryColor),child: Text(widget.text),),
    );
  }
}
