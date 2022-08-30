import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:university_management_system/models/subject_model.dart';
import 'package:university_management_system/models/teacher_model.dart';
import 'package:university_management_system/models/workload_assignment_model.dart';
import 'package:university_management_system/ui/teacher/teacher_attendance/fetch_attendance.dart';
import 'package:university_management_system/ui/teacher/teacher_subjects/teacher_classes.dart';
import 'package:university_management_system/widgets/no_data.dart';
import 'package:university_management_system/widgets/primary_button.dart';
import 'package:university_management_system/widgets/primary_text_field.dart';
import '../../../assets/app_assets.dart';
import '../../../models/class_model.dart';
import '../../../models/dpt_model.dart';
import '../../../models/teacher_model_credithours.dart';
import '../../../models/user_model.dart';
import '../../../providers/app_provider.dart';
import '../../../utilities/base/my_message.dart';
import '../../../utilities/constants.dart';
import '../../../widgets/primary_dropdown_field.dart';
import '../../../widgets/progress_bar.dart';
import 'fetch_workloads.dart';

class WorkloadAssignment extends StatefulWidget {
  const WorkloadAssignment({Key? key}) : super(key: key);

  @override
  State<WorkloadAssignment> createState() => _WorkloadAssignmentState();
}

class _WorkloadAssignmentState extends State<WorkloadAssignment> {

  var itemsDemand = [
    "Select Payment Demand",
    "Demanded",
    "Not Demanded",
  ];
  String demandSelectedValue = "Select Payment Demand";

  var itemsRoutine = [
    "Select Class Routine",
    "Once a Week",
    "Two Times a Week",
    "Three Times a Week",
  ];
  String routineSelectedValue = "Select Class Routine";

  List<DepartmentModel> departmentList = [];
  DepartmentModel dptSelectedValue = DepartmentModel(departmentId: 0, departmentName: "Select Department", departmentType: "Demo");
  var departmentItems;

  List<ClassModel> classList = [];
  ClassModel classSelectedValue = ClassModel(classId: 0, className: "Select Class", classSemester: "", classType: "", departmentModel: DepartmentModel.getInstance());
  var classItems;

  List<SubjectModel> subjectList = [];
  SubjectModel subjectSelectedValue = SubjectModel(subjectId: 0, subjectCode: "", subjectName: "Select Subject", creditHours: 0, departmentModel: DepartmentModel.getInstance());
  var subjectItems;

  List<TeacherModel> teacherList = [];
  TeacherModel teacherSelectedValue = TeacherModel(userModel: UserModel.getInstance(), departmentModel: DepartmentModel.getInstance(), workloadList: []);
  var teacherItems;

  String authToken = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Constants.getAuthToken().then((value) {
      authToken = value;
    });

    getDepartments(false);
    getClasses(false);
    getSubjects(false);
    getTeachers(false);
  }

  void getDepartments(bool specific) async {
    if(!specific){
      Provider.of<AppProvider>(context, listen: false).fetchAllDepartments(Constants.getAuthToken().toString()).then((value) {
        setState(() {
          if(value.isSuccess){
            departmentList.clear();
            departmentList = Provider.of<AppProvider>(context, listen: false).departmentList;
            departmentList.add(dptSelectedValue);
            departmentList.sort((a, b) => a.departmentId.compareTo(b.departmentId));

            departmentItems = departmentList.map((item) {
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
              dptSelectedValue = departmentList[0];
            }
          }
        });
      });
    }
    else{
      setState(() {
        dptSelectedValue = departmentList[0];
        getSubjects(true);
        getTeachers(true);
        getClasses(true);
      });
    }

  }

  void getClasses(bool specific) async {
    if(!specific) {
      classList.clear();
      Provider.of<AppProvider>(context, listen: false).fetchAllClasses(
          Constants.getAuthToken().toString()).then((value) {
        setState(() {
          if (value.isSuccess) {
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

  void getSubjects(bool specific) async {
    if(!specific) {
      subjectList.clear();
      Provider.of<AppProvider>(context, listen: false).fetchAllSubjects(
          Constants.getAuthToken().toString()).then((value) {
        setState(() {
          if (value.isSuccess) {
            subjectList = Provider.of<AppProvider>(context, listen: false).subjectList;
            subjectList.add(subjectSelectedValue);
            subjectList.sort((a, b) => a.subjectId.compareTo(b.subjectId));

            subjectItems = subjectList.map((item) {
              return DropdownMenuItem<SubjectModel>(
                child: Text("${item.subjectName}"),
                value: item,
              );
            }).toList();

            // if list is empty, create a dummy item
            if (subjectItems.isEmpty) {
              subjectItems = [
                DropdownMenuItem(
                  child: Text(subjectSelectedValue.subjectName),
                  value: subjectSelectedValue,
                )
              ];
            } else {
              subjectSelectedValue = subjectList[0];
            }
          }
        });
      });
    }
    else{
      setState(() {
        subjectSelectedValue = subjectList[0];

        List<SubjectModel> searchedList = [];
        subjectList.forEach((element) {
          if(dptSelectedValue.departmentId == element.departmentModel.departmentId){
            searchedList.add(element);
          }
        });

        subjectItems = searchedList.map((item) {
          return DropdownMenuItem<SubjectModel>(
            child: Text("${item.subjectName}"),
            value: item,
          );
        }).toList();

        // if list is empty, create a dummy item
        if (subjectItems.isEmpty) {
          subjectItems = [
            DropdownMenuItem(
              child: Text(subjectSelectedValue.subjectName),
              value: subjectSelectedValue,
            )
          ];
        } else {
          subjectSelectedValue = searchedList[0];
        }
      });
    }
  }

  void getTeachers(bool specific) async {
    if(!specific) {
      teacherList.clear();
      Provider.of<AppProvider>(context, listen: false).fetchAllTeachers(true, "teacher",
          Constants.getAuthToken().toString()).then((value) {
        setState(() {
          if (value.isSuccess) {
            teacherList = Provider.of<AppProvider>(context, listen: false).teacherList;
            teacherList.add(teacherSelectedValue);
            teacherList.sort((a, b) => a.userModel.userId.compareTo(b.userModel.userId));

            teacherItems = teacherList.map((item) {
              return DropdownMenuItem<TeacherModel>(
                child: Text("${item.userModel.userName}"),
                value: item,
              );
            }).toList();

            // if list is empty, create a dummy item
            if (teacherItems.isEmpty) {
              teacherItems = [
                DropdownMenuItem(
                  child: Text(teacherSelectedValue.userModel.userName),
                  value: teacherSelectedValue,
                )
              ];
            } else {
              teacherSelectedValue = teacherList[0];
            }
          }
        });
      });
    }
    else{
      setState(() {
        teacherSelectedValue = teacherList[0];

        List<TeacherModel> searchedList = [];
        teacherList.forEach((element) {
          if(dptSelectedValue.departmentId == element.departmentModel.departmentId){
            searchedList.add(element);
          }
        });

        teacherItems = searchedList.map((item) {
          return DropdownMenuItem<TeacherModel>(
            child: Text("${item.userModel.userName}"),
            value: item,
          );
        }).toList();

        // if list is empty, create a dummy item
        if (teacherItems.isEmpty) {
          teacherItems = [
            DropdownMenuItem(
              child: Text(teacherSelectedValue.userModel.userName),
              value: teacherSelectedValue,
            )
          ];
        } else {
          teacherSelectedValue = searchedList[0];
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<AppProvider>(builder: (context, appProvider, child) => Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: AppAssets.backgroundColor,
          child: Stack(children: [
            Opacity(opacity: 0.05, child: Center(child: Image.asset(AppAssets.overloadIcon,))),
            Container(
              height: double.infinity,
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(children: [
                  const SizedBox(height: 80,),
                  Image.asset(AppAssets.overloadIcon, width: 100, height: 100,),
                  const SizedBox(height: 30,),
                  Text("Please Select Department, Class, Subject & Teacher to Assign Class and Subject", textAlign: TextAlign.center, style: AppAssets.latoBold_textDarkColor_20,),
                  const SizedBox(height: 30,),
                  Container(
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
                          getSubjects(true);
                          getTeachers(true);
                        });
                      },
                      items: departmentItems,
                    ),
                  ),
                  const SizedBox(height: 20,),
                  Container(
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
                  const SizedBox(height: 20,),
                  Container(
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
                    child: DropdownButton<SubjectModel>(
                      value: subjectSelectedValue,
                      icon: const Icon(Icons.arrow_drop_down),
                      underline: Container(
                        height: 0,
                        color: Colors.transparent,
                      ),
                      isExpanded: true,
                      onChanged: (value) {
                        setState(() {
                          subjectSelectedValue = value!;
                        });
                      },
                      items: subjectItems,
                    ),
                  ),
                  const SizedBox(height: 20,),
                  Container(
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
                    child: DropdownButton<TeacherModel>(
                      value: teacherSelectedValue,
                      icon: const Icon(Icons.arrow_drop_down),
                      underline: Container(
                        height: 0,
                        color: Colors.transparent,
                      ),
                      isExpanded: true,
                      onChanged: (value) {
                        setState(() {
                          teacherSelectedValue = value!;
                        });
                      },
                      items: teacherItems,
                    ),
                  ),
                  const SizedBox(height: 20,),
                  PrimaryDropDownFiled(
                      hint: "Select Payment Demand",
                      selectedValue: demandSelectedValue,
                      items: itemsDemand,
                      onChange: (text) {
                        setState(() {
                          demandSelectedValue = text.toString();
                        });
                      }
                  ),
                  const SizedBox(height: 20,),
                  PrimaryDropDownFiled(
                      hint: "Select Class Routine",
                      selectedValue: routineSelectedValue,
                      items: itemsRoutine,
                      onChange: (text) {
                        setState(() {
                          routineSelectedValue = text.toString();
                        });
                      }
                  ),
                  const SizedBox(height: 30,),
                  Visibility(
                    visible: !appProvider.progress,
                    child: PrimaryButton(
                      width: double.infinity,
                      height: 50,
                      buttonMargin: const EdgeInsets.only(top: 20, bottom: 10),
                      buttonPadding: const EdgeInsets.all(12),
                      buttonText: "Assign Class",
                      buttonTextStyle: AppAssets.latoBold_whiteColor_16,
                      shadowColor: AppAssets.shadowColor,
                      buttonRadius: BorderRadius.circular(30),
                      onPress: () {
                        if(dptSelectedValue.departmentId == 0){
                          MyMessage.showFailedMessage("Please choose Department", context);
                        }else if(classSelectedValue.classId == 0){
                          MyMessage.showFailedMessage("Please choose Class", context);
                        }else if(subjectSelectedValue.subjectId == 0){
                          MyMessage.showFailedMessage("Please choose Subject", context);
                        }else if(teacherSelectedValue.userModel.userId == 0){
                          MyMessage.showFailedMessage("Please choose Teacher", context);
                        }else if(demandSelectedValue == "Select Payment Demand"){
                          MyMessage.showFailedMessage("Please choose Payment Demand", context);
                        }else if(routineSelectedValue == "Select Class Routine"){
                          MyMessage.showFailedMessage("Please choose Class Routine", context);
                        }else {
                          WorkloadAssignmentModel model = WorkloadAssignmentModel.getInstance();
                          model.userModel = teacherSelectedValue.userModel;
                          model.departmentModel = dptSelectedValue;
                          model.classModel = classSelectedValue;
                          model.subjectModel = subjectSelectedValue;
                          model.workDemanded = demandSelectedValue;
                          model.workloadStatus = "Active";
                          model.classRoutine = routineSelectedValue;

                          Provider.of<AppProvider>(context, listen: false).addWorkload(model, authToken).then((value) {
                            if(value.isSuccess){
                              setState(() {
                                model = WorkloadAssignmentModel.getInstance();
                                demandSelectedValue = "Select Payment Demand";
                                routineSelectedValue = "Select Class Routine";
                                getDepartments(true);
                              });
                              MyMessage.showSuccessMessage(value.message, context);
                            }else{
                              MyMessage.showFailedMessage(value.message, context);
                            }
                          });
                        }
                      },
                    ),
                  ),
                  Text("OR"),
                  Visibility(
                    visible: !appProvider.progress,
                    child: PrimaryButton(
                      width: double.infinity,
                      height: 50,
                      buttonMargin: const EdgeInsets.only(top: 10, bottom: 30),
                      buttonPadding: const EdgeInsets.all(12),
                      buttonText: "View all Workload",
                      buttonTextStyle: AppAssets.latoBold_whiteColor_16,
                      shadowColor: AppAssets.shadowColor,
                      buttonRadius: BorderRadius.circular(30),
                      onPress: () {
                        if(dptSelectedValue.departmentId == 0){
                          MyMessage.showFailedMessage("Please Select Department first", context);
                        }else {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => FetchWorkloads(departmentModel: dptSelectedValue,)));
                        }
                      },
                    ),
                  ),
                  Visibility(visible: appProvider.progress, child: const SizedBox(height:80, child: ProgressBarWidget())),
                ],),
              ),
            ),
            Container(
              width: double.infinity,
              height: 60,
              padding: const EdgeInsets.only(left: 0, right: 10),
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
                Expanded(child: Container(padding: const EdgeInsets.only(left: 20, right: 20), child: Center(child: Text("Workload", style: AppAssets.latoBold_textDarkColor_20)))),
                Container(padding: const EdgeInsets.all(10), height: 50, width: 50,),
              ],),
            ),
          ]),
        ),),
      ),
    );
  }
}
