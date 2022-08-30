import 'package:flutter/material.dart';
import 'package:university_management_system/assets/app_assets.dart';

class NoDataFound extends StatelessWidget {
  const NoDataFound({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: [
        Image.asset(AppAssets.noDataIcon,width: 60, height: 60, color: AppAssets.textLightColor,),
        const SizedBox(height: 6,),
        Text("There is no data",  style: AppAssets.latoBold_textLightColor_18,)
      ],),
    );
  }
}
