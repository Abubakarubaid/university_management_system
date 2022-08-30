import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:university_management_system/models/subject_model.dart';
import 'package:university_management_system/ui/teacher/teacher_attendance/fetch_attendance.dart';
import 'package:university_management_system/ui/teacher/teacher_subjects/teacher_classes.dart';
import 'package:university_management_system/widgets/no_data.dart';
import 'package:university_management_system/widgets/primary_button.dart';
import 'package:university_management_system/widgets/primary_text_field.dart';
import '../../../assets/app_assets.dart';
import '../../../utilities/base/my_message.dart';
import '../../../widgets/primary_dropdown_field.dart';
import '../../../widgets/progress_bar.dart';
import 'fetch_all_attendance.dart';

class SelectAttendance extends StatefulWidget {
  const SelectAttendance({Key? key}) : super(key: key);

  @override
  State<SelectAttendance> createState() => _SelectAttendanceState();
}

class _SelectAttendanceState extends State<SelectAttendance> {

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
              margin: const EdgeInsets.only(top: 60),
              padding: const EdgeInsets.only(left: 30, right: 30, top: 30),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(children: [
                  Image.asset(AppAssets.attendanceColoredIcon, width: 100, height: 100,),
                  const SizedBox(height: 30,),
                  Text("Please Select Department, Class & Subject to Mark Attendance", textAlign: TextAlign.center, style: AppAssets.latoBold_textDarkColor_20,),
                  const SizedBox(height: 30,),
                  PrimaryDropDownFiled(
                      hint: "Select Department",
                      selectedValue: dptSelectedValue,
                      items: itemsDpt,
                      onChange: (text) {
                        setState(() {
                          dptSelectedValue = text.toString();
                        });
                      }
                  ),
                  const SizedBox(height: 20,),
                  PrimaryDropDownFiled(
                      hint: "Select Class",
                      selectedValue: classSelectedValue,
                      items: itemsClass,
                      onChange: (text) {
                        setState(() {
                          classSelectedValue = text.toString();
                        });
                      }
                  ),
                  const SizedBox(height: 20,),
                  PrimaryDropDownFiled(
                      hint: "Select Subject",
                      selectedValue: subjectSelectedValue,
                      items: itemsSubjects,
                      onChange: (text) {
                        setState(() {
                          subjectSelectedValue = text.toString();
                        });
                      }
                  ),
                  const SizedBox(height: 30,),
                  Visibility(
                    visible: true,
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
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => FetchAllAttendance(selectedClass: classSelectedValue, selectedDepartment: dptSelectedValue, selectedSubject: subjectSelectedValue,)));
                        }
                      },
                    ),
                  ),
                  const Visibility(visible: false, child: SizedBox(height:80, child: ProgressBarWidget())),
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
        ),
      ),
    );
  }
}
