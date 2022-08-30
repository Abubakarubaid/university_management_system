import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:university_management_system/assets/app_assets.dart';
import 'package:university_management_system/providers/auth_provider.dart';
import 'package:university_management_system/utilities/base/my_message.dart';
import 'package:university_management_system/widgets/progress_bar.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/primary_text_field.dart';
import '../admin/admin_dashboard.dart';
import '../auth/sign_up.dart';import 'forgotpassword.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController=TextEditingController();
  TextEditingController passwordController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            Image.asset(AppAssets.appDoodle, width: double.infinity, height: double.infinity, fit: BoxFit.cover, color: AppAssets.textLightColor.withOpacity(0.15),),
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 250, child: Center(child: Image.asset(AppAssets.loginIllustration,))),
                    Expanded(
                      child: Consumer<AuthProvider>(builder: (context, authProvider, child) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20,),
                          Container(
                            margin: const EdgeInsets.only(left: 22),
                            child: Align(
                                alignment: Alignment.topLeft,
                                child: Text("Sign in",style: AppAssets.latoBold_primaryColor_30,)),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 22, top: 30),
                            child: Align(
                                alignment: Alignment.topLeft,
                                child: Text("Email Address",style: AppAssets.latoBold_textCustomColor_16,)),
                          ),
                          const SizedBox(height: 10,),
                          Container(
                            margin: const EdgeInsets.only(left: 20,right: 20),
                            child: PrimaryTextFiled(controller: emailController,onChange: (value){},hint: "Enter Email or Phone No",keyboardType: TextInputType.emailAddress,

                            ),
                          ),
                          const SizedBox(height: 20,),
                          Container(
                            margin: const EdgeInsets.only(left: 22),
                            child: Align(
                                alignment: Alignment.topLeft,
                                child: Text("Password",style: AppAssets.latoBold_textCustomColor_16,)),
                          ),
                          const SizedBox(height: 10,),
                          Container(
                            margin: const EdgeInsets.only(left: 20,right: 20),
                            child: PrimaryTextFiled(controller: passwordController,onChange: (value){},hint: "Enter Password",keyboardType: TextInputType.emailAddress,

                            ),
                          ),
                          Container(
                            alignment: Alignment.bottomRight,
                            margin: const EdgeInsets.only(top: 20,right: 20),
                            //child: Text('Don\'t have an account? Create'),
                            child: Text.rich(
                                TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Forgot Password?',
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = (){
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPasswordPage()));
                                          },
                                        style: AppAssets.latoBold_primaryColor_16,
                                      ),
                                    ]
                                )
                            ),
                          ),
                          const SizedBox(height: 10,),
                          Visibility(
                            visible: !authProvider.progress,
                            child: PrimaryButton(
                              width: double.infinity,
                              height: 60,
                              buttonMargin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                              buttonPadding: const EdgeInsets.all(12),
                              buttonText: "Login",
                              buttonTextStyle: AppAssets.latoBold_whiteColor_18,
                              shadowColor: AppAssets.shadowColor,
                              buttonRadius: BorderRadius.circular(30),
                              onPress: () {
                                //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const AdminDashboard()), (route) => false);
                                if(emailController.text.isEmpty){
                                  MyMessage.showFailedMessage("Please Enter Email", context);
                                }else if(passwordController.text.isEmpty){
                                  MyMessage.showFailedMessage("Password is missing", context);
                                }else {
                                  /*authProvider.userLogin(emailController.text, passwordController.text).then((value) {
                                    if(value.isSuccess){
                                      MyMessage.showSuccessMessage(value.message, context);
                                    }else{
                                      MyMessage.showFailedMessage(value.message, context);
                                    }
                                  });*/
                                }
                              },
                            ),
                          ),
                          Visibility(
                              visible: authProvider.progress,
                              child: const SizedBox(height: 80, child: ProgressBarWidget())),
                          Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.fromLTRB(10,50,10,20),
                            child: Text.rich(
                                TextSpan(
                                    children: [
                                      const TextSpan(text: "Don\'t have an account?   "),
                                      TextSpan(
                                        text: 'Sign Up',
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = (){
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpPage()));
                                          },
                                        style: AppAssets.latoBold_primaryColor_16,
                                      ),
                                    ]
                                )
                            ),
                          ),
                        ],
                      ),),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
