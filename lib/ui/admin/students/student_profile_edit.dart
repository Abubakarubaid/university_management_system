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
import 'package:university_management_system/models/class_model.dart';
import 'package:university_management_system/providers/auth_provider.dart';
import 'package:university_management_system/utilities/base/my_message.dart';
import 'package:university_management_system/utilities/shared_preference_manager.dart';
import '../../../assets/app_assets.dart';
import 'package:pk_cnic_input_field/pk_cnic_input_field.dart';
import 'dart:ui' as ui;

import '../../../models/dpt_model.dart';
import '../../../models/student_model.dart';
import '../../../models/teacher_model.dart';
import '../../../models/user_model.dart';
import '../../../providers/app_provider.dart';
import '../../../utilities/constants.dart';
import '../../../widgets/primary_button.dart';
import '../../../widgets/primary_dropdown_field.dart';
import '../../../widgets/primary_text_field.dart';
import '../../../widgets/profile_image_pick.dart';
import '../../../widgets/progress_bar.dart';

class StudentProfileEdit extends StatefulWidget {
  StudentModel studentModel;
  StudentProfileEdit({required this.studentModel, Key? key}) : super(key: key);

  @override
  State<StudentProfileEdit> createState() => _StudentProfileEditState();
}

class _StudentProfileEditState extends State<StudentProfileEdit> {

  final SignatureController _signatureController = SignatureController(
    penStrokeWidth: 2,
    penColor: Colors.blue,
    exportBackgroundColor: Colors.transparent,
  );
  Uint8List? imageData;

  TextEditingController nameController=TextEditingController();
  TextEditingController emailController=TextEditingController();
  TextEditingController phoneController=TextEditingController();
  TextEditingController sessionController=TextEditingController();
  TextEditingController rollNoController=TextEditingController();
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

  List<ClassModel> classList = [];
  ClassModel classSelectedValue = ClassModel(classId: 0, className: "Select Class", classSemester: "", classType: "", departmentModel: DepartmentModel.getInstance());
  var classItems;

  var signatureBytes = null;
  var imageSignature = null;
  var data;
  UserModel userModel = UserModel.getInstance();

  String authToken = "";

  @override
  void initState() {
    super.initState();

    Constants.getAuthToken().then((value) {
      authToken = value;
    });

    getMyData();
    getDepartments();
    getClasses(false);
  }

  void getMyData() {
      nameController.text = widget.studentModel.userModel.userName == "null" ? "" : widget.studentModel.userModel.userName;
      emailController.text = widget.studentModel.userModel.userEmail == "null" ? "" : widget.studentModel.userModel.userEmail;
      phoneController.text = widget.studentModel.userModel.userPhone == "null" ? "" : widget.studentModel.userModel.userPhone;
      sessionController.text = widget.studentModel.userModel.userSession == "null" ? "" : widget.studentModel.userModel.userSession;
      rollNoController.text = widget.studentModel.userModel.userRollNo == "null" ? "" : widget.studentModel.userModel.userRollNo;
      addressController.text = widget.studentModel.userModel.userAddress == "null" ? "" : widget.studentModel.userModel.userAddress;
      userCNICController.text = widget.studentModel.userModel.userCnic == "null" ? "" : widget.studentModel.userModel.userCnic;
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

  void getClasses(bool specific) async {
    if(!specific) {
      Provider.of<AppProvider>(context, listen: false).fetchAllClasses(Constants.getAuthToken().toString()).then((value) {
        setState(() {
          classList = Provider.of<AppProvider>(context, listen: false).classList;
          classList.add(classSelectedValue);
          classList.sort((a, b) => a.classId.compareTo(b.classId));
          classItems = classList.map((item) {
            return DropdownMenuItem<ClassModel>(
              child: Text("${item.className} ${item.classSemester} ${item
                  .classType}"),
              value: item,
            );
          }).toList();

          // if list is empty, create a dummy item
          if (classItems.isEmpty) {
            classItems = [
              DropdownMenuItem(
                child: Text(classSelectedValue.className),
                value: classSelectedValue,
              )
            ];
          } else {
            classSelectedValue = classList[0];
          }
        });
      });
    }
    else{
      setState(() {
        classSelectedValue = classList[0];

        List<ClassModel> searchedList = [];
        classList.forEach((element) {
          if(dptSelectedValue.departmentId == element.departmentModel.departmentId){
            searchedList.add(element);
          }
        });

        classItems = searchedList.map((item) {
          return DropdownMenuItem<ClassModel>(
            child: Text("${item.className} ${item.classSemester} ${item
                .classType}"),
            value: item,
          );
        }).toList();

        // if list is empty, create a dummy item
        if (classItems.isEmpty) {
          classItems = [
            DropdownMenuItem(
              child: Text(classSelectedValue.className),
              value: classSelectedValue,
            )
          ];
        } else {
          classSelectedValue = searchedList[0];
        }
      });
    }
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
                        child: Text("Update Student's Data",style: AppAssets.latoBold_textDarkColor_20,)),
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
                              child: Text("Session",style: AppAssets.latoBold_textCustomColor_16,)),
                        ),
                        SizedBox(height: 6,),
                        Container(
                          margin: EdgeInsets.only(left: 20,right: 20),
                          child: PrimaryTextFiled(controller: sessionController,onChange: (value){},hint: "Enter Session",keyboardType: TextInputType.text,),
                        ),
                        SizedBox(height: 20,),
                        Container(
                          margin: EdgeInsets.only(left: 22),
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Text("Roll No",style: AppAssets.latoBold_textCustomColor_16,)),
                        ),
                        SizedBox(height: 6,),
                        Container(
                          margin: EdgeInsets.only(left: 20,right: 20),
                          child: PrimaryTextFiled(controller: rollNoController,onChange: (value){},hint: "Enter RollNo",keyboardType: TextInputType.text,),
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
                              child: Text("Gender: (${widget.studentModel.userModel.userGender})",style: AppAssets.latoBold_textCustomColor_16,)),
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
                              child: Text("Status: (${widget.studentModel.userModel.userStatus})",style: AppAssets.latoBold_textCustomColor_16,)),
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
                              child: Text("Department: (${widget.studentModel.departmentModel.departmentName})",style: AppAssets.latoBold_textCustomColor_16, maxLines: 1, overflow: TextOverflow.ellipsis,),),
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
                                  getClasses(true);
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
                            child: Text("Class: (${widget.studentModel.classModel.className} ${widget.studentModel.classModel.classSemester} ${widget.studentModel.classModel.classType})",style: AppAssets.latoBold_textCustomColor_16, maxLines: 1, overflow: TextOverflow.ellipsis,),),
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
                            child: DropdownButton<ClassModel>(
                              value: classSelectedValue,
                              icon: const Icon(Icons.arrow_drop_down),
                              underline: Container(
                                height: 0,
                                color: Colors.transparent,
                              ),
                              isExpanded: true,
                              onChanged: (value) {
                                setState(() {
                                  classSelectedValue = value!;
                                });
                              },
                              items: classItems,
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
                              } else if(sessionController.text.isEmpty){
                                MyMessage.showFailedMessage("Incomplete Data, PLease fill all your details", context);
                              } else if(rollNoController.text.isEmpty){
                                MyMessage.showFailedMessage("Incomplete Data, PLease fill all your details", context);
                              } else if(addressController.text.isEmpty){
                                MyMessage.showFailedMessage("Incomplete Data, PLease fill all your details", context);
                              } else if(genderSelectedValue == "Select Gender"){
                                MyMessage.showFailedMessage("Incomplete Data, PLease fill all your details", context);
                              } else if(dptSelectedValue.departmentId == 0){
                                MyMessage.showFailedMessage("Incomplete Data, PLease fill all your details", context);
                              } else {
                                UserModel userModel = UserModel(
                                    userId: widget.studentModel.userModel.userId,
                                    userName: nameController.text,
                                    userEmail: widget.studentModel.userModel.userEmail,
                                    userPassword: "123456789",
                                    userPhone: phoneController.text,
                                    userSession: sessionController.text,
                                    userRollNo: rollNoController.text,
                                    userGender: genderSelectedValue,
                                    userDepartment: dptSelectedValue.departmentId == 0 ? widget.studentModel.departmentModel.departmentId.toString() : dptSelectedValue.departmentId.toString(),
                                    userClass: dptSelectedValue.departmentId == 0 ? widget.studentModel.classModel.classId.toString() : dptSelectedValue.departmentId.toString(),
                                    userQualification: "",
                                    userDesignation: "",
                                    userImage: "",
                                    userType: "student",
                                    userStatus: statusSelectedValue == "Select Status" ? widget.studentModel.userModel.userStatus : statusSelectedValue == "Active" ? "active" : "in_active",
                                    totalAllowedCreditHours: 0,
                                    userAddress: addressController.text,
                                    userExaminationPassedMPhil: "",
                                    mPhilPassedExamSubject: "",
                                    mPhilPassedExamYear: "",
                                    mPhilPassedExamDivision: "",
                                    mPhilPassedExamInstitute: "",
                                    userExaminationPassedPhd: "PhD",
                                    phdPassedExamSubject: "",
                                    phdPassedExamYear: "",
                                    phdPassedExamDivision: "",
                                    phdPassedExamInstitute: "",
                                    userSpecializedField: "",
                                    userGraduationLevelExperience: "",
                                    userPostGraduationLevelExperience: "",
                                    userSignature: "",
                                    userCnic: userCNICController.text.toString());

                                StudentModel model = StudentModel.getInstance();
                                model.userModel = userModel;
                                model.departmentModel = dptSelectedValue;
                                model.classModel = classSelectedValue;

                                Provider.of<AppProvider>(context, listen: false).updateStudent(model, authToken).then((value) async {
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
