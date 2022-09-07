import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:university_management_system/models/subject_model.dart';
import 'package:university_management_system/ui/teacher/teacher_attendance/fetch_attendance.dart';
import 'package:university_management_system/ui/teacher/teacher_subjects/teacher_classes.dart';
import 'package:university_management_system/widgets/no_data.dart';
import 'package:university_management_system/widgets/primary_button.dart';
import 'package:university_management_system/widgets/primary_text_field.dart';
import '../../../assets/app_assets.dart';
import '../../../models/class_model.dart';
import '../../../models/dpt_model.dart';
import '../../../models/single_teacher_model.dart';
import '../../../models/teacher_workload_model.dart';
import '../../../providers/app_provider.dart';
import '../../../utilities/base/my_message.dart';
import '../../../utilities/constants.dart';
import '../../../widgets/primary_dropdown_field.dart';
import '../../../widgets/progress_bar.dart';
import 'mark_attendance.dart';
import 'package:provider/provider.dart';

class TeacherAttendance extends StatefulWidget {
  SingleTeacherModel teacherModel;
  TeacherAttendance({required this.teacherModel, Key? key}) : super(key: key);

  @override
  State<TeacherAttendance> createState() => _TeacherAttendanceState();
}

class _TeacherAttendanceState extends State<TeacherAttendance> {

  List<DepartmentModel> departmentList = [];
  DepartmentModel dptSelectedValue = DepartmentModel(departmentId: 0, departmentName: "Select Department", departmentType: "Demo");
  var departmentItems;

  List<ClassModel> classList = [];
  ClassModel classSelectedValue = ClassModel(classId: 0, className: "Select Class", classSemester: "", classType: "", departmentModel: DepartmentModel.getInstance());
  var classItems;

  List<SubjectModel> subjectList = [];
  SubjectModel subjectSelectedValue = SubjectModel(subjectId: 0, subjectCode: "", subjectName: "Select Subject", creditHours: 0, departmentModel: DepartmentModel.getInstance());
  var subjectItems;

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
  }

  void getDepartments(bool specific) async {
    if(!specific){

      departmentList.add(dptSelectedValue);
      widget.teacherModel.workloadList.forEach((element) {
        int count = departmentList.where((c) => c.departmentId == element.subDepartmentModel.departmentId).toList().length;
        if(count == 0) {
          departmentList.add(element.subDepartmentModel);
        }
      });

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
    else{
      setState(() {
        dptSelectedValue = departmentList[0];
        getClasses(true);
      });
    }
  }

  void getClasses(bool specific) async {
    if(!specific) {
      classList.clear();

      classList.add(classSelectedValue);
      widget.teacherModel.workloadList.forEach((element) {
        int count = classList.where((c) => c.classId == element.classModel.classId).toList().length;
        if(count == 0) {
          classList.add(element.classModel);
        }
      });

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
    else{
      setState(() {
        classSelectedValue = classList[0];

        List<ClassModel> searchedList = [];
        widget.teacherModel.workloadList.forEach((element) {
          if(dptSelectedValue.departmentId == element.subDepartmentModel.departmentId){
            int count = searchedList.where((c) => c.classId == element.classModel.classId).toList().length;
            if(count == 0) {
              searchedList.add(element.classModel);
            }
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

      subjectList.add(subjectSelectedValue);
      widget.teacherModel.workloadList.forEach((element) {
        subjectList.add(element.subjectModel);
      });

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
    else{
      setState(() {
        subjectSelectedValue = subjectList[0];

        List<SubjectModel> searchedList = [];
        widget.teacherModel.workloadList.forEach((element) {
          if(classSelectedValue.classId == element.classModel.classId){
            searchedList.add(element.subjectModel);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<AppProvider>(builder: (context, appProvider, child)=>Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: AppAssets.backgroundColor,
          child: Stack(children: [
            Opacity(opacity: 0.05, child: Center(child: Image.asset(AppAssets.attendanceColoredIcon,))),
            Container(
              height: double.infinity,
              margin: const EdgeInsets.only(top: 60),
              padding: const EdgeInsets.only(left: 30, right: 30, top: 30),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(children: [
                  Image.asset(AppAssets.attendanceColoredIcon, width: 100, height: 100,),
                  const SizedBox(height: 30,),
                  Text("Please Select Department, Class & Subject to Mark Attendance", textAlign: TextAlign.center, style: AppAssets.latoBold_textDarkColor_20,),
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
                          getSubjects(true);
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
                  const SizedBox(height: 30,),
                  Visibility(
                    visible: !appProvider.progress,
                    child: PrimaryButton(
                      width: double.infinity,
                      height: 50,
                      buttonMargin: const EdgeInsets.only(top: 20, bottom: 10),
                      buttonPadding: const EdgeInsets.all(12),
                      buttonText: "Mark Attendance",
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
                        }else {

                          TeacherWorkloadModel teacherWorkloadModel = widget.teacherModel.workloadList[widget.teacherModel.workloadList.indexWhere((element) =>
                          element.departmentModel.departmentId == dptSelectedValue.departmentId &&
                              element.classModel.classId == classSelectedValue.classId &&
                              element.subjectModel.subjectId == subjectSelectedValue.subjectId)];

                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => MarkAttendance(teacherWorkloadModel: teacherWorkloadModel,)));
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
                      buttonText: "Search Attendance",
                      buttonTextStyle: AppAssets.latoBold_whiteColor_16,
                      shadowColor: AppAssets.shadowColor,
                      buttonRadius: BorderRadius.circular(30),
                      onPress: () {
                        if(dptSelectedValue == "Select Department"){
                          MyMessage.showFailedMessage("Please choose Department", context);
                        }else if(classSelectedValue == "Select Class"){
                          MyMessage.showFailedMessage("Please choose Class", context);
                        }else {
                          TeacherWorkloadModel teacherWorkloadModel = widget.teacherModel.workloadList[widget.teacherModel.workloadList.indexWhere((element) =>
                          element.departmentModel.departmentId == dptSelectedValue.departmentId &&
                              element.classModel.classId == classSelectedValue.classId &&
                              element.subjectModel.subjectId == subjectSelectedValue.subjectId)];

                          Provider.of<AppProvider>(context, listen: false).fetchAttendance(teacherWorkloadModel.workloadId, authToken).then((value) async {
                            if(value.isSuccess){
                              if(appProvider.attendanceList.isNotEmpty) {
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => FetchAttendance(attendanceList: appProvider.attendanceList,)));
                              }else{
                                MyMessage.showFailedMessage("There is no attendance record", context);
                              }
                            }else{
                              MyMessage.showFailedMessage(value.message, context);
                            }
                          });
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
                Expanded(child: Container(padding: const EdgeInsets.only(left: 20, right: 20), child: Center(child: Text("Attendance", style: AppAssets.latoBold_textDarkColor_20)))),
                Container(padding: const EdgeInsets.all(10), height: 50, width: 50,),
              ],),
            ),
          ]),
        ),),
      ),
    );
  }
}
