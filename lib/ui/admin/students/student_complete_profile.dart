import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:university_management_system/models/user_model.dart';
import '../../../assets/app_assets.dart';
import '../../../models/student_model.dart';
import '../../../utilities/ip_configurations.dart';

class StudentCompleteProfile extends StatelessWidget {
  StudentModel studentModel;
  StudentCompleteProfile({required this.studentModel, Key? key}) : super(key: key);

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
                      child: studentModel.userModel.userImage.isEmpty || studentModel.userModel.userImage == "null" ? SvgPicture.asset(studentModel.userModel.userGender == "male" ? AppAssets.maleAvatar : AppAssets.femaleAvatar, color: AppAssets.textDarkColor,) : Image.network(studentModel.userModel.userImage + IPConfigurations.serverImagePath, fit: BoxFit.cover,),
                    ),
                  ),
                ]),

                Container(
                  margin: const EdgeInsets.only(left: 30, right: 30, top: 15),
                  child: Text(studentModel.userModel.userName, style: AppAssets.latoBold_textDarkColor_20, maxLines: 2, overflow: TextOverflow.ellipsis,),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 30, right: 30, top: 3),
                  child: Text(studentModel.userModel.userType == "student" ? studentModel.userModel.userRollNo : studentModel.userModel.userQualification, style: AppAssets.latoRegular_textDarkColor_16, maxLines: 2, overflow: TextOverflow.ellipsis,),
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
                      Text(studentModel.userModel.userName, style: AppAssets.latoRegular_textDarkColor_16, maxLines: 2, overflow: TextOverflow.ellipsis,),
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
                      Text(studentModel.userModel.userEmail, style: AppAssets.latoRegular_textDarkColor_16, maxLines: 2, overflow: TextOverflow.ellipsis,),
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
                      Text(studentModel.userModel.userPassword, style: AppAssets.latoRegular_textDarkColor_16, maxLines: 2, overflow: TextOverflow.ellipsis,),
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
                      Text(studentModel.userModel.userPhone, style: AppAssets.latoRegular_textDarkColor_16, maxLines: 2, overflow: TextOverflow.ellipsis,),
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
                      Icon(studentModel.userModel.userGender == "male" ? Icons.male : Icons.female, color: AppAssets.textLightColor,),
                      const SizedBox(width: 10,),
                      Text(studentModel.userModel.userGender == "male" ? "Male" : studentModel.userModel.userGender == "female" ? "Female ": "Others", style: AppAssets.latoRegular_textDarkColor_16, maxLines: 2, overflow: TextOverflow.ellipsis,),
                    ],),
                ),
                Visibility(
                  visible: studentModel.userModel.userType == "student",
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
                        Text(studentModel.userModel.userSession, style: AppAssets.latoRegular_textDarkColor_16, maxLines: 2, overflow: TextOverflow.ellipsis,),
                      ],),
                  ),
                ),
                Visibility(
                  visible: studentModel.userModel.userType == "student",
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
                        Text("${studentModel.classModel.className} ${studentModel.classModel.classSemester} ${studentModel.classModel.classType}", style: AppAssets.latoRegular_textDarkColor_16, maxLines: 2, overflow: TextOverflow.ellipsis,),
                      ],),
                  ),
                ),
                Visibility(
                  visible: studentModel.userModel.userType == "Teacher",
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
                        Text(studentModel.userModel.userQualification, style: AppAssets.latoRegular_textDarkColor_16, maxLines: 2, overflow: TextOverflow.ellipsis,),
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
                      Text(studentModel.departmentModel.departmentName, style: AppAssets.latoRegular_textDarkColor_16, maxLines: 2, overflow: TextOverflow.ellipsis,),
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
                      Text(studentModel.userModel.userStatus == "active" ? "Active" : "In Active", style: AppAssets.latoRegular_textDarkColor_16, maxLines: 2, overflow: TextOverflow.ellipsis,),
                    ],),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
