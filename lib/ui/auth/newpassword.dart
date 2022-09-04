import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:university_management_system/ui/auth/login_page.dart';
import 'package:university_management_system/utilities/base/my_message.dart';

import '../../../assets/app_assets.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/primary_text_field.dart';
import '../../widgets/progress_bar.dart';
import '../auth/otp_screen.dart';
class NewPasswordPage extends StatefulWidget {
  String email;
  String otpCode;
  String authToken;
  NewPasswordPage({required this.email, required this.otpCode, required this.authToken, Key? key}) : super(key: key);

  @override
  State<NewPasswordPage> createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {

  TextEditingController passwordController=TextEditingController();
  TextEditingController confirmPasswordController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: AppAssets.backgroundColor,
          child: Stack(
            children: [
              Image.asset(AppAssets.appDoodle, width: double.infinity, height: double.infinity, fit: BoxFit.cover, color: AppAssets.textLightColor.withOpacity(0.15),),
              SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 80,),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(AppAssets.resetPasswordIcon,width: 150,height: 150,),
                        ],
                      ),
                    ),
                    SizedBox(height: 50,),
                    Align(
                        alignment: Alignment.center,
                        child: Text("Enter your New Password",style: AppAssets.latoBold_textCustomColor_16,)),
                    SizedBox(height: 20,),
                    Container(
                      margin: EdgeInsets.only(left: 20,right: 20),
                      child: PrimaryTextFiled(
                        controller: passwordController,
                        keyboardType: TextInputType.text,
                        hint: "Password",
                        onChange: (text) {},
                      ),
                    ),
                    SizedBox(height: 20,),
                    Align(
                        alignment: Alignment.center,
                        child: Text("Confirm Password",style: AppAssets.latoBold_textCustomColor_16,)),
                    SizedBox(height: 20,),
                    Container(
                      margin: EdgeInsets.only(left: 20,right: 20),
                      child: PrimaryTextFiled(
                        controller: confirmPasswordController,
                        keyboardType: TextInputType.text,
                        hint: "Confirm Password",
                        onChange: (text) {},
                      ),
                    ),
                    SizedBox(height: 50,),
                    Visibility(visible: Provider.of<AuthProvider>(context, listen: true).progress, child: const SizedBox(height:80, child: ProgressBarWidget())),
                    Visibility(
                      visible: !Provider.of<AuthProvider>(context, listen: true).progress,
                      child: PrimaryButton(
                        width: double.infinity,
                        height: 60,
                        buttonMargin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                        buttonPadding: const EdgeInsets.all(12),
                        buttonText: "Update Password",
                        buttonTextStyle: AppAssets.latoBold_whiteColor_16,
                        shadowColor: AppAssets.shadowColor,
                        buttonRadius: BorderRadius.circular(30),
                        onPress: () {
                          if(passwordController.text.isEmpty){
                            MyMessage.showFailedMessage("Please enter your Password", context);
                          } else if(passwordController.text.length < 6){
                            MyMessage.showFailedMessage("Please enter at least 6 characters", context);
                          } else if(confirmPasswordController.text.isEmpty){
                            MyMessage.showFailedMessage("Please enter your Confirm Password", context);
                          } else if(passwordController.text != confirmPasswordController.text){
                            MyMessage.showFailedMessage("Password Not Matched", context);
                          } else{
                            Provider.of<AuthProvider>(context, listen: false).requestNewPassword(passwordController.text, widget.authToken).then((value) async {
                              if(value.isSuccess){
                                MyMessage.showSuccessMessage(value.message, context);
                                await Future.delayed(const Duration(milliseconds: 2000),(){});
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> LoginPage()));
                              }else{
                                MyMessage.showFailedMessage(value.message, context);
                              }
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(onTap: () {Navigator.of(context).pop();}, child: Container(padding: const EdgeInsets.all(16), height: 50, width: 50, child: SvgPicture.asset(AppAssets.backArrowIcon, color: AppAssets.iconsTintDarkGreyColor,))),
            ],
          ),
        ),
      ),
    );
  }
}
