import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:university_management_system/models/mark_attendance_model.dart';
import 'package:university_management_system/models/subject_model.dart';
import 'package:university_management_system/ui/teacher/teacher_subjects/teacher_classes.dart';
import 'package:university_management_system/widgets/no_data.dart';
import 'package:university_management_system/widgets/primary_button.dart';
import 'package:university_management_system/widgets/primary_text_field.dart';
import '../../../assets/app_assets.dart';
import '../../../models/teacher_workload_model.dart';
import '../../../models/user_model.dart';
import '../../../widgets/primary_dropdown_field.dart';
import '../../../widgets/progress_bar.dart';

class MarkAttendance extends StatefulWidget {
  TeacherWorkloadModel teacherWorkloadModel;
  MarkAttendance({required this.teacherWorkloadModel, Key? key}) : super(key: key);

  @override
  State<MarkAttendance> createState() => _MarkAttendanceState();
}

class _MarkAttendanceState extends State<MarkAttendance> {

  int presentCount = 0;
  int absentCount = 0;

  List<UserModel> studentsList = [];
  List<MarkAttendanceModel> markAttendanceList = [];

  @override
  void initState() {
    super.initState();

    addAllStudentsToAttendanceList();
  }

  void addAllStudentsToAttendanceList() {
    studentsList.forEach((element) {
      markAttendanceList.add(MarkAttendanceModel(
          userId: element.userId,
          userName: element.userName,
          userEmail: element.userEmail,
          userPassword: element.userPassword,
          userPhone: element.userPhone,
          userSession: element.userSession,
          userRollNo: element.userRollNo,
          userGender: element.userGender,
          userDepartment: element.userDepartment,
          userClass: element.userClass,
          userQualification: element.userQualification,
          userDesignation: element.userDesignation,
          userImage: element.userImage,
          userType: element.userType,
          userStatus: element.userStatus,
          studentRollNo: element.userRollNo,
          attendanceStatus: ""));
    });

    setState(() {});
  }

  void updateAttendance(int index) {
    setState(() {
      if(markAttendanceList[index].attendanceStatus.isEmpty){
        markAttendanceList[index].attendanceStatus = "Present";
      }else if(markAttendanceList[index].attendanceStatus == "Present"){
        markAttendanceList[index].attendanceStatus = "Absent";
      }else {
        markAttendanceList[index].attendanceStatus = "";
      }

      presentCount = 0;
      absentCount = 0;
      markAttendanceList.forEach((element) {
        if(element.attendanceStatus == "Present"){
          presentCount++;
        }else if(element.attendanceStatus == "Absent"){
          absentCount++;
        }
      });
    });
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
            Opacity(opacity: 0.05, child: Align(child: Container(margin: const EdgeInsets.only(top: 130),child: Image.asset(AppAssets.attendanceColoredIcon,)))),
            Container(
              height: double.infinity,
              margin: const EdgeInsets.only(top: 160),
              child: GridView.builder(
                padding: const EdgeInsets.only(left: 10, right: 10),
                physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 3,
                    crossAxisSpacing: 3,
                  ),
                  itemCount: markAttendanceList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        updateAttendance(index);
                      },
                      child: Container(
                        color: AppAssets.whiteColor,
                        padding: EdgeInsets.only(top: 12,left: 6, right: 6, bottom: 6),
                        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Stack(children:[
                            Container(
                              clipBehavior: Clip.antiAlias,
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: AppAssets.whiteColor,
                                borderRadius: BorderRadius.circular(40),
                              ),
                              child: SvgPicture.asset(markAttendanceList[index].userGender == "Male"? AppAssets.maleAvatar : AppAssets.femaleAvatar, fit: BoxFit.cover,)
                          ),
                            Container(
                                clipBehavior: Clip.antiAlias,
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: markAttendanceList[index].attendanceStatus.isEmpty ? AppAssets.transparentColor : markAttendanceList[index].attendanceStatus == "Present" ? AppAssets.successColor.withOpacity(0.8) : AppAssets.failureColor.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(40),
                                ),
                              child: Center(child: Text(markAttendanceList[index].attendanceStatus.isEmpty ? "" : markAttendanceList[index].attendanceStatus == "Present" ? "P" : "A", style: AppAssets.latoBold_whiteColor_30,)),
                            ),
                          ]),
                          const SizedBox(height: 10,),
                          Text(markAttendanceList[index].userRollNo, textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis,),
                        ],),
                      ),
                    );
                  }
              ),
            ),
            Container(
              alignment: Alignment.topCenter,
              width: double.infinity,
              height: 160,
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
              child: Container(
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    Row(children: [
                      GestureDetector(onTap: () {Navigator.of(context).pop();}, child: Container(padding: const EdgeInsets.all(16), height: 50, width: 50, child: SvgPicture.asset(AppAssets.backArrowIcon, color: AppAssets.iconsTintDarkGreyColor,))),
                      Expanded(child: Container(padding: const EdgeInsets.only(left: 20, right: 20), child: Center(child: Text("Mark Attendance", style: AppAssets.latoBold_textDarkColor_20)))),
                      GestureDetector(
                          onTap: () {
                          },
                          child: Container(padding: const EdgeInsets.all(10), height: 50, width: 50, child: SvgPicture.asset(AppAssets.approveIcon, color: AppAssets.successColor,))),
                    ],),
                    const SizedBox(height: 16,),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Column(children: [
                        Container(
                          width: 60,
                          height: 60,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppAssets.backgroundColor,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppAssets.successColor, width: 2),
                          ),
                          child: Center(child: Text(presentCount.toString(), style: AppAssets.latoBold_successColor_24,)),
                        ),
                        const SizedBox(height: 6,),
                        Text("Present", style: AppAssets.latoBold_textDarkColor_14,)
                      ],),
                      const SizedBox(width: 20,),
                      Column(children: [
                        Container(
                          width: 60,
                          height: 60,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppAssets.backgroundColor,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppAssets.failureColor, width: 2),
                          ),
                          child: Center(child: Text(absentCount.toString(), style: AppAssets.latoBold_failureColor_24,)),
                        ),
                        const SizedBox(height: 6,),
                        Text("Absent", style: AppAssets.latoBold_textDarkColor_14,)
                      ],),
                      const SizedBox(width: 20,),
                      Column(children: [
                        Container(
                          width: 60,
                          height: 60,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppAssets.backgroundColor,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.blue, width: 2),
                          ),
                          child: Center(child: Text((presentCount + absentCount).toString(), style: AppAssets.latoBold_blueColor_24,)),
                        ),
                        const SizedBox(height: 6,),
                        Text("Total", style: AppAssets.latoBold_textDarkColor_14,)
                      ],),
                    ],),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
