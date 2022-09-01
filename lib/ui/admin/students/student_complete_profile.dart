import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:university_management_system/models/user_model.dart';
import 'package:university_management_system/providers/app_provider.dart';
import 'package:university_management_system/ui/admin/students/student_profile_edit.dart';
import '../../../assets/app_assets.dart';
import '../../../models/student_model.dart';
import '../../../utilities/ip_configurations.dart';

class StudentCompleteProfile extends StatefulWidget {
  StudentModel studentModel;
  StudentCompleteProfile({required this.studentModel, Key? key}) : super(key: key);

  @override
  State<StudentCompleteProfile> createState() => _StudentCompleteProfileState();
}

class _StudentCompleteProfileState extends State<StudentCompleteProfile> {

  StudentModel studentModel = StudentModel.getInstance();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    studentModel = widget.studentModel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<AppProvider>(builder: (context, appProvider, child) {
          if(Provider.of<AppProvider>(context, listen: false).studentUpdatedModel.userModel.userId != 0) {
            studentModel = Provider
                .of<AppProvider>(context, listen: false)
                .studentUpdatedModel;
          }
          return Container(
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
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => StudentProfileEdit(studentModel: studentModel,),));
                            },
                            child: Container(
                              height: double.infinity,
                              padding: const EdgeInsets.all(5),
                              child: Row(
                                children: [
                                  const Text("Edit", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),),
                                  const SizedBox(width: 8,),
                                  SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: SvgPicture.asset(AppAssets.editIcon, color: AppAssets.textDarkColor,)),
                                ],
                              ),
                            ),
                          ),
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
                    child: Text(studentModel.userModel.userName == "null" ? "" : studentModel.userModel.userName, style: AppAssets.latoBold_textDarkColor_20, maxLines: 2, overflow: TextOverflow.ellipsis,),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 30, right: 30, top: 3),
                    child: Text(studentModel.userModel.userRollNo == "null" ? "" : studentModel.userModel.userRollNo, style: AppAssets.latoRegular_textDarkColor_16, maxLines: 2, overflow: TextOverflow.ellipsis,),
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
                        Text(studentModel.userModel.userEmail == "null" ? "" : studentModel.userModel.userEmail, style: AppAssets.latoRegular_textDarkColor_16, maxLines: 2, overflow: TextOverflow.ellipsis,),
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
                        Text(studentModel.userModel.userPhone == "null" ? "" : studentModel.userModel.userPhone, style: AppAssets.latoRegular_textDarkColor_16, maxLines: 2, overflow: TextOverflow.ellipsis,),
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
                        Text(studentModel.userModel.userGender == "male" ? "Male" : studentModel.userModel.userGender == "female" ? "Female ": "Others", style: AppAssets.latoRegular_textDarkColor_16, maxLines: 2, overflow: TextOverflow.ellipsis,),
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
                        Text("Session", style: AppAssets.latoBlack_textLightColor_12,),
                        const SizedBox(width: 4,),
                        Text(studentModel.userModel.userSession == "null" ? "" : studentModel.userModel.userSession, style: AppAssets.latoRegular_textDarkColor_16, maxLines: 2, overflow: TextOverflow.ellipsis,),
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
                        Text(studentModel.departmentModel.departmentName == "null" ? "" : studentModel.departmentModel.departmentName, style: AppAssets.latoRegular_textDarkColor_16, maxLines: 2, overflow: TextOverflow.ellipsis,),
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
                        Text("Class", style: AppAssets.latoBlack_textLightColor_12,),
                        const SizedBox(width: 4,),
                        Text("${studentModel.classModel.className} ${studentModel.classModel.classSemester} ${studentModel.classModel.classType}" , style: AppAssets.latoRegular_textDarkColor_16, maxLines: 1, overflow: TextOverflow.ellipsis,),
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
                        Text(studentModel.userModel.userCnic == "null" ? "" : studentModel.userModel.userCnic, style: AppAssets.latoRegular_textDarkColor_16, maxLines: 1, overflow: TextOverflow.ellipsis,),
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
                        Text(studentModel.userModel.userAddress == "null" ? "" : studentModel.userModel.userAddress, style: AppAssets.latoRegular_textDarkColor_16, maxLines: 1, overflow: TextOverflow.ellipsis,),
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
                        Icon(Icons.verified, color: studentModel.userModel.userStatus == "active" ? AppAssets.successColor : AppAssets.textLightColor,),
                        const SizedBox(width: 10,),
                        Text(studentModel.userModel.userStatus == "active" ? "Active" : "In Active", style: AppAssets.latoRegular_textDarkColor_16, maxLines: 2, overflow: TextOverflow.ellipsis,),
                      ],),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
