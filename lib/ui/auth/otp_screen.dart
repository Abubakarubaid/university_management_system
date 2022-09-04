import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:provider/provider.dart';
import '../../../assets/app_assets.dart';
import '../../providers/auth_provider.dart';
import '../../utilities/base/my_message.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/progress_bar.dart';
import 'newpassword.dart';
class OtpScreen extends StatefulWidget {
  String email;
  OtpScreen({required this.email, Key? key}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {

  String otpCode = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Provider.of<AuthProvider>(context, listen: false).progress = false;
  }

  Color accentPurpleColor = Color(0xFF6A53A1);
  Color primaryColor = Color(0xFF121212);
  Color accentPinkColor = Color(0xFFF99BBD);
  Color accentDarkGreenColor = Color(0xFF115C49);
  Color accentYellowColor = Color(0xFFFFB612);
  Color accentOrangeColor = Color(0xFFEA7A3B);

  TextStyle? createStyle(Color color) {
    ThemeData theme = Theme.of(context);
    return theme.textTheme.headline3?.copyWith(color: color);
  }


  @override
  Widget build(BuildContext context) {

    var otpTextStyles = [
      createStyle(AppAssets.primaryColor),
      createStyle(AppAssets.primaryColor),
      createStyle(AppAssets.primaryColor),
      createStyle(AppAssets.primaryColor),
      createStyle(AppAssets.primaryColor),
      createStyle(AppAssets.primaryColor),
    ];

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
                        child: Text("Enter your OTP Code",style: AppAssets.latoBold_textCustomColor_16,)),
                    SizedBox(height: 20,),
                    Container(
                      width: double.infinity,
                      height: 50,
                      margin: EdgeInsets.only(left: 30, right: 30),
                      child: OtpTextField(
                        numberOfFields: 6,
                        styles: otpTextStyles,
                        borderColor: Colors.grey,
                        borderWidth: 2.0,
                        filled: false,
                        keyboardType: TextInputType.number,
                        autoFocus: true,
                        enabledBorderColor: AppAssets.textLightColor,
                        focusedBorderColor: AppAssets.primaryColor,
                        borderRadius: BorderRadius.circular(10),
                        showFieldAsBox: false,
                        onCodeChanged: (String code) {},
                        onSubmit: (String verificationCode){
                          setState(() {
                            otpCode = verificationCode;
                          });
                        }, // end onSubmit
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
                        buttonText: "Verify OTP",
                        buttonTextStyle: AppAssets.latoBold_whiteColor_16,
                        shadowColor: AppAssets.shadowColor,
                        buttonRadius: BorderRadius.circular(30),
                        onPress: () {
                          if(otpCode.isEmpty){
                            MyMessage.showFailedMessage("Please enter your Otp Code", context);
                          }else{
                            print("___________: ${otpCode}");
                            Provider.of<AuthProvider>(context, listen: false).verifyResetPassword(widget.email, otpCode).then((value) async {
                              if(value.isSuccess){
                                MyMessage.showSuccessMessage(value.message, context);
                                await Future.delayed(const Duration(milliseconds: 2000),(){});
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> NewPasswordPage(email: widget.email, otpCode: otpCode, authToken: Provider.of<AuthProvider>(context, listen: false).authNewToken,)));
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
