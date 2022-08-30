import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:university_management_system/models/subject_model.dart';
import 'package:university_management_system/models/user_model_attendance.dart';
import 'package:university_management_system/ui/teacher/teacher_attendance/attendance_details.dart';
import 'package:university_management_system/ui/teacher/teacher_subjects/teacher_classes.dart';
import 'package:university_management_system/widgets/no_data.dart';
import 'package:university_management_system/widgets/primary_button.dart';
import 'package:university_management_system/widgets/primary_text_field.dart';
import '../../../assets/app_assets.dart';
import '../../../models/attendance_model.dart';
import '../../../models/user_small_model.dart';
import '../../../utilities/base/my_message.dart';
import '../../../widgets/primary_dropdown_field.dart';
import '../../../widgets/progress_bar.dart';
import 'mark_attendance.dart';

class FetchAttendance extends StatefulWidget {
  String selectedClass;
  String selectedDepartment;
  String selectedSubject;
  FetchAttendance({required this.selectedClass, required this.selectedDepartment, required this.selectedSubject, Key? key}) : super(key: key);

  @override
  State<FetchAttendance> createState() => _FetchAttendanceState();
}

class _FetchAttendanceState extends State<FetchAttendance> {

  var itemsClass = [
    "Select Class",
    "Class 1",
    "Class 2",
    "Class 3",
  ];
  String classSelectedValue = "Select Class";

  var itemsDpt = [
    "Select Department",
    "Department 1",
    "Department 2",
    "Department 3",
  ];
  String dptSelectedValue = "Select Department";

  var itemsSubjects = [
    "Select Subject",
    "Subject 1",
    "Subject 2",
    "Subject 3",
  ];
  String subjectSelectedValue = "Select Subject";

  List<UserSmallModel> allStudents = [
    UserSmallModel(userId: 1, userName: "Abu Bakar", userRollNo: "BSE-F14-M046"),
    UserSmallModel(userId: 2, userName: "Ali Seemab", userRollNo: "BSE-F14-M048"),
    UserSmallModel(userId: 3, userName: "Saboor Ali", userRollNo: "BSE-F14-M050"),
    UserSmallModel(userId: 4, userName: "Hina Khan", userRollNo: "BSE-F14-M051"),
    UserSmallModel(userId: 5, userName: "Hania Khan", userRollNo: "BSE-F14-M052"),
  ];
  List<UserModelAttendance> presentStudentsList = [
    UserModelAttendance(userId: 1, userName: "Abu Bakar", userEmail: "abu@gmail.com", userPassword: "123456789", userPhone: "+923058008620", userSession: "2018-2020", userRollNo: "BSE-F14-M046", userGender: "Male", userDepartment: "Department 1", userClass: "Class 1", userQualification: "", userDesignation: "", userImage: "", userType: "Student", userStatus: "Active", attendanceStatus: "Present", overAllAttendancePercentage: 70.87),
    UserModelAttendance(userId: 3, userName: "Saboor Ali", userEmail: "sboor@gmail.com", userPassword: "123456789", userPhone: "+923028008620", userSession: "2012-2026", userRollNo: "BSE-F14-M050", userGender: "Male", userDepartment: "Department 3", userClass: "Class 3", userQualification: "", userDesignation: "", userImage: "", userType: "Student", userStatus: "Active", attendanceStatus: "Present", overAllAttendancePercentage: 45.60),
    UserModelAttendance(userId: 5, userName: "Hania Khan", userEmail: "hania@gmail.com", userPassword: "123456789", userPhone: "+923028003620", userSession: "2012-2026", userRollNo: "BSE-F14-M052", userGender: "Female", userDepartment: "Department 3", userClass: "Class 3", userQualification: "", userDesignation: "", userImage: "", userType: "Student", userStatus: "Active", attendanceStatus: "Present", overAllAttendancePercentage: 90),
  ];
  List<UserModelAttendance> absentStudentsList = [
    UserModelAttendance(userId: 2, userName: "Ali Seemab", userEmail: "ali@gmail.com", userPassword: "123456789", userPhone: "+923088008620", userSession: "2014-2018", userRollNo: "BSE-F14-M048", userGender: "Male", userDepartment: "Department 2", userClass: "Class 2", userQualification: "", userDesignation: "", userImage: "", userType: "Student", userStatus: "Active", attendanceStatus: "Absent", overAllAttendancePercentage: 80),
    UserModelAttendance(userId: 4, userName: "Hina Khan", userEmail: "hina@gmail.com", userPassword: "123456789", userPhone: "+923028008621", userSession: "2012-2026", userRollNo: "BSE-F14-M051", userGender: "Female", userDepartment: "Department 3", userClass: "Class 3", userQualification: "", userDesignation: "", userImage: "", userType: "Student", userStatus: "Active", attendanceStatus: "Absent", overAllAttendancePercentage: 78),
  ];

  List<AttendanceDetailModel> detailsList = [];

  @override
  void initState() {
    super.initState();

    addData();
  }

  addData() {
    detailsList = [];

    setState(() {});

    // 2022-08-19 12:32:04
    /*var dateObj1 = DateFormat().add_MMM().format(DateFormat('yyyy-MM-dd H:m:s').parse(detailsList[0].attendanceDateAndTime));
    DateTime dateObj = DateFormat('yyyy-MM-dd H:m:s').parse(detailsList[0].attendanceDateAndTime);
    print(dateObj1);*/
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
            Opacity(opacity: 0.05, child: Center(child: Image.asset(AppAssets.attendanceColoredIcon,))),
            Container(
              height: double.infinity,
              margin: const EdgeInsets.only(top: 60, left: 20, right: 20),
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: detailsList.length,
                itemBuilder: (context, index) =>
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => AttendanceDetails(attendanceDetailModel: detailsList[index],)));
                      },
                      child: Container(
                        clipBehavior: Clip.antiAlias,
                        margin: index == detailsList.length-1 ? const EdgeInsets.only(top: 20, bottom: 30) : const EdgeInsets.only(top: 20),
                        width: double.infinity,
                        height: 150,
                        decoration: BoxDecoration(
                          color: AppAssets.whiteColor,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [BoxShadow(
                            spreadRadius: 5,
                            blurRadius: 5,
                            offset: const Offset(0,3),
                            color: AppAssets.shadowColor.withOpacity(0.5),
                          )]
                        ),
                        child: Stack(children: [
                          Container(padding: EdgeInsets.all(20), child: Opacity(opacity: 0.06, child: Align(alignment: Alignment.centerRight, child: Image.asset(AppAssets.attendanceColoredIcon,)))),
                          Row(children: [
                            Container(
                              width: 100,
                              height: double.infinity,
                              color: AppAssets.primaryColor,
                              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                Text("${DateFormat('yyyy-MM-dd').parse(detailsList[index].attendanceDateAndTime).day}", style: AppAssets.latoBold_whiteColor_26, maxLines: 1, overflow: TextOverflow.ellipsis,),
                                Text("${DateFormat().add_MMM().format(DateFormat('yyyy-MM-dd H:m:s').parse(detailsList[index].attendanceDateAndTime))}", style: AppAssets.latoRegular_whiteColor_20, maxLines: 1, overflow: TextOverflow.ellipsis,),
                                const SizedBox(height: 30,),
                                Text("${DateFormat().add_jm().format(DateFormat('yyyy-MM-dd H:m:s').parse(detailsList[index].attendanceDateAndTime))}", style: AppAssets.latoRegular_whiteColor_16, maxLines: 1, overflow: TextOverflow.ellipsis,),
                              ],),
                            ),
                            Expanded(child: Container(
                              height: double.infinity,
                              padding: const EdgeInsets.all(12),
                              child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                                Row(children: [
                                  const Icon(Icons.class_, color: AppAssets.textLightColor,),
                                  const SizedBox(width: 8,),
                                  //Expanded(child: Text("${detailsList[index].className} ${detailsList[index].classSemester} ${detailsList[index].classType}", style: AppAssets.latoRegular_textDarkColor_14, maxLines: 1, overflow: TextOverflow.ellipsis,)),
                                ],),
                                const SizedBox(height: 8,),
                                Expanded(
                                  child: Row(children: [
                                    const Icon(Icons.subject, color: AppAssets.textLightColor,),
                                    const SizedBox(width: 8,),
                                    //Expanded(child: Text(detailsList[index].departmentName, style: AppAssets.latoRegular_textDarkColor_14, maxLines: 2, overflow: TextOverflow.ellipsis,)),
                                  ],),
                                ),
                                const SizedBox(height: 8,),
                                Row(children: [
                                  const SizedBox(width: 6,),
                                  Text("Present: ", style: AppAssets.latoBold_textDarkColor_14, maxLines: 1, overflow: TextOverflow.ellipsis,),
                                  const SizedBox(width: 8,),
                                  Text(detailsList[index].presentStudents.length.toString(), style: AppAssets.latoBold_textDarkColor_14, maxLines: 1, overflow: TextOverflow.ellipsis,),
                                ],),
                                const SizedBox(height: 8,),
                                Row(children: [
                                  const SizedBox(width: 6,),
                                  Text("Absent: ", style: AppAssets.latoBold_textDarkColor_14, maxLines: 1, overflow: TextOverflow.ellipsis,),
                                  const SizedBox(width: 8,),
                                  Text(detailsList[index].absentStudents.length.toString(), style: AppAssets.latoBold_textDarkColor_14, maxLines: 1, overflow: TextOverflow.ellipsis,),
                                ],),
                              ],),
                            )),
                          ],),
                        ],),
                      ),
                    ),
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
        ),
      ),
    );
  }
}
