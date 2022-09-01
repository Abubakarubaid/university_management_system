import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:university_management_system/models/teacher_model.dart';
import 'package:university_management_system/models/user_model.dart';
import 'package:university_management_system/ui/admin/teachers/teacher_profile_edit.dart';
import '../../../assets/app_assets.dart';
import '../../../models/student_model.dart';
import '../../../utilities/ip_configurations.dart';

class TeacherCompleteProfile extends StatelessWidget {
  TeacherModel teacherModel;
  TeacherCompleteProfile({required this.teacherModel, Key? key}) : super(key: key);

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
                        GestureDetector(onTap: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => TeacherProfileEdit(teacherModel: teacherModel,),));}, child: Container(padding: const EdgeInsets.all(16), height: 50, child: const Text("Edit", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),))),
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
                      child: teacherModel.userModel.userImage.isEmpty || teacherModel.userModel.userImage == "null" ? SvgPicture.asset(teacherModel.userModel.userGender == "male" ? AppAssets.maleAvatar : AppAssets.femaleAvatar, color: AppAssets.textDarkColor,) : Image.network(teacherModel.userModel.userImage + IPConfigurations.serverImagePath, fit: BoxFit.cover,),
                    ),
                  ),
                ]),
                Container(
                  margin: const EdgeInsets.only(left: 30, right: 30, top: 15),
                  child: Text(teacherModel.userModel.userName == "null" ? "" : teacherModel.userModel.userName, style: AppAssets.latoBold_textDarkColor_20, maxLines: 2, overflow: TextOverflow.ellipsis,),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 30, right: 30, top: 3),
                  child: Text(teacherModel.userModel.userDesignation == "null" ? "" : teacherModel.userModel.userDesignation, style: AppAssets.latoRegular_textDarkColor_16, maxLines: 2, overflow: TextOverflow.ellipsis,),
                ),
                Container(
                  width: double.infinity,
                  height: 70,
                  margin: const EdgeInsets.only(left: 30, right: 30, top: 20),
                  padding: const EdgeInsets.only(top: 10, bottom: 16, left: 16, right: 16),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: AppAssets.backgroundColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Email Address", style: AppAssets.latoBlack_textLightColor_12,),
                      const SizedBox(width: 4,),
                      Text(teacherModel.userModel.userEmail == "null" ? "" : teacherModel.userModel.userEmail, style: AppAssets.latoRegular_textDarkColor_16, maxLines: 2, overflow: TextOverflow.ellipsis,),
                    ],),
                ),
                Container(
                  width: double.infinity,
                  height: 70,
                  margin: const EdgeInsets.only(left: 30, right: 30, top: 20),
                  padding: const EdgeInsets.only(top: 10, bottom: 16, left: 16, right: 16),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: AppAssets.backgroundColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Phone No", style: AppAssets.latoBlack_textLightColor_12,),
                      const SizedBox(width: 4,),
                      Text(teacherModel.userModel.userPhone == "null" ? "" : teacherModel.userModel.userPhone, style: AppAssets.latoRegular_textDarkColor_16, maxLines: 2, overflow: TextOverflow.ellipsis,),
                    ],),
                ),
                Container(
                  width: double.infinity,
                  height: 70,
                  margin: const EdgeInsets.only(left: 30, right: 30, top: 20),
                  padding: const EdgeInsets.only(top: 10, bottom: 16, left: 16, right: 16),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: AppAssets.backgroundColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Gender", style: AppAssets.latoBlack_textLightColor_12,),
                      const SizedBox(width: 4,),
                      Text(teacherModel.userModel.userGender == "male" ? "Male" : teacherModel.userModel.userGender == "female" ? "Female ": "Others", style: AppAssets.latoRegular_textDarkColor_16, maxLines: 2, overflow: TextOverflow.ellipsis,),
                    ],),
                ),
                Container(
                  width: double.infinity,
                  height: 70,
                  margin: const EdgeInsets.only(left: 30, right: 30, top: 20),
                  padding: const EdgeInsets.only(top: 10, bottom: 16, left: 16, right: 16),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: AppAssets.backgroundColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Qualification", style: AppAssets.latoBlack_textLightColor_12,),
                      const SizedBox(width: 4,),
                      Text(teacherModel.userModel.userQualification == "null" ? "" : teacherModel.userModel.userQualification, style: AppAssets.latoRegular_textDarkColor_16, maxLines: 2, overflow: TextOverflow.ellipsis,),
                    ],),
                ),
                Container(
                  width: double.infinity,
                  height: 70,
                  margin: const EdgeInsets.only(left: 30, right: 30, top: 20),
                  padding: const EdgeInsets.only(top: 10, bottom: 16, left: 16, right: 16),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: AppAssets.backgroundColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Department", style: AppAssets.latoBlack_textLightColor_12,),
                      const SizedBox(width: 4,),
                      Text(teacherModel.departmentModel.departmentName == "null" ? "" : teacherModel.departmentModel.departmentName, style: AppAssets.latoRegular_textDarkColor_16, maxLines: 2, overflow: TextOverflow.ellipsis,),
                    ],),
                ),
                Container(
                  width: double.infinity,
                  height: 70,
                  margin: const EdgeInsets.only(left: 30, right: 30, top: 20),
                  padding: const EdgeInsets.only(top: 10, bottom: 16, left: 16, right: 16),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: AppAssets.backgroundColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Field of Specialization", style: AppAssets.latoBlack_textLightColor_12,),
                      const SizedBox(width: 4,),
                      Text(teacherModel.userModel.userSpecializedField == "null" ? "" : teacherModel.userModel.userSpecializedField, style: AppAssets.latoRegular_textDarkColor_16, maxLines: 1, overflow: TextOverflow.ellipsis,),
                    ],),
                ),
                Container(
                  width: double.infinity,
                  height: 70,
                  margin: const EdgeInsets.only(left: 30, right: 30, top: 20),
                  padding: const EdgeInsets.only(top: 10, bottom: 16, left: 16, right: 16),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: AppAssets.backgroundColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("CNIC Number", style: AppAssets.latoBlack_textLightColor_12,),
                      const SizedBox(width: 4,),
                      Text(teacherModel.userModel.userCnic == "null" ? "" : teacherModel.userModel.userCnic, style: AppAssets.latoRegular_textDarkColor_16, maxLines: 1, overflow: TextOverflow.ellipsis,),
                    ],),
                ),
                Container(
                  width: double.infinity,
                  height: 70,
                  margin: const EdgeInsets.only(left: 30, right: 30, top: 20),
                  padding: const EdgeInsets.only(top: 10, bottom: 16, left: 16, right: 16),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: AppAssets.backgroundColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Street Address", style: AppAssets.latoBlack_textLightColor_12,),
                      const SizedBox(width: 4,),
                      Text(teacherModel.userModel.userAddress == "null" ? "" : teacherModel.userModel.userAddress, style: AppAssets.latoRegular_textDarkColor_16, maxLines: 1, overflow: TextOverflow.ellipsis,),
                    ],),
                ),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(left: 30, right: 30, top: 20),
                  padding: const EdgeInsets.only(top: 10, bottom: 16, left: 16, right: 16),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: AppAssets.backgroundColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("M.Phil Examination Details", style: AppAssets.latoBlack_textLightColor_12,),
                      const SizedBox(height: 6,),
                      Text("M.Phil", style: AppAssets.latoRegular_textDarkColor_16, maxLines: 1, overflow: TextOverflow.ellipsis,),
                      const SizedBox(height: 12,),
                      Text("M.Phil Passed Exam Subject", style: AppAssets.latoBlack_textLightColor_12,),
                      const SizedBox(height: 6,),
                      Text(teacherModel.userModel.mPhilPassedExamSubject == "null" ? "-" : teacherModel.userModel.mPhilPassedExamSubject, style: AppAssets.latoRegular_textDarkColor_16, maxLines: 1, overflow: TextOverflow.ellipsis,),
                      const SizedBox(height: 12,),
                      Text("M.Phil Passed Exam Year", style: AppAssets.latoBlack_textLightColor_12,),
                      const SizedBox(height: 6,),
                      Text(teacherModel.userModel.mPhilPassedExamYear == "null" ? "-" : teacherModel.userModel.mPhilPassedExamYear, style: AppAssets.latoRegular_textDarkColor_16, maxLines: 1, overflow: TextOverflow.ellipsis,),
                      const SizedBox(height: 12,),
                      Text("M.Phil Passed Exam Division", style: AppAssets.latoBlack_textLightColor_12,),
                      const SizedBox(height: 6,),
                      Text(teacherModel.userModel.mPhilPassedExamDivision == "null" ? "-" : teacherModel.userModel.mPhilPassedExamDivision, style: AppAssets.latoRegular_textDarkColor_16, maxLines: 1, overflow: TextOverflow.ellipsis,),
                      const SizedBox(height: 12,),
                      Text("M.Phil Passed Exam Institute", style: AppAssets.latoBlack_textLightColor_12,),
                      const SizedBox(height: 6,),
                      Text(teacherModel.userModel.mPhilPassedExamInstitute == "null" ? "-" : teacherModel.userModel.mPhilPassedExamInstitute, style: AppAssets.latoRegular_textDarkColor_16, maxLines: 1, overflow: TextOverflow.ellipsis,),
                    ],),
                ),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(left: 30, right: 30, top: 20),
                  padding: const EdgeInsets.only(top: 10, bottom: 16, left: 16, right: 16),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: AppAssets.backgroundColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("PhD Examination Details", style: AppAssets.latoBlack_textLightColor_12,),
                      const SizedBox(height: 6,),
                      Text("PhD", style: AppAssets.latoRegular_textDarkColor_16, maxLines: 1, overflow: TextOverflow.ellipsis,),
                      const SizedBox(height: 12,),
                      Text("PhD Passed Exam Subject", style: AppAssets.latoBlack_textLightColor_12,),
                      const SizedBox(height: 6,),
                      Text(teacherModel.userModel.phdPassedExamSubject == "null" ? "-" : teacherModel.userModel.phdPassedExamSubject, style: AppAssets.latoRegular_textDarkColor_16, maxLines: 1, overflow: TextOverflow.ellipsis,),
                      const SizedBox(height: 12,),
                      Text("PhD Passed Exam Year", style: AppAssets.latoBlack_textLightColor_12,),
                      const SizedBox(height: 6,),
                      Text(teacherModel.userModel.phdPassedExamYear == "null" ? "-" : teacherModel.userModel.phdPassedExamYear, style: AppAssets.latoRegular_textDarkColor_16, maxLines: 1, overflow: TextOverflow.ellipsis,),
                      const SizedBox(height: 12,),
                      Text("PhD Passed Exam Division", style: AppAssets.latoBlack_textLightColor_12,),
                      const SizedBox(height: 6,),
                      Text(teacherModel.userModel.phdPassedExamDivision == "null" ? "-" : teacherModel.userModel.phdPassedExamDivision, style: AppAssets.latoRegular_textDarkColor_16, maxLines: 1, overflow: TextOverflow.ellipsis,),
                      const SizedBox(height: 12,),
                      Text("PhD Passed Exam Institute", style: AppAssets.latoBlack_textLightColor_12,),
                      const SizedBox(height: 6,),
                      Text(teacherModel.userModel.phdPassedExamInstitute == "null" ? "-" : teacherModel.userModel.phdPassedExamInstitute, style: AppAssets.latoRegular_textDarkColor_16, maxLines: 1, overflow: TextOverflow.ellipsis,),
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
                      Icon(Icons.verified, color: teacherModel.userModel.userStatus == "active" ? AppAssets.successColor : AppAssets.textLightColor,),
                      const SizedBox(width: 10,),
                      Text(teacherModel.userModel.userStatus == "active" ? "Active" : "In Active", style: AppAssets.latoRegular_textDarkColor_16, maxLines: 2, overflow: TextOverflow.ellipsis,),
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
