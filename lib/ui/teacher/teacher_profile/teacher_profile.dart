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
import 'package:university_management_system/models/user_model.dart';
import 'package:university_management_system/providers/auth_provider.dart';
import 'package:university_management_system/utilities/base/my_message.dart';
import 'package:university_management_system/utilities/shared_preference_manager.dart';
import '../../../assets/app_assets.dart';
import 'package:pk_cnic_input_field/pk_cnic_input_field.dart';
import 'dart:ui' as ui;

import '../../../models/dpt_model.dart';
import '../../../models/teacher_model.dart';
import '../../../providers/app_provider.dart';
import '../../../utilities/constants.dart';
import '../../../widgets/primary_button.dart';
import '../../../widgets/primary_dropdown_field.dart';
import '../../../widgets/primary_text_field.dart';
import '../../../widgets/profile_image_pick.dart';
import '../../../widgets/progress_bar.dart';

class TeacherProfile extends StatefulWidget {
  const TeacherProfile({Key? key}) : super(key: key);

  @override
  State<TeacherProfile> createState() => _TeacherProfileState();
}

class _TeacherProfileState extends State<TeacherProfile> {

  final SignatureController _signatureController = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
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
  UserModel tModel = UserModel.getInstance();

  String authToken = "";

  @override
  void initState() {
    super.initState();

    Constants.getAuthToken().then((value) {
      authToken = value;
    });

    getMyData();
    getDepartments();
  }

  void getMyData() async {
    await SharedPreferenceManager.getInstance().getUser().then((teacherModel) {
      tModel = teacherModel;
      nameController.text = teacherModel.userName == "null" ? "" : teacherModel.userName;
      emailController.text = teacherModel.userEmail == "null" ? "" : teacherModel.userEmail;
      phoneController.text = teacherModel.userPhone == "null" ? "" : teacherModel.userPhone;
      qualificationController.text = teacherModel.userQualification == "null" ? "" : teacherModel.userQualification;
      designationController.text = teacherModel.userDesignation == "null" ? "" : teacherModel.userDesignation;
      addressController.text = teacherModel.userAddress == "null" ? "" : teacherModel.userAddress;
      examPassedMPController.text = teacherModel.userExaminationPassedMPhil == "null" ? "" : teacherModel.userExaminationPassedMPhil;
      userExaminationPassedMPhilController.text = teacherModel.userExaminationPassedMPhil == "null" ? "" : teacherModel.userExaminationPassedMPhil;
      mPhilPassedExamSubjectController.text = teacherModel.mPhilPassedExamSubject == "null" ? "" : teacherModel.mPhilPassedExamSubject;
      mPhilPassedExamYearController.text = teacherModel.mPhilPassedExamYear == "null" ? "" : teacherModel.mPhilPassedExamYear;
      mPhilPassedExamDivisionController.text = teacherModel.mPhilPassedExamDivision == "null" ? "" : teacherModel.mPhilPassedExamDivision;
      mPhilPassedExamInstituteController.text = teacherModel.mPhilPassedExamInstitute == "null" ? "" : teacherModel.mPhilPassedExamInstitute;
      userExaminationPassedPhdController.text = teacherModel.userExaminationPassedPhd == "null" ? "" : teacherModel.userExaminationPassedPhd;
      phdPassedExamSubjectController.text = teacherModel.phdPassedExamSubject == "null" ? "" : teacherModel.phdPassedExamSubject;
      phdPassedExamYearController.text = teacherModel.phdPassedExamYear == "null" ? "" : teacherModel.phdPassedExamYear;
      phdPassedExamDivisionController.text = teacherModel.phdPassedExamDivision == "null" ? "" : teacherModel.phdPassedExamDivision;
      phdPassedExamInstituteController.text = teacherModel.phdPassedExamInstitute == "null" ? "" : teacherModel.phdPassedExamInstitute;
      userSpecializedFieldController.text = teacherModel.userSpecializedField == "null" ? "" : teacherModel.userSpecializedField;
      userGraduationLevelExperienceController.text = teacherModel.userGraduationLevelExperience == "null" ? "" : teacherModel.userGraduationLevelExperience;
      userPostGraduationLevelExperienceController.text = teacherModel.userPostGraduationLevelExperience == "null" ? "" : teacherModel.userPostGraduationLevelExperience;
      userSignatureController.text = teacherModel.userSignature == "null" ? signatureText="Add your Signature" : signatureText="Change Signature";
      userCNICController.text = teacherModel.userCnic == "null" ? "" : teacherModel.userCnic;
      userTotalAllowedCreditHours.text = teacherModel.totalAllowedCreditHours == 0 ? "0" : teacherModel.totalAllowedCreditHours.toString();
    });
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

  void _handleClearButtonPressed() {
    _signatureController.clear();
  }

  Future<void> _handleSaveButtonPressed() async {
    if (_signatureController.isEmpty) {
      return;
    }

    imageData = await _signatureController.toPngBytes();
    if (imageData == null) {
      return;
    }
  }

  Future<void> _signatureDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
            backgroundColor: AppAssets.backgroundColor,
            title: Center(child: Text('Signature', style: AppAssets.latoBlack_textDarkColor_20,)),
            content: StatefulBuilder(
                builder: (context, setState) => Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Container(
                    height: 200,
                    child: Stack(children: [
                      Container(
                        clipBehavior: Clip.antiAlias,
                        height: 200,
                        width: double.infinity,
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
                        child: Signature(
                          controller: _signatureController,
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                          onTap: () {
                            _handleClearButtonPressed();
                          },
                          child: Container(
                            width: 30,
                            height: 30,
                            padding: const EdgeInsets.all(3),
                            margin: const EdgeInsets.only(right: 10, top: 10),
                            child: SizedBox(
                                width: 50,
                                height: 50,
                                child: SvgPicture.asset(AppAssets.rejectIcon,)),
                          ),
                        ),
                      ),
                    ],),
                  ),
                ],)
            ),
            actions: true ? <Widget>[
              TextButton(
                child: Text('Save', style: AppAssets.latoBlack_primaryColor_16,),
                onPressed: () {
                  _handleSaveButtonPressed();
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Cancel', style: AppAssets.latoBlack_failureColor_15,),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ] : null
        );
      },
    );
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
                    Container(
                      margin: const EdgeInsets.only(left: 22),
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Text("Profile",style: AppAssets.latoBold_primaryColor_30,)),
                    ),
                    const SizedBox(height: 30,),
                    _imagePick,
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
                              child: Text("Gender: (${tModel.userGender})",style: AppAssets.latoBold_textCustomColor_16,)),
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
                              child: Text("CNIC (${tModel.userCnic})", style: AppAssets.latoBold_textCustomColor_16,)),
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
                        Container(
                          clipBehavior: Clip.antiAlias,
                          height: 80,
                          width: double.infinity,
                          margin: EdgeInsets.only(left: 20,right: 20),
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
                          child: Row(children: [
                            Container(
                              height: 80,
                              width: 80,
                              margin: EdgeInsets.only(right: 20),
                              child: imageData == null ? Image.asset(AppAssets.placeholder) : Image.memory(imageData!),
                            ),
                            GestureDetector(
                              onTap: () {
                                _signatureDialog();
                              },
                              child: Container(
                                margin: EdgeInsets.only(left: 22),
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(signatureBytes == null ? "Add your Signature" : "Signature Added",style: AppAssets.latoBold_textCustomColor_16,)),
                              ),
                            ),
                          ],),
                        ),
                        SizedBox(height: 30,),
                        Visibility(
                          visible: !Provider.of<AppProvider>(context, listen: true).progress,
                          child: PrimaryButton(
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
                              } else if(userCNICController.text.isEmpty){
                                MyMessage.showFailedMessage("Incomplete Data, PLease fill all your details", context);
                              } else {
                                UserModel userModel = UserModel(
                                    userId: tModel.userId,
                                    userName: nameController.text,
                                    userEmail: tModel.userEmail,
                                    userPassword: "",
                                    userPhone: phoneController.text,
                                    userSession: "",
                                    userRollNo: "",
                                    userGender: genderSelectedValue,
                                    userDepartment: tModel.userDepartment.toString(),
                                    userClass: tModel.userClass.toString(),
                                    userQualification: qualificationController.text,
                                    userDesignation: designationController.text,
                                    userImage: _imagePick.getUri().toString(),
                                    userType: "teacher",
                                    userStatus: tModel.userStatus,
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
                                    userSignature: "",
                                    userCnic: userCNICController.text.toString());
                                // imageData == null
                                TeacherModel model = TeacherModel.getInstance();
                                model.userModel = userModel;

                                Provider.of<AppProvider>(context, listen: false).updateTeacherProfile(model, imageData, authToken).then((value) async {
                                  if(value.isSuccess){
                                    MyMessage.showSuccessMessage(value.message, context);
                                    await Future.delayed(const Duration(milliseconds: 2000),(){});
                                    Navigator.of(context).pop();
                                  }else{
                                    MyMessage.showFailedMessage(value.message, context);
                                  }
                                });
                              }
                            },
                          ),
                        ),
                        Visibility(
                            visible: Provider.of<AppProvider>(context, listen: true).progress,
                            child: const SizedBox(height: 80, child: ProgressBarWidget())),

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
