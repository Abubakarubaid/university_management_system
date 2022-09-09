import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
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
import '../../../models/timeslots_model_day.dart';
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

class CustomTimeTablePage extends StatefulWidget {
  const CustomTimeTablePage({Key? key}) : super(key: key);

  @override
  State<CustomTimeTablePage> createState() => _CustomTimeTablePageState();
}

class _CustomTimeTablePageState extends State<CustomTimeTablePage> {

  var searchController = TextEditingController();

  String authToken = "";
  List<TimeSlotsModel> timeSlotList = [];
  List<TeacherOwnTimeTableModel> timeTableList = [];
  TeacherOwnTimeTableModel ttSelectedValue1 = TeacherOwnTimeTableModel(timeTableId: 0, workloadId: 0, departmentId: 0, userId: 0, roomId: 0, timeSlotId: 0, day: "Select ID", date: "", status: "", userModel: UserModel.getInstance(), roomsModel: RoomsModel.getInstance(), timeSlotsModel: TimeSlotsModel.getInstance(), workloadAssignmentModel: WorkloadAssignmentModel.getInstance());
  var timeTableListItems1;

  List<TimeSlotsModelDay> freeSlotList = [];
  TimeSlotsModelDay freeSelectedSlot = TimeSlotsModelDay(timeslotId: 0, timeslot: "Select Time Slot", departmentModel: DepartmentModel.getInstance(), timeslotType: "NA", day: "NA");
  var freeSelectedSlotItem;

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
        checkAvailableTimeSlots();

        timeTableListItems1 = timeTableList.map((item) {
          return DropdownMenuItem<TeacherOwnTimeTableModel>(
            //child: Text("${item.day}\n${item.workloadAssignmentModel.classModel.className} ${item.workloadAssignmentModel.classModel.classSemester} ${item.workloadAssignmentModel.classModel.classType}\n${item.userModel.userName}\n(${item.workloadAssignmentModel.subjectModel.subjectCode}) ${item.workloadAssignmentModel.subjectModel.subjectName}\n${item.roomsModel.roomName}"),
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
      }
    });
  }

  void checkAvailableTimeSlots() {
    timeSlotList.clear();
    timeSlotList = Provider.of<AppProvider>(context, listen: false).timeSlotList;
    timeSlotList.sort((a, b) => a.timeslotId.compareTo(b.timeslotId));

    List<TimeSlotsModelDay> mondayTimeSlotList = [];
    List<TimeSlotsModelDay> tuesdayTimeSlotList = [];
    List<TimeSlotsModelDay> wednesdayTimeSlotList = [];
    List<TimeSlotsModelDay> thursdayTimeSlotList = [];
    List<TimeSlotsModelDay> fridayTimeSlotList = [];

    timeSlotList.forEach((element) {
      int mondayCount = timeTableList.where((c) => c.timeSlotId == element.timeslotId && c.day == "Monday").toList().length;
      int tuesdayCount = timeTableList.where((c) => c.timeSlotId == element.timeslotId && c.day == "Tuesday").toList().length;
      int wednesdayCount = timeTableList.where((c) => c.timeSlotId == element.timeslotId && c.day == "Wednesday").toList().length;
      int thursdayCount = timeTableList.where((c) => c.timeSlotId == element.timeslotId && c.day == "Thursday").toList().length;
      int fridayCount = timeTableList.where((c) => c.timeSlotId == element.timeslotId && c.day == "Friday").toList().length;
      if(mondayCount == 0){
        TimeSlotsModelDay model = TimeSlotsModelDay.getInstance();
        model.timeslotId = element.timeslotId;
        model.timeslot = element.timeslot;
        model.timeslotType = element.timeslotType;
        model.day = "Monday";
        model.departmentModel = element.departmentModel;
        mondayTimeSlotList.add(model);
      }
      if(tuesdayCount == 0){
        TimeSlotsModelDay model = TimeSlotsModelDay.getInstance();
        model.timeslotId = element.timeslotId;
        model.timeslot = element.timeslot;
        model.timeslotType = element.timeslotType;
        model.day = "Tuesday";
        model.departmentModel = element.departmentModel;
        tuesdayTimeSlotList.add(model);
      }
      if(wednesdayCount == 0){
        TimeSlotsModelDay model = TimeSlotsModelDay.getInstance();
        model.timeslotId = element.timeslotId;
        model.timeslot = element.timeslot;
        model.timeslotType = element.timeslotType;
        model.day = "Wednesday";
        model.departmentModel = element.departmentModel;
        wednesdayTimeSlotList.add(model);
      }
      if(thursdayCount == 0){
        TimeSlotsModelDay model = TimeSlotsModelDay.getInstance();
        model.timeslotId = element.timeslotId;
        model.timeslot = element.timeslot;
        model.timeslotType = element.timeslotType;
        model.day = "Thursday";
        model.departmentModel = element.departmentModel;
        thursdayTimeSlotList.add(model);
      }
      if(fridayCount == 0){
        TimeSlotsModelDay model = TimeSlotsModelDay.getInstance();
        model.timeslotId = element.timeslotId;
        model.timeslot = element.timeslot;
        model.timeslotType = element.timeslotType;
        model.day = "Friday";
        model.departmentModel = element.departmentModel;
        fridayTimeSlotList.add(model);
      }
    });

    //freeSlotList.add(freeSelectedSlot);
    for(int i=0; i<mondayTimeSlotList.length; i++){
      freeSlotList.add(mondayTimeSlotList[i]);
      print("______________: ${mondayTimeSlotList[i].day}: ${mondayTimeSlotList[i].timeslot}");
    }
    for(int i=0; i<tuesdayTimeSlotList.length; i++){
      freeSlotList.add(tuesdayTimeSlotList[i]);
      print("______________: ${tuesdayTimeSlotList[i].day}: ${tuesdayTimeSlotList[i].timeslot}");
    }
    for(int i=0; i<wednesdayTimeSlotList.length; i++){
      freeSlotList.add(wednesdayTimeSlotList[i]);
      print("______________: ${wednesdayTimeSlotList[i].day}: ${wednesdayTimeSlotList[i].timeslot}");
    }
    for(int i=0; i<thursdayTimeSlotList.length; i++){
      freeSlotList.add(thursdayTimeSlotList[i]);
      print("______________: ${thursdayTimeSlotList[i].day}: ${thursdayTimeSlotList[i].timeslot}");
    }
    for(int i=0; i<fridayTimeSlotList.length; i++){
      freeSlotList.add(fridayTimeSlotList[i]);
      print("______________: ${fridayTimeSlotList[i].day}: ${fridayTimeSlotList[i].timeslot}");
    }

    freeSelectedSlotItem = freeSlotList.map((item) {
      return DropdownMenuItem<TimeSlotsModelDay>(
        child: Text("${item.day}, ${item.timeslot}, ${item.timeslotType}"),
        value: item,
      );
    }).toList();

    // if list is empty, create a dummy item
    if (freeSelectedSlotItem.isEmpty) {
      freeSelectedSlotItem = [
        DropdownMenuItem(
          child: Text("${freeSelectedSlot.day}, ${freeSelectedSlot.timeslot}, ${freeSelectedSlot.timeslotType}"),
          value: freeSelectedSlot,
        )
      ];
    }else{
      freeSelectedSlot = freeSlotList[0];
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
                    Text("Please Select Time-Table ID to Change Slot", textAlign: TextAlign.center, style: AppAssets.latoBold_textDarkColor_20,),
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
                        icon: const Icon(Icons.arrow_drop_down),
                        itemHeight: 100,
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
                    Text("Replace with available time slots", textAlign: TextAlign.center, style: AppAssets.latoBold_textDarkColor_16,),
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
                      child: DropdownButton<TimeSlotsModelDay>(
                        value: freeSelectedSlot,
                        icon: const Icon(Icons.arrow_drop_down),
                        underline: Container(
                          height: 0,
                          color: Colors.transparent,
                        ),
                        isExpanded: true,
                        onChanged: (value) {
                          setState(() {
                            freeSelectedSlot = value!;
                          });
                        },
                        items: freeSelectedSlotItem,
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
                          } else if(freeSelectedSlot.timeslotId == 0){
                            MyMessage.showFailedMessage("Please Select Free Slot", context);
                          } else{
                            TimeTableUploadModel model = TimeTableUploadModel.getInstance();
                            model.timetable_id = ttSelectedValue1.timeTableId;
                            model.workload_id = ttSelectedValue1.workloadId;
                            model.roomId = ttSelectedValue1.roomId;
                            model.timeSlotId = freeSelectedSlot.timeslotId;
                            model.userId = ttSelectedValue1.userId;
                            model.date = ttSelectedValue1.date;
                            model.day = freeSelectedSlot.day;
                            model.status = ttSelectedValue1.status;
                            Provider.of<AppProvider>(context, listen: false)
                                .updateSlotTimeTable(model, authToken)
                                .then((value) {
                              if (value.isSuccess) {
                                Navigator.of(context).pop();
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
                  Expanded(child: Container(padding: const EdgeInsets.only(left: 20, right: 20), child: Center(child: Text("Custom Time Table", style: AppAssets.latoBold_textDarkColor_20)))),
                  Container(padding: const EdgeInsets.all(10), height: 50, width: 50,),
                ],),
              ),
            ]),
          ),)
      ),
    );
  }
}
