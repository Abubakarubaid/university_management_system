import 'package:flutter/material.dart';

import '../assets/app_assets.dart';

class PrimaryTextFiled extends StatelessWidget {
  TextEditingController controller;
  String hint;
  var keyboardType;
  Function(String) onChange;

  PrimaryTextFiled({required this.controller, required this.hint, required this.keyboardType, required this.onChange, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppAssets.whiteColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppAssets.textLightColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppAssets.shadowColor.withOpacity(0.5),
            spreadRadius: 4,
            blurRadius: 8,
            offset: const Offset(0, 6),
          )],
      ),
      child: TextFormField(
        cursorColor: AppAssets.textDarkColor,
        controller: controller,
        textAlign: TextAlign.start,
        maxLines: 1,
        style: AppAssets.latoRegular_textDarkColor_16,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppAssets.latoRegular_textLightColor_14,
          border: InputBorder.none,
        ),
        onChanged: onChange,
      ),
    );
  }
}
