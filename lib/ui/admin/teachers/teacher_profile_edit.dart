import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signature/signature.dart';
import 'package:university_management_system/providers/auth_provider.dart';
import 'package:university_management_system/utilities/base/my_message.dart';
import 'package:university_management_system/utilities/shared_preference_manager.dart';
import '../../../assets/app_assets.dart';
import 'package:pk_cnic_input_field/pk_cnic_input_field.dart';
import 'dart:ui' as ui;

import '../../../models/dpt_model.dart';
import '../../../models/teacher_model.dart';
import '../../../models/user_model.dart';
import '../../../providers/app_provider.dart';
import '../../../utilities/constants.dart';
import '../../../widgets/primary_button.dart';
import '../../../widgets/primary_dropdown_field.dart';
import '../../../widgets/primary_text_field.dart';
import '../../../widgets/profile_image_pick.dart';

class TeacherProfileEdit extends StatefulWidget {
  TeacherModel teacherModel;
  TeacherProfileEdit({required this.teacherModel, Key? key}) : super(key: key);

  @override
  State<TeacherProfileEdit> createState() => _TeacherProfileEditState();
}

class _TeacherProfileEditState extends State<TeacherProfileEdit> {

  final SignatureController _signatureController = SignatureController(
    penStrokeWidth: 2,
    penColor: Colors.blue,
    exportBackgroundColor: Colors.transparent,
  );
  Uint8List? imageData;

  TextEditingController nameController=TextEditingController();
  TextEditingController emailController=TextEditingController();
  TextEditingController phoneController=TextEditingController();
  TextEditingController qualificationController=TextEditingController();
  TextEditingController designationController=TextEditingController();
  TextEditingController addressController=TextEditingController();
  TextEditingController examPassedMPController=TextEditingController();
  TextEditingController userExaminationPassedMPhilController=TextEditingController();
  TextEditingController mPhilPassedExamSubjectController=TextEditingController();
  TextEditingController mPhilPassedExamYearController=TextEditingController();
  TextEditingController mPhilPassedExamDivisionController=TextEditingController();
  TextEditingController mPhilPassedExamInstituteController=TextEditingController();
  TextEditingController userExaminationPassedPhdController=TextEditingController();
  TextEditingController phdPassedExamSubjectController=TextEditingController();
  TextEditingController phdPassedExamYearController=TextEditingController();
  TextEditingController phdPassedExamDivisionController=TextEditingController();
  TextEditingController phdPassedExamInstituteController=TextEditingController();
  TextEditingController userSpecializedFieldController=TextEditingController();
  TextEditingController userGraduationLevelExperienceController=TextEditingController();
  TextEditingController userPostGraduationLevelExperienceController=TextEditingController();
  TextEditingController userSignatureController=TextEditingController();
  TextEditingController userCNICController=TextEditingController();
  TextEditingController userTotalAllowedCreditHours=TextEditingController();

  var itemsGender = [
    "Select Gender",
    "Male",
    "Female",
    "Other",
  ];
  String genderSelectedValue = "Select Gender";

  var itemsStatus = [
    "Select Status",
    "Active",
    "Inactive",
  ];
  String statusSelectedValue = "Select Status";

  String signatureText = "Add your Signature";

  ProfileImagePick _imagePick = ProfileImagePick(
    addButtonVisibility: true,
  );

  List<DepartmentModel> departmentList = [];
  DepartmentModel dptSelectedValue = DepartmentModel(departmentId: 0, departmentName: "Select Department", departmentType: "Demo");
  var items;

  var signatureBytes = null;
  var imageSignature = null;
  var data;
  UserModel userModel = UserModel.getInstance();

  @override
  void initState() {
    super.initState();

    getMyData();
    getDepartments();
  }

  void getMyData() {
      nameController.text = widget.teacherModel.userModel.userName == "null" ? "" : widget.teacherModel.userModel.userName;
      emailController.text = widget.teacherModel.userModel.userEmail == "null" ? "" : widget.teacherModel.userModel.userEmail;
      phoneController.text = widget.teacherModel.userModel.userPhone == "null" ? "" : widget.teacherModel.userModel.userPhone;
      qualificationController.text = widget.teacherModel.userModel.userQualification == "null" ? "" : widget.teacherModel.userModel.userQualification;
      designationController.text = widget.teacherModel.userModel.userDesignation == "null" ? "" : widget.teacherModel.userModel.userDesignation;
      addressController.text = widget.teacherModel.userModel.userAddress == "null" ? "" : widget.teacherModel.userModel.userAddress;
      examPassedMPController.text = widget.teacherModel.userModel.userExaminationPassedMPhil == "null" ? "" : widget.teacherModel.userModel.userExaminationPassedMPhil;
      userExaminationPassedMPhilController.text = widget.teacherModel.userModel.userExaminationPassedMPhil == "null" ? "" : widget.teacherModel.userModel.userExaminationPassedMPhil;
      mPhilPassedExamSubjectController.text = widget.teacherModel.userModel.mPhilPassedExamSubject == "null" ? "" : widget.teacherModel.userModel.mPhilPassedExamSubject;
      mPhilPassedExamYearController.text = widget.teacherModel.userModel.mPhilPassedExamYear == "null" ? "" : widget.teacherModel.userModel.mPhilPassedExamYear;
      mPhilPassedExamDivisionController.text = widget.teacherModel.userModel.mPhilPassedExamDivision == "null" ? "" : widget.teacherModel.userModel.mPhilPassedExamDivision;
      mPhilPassedExamInstituteController.text = widget.teacherModel.userModel.mPhilPassedExamInstitute == "null" ? "" : widget.teacherModel.userModel.mPhilPassedExamInstitute;
      userExaminationPassedPhdController.text = widget.teacherModel.userModel.userExaminationPassedPhd == "null" ? "" : widget.teacherModel.userModel.userExaminationPassedPhd;
      phdPassedExamSubjectController.text = widget.teacherModel.userModel.phdPassedExamSubject == "null" ? "" : widget.teacherModel.userModel.phdPassedExamSubject;
      phdPassedExamYearController.text = widget.teacherModel.userModel.phdPassedExamYear == "null" ? "" : widget.teacherModel.userModel.phdPassedExamYear;
      phdPassedExamDivisionController.text = widget.teacherModel.userModel.phdPassedExamDivision == "null" ? "" : widget.teacherModel.userModel.phdPassedExamDivision;
      phdPassedExamInstituteController.text = widget.teacherModel.userModel.phdPassedExamInstitute == "null" ? "" : widget.teacherModel.userModel.phdPassedExamInstitute;
      userSpecializedFieldController.text = widget.teacherModel.userModel.userSpecializedField == "null" ? "" : widget.teacherModel.userModel.userSpecializedField;
      userGraduationLevelExperienceController.text = widget.teacherModel.userModel.userGraduationLevelExperience == "null" ? "" : widget.teacherModel.userModel.userGraduationLevelExperience;
      userPostGraduationLevelExperienceController.text = widget.teacherModel.userModel.userPostGraduationLevelExperience == "null" ? "" : widget.teacherModel.userModel.userPostGraduationLevelExperience;
      userSignatureController.text = widget.teacherModel.userModel.userSignature == "null" ? signatureText="Add your Signature" : signatureText="Change Signature";
      userCNICController.text = widget.teacherModel.userModel.userCnic == "null" ? "" : widget.teacherModel.userModel.userCnic;
      userTotalAllowedCreditHours.text = widget.teacherModel.userModel.totalAllowedCreditHours == 0 ? "0" : widget.teacherModel.userModel.totalAllowedCreditHours.toString();
    setState(() {});
  }

  void getDepartments() async {
    Provider.of<AppProvider>(context, listen: false).fetchAllDepartments(Constants.getAuthToken().toString()).then((value) {
      setState(() {
        if(value.isSuccess){
          departmentList = Provider.of<AppProvider>(context, listen: false).departmentList;
          departmentList.add(dptSelectedValue);
          departmentList.sort((a, b) => a.departmentId.compareTo(b.departmentId));

          items = departmentList.map((item) {
            return DropdownMenuItem<DepartmentModel>(
              child: Text(item.departmentName),
              value: item,
            );
          }).toList();

          // if list is empty, create a dummy item
          if (items.isEmpty) {
            items = [
              DropdownMenuItem(
                child: Text(dptSelectedValue.departmentName),
                value: dptSelectedValue,
              )
            ];
          }else{
            dptSelectedValue = departmentList[0];
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: AppAssets.backgroundColor,
          child: Stack(
            children: [
              Image.asset(AppAssets.appDoodle, width: double.infinity, height: double.infinity, fit: BoxFit.cover, color: AppAssets.textLightColor.withOpacity(0.15),),
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(alignment: Alignment.topLeft, child: GestureDetector(onTap: () {Navigator.of(context).pop();}, child: Container(padding: const EdgeInsets.all(16), height: 50, width: 50, child: SvgPicture.asset(AppAssets.backArrowIcon, color: AppAssets.iconsTintDarkGreyColor,)))),
                    Align(
                        alignment: Alignment.center,
                        child: Text("Update Teacher's Data",style: AppAssets.latoBold_textDarkColor_20,)),
                    const SizedBox(height: 30,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 22),
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Text("Name",style: AppAssets.latoBold_textCustomColor_16,)),
                        ),
                        const SizedBox(height: 6,),
                        Container(
                          margin: const EdgeInsets.only(left: 20,right: 20),
                          child: PrimaryTextFiled(controller: nameController,onChange: (value){},hint: "Enter Name",keyboardType: TextInputType.text,

                          ),
                        ),
                        SizedBox(height: 20,),
                        Container(
                          margin: EdgeInsets.only(left: 22),
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Text("Email",style: AppAssets.latoBold_textCustomColor_16,)),
                        ),
                        SizedBox(height: 6,),
                        Container(
                          margin: EdgeInsets.only(left: 20,right: 20),
                          child: Container(
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
                            child: TextFormField(
                              cursorColor: AppAssets.textDarkColor,
                              controller: emailController,
                              textAlign: TextAlign.start,
                              maxLines: 1,
                              enabled: false,
                              style: AppAssets.latoRegular_textDarkColor_16,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText: "Email Address",
                                hintStyle: AppAssets.latoRegular_textLightColor_14,
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20,),
                        Container(
                          margin: EdgeInsets.only(left: 22),
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Text("Phone Number",style: AppAssets.latoBold_textCustomColor_16,)),
                        ),
                        SizedBox(height: 6,),
                        Container(
                          margin: EdgeInsets.only(left: 20,right: 20),
                          child: PrimaryTextFiled(controller: phoneController,onChange: (value){},hint: "Enter Namw",keyboardType: TextInputType.text,),
                        ),
                        SizedBox(height: 20,),
                        Container(
                          margin: EdgeInsets.only(left: 22),
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Text("Qualification",style: AppAssets.latoBold_textCustomColor_16,)),
                        ),
                        SizedBox(height: 6,),
                        Container(
                          margin: EdgeInsets.only(left: 20,right: 20),
                          child: PrimaryTextFiled(controller: qualificationController,onChange: (value){},hint: "Enter Qualification",keyboardType: TextInputType.text,),
                        ),
                        SizedBox(height: 20,),
                        Container(
                          margin: EdgeInsets.only(left: 22),
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Text("Designation",style: AppAssets.latoBold_textCustomColor_16,)),
                        ),
                        SizedBox(height: 6,),
                        Container(
                          margin: EdgeInsets.only(left: 20,right: 20),
                          child: PrimaryTextFiled(controller: designationController,onChange: (value){},hint: "Enter Designation",keyboardType: TextInputType.text,),
                        ),
                        SizedBox(height: 20,),
                        Container(
                          margin: EdgeInsets.only(left: 22),
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Text("Address",style: AppAssets.latoBold_textCustomColor_16,)),
                        ),
                        SizedBox(height: 6,),
                        Container(
                          margin: EdgeInsets.only(left: 20,right: 20),
                          child: PrimaryTextFiled(controller: addressController,onChange: (value){},hint: "Enter Address",keyboardType: TextInputType.text,),
                        ),
                        SizedBox(height: 20,),
                        Container(
                          margin: EdgeInsets.only(left: 22),
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Text("M.Phil Examination Details",style: AppAssets.latoBold_primaryColor_16,)),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppAssets.textLightColor, width: 1),
                          ),
                          child: Column(children: [
                            Container(margin: const EdgeInsets.only(left: 3),child: Align(alignment: Alignment.topLeft, child: Text("Subject Field",style: AppAssets.latoBold_textCustomColor_16,))),
                            const SizedBox(height: 6,),
                            PrimaryTextFiled(controller: mPhilPassedExamSubjectController,onChange: (value){},hint: "Enter Major Subject",keyboardType: TextInputType.text,),
                            SizedBox(height: 20,),

                            Container(margin: const EdgeInsets.only(left: 3),child: Align(alignment: Alignment.topLeft, child: Text("Pass Year",style: AppAssets.latoBold_textCustomColor_16,))),
                            const SizedBox(height: 6,),
                            PrimaryTextFiled(controller: mPhilPassedExamYearController,onChange: (value){},hint: "Enter Year",keyboardType: TextInputType.text,),
                            SizedBox(height: 20,),

                            Container(margin: const EdgeInsets.only(left: 3),child: Align(alignment: Alignment.topLeft, child: Text("Division",style: AppAssets.latoBold_textCustomColor_16,))),
                            const SizedBox(height: 6,),
                            PrimaryTextFiled(controller: mPhilPassedExamDivisionController,onChange: (value){},hint: "Enter Division",keyboardType: TextInputType.text,),
                            SizedBox(height: 20,),

                            Container(margin: const EdgeInsets.only(left: 3),child: Align(alignment: Alignment.topLeft, child: Text("Name of Institute",style: AppAssets.latoBold_textCustomColor_16,))),
                            const SizedBox(height: 6,),
                            PrimaryTextFiled(controller: mPhilPassedExamInstituteController,onChange: (value){},hint: "Enter Institute",keyboardType: TextInputType.text,),
                          ],),
                        ),
                        SizedBox(height: 20,),
                        Container(
                          margin: EdgeInsets.only(left: 22),
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Text("PhD Examination Details",style: AppAssets.latoBold_primaryColor_16,)),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppAssets.textLightColor, width: 1),
                          ),
                          child: Column(children: [
                            Container(margin: const EdgeInsets.only(left: 3),child: Align(alignment: Alignment.topLeft, child: Text("Subject Field",style: AppAssets.latoBold_textCustomColor_16,))),
                            const SizedBox(height: 6,),
                            PrimaryTextFiled(controller: phdPassedExamSubjectController,onChange: (value){},hint: "Enter Major Subject",keyboardType: TextInputType.text,),
                            SizedBox(height: 20,),

                            Container(margin: const EdgeInsets.only(left: 3),child: Align(alignment: Alignment.topLeft, child: Text("Pass Year",style: AppAssets.latoBold_textCustomColor_16,))),
                            const SizedBox(height: 6,),
                            PrimaryTextFiled(controller: phdPassedExamYearController,onChange: (value){},hint: "Enter Year",keyboardType: TextInputType.text,),
                            SizedBox(height: 20,),

                            Container(margin: const EdgeInsets.only(left: 3),child: Align(alignment: Alignment.topLeft, child: Text("Division",style: AppAssets.latoBold_textCustomColor_16,))),
                            const SizedBox(height: 6,),
                            PrimaryTextFiled(controller: phdPassedExamDivisionController,onChange: (value){},hint: "Enter Division",keyboardType: TextInputType.text,),
                            SizedBox(height: 20,),

                            Container(margin: const EdgeInsets.only(left: 3),child: Align(alignment: Alignment.topLeft, child: Text("Name of Institute",style: AppAssets.latoBold_textCustomColor_16,))),
                            const SizedBox(height: 6,),
                            PrimaryTextFiled(controller: phdPassedExamInstituteController,onChange: (value){},hint: "Enter Institute",keyboardType: TextInputType.text,),
                          ],),
                        ),
                        SizedBox(height: 20,),
                        Container(
                          margin: EdgeInsets.only(left: 22),
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Text("Field of Specialization",style: AppAssets.latoBold_textCustomColor_16,)),
                        ),
                        SizedBox(height: 6,),
                        Container(
                          margin: EdgeInsets.only(left: 20,right: 20),
                          child: PrimaryTextFiled(controller: userSpecializedFieldController,onChange: (value){},hint: "Enter Your Specialization",keyboardType: TextInputType.text,),
                        ),
                        SizedBox(height: 20,),
                        Container(
                          margin: EdgeInsets.only(left: 22),
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Text("Graduation Level Experience (in years)",style: AppAssets.latoBold_textCustomColor_16,)),
                        ),
                        SizedBox(height: 6,),
                        Container(
                          margin: EdgeInsets.only(left: 20,right: 20),
                          child: PrimaryTextFiled(controller: userGraduationLevelExperienceController,onChange: (value){},hint: "Enter Graduation Level Experience",keyboardType: TextInputType.text,),
                        ),
                        SizedBox(height: 20,),
                        Container(
                          margin: EdgeInsets.only(left: 22),
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Text("Post-Graduation Level Experience (in years)",style: AppAssets.latoBold_textCustomColor_16,)),
                        ),
                        SizedBox(height: 6,),
                        Container(
                          margin: EdgeInsets.only(left: 20,right: 20),
                          child: PrimaryTextFiled(controller: userPostGraduationLevelExperienceController,onChange: (value){},hint: "Enter Post-Graduation Level Experience",keyboardType: TextInputType.text,),
                        ),
                        SizedBox(height: 20,),
                        Container(
                          margin: EdgeInsets.only(left: 22),
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Text("Total Allowed Credit Hours",style: AppAssets.latoBold_textCustomColor_16,)),
                        ),
                        SizedBox(height: 6,),
                        Container(
                          margin: EdgeInsets.only(left: 20,right: 20),
                          child: PrimaryTextFiled(controller: userTotalAllowedCreditHours,onChange: (value){},hint: "Total Allowed Credit Hours",keyboardType: TextInputType.text,),
                        ),
                        SizedBox(height: 20,),
                        Container(
                          margin: EdgeInsets.only(left: 22),
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Text("Gender: (${widget.teacherModel.userModel.userGender})",style: AppAssets.latoBold_textCustomColor_16,)),
                        ),
                        SizedBox(height: 6,),
                        Container(
                          margin: EdgeInsets.only(left: 20,right: 20),
                          child: PrimaryDropDownFiled(
                              hint: "Select Gender",
                              selectedValue: genderSelectedValue,
                              items: itemsGender,
                              onChange: (text) {
                                setState(() {
                                  genderSelectedValue = text.toString();
                                });
                              }
                          ),
                        ),
                        SizedBox(height: 20,),
                        Container(
                          margin: EdgeInsets.only(left: 22),
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Text("Status: (${widget.teacherModel.userModel.userStatus})",style: AppAssets.latoBold_textCustomColor_16,)),
                        ),
                        SizedBox(height: 6,),
                        Container(
                          margin: EdgeInsets.only(left: 20,right: 20),
                          child: PrimaryDropDownFiled(
                              hint: "Select Status",
                              selectedValue: statusSelectedValue,
                              items: itemsStatus,
                              onChange: (text) {
                                setState(() {
                                  statusSelectedValue = text.toString();
                                });
                              }
                          ),
                        ),
                        SizedBox(height: 20,),
                        Container(
                          margin: EdgeInsets.only(left: 22),
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Text("Department: (${widget.teacherModel.departmentModel.departmentName})",style: AppAssets.latoBold_textCustomColor_16, maxLines: 1, overflow: TextOverflow.ellipsis,),),
                        ),
                        SizedBox(height: 6,),
                        Container(
                          margin: EdgeInsets.only(left: 20,right: 20),
                          child: Container(
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
                            child: DropdownButton<DepartmentModel>(
                              value: dptSelectedValue,
                              icon: const Icon(Icons.arrow_drop_down),
                              underline: Container(
                                height: 0,
                                color: Colors.transparent,
                              ),
                              isExpanded: true,
                              onChanged: (value) {
                                setState(() {
                                  dptSelectedValue = value!;
                                });
                              },
                              items: items,
                            ),
                          ),
                        ),
                        SizedBox(height: 20,),
                        Container(
                          margin: EdgeInsets.only(left: 22),
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Text("CNIC (${userCNICController.text})",style: AppAssets.latoBold_textCustomColor_16,)),
                        ),
                        SizedBox(height: 6,),
                        Container(
                          margin: EdgeInsets.only(left: 20,right: 20),
                          child: Container(
                            width: double.infinity,
                            height: 70,
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
                            child: PKCNICInputField(
                              prefixIconColor: AppAssets.textLightColor,
                              cursorColor: AppAssets.primaryColor,
                              onChanged: (value) {
                                userCNICController.text = value;
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 30,),
                        PrimaryButton(
                          width: double.infinity,
                          height: 60,
                          buttonMargin: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 30),
                          buttonPadding: const EdgeInsets.all(12),
                          buttonText: "Update Information",
                          buttonTextStyle: AppAssets.latoBold_whiteColor_16,
                          shadowColor: AppAssets.shadowColor,
                          buttonRadius: BorderRadius.circular(30),
                          onPress: () {
                            if(nameController.text.isEmpty){
                              MyMessage.showFailedMessage("Incomplete Data, PLease fill all your details", context);
                            } else if(emailController.text.isEmpty){
                              MyMessage.showFailedMessage("Incomplete Data, PLease fill all your details", context);
                            } else if(phoneController.text.isEmpty){
                              MyMessage.showFailedMessage("Incomplete Data, PLease fill all your details", context);
                            } else if(qualificationController.text.isEmpty){
                              MyMessage.showFailedMessage("Incomplete Data, PLease fill all your details", context);
                            } else if(designationController.text.isEmpty){
                              MyMessage.showFailedMessage("Incomplete Data, PLease fill all your details", context);
                            } else if(addressController.text.isEmpty){
                              MyMessage.showFailedMessage("Incomplete Data, PLease fill all your details", context);
                            } else if(userSpecializedFieldController.text.isEmpty){
                              MyMessage.showFailedMessage("Incomplete Data, PLease fill all your details", context);
                            } else if(genderSelectedValue == "Select Gender"){
                              MyMessage.showFailedMessage("Incomplete Data, PLease fill all your details", context);
                            } else if(dptSelectedValue.departmentId == 0){
                              MyMessage.showFailedMessage("Incomplete Data, PLease fill all your details", context);
                            } else if(imageData == null){
                              MyMessage.showFailedMessage("Incomplete Data, PLease fill all your details", context);
                            } else {
                              UserModel userModel = UserModel(
                                  userId: widget.teacherModel.userModel.userId,
                                  userName: nameController.text,
                                  userEmail: widget.teacherModel.userModel.userEmail,
                                  userPassword: "",
                                  userPhone: phoneController.text,
                                  userSession: "",
                                  userRollNo: "",
                                  userGender: genderSelectedValue,
                                  userDepartment: dptSelectedValue.departmentId == 0 ? widget.teacherModel.departmentModel.departmentId.toString() : dptSelectedValue.departmentId.toString(),
                                  userClass: "",
                                  userQualification: qualificationController.text,
                                  userDesignation: designationController.text,
                                  userImage: "",
                                  userType: "teacher",
                                  userStatus: statusSelectedValue == "Select Status" ? widget.teacherModel.userModel.userStatus : statusSelectedValue == "Active" ? "active" : "in_active",
                                  totalAllowedCreditHours: int.parse(userTotalAllowedCreditHours.text),
                                  userAddress: addressController.text,
                                  userExaminationPassedMPhil: "M.Phil",
                                  mPhilPassedExamSubject: mPhilPassedExamSubjectController.text,
                                  mPhilPassedExamYear: mPhilPassedExamYearController.text,
                                  mPhilPassedExamDivision: mPhilPassedExamDivisionController.text,
                                  mPhilPassedExamInstitute: mPhilPassedExamInstituteController.text,
                                  userExaminationPassedPhd: "PhD",
                                  phdPassedExamSubject: phdPassedExamSubjectController.text,
                                  phdPassedExamYear: phdPassedExamYearController.text,
                                  phdPassedExamDivision: phdPassedExamDivisionController.text,
                                  phdPassedExamInstitute: phdPassedExamInstituteController.text,
                                  userSpecializedField: userSpecializedFieldController.text,
                                  userGraduationLevelExperience: userGraduationLevelExperienceController.text,
                                  userPostGraduationLevelExperience: userPostGraduationLevelExperienceController.text,
                                  userSignature: "userSignature",
                                  userCnic: userCNICController.text.toString());

                              Provider.of<AuthProvider>(context, listen: false).teacherRegistration(userModel, imageData).then((value) {
                                if(value.isSuccess){
                                  MyMessage.showSuccessMessage(value.message, context);
                                }else{
                                  MyMessage.showFailedMessage(value.message, context);
                                }
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
