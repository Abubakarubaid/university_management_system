import 'package:flutter/material.dart';

import '../assets/app_assets.dart';

class PrimaryDropDownFiled extends StatelessWidget {
  String hint;
  var items;
  String selectedValue;
  Function(String?) onChange;

  PrimaryDropDownFiled({required this.hint, required this.selectedValue, required this.items, required this.onChange, Key? key}) : super(key: key);

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
      child: DropdownButton(
        value: selectedValue,
        icon: const Icon(Icons.arrow_drop_down),
        underline: Container(
          height: 0,
          color: Colors.transparent,
        ),
        isExpanded: true,
        hint: Text(hint, style: AppAssets.latoRegular_textLightColor_14,),
        onChanged: onChange,
        items: items
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
