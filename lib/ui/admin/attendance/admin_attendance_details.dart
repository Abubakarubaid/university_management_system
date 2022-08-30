import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:university_management_system/models/class_model.dart';
import 'package:university_management_system/ui/teacher/teacher_subjects/teacher_students.dart';
import 'package:university_management_system/widgets/primary_text_field.dart';
import '../../../assets/app_assets.dart';
import '../../../models/attendance_model.dart';
import '../../../models/subject_model.dart';
import '../../../models/user_model_attendance.dart';
import '../../../models/user_small_model.dart';
import '../../../widgets/primary_dropdown_field.dart';
import '../../../widgets/progress_bar.dart';

class AdminAttendanceDetails extends StatefulWidget {
  //AttendanceDetailModel attendanceDetailModel;
  //List<UserSmallModel> allStudents;

  AdminAttendanceDetails({/*required this.attendanceDetailModel, required this.allStudents*/ Key? key}) : super(key: key);
  @override
  State<AdminAttendanceDetails> createState() => _AdminAttendanceDetailsState();
}

class _AdminAttendanceDetailsState extends State<AdminAttendanceDetails> {

  List<UserModelAttendance> usersList = [];

  @override
  void initState() {
    super.initState();

    setData();
  }

  setData() {
    /*widget.attendanceDetailModel.presentStudents.forEach((element) {
      usersList.add(element);
    });
    widget.attendanceDetailModel.absentStudents.forEach((element) {
      usersList.add(element);
    });*/

    setState(() {});
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
              margin: const EdgeInsets.only(top: 160),
              child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: usersList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      height: 70,
                      width: double.infinity,
                      child: Column(children: [
                        Expanded(
                          child: Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Container(
                              width: 70,
                              height: double.infinity,
                              padding: const EdgeInsets.all(12),
                              child: Stack(children:[
                                Container(
                                    clipBehavior: Clip.antiAlias,
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: AppAssets.whiteColor,
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                    child: SvgPicture.asset(usersList[index].userGender == "Male"? AppAssets.maleAvatar : AppAssets.femaleAvatar, fit: BoxFit.cover,)
                                ),
                                Container(
                                  clipBehavior: Clip.antiAlias,
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: usersList[index].attendanceStatus.isEmpty ? AppAssets.transparentColor : usersList[index].attendanceStatus == "Present" ? AppAssets.successColor.withOpacity(0.8) : AppAssets.failureColor.withOpacity(0.8),
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                  child: Center(child: Text(usersList[index].attendanceStatus.isEmpty ? "" : usersList[index].attendanceStatus == "Present" ? "P" : "A", style: AppAssets.latoBold_whiteColor_30,)),
                                ),
                              ]),
                            ),
                            const SizedBox(width: 6,),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(right: 16),
                                    child: Align(alignment: Alignment.centerLeft, child: Text(usersList[index].userName, style: AppAssets.latoBold_textDarkColor_16, maxLines: 2, overflow: TextOverflow.ellipsis,)),
                                  ),
                                  const SizedBox(height: 4,),
                                  Container(
                                    padding: const EdgeInsets.only(right: 16),
                                    child: Align(alignment: Alignment.centerLeft, child: Text(usersList[index].userRollNo, style: AppAssets.latoRegular_textDarkColor_14, maxLines: 1, overflow: TextOverflow.ellipsis,)),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: double.infinity,
                              padding: const EdgeInsets.all(5),
                              margin: const EdgeInsets.only(right: 10),
                              child: Center(child: Text("${usersList[index].overAllAttendancePercentage} %", style: usersList[index].overAllAttendancePercentage >= 75 ? AppAssets.latoBold_successColor_16 : AppAssets.latoBold_failureColor_16,)),
                            ),
                          ],),
                        ),
                        Container(height: 1, width: double.infinity, color: AppAssets.textLightColor,),
                      ],),
                    );
              }),
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
                      Expanded(child: Container(padding: const EdgeInsets.only(left: 20, right: 20), child: Center(child: Text("Attendance Details", style: AppAssets.latoBold_textDarkColor_20)))),
                      Container(padding: const EdgeInsets.all(10), height: 50, width: 50,),
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
                          child: Center(child: Text(/*widget.attendanceDetailModel.presentStudents.length.toString()*/ "", style: AppAssets.latoBold_successColor_24,)),
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
                          child: Center(child: Text(/*widget.attendanceDetailModel.absentStudents.length.toString()*/ "", style: AppAssets.latoBold_failureColor_24,)),
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
                          child: Center(child: Text(/*(widget.attendanceDetailModel.presentStudents.length + widget.attendanceDetailModel.absentStudents.length).toString()*/"", style: AppAssets.latoBold_blueColor_24,)),
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
