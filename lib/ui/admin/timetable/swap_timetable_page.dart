import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:university_management_system/models/workload_model.dart';
import 'package:university_management_system/ui/admin/timetable/pdf/TimeTablePdfPreviewPage.dart';
import 'package:university_management_system/ui/admin/timetable/timtable_assignment.dart';
import 'package:university_management_system/ui/admin/timetable/view_timetable_page.dart';
import 'package:university_management_system/ui/admin/workload/pdf/PdfPreviewPage.dart';
import 'package:uuid/uuid.dart';
import '../../../assets/app_assets.dart';
import '../../../models/dpt_model.dart';
import '../../../models/rooms_model.dart';
import '../../../models/teacher_model.dart';
import '../../../models/teacher_own_timetable_model.dart';
import '../../../models/timeslots_model.dart';
import '../../../models/timetable_upload_model.dart';
import '../../../models/user_model.dart';
import '../../../models/workload_assignment_model.dart';
import '../../../models/workload_timtable_model.dart';
import '../../../providers/app_provider.dart';
import '../../../utilities/base/my_message.dart';
import '../../../utilities/constants.dart';
import '../../../widgets/no_data.dart';
import '../../../widgets/primary_button.dart';
import '../../../widgets/primary_search_field.dart';
import '../../../widgets/progress_bar.dart';
import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;

class SwapTimeTablePage extends StatefulWidget {
  const SwapTimeTablePage({Key? key}) : super(key: key);

  @override
  State<SwapTimeTablePage> createState() => _SwapTimeTablePageState();
}

class _SwapTimeTablePageState extends State<SwapTimeTablePage> {

  var searchController = TextEditingController();

  String authToken = "";
  List<TeacherOwnTimeTableModel> timeTableList = [];
  TeacherOwnTimeTableModel ttSelectedValue1 = TeacherOwnTimeTableModel(timeTableId: 0, workloadId: 0, departmentId: 0, userId: 0, roomId: 0, timeSlotId: 0, day: "Select ID", date: "", status: "", userModel: UserModel.getInstance(), roomsModel: RoomsModel.getInstance(), timeSlotsModel: TimeSlotsModel.getInstance(), workloadAssignmentModel: WorkloadAssignmentModel.getInstance());
  var timeTableListItems1;

  TeacherOwnTimeTableModel ttSelectedValue2 = TeacherOwnTimeTableModel(timeTableId: 0, workloadId: 0, departmentId: 0, userId: 0, roomId: 0, timeSlotId: 0, day: "Select ID", date: "", status: "", userModel: UserModel.getInstance(), roomsModel: RoomsModel.getInstance(), timeSlotsModel: TimeSlotsModel.getInstance(), workloadAssignmentModel: WorkloadAssignmentModel.getInstance());
  var timeTableListItems2;

  bool progressData = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Constants.getAuthToken().then((value) {
      authToken = value;
    });

    getData();
  }

  void getData() async {
    Provider.of<AppProvider>(context, listen: false).fetchAllTimeTable(authToken).then((value) {
      if(value.isSuccess){
        timeTableList.clear();
        timeTableList = Provider.of<AppProvider>(context, listen: false).teacherTimeTableList;
        timeTableList.add(ttSelectedValue1);
        timeTableList.sort((a, b) => a.timeTableId.compareTo(b.timeTableId));

        timeTableListItems1 = timeTableList.map((item) {
          return DropdownMenuItem<TeacherOwnTimeTableModel>(
            child: Container(
              width: double.infinity,
              child: Column( mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(item.day, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis,),
                Text(item.timeSlotsModel.timeslot, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis,),
                Text("${item.workloadAssignmentModel.classModel.className} ${item.workloadAssignmentModel.classModel.classSemester} ${item.workloadAssignmentModel.classModel.classType}", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis,),
                Text(item.userModel.userName, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis,),
                Text("(${item.workloadAssignmentModel.subjectModel.subjectCode}) ${item.workloadAssignmentModel.subjectModel.subjectName}", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis,),
                Text(item.roomsModel.roomName, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis,),
                Container(width: double.infinity,height: 1, color: Colors.grey,)
              ]),
            ),
            value: item,
          );
        }).toList();
        timeTableListItems2 = timeTableList.map((item) {
          return DropdownMenuItem<TeacherOwnTimeTableModel>(
            child: Container(
              width: double.infinity,
              child: Column( mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(item.day, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis,),
                Text(item.timeSlotsModel.timeslot, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis,),
                Text("${item.workloadAssignmentModel.classModel.className} ${item.workloadAssignmentModel.classModel.classSemester} ${item.workloadAssignmentModel.classModel.classType}", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis,),
                Text(item.userModel.userName, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis,),
                Text("(${item.workloadAssignmentModel.subjectModel.subjectCode}) ${item.workloadAssignmentModel.subjectModel.subjectName}", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis,),
                Text(item.roomsModel.roomName, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis,),
                Container(width: double.infinity,height: 1, color: Colors.grey,)
              ]),
            ),
            value: item,
          );
        }).toList();

        // if list is empty, create a dummy item
        if (timeTableListItems1.isEmpty) {
          timeTableListItems1 = [
            DropdownMenuItem(
              child: Text("${ttSelectedValue1.timeTableId} - ${ttSelectedValue1.day}"),
              value: ttSelectedValue1,
            )
          ];
        }else{
          ttSelectedValue1 = timeTableList[0];
        }
        // if list is empty, create a dummy item
        if (timeTableListItems2.isEmpty) {
          timeTableListItems2 = [
            DropdownMenuItem(
              child: Text("${ttSelectedValue2.timeTableId} - ${ttSelectedValue2.day}"),
              value: ttSelectedValue2,
            )
          ];
        }else{
          ttSelectedValue2 = timeTableList[0];
        }
      }
    });
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
              Opacity(opacity: 0.05, child: Center(child: Image.asset(AppAssets.timetable_new,))),
              Container(
                height: double.infinity,
                margin: const EdgeInsets.only(top: 0),
                padding: const EdgeInsets.only(left: 30, right: 30, top: 30),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    const SizedBox(height: 60,),
                    Image.asset(AppAssets.timetable_new, width: 100, height: 100,),
                    const SizedBox(height: 50,),
                    Text("Please Select 2 Time-Tables to replace", textAlign: TextAlign.center, style: AppAssets.latoBold_textDarkColor_20,),
                    const SizedBox(height: 50,),
                    Container(
                      width: double.infinity,
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
                      child: DropdownButton<TeacherOwnTimeTableModel>(
                        value: ttSelectedValue1,
                        itemHeight: 100,
                        icon: const Icon(Icons.arrow_drop_down),
                        underline: Container(
                          height: 0,
                          color: Colors.transparent,
                        ),
                        isExpanded: true,
                        onChanged: (value) {
                          setState(() {
                            ttSelectedValue1 = value!;
                          });
                        },
                        items: timeTableListItems1,
                      ),
                    ),
                    const SizedBox(height: 20,),
                    Text("Replace by", textAlign: TextAlign.center, style: AppAssets.latoBold_textDarkColor_16,),
                    const SizedBox(height: 20,),
                    Container(
                      width: double.infinity,
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
                      child: DropdownButton<TeacherOwnTimeTableModel>(
                        value: ttSelectedValue2,
                        itemHeight: 100,
                        icon: const Icon(Icons.arrow_drop_down),
                        underline: Container(
                          height: 0,
                          color: Colors.transparent,
                        ),
                        isExpanded: true,
                        onChanged: (value) {
                          setState(() {
                            ttSelectedValue2 = value!;
                          });
                        },
                        items: timeTableListItems2,
                      ),
                    ),
                    const SizedBox(height: 50,),
                    Visibility(
                      visible: !appProvider.progress,
                      child: PrimaryButton(
                        width: double.infinity,
                        height: 50,
                        buttonMargin: const EdgeInsets.only(top: 10, bottom: 10),
                        buttonPadding: const EdgeInsets.all(12),
                        buttonText: "Replace Time Table",
                        buttonTextStyle: AppAssets.latoBold_whiteColor_16,
                        shadowColor: AppAssets.shadowColor,
                        buttonRadius: BorderRadius.circular(30),
                        onPress: () {
                          if(ttSelectedValue1.timeTableId == 0){
                            MyMessage.showFailedMessage("Please Select Time Table ID", context);
                          } else if(ttSelectedValue2.timeTableId == 0){
                            MyMessage.showFailedMessage("Please Select Replacing Time Table ID", context);
                          } else if(ttSelectedValue1.timeTableId == ttSelectedValue2.timeTableId){
                            MyMessage.showFailedMessage("Please Select Different Time Table ID", context);
                          } else{
                            Provider.of<AppProvider>(context, listen: false)
                                .replaceTimeTable(ttSelectedValue1.timeTableId.toString(), ttSelectedValue2.timeTableId.toString(), authToken)
                                .then((value) {
                              if (value.isSuccess) {
                                setState(() {
                                  ttSelectedValue1 = timeTableList[0];
                                  ttSelectedValue2 = timeTableList[0];
                                });
                                MyMessage.showSuccessMessage(value.message, context);
                              } else {
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
                  Expanded(child: Container(padding: const EdgeInsets.only(left: 20, right: 20), child: Center(child: Text("Replace Time Table", style: AppAssets.latoBold_textDarkColor_20)))),
                  Container(padding: const EdgeInsets.all(10), height: 50, width: 50,),
                ],),
              ),
            ]),
          ),)
      ),
    );
  }
}
