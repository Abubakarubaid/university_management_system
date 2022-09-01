import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pk_cnic_input_field/pk_cnic_input_field.dart';
import 'package:provider/provider.dart';
import 'package:university_management_system/models/class_model.dart';
import 'package:university_management_system/models/student_model.dart';
import 'package:university_management_system/utilities/base/my_message.dart';
import 'package:university_management_system/widgets/no_data.dart';
import 'package:university_management_system/widgets/primary_button.dart';
import 'package:university_management_system/widgets/primary_dropdown_field.dart';
import 'package:university_management_system/widgets/primary_search_field.dart';
import 'package:university_management_system/widgets/primary_text_field.dart';
import '../../../assets/app_assets.dart';
import '../../../models/dpt_model.dart';
import '../../../models/user_model.dart';
import '../../../providers/app_provider.dart';
import '../../../utilities/constants.dart';
import '../../../widgets/progress_bar.dart';

class AddStudents extends StatefulWidget {
  StudentModel studentModel;
  List<DepartmentModel> departmentList;
  List<ClassModel> classList;
  AddStudents({required this.departmentList, required this.classList, required this.studentModel, Key? key}) : super(key: key);

  @override
  State<AddStudents> createState() => _AddStudentsState();
}

class _AddStudentsState extends State<AddStudents> {

  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var rollNoController = TextEditingController();
  var phoneController = TextEditingController();
  var sessionController = TextEditingController();
  var statusController = TextEditingController();
  var addressController = TextEditingController();
  var cnicController = TextEditingController();

  var itemsGender = [
    "Select Gender",
    "Male",
    "Female",
    "Others",
  ];
  String genderSelectedValue = "Select Gender";

  var itemsStatus = [
    "Select Status",
    "Active",
    "Inactive",
    "Suspended",
  ];
  String statusSelectedValue = "Select Status";

  DepartmentModel dptSelectedValue = DepartmentModel(departmentId: 0, departmentName: "Select Department", departmentType: "Demo");
  var departmentItems;

  ClassModel classSelectedValue = ClassModel(classId: 0, className: "Select Class", classSemester: "", classType: "", departmentModel: DepartmentModel.getInstance());
  var classItems;

  String authToken = "";

  @override
  void initState() {
    super.initState();

    //Provider.of<AppProvider>(context, listen: false).progressReset();

    Constants.getAuthToken().then((value) {
      authToken = value;
    });

    getDepartments();
    getClasses(false);
  }

  void getDepartments() async {
    setState(() {
      departmentItems = widget.departmentList.map((item) {
        return DropdownMenuItem<DepartmentModel>(
          child: Text(item.departmentName),
          value: item,
        );
      }).toList();

      // if list is empty, create a dummy item
      if (departmentItems.isEmpty) {
        departmentItems = [
          DropdownMenuItem(
            child: Text(dptSelectedValue.departmentName),
            value: dptSelectedValue,
          )
        ];
      }else{
        dptSelectedValue = widget.departmentList[0];
      }
    });
  }

  void getClasses(bool specific) async {
    if(!specific) {
      setState(() {
        classItems = widget.classList.map((item) {
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
          classSelectedValue = widget.classList[0];
        }
      });
    }
    else{
      setState(() {
        classSelectedValue = widget.classList[0];

        List<ClassModel> searchedList = [];
        widget.classList.forEach((element) {
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
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: AppAssets.backgroundColor,
          child: Stack(children: [
            Container(
              margin: const EdgeInsets.only(top: 60, left: 20, right: 20),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(children: [
                  const SizedBox(height: 30,),
                  PrimaryTextFiled(
                      controller: nameController,
                      hint: "Student Name",
                      keyboardType: TextInputType.text,
                      onChange: (text) {
                        print("-------------:${text}" );
                      }
                  ),
                  const SizedBox(height: 20,),
                  PrimaryTextFiled(
                      controller: rollNoController,
                      hint: "Student Roll No",
                      keyboardType: TextInputType.text,
                      onChange: (text) {
                        print("-------------:${text}" );
                      }
                  ),
                  const SizedBox(height: 20,),
                  PrimaryTextFiled(
                      controller: phoneController,
                      hint: "Student Phone No",
                      keyboardType: TextInputType.phone,
                      onChange: (text) {
                        print("-------------:${text}" );
                      }
                  ),
                  const SizedBox(height: 20,),
                  PrimaryTextFiled(
                      controller: sessionController,
                      hint: "Student Session",
                      keyboardType: TextInputType.number,
                      onChange: (text) {
                        print("-------------:${text}" );
                      }
                  ),
                  const SizedBox(height: 20,),
                  PrimaryTextFiled(
                      controller: addressController,
                      hint: "Address",
                      keyboardType: TextInputType.number,
                      onChange: (text) {
                        print("-------------:${text}" );
                      }
                  ),
                  const SizedBox(height: 20,),
                  Container(
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
                        cnicController.text = value;
                      },
                    ),
                  ),
                  const SizedBox(height: 20,),
                  PrimaryDropDownFiled(
                      hint: "Select Gender",
                      selectedValue: genderSelectedValue,
                      items: itemsGender,
                      onChange: (text) {
                        setState(() {
                          genderSelectedValue = text.toString();
                        });
                      }
                  ),
                  Container(
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      margin: const EdgeInsets.only(top: 20),
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
                        items: departmentItems,
                      ),
                    ),
                  ),
                  Container(
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      margin: const EdgeInsets.only(top: 20),
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
                  const SizedBox(height: 30,),
                  Visibility(
                    visible: !Provider.of<AppProvider>(context, listen: true).progress,
                    child: PrimaryButton(
                      width: double.infinity,
                      height: 50,
                      buttonMargin: const EdgeInsets.only(top: 20, bottom: 30),
                      buttonPadding: const EdgeInsets.all(12),
                      buttonText: "Add Student",
                      buttonTextStyle: AppAssets.latoBold_whiteColor_16,
                      shadowColor: AppAssets.shadowColor,
                      buttonRadius: BorderRadius.circular(30),
                      onPress: () {
                        StudentModel studentModel = StudentModel.getInstance();
                        if(nameController.text.isEmpty){
                          MyMessage.showFailedMessage("Student name is missing", context);
                        } else if(rollNoController.text.isEmpty){
                          MyMessage.showFailedMessage("Student rollno is missing", context);
                        } else if(phoneController.text.isEmpty){
                          MyMessage.showFailedMessage("Student phone is missing", context);
                        } else if(sessionController.text.isEmpty){
                          MyMessage.showFailedMessage("Student session is missing", context);
                        } else if(addressController.text.isEmpty){
                          MyMessage.showFailedMessage("Student address is missing", context);
                        } else if(cnicController.text.isEmpty){
                          MyMessage.showFailedMessage("Student cnic is missing", context);
                        } else if(genderSelectedValue == "Select Gender"){
                          MyMessage.showFailedMessage("Student gender is missing", context);
                        } else if(dptSelectedValue.departmentId == 0){
                          MyMessage.showFailedMessage("Student department is missing", context);
                        } else if(classSelectedValue.classId == 0){
                          MyMessage.showFailedMessage("Student class is missing", context);
                        }else{
                          studentModel.userModel.userName = nameController.text;
                          studentModel.userModel.userEmail = "${rollNoController.text}@uoc.edu.pk";
                          studentModel.userModel.userPassword = "123456789";
                          studentModel.userModel.userPhone = phoneController.text;
                          studentModel.userModel.userSession = sessionController.text;
                          studentModel.userModel.userRollNo = rollNoController.text;
                          studentModel.userModel.userGender = genderSelectedValue == "Male" ? "male" : genderSelectedValue == "Female" ? "female" : "others";
                          studentModel.userModel.userCnic = cnicController.text;
                          studentModel.userModel.userAddress = addressController.text;
                          studentModel.userModel.userDepartment = dptSelectedValue.departmentId.toString();
                          studentModel.userModel.userClass = classSelectedValue.classId.toString();
                          studentModel.userModel.userType = "student";
                          studentModel.userModel.userStatus = statusSelectedValue == "Select Status" ? "active" : statusSelectedValue == "Active" ? "active" : statusSelectedValue == "Inactive" ? "in_active" : "suspended";
                          studentModel.departmentModel = dptSelectedValue;
                          studentModel.classModel = classSelectedValue;


                            Provider.of<AppProvider>(context, listen: false).addStudent(studentModel, authToken).then((value) async {
                              if(value.isSuccess){
                                MyMessage.showSuccessMessage(value.message, context);
                                await Future.delayed(const Duration(milliseconds: 2000),(){
                                  Navigator.of(context).pop();
                                });
                              }else{
                                MyMessage.showFailedMessage(value.message, context);
                              }
                            });


                        }
                      },
                    ),
                  ),
                  Visibility(visible: Provider.of<AppProvider>(context, listen: true).progress, child: const SizedBox(height: 80,child: ProgressBarWidget())),
                ],),
              ),
            ),
            Container(
              width: double.infinity,
              height: 60,
              padding: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                  color: AppAssets.whiteColor,
                  boxShadow: [
                    BoxShadow(
                      color: AppAssets.shadowColor.withOpacity(0.3),
                      spreadRadius: 6,
                      blurRadius: 12,
                      offset: const Offset(0, 6), // changes position of shadow
                    )]
              ),
              child: Row(children: [
                GestureDetector(onTap: () {Navigator.of(context).pop();}, child: Container(padding: const EdgeInsets.all(16), height: 50, width: 50, child: SvgPicture.asset(AppAssets.backArrowIcon, color: AppAssets.iconsTintDarkGreyColor,))),
                Expanded(child: Container(padding: const EdgeInsets.only(left: 20, right: 20), child: Center(child: Text("Add Student", style: AppAssets.latoBold_textDarkColor_20)))),
                GestureDetector(
                  onTap: () {
                  },
                    child: Container(padding: const EdgeInsets.all(10), height: 50, width: 50,)),
              ],),
            ),
          ]),
        ),
      ),
    );
  }
}
