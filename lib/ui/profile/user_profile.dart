import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:university_management_system/models/user_model.dart';
import 'package:university_management_system/providers/auth_provider.dart';
import 'package:university_management_system/ui/auth/login_page.dart';
import 'package:university_management_system/utilities/constants.dart';
import 'package:university_management_system/utilities/shared_preference_manager.dart';
import '../../../assets/app_assets.dart';
import '../../../utilities/ip_configurations.dart';
import '../../utilities/base/my_message.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/progress_bar.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {

  UserModel? userModel;

  bool progressBar = false;
  String authToken = "";

  @override
  void initState() {
    super.initState();

    getUserData();
    getToken();
  }

  void getToken() {
    Constants.getAuthToken().then((value) {
      setState(() {
        authToken = value;
      });
    });
  }
  void getUserData() async {
    SharedPreferenceManager.getInstance().getUser().then((value) {
      userModel = value;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: AppAssets.whiteColor,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(children: [
                  Container(
                    width: double.infinity,
                    height: 150,
                    alignment: Alignment.topCenter,
                    padding: const EdgeInsets.only(left: 0, right: 10),
                    color: AppAssets.backgroundColor,
                    child: Container(
                      height: 50,
                      alignment: Alignment.topCenter,
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                        GestureDetector(onTap: () {Navigator.of(context).pop();}, child: Container(padding: const EdgeInsets.all(16), height: 50, width: 50, child: SvgPicture.asset(AppAssets.backArrowIcon, color: AppAssets.iconsTintDarkGreyColor,))),
                      ],),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      clipBehavior: Clip.antiAlias,
                      margin: const EdgeInsets.only(top: 75),
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: AppAssets.whiteColor,
                        borderRadius: BorderRadius.circular(75),
                        boxShadow: [
                          BoxShadow(
                            color: AppAssets.shadowColor.withOpacity(0.3),
                            spreadRadius: 6,
                            blurRadius: 12,
                            offset: const Offset(0, 6), // changes position of shadow
                          )],
                      ),
                      child: userModel!.userImage.isEmpty ? SvgPicture.asset(userModel!.userGender == "Male" ? AppAssets.maleAvatar : AppAssets.femaleAvatar, color: AppAssets.textDarkColor,) : Image.network(userModel!.userImage + IPConfigurations.serverImagePath, fit: BoxFit.cover,),
                    ),
                  ),
                ]),

                Container(
                  margin: const EdgeInsets.only(left: 30, right: 30, top: 15),
                  child: Text(userModel!.userName, style: AppAssets.latoBold_textDarkColor_20, maxLines: 2, overflow: TextOverflow.ellipsis,),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 30, right: 30, top: 3),
                  child: Text(userModel!.userType == "Student" ? userModel!.userRollNo : userModel!.userQualification, style: AppAssets.latoRegular_textDarkColor_16, maxLines: 2, overflow: TextOverflow.ellipsis,),
                ),
                Container(
                  width: double.infinity,
                  height: 60,
                  margin: const EdgeInsets.only(left: 30, right: 30, top: 50),
                  padding: const EdgeInsets.all(12),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: AppAssets.backgroundColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.verified_user, color: AppAssets.textLightColor,),
                      const SizedBox(width: 10,),
                      Text(userModel!.userName, style: AppAssets.latoRegular_textDarkColor_16, maxLines: 2, overflow: TextOverflow.ellipsis,),
                    ],),
                ),
                Container(
                  width: double.infinity,
                  height: 60,
                  margin: const EdgeInsets.only(left: 30, right: 30, top: 20),
                  padding: const EdgeInsets.all(12),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: AppAssets.backgroundColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.email, color: AppAssets.textLightColor,),
                      const SizedBox(width: 10,),
                      Text(userModel!.userEmail, style: AppAssets.latoRegular_textDarkColor_16, maxLines: 2, overflow: TextOverflow.ellipsis,),
                    ],),
                ),
                Container(
                  width: double.infinity,
                  height: 60,
                  margin: const EdgeInsets.only(left: 30, right: 30, top: 20),
                  padding: const EdgeInsets.all(12),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: AppAssets.backgroundColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.password, color: AppAssets.textLightColor,),
                      const SizedBox(width: 10,),
                      Text(userModel!.userPassword, style: AppAssets.latoRegular_textDarkColor_16, maxLines: 2, overflow: TextOverflow.ellipsis,),
                    ],),
                ),
                Container(
                  width: double.infinity,
                  height: 60,
                  margin: const EdgeInsets.only(left: 30, right: 30, top: 20),
                  padding: const EdgeInsets.all(12),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: AppAssets.backgroundColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.phone, color: AppAssets.textLightColor,),
                      const SizedBox(width: 10,),
                      Text(userModel!.userPhone, style: AppAssets.latoRegular_textDarkColor_16, maxLines: 2, overflow: TextOverflow.ellipsis,),
                    ],),
                ),
                Container(
                  width: double.infinity,
                  height: 60,
                  margin: const EdgeInsets.only(left: 30, right: 30, top: 20),
                  padding: const EdgeInsets.all(12),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: AppAssets.backgroundColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(Constants.capitalize(userModel!.userGender) == "Male" ? Icons.male : Icons.female, color: AppAssets.textLightColor,),
                      const SizedBox(width: 10,),
                      Text(Constants.capitalize(userModel!.userGender), style: AppAssets.latoRegular_textDarkColor_16, maxLines: 2, overflow: TextOverflow.ellipsis,),
                    ],),
                ),
                Visibility(
                  visible: userModel!.userType == "Student",
                  child: Container(
                    width: double.infinity,
                    height: 60,
                    margin: const EdgeInsets.only(left: 30, right: 30, top: 20),
                    padding: const EdgeInsets.all(12),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      color: AppAssets.backgroundColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.numbers, color: AppAssets.textLightColor,),
                        const SizedBox(width: 10,),
                        Text(userModel!.userSession, style: AppAssets.latoRegular_textDarkColor_16, maxLines: 2, overflow: TextOverflow.ellipsis,),
                      ],),
                  ),
                ),
                Visibility(
                  visible: userModel!.userType == "Student",
                  child: Container(
                    width: double.infinity,
                    height: 60,
                    margin: const EdgeInsets.only(left: 30, right: 30, top: 20),
                    padding: const EdgeInsets.all(12),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      color: AppAssets.backgroundColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.class_, color: AppAssets.textLightColor,),
                        const SizedBox(width: 10,),
                        Text(userModel!.userClass, style: AppAssets.latoRegular_textDarkColor_16, maxLines: 2, overflow: TextOverflow.ellipsis,),
                      ],),
                  ),
                ),
                Visibility(
                  visible: userModel!.userType == "Teacher",
                  child: Container(
                    width: double.infinity,
                    height: 60,
                    margin: const EdgeInsets.only(left: 30, right: 30, top: 20),
                    padding: const EdgeInsets.all(12),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      color: AppAssets.backgroundColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.class_, color: AppAssets.textLightColor,),
                        const SizedBox(width: 10,),
                        Text(userModel!.userQualification, style: AppAssets.latoRegular_textDarkColor_16, maxLines: 2, overflow: TextOverflow.ellipsis,),
                      ],),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 60,
                  margin: const EdgeInsets.only(left: 30, right: 30, top: 20),
                  padding: const EdgeInsets.all(12),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: AppAssets.backgroundColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.house, color: AppAssets.textLightColor,),
                      const SizedBox(width: 10,),
                      Text(userModel!.userDepartment, style: AppAssets.latoRegular_textDarkColor_16, maxLines: 2, overflow: TextOverflow.ellipsis,),
                    ],),
                ),
                Container(
                  width: double.infinity,
                  height: 60,
                  margin: const EdgeInsets.only(left: 30, right: 30, top: 20, bottom: 30),
                  padding: const EdgeInsets.all(12),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: AppAssets.backgroundColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.verified, color: AppAssets.textLightColor,),
                      const SizedBox(width: 10,),
                      Text(userModel!.userStatus, style: AppAssets.latoRegular_textDarkColor_16, maxLines: 2, overflow: TextOverflow.ellipsis,),
                    ],),
                ),
                Visibility(visible: progressBar, child: const SizedBox(height: 80,child: ProgressBarWidget())),
                Visibility(
                  visible: !progressBar,
                  child: PrimaryButton(
                    width: double.infinity,
                    height: 60,
                    buttonMargin: const EdgeInsets.only(top: 20, left: 30, right: 30, bottom: 50),
                    buttonPadding: const EdgeInsets.all(12),
                    buttonText: "Logout",
                    buttonTextStyle: AppAssets.latoBold_whiteColor_18,
                    shadowColor: AppAssets.shadowColor,
                    buttonRadius: BorderRadius.circular(30),
                    onPress: () {
                      setState(() {
                        progressBar = true;
                      });
                      print(authToken);
                      Provider.of<AuthProvider>(context, listen: false).userLogout(authToken).then((value) async {
                        if(value.isSuccess)  {
                          MyMessage.showSuccessMessage(value.message, context);
                          await Future.delayed(const Duration(milliseconds: 3000),(){});
                          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                              LoginPage()), (Route<dynamic> route) => false);
                        }else{
                          MyMessage.showFailedMessage(value.message, context);
                        }
                        setState(() {
                          progressBar = false;
                        });
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
