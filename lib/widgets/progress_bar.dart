import 'package:flutter/material.dart';
import '../assets/app_assets.dart';
import 'package:lottie/lottie.dart';

class ProgressBarWidget extends StatelessWidget {
  const ProgressBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: [
        Lottie.asset(AppAssets.progressDots, height: 80),
        //Text("Please wait",  style: AppAssets.latoBold_textLightColor_18,)
      ],),
    );
  }
}
