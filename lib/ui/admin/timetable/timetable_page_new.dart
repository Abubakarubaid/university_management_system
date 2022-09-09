import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:university_management_system/models/workload_model.dart';
import 'package:university_management_system/ui/admin/timetable/pdf/TimeTablePdfPreviewPage.dart';
import 'package:university_management_system/ui/admin/timetable/swap_timetable_page.dart';
import 'package:university_management_system/ui/admin/timetable/timtable_assignment.dart';
import 'package:university_management_system/ui/admin/timetable/view_timetable_page.dart';
import 'package:university_management_system/ui/admin/workload/pdf/PdfPreviewPage.dart';
import 'package:uuid/uuid.dart';
import '../../../assets/app_assets.dart';
import '../../../models/dpt_model.dart';
import '../../../models/rooms_model.dart';
import '../../../models/teacher_model.dart';
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

import 'custom_timetable_page.dart';

class TimeTablePageNew extends StatefulWidget {
  const TimeTablePageNew({Key? key}) : super(key: key);

  @override
  State<TimeTablePageNew> createState() => _TimeTablePageNewState();
}

class _TimeTablePageNewState extends State<TimeTablePageNew> {

  var searchController = TextEditingController();

  String authToken = "";
  List<DepartmentModel> departmentList = [];
  DepartmentModel dptSelectedValue = DepartmentModel(departmentId: 0, departmentName: "Select Department", departmentType: "Demo");
  var departmentItems;

  bool progressData = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Constants.getAuthToken().then((value) {
      authToken = value;
    });

    getDepartments(false);
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
      });
    }

  }

  getTeachers() async {
    setState(() {
      progressData = true;
    });
    Provider.of<AppProvider>(context, listen: false).fetchAllTeachers(true, "teacher", authToken).then((value) {
      if(value.isSuccess){
        getRooms();
      }
    });
  }

  getRooms() async {
    Provider.of<AppProvider>(context, listen: false).fetchAllRooms(authToken).then((value) {
      if(value.isSuccess){
        getTimeSlots();
      }
    });
  }

  getTimeSlots() async {
    Provider.of<AppProvider>(context, listen: false).fetchAllTimeSlots(authToken).then((value) {
      if(value.isSuccess){
        getWorkloads();
      }
    });
  }

  getWorkloads() async {
    Provider.of<AppProvider>(context, listen: false).fetchAttendanceWorkload(dptSelectedValue, authToken).then((value) {
      setState(() {
        progressData = false;
      });
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
                    Text("Please Select Department to Generate, View and Reschedule Time-Table", textAlign: TextAlign.center, style: AppAssets.latoBold_textDarkColor_20,),
                    const SizedBox(height: 50,),
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
                            if(dptSelectedValue.departmentId != 0){
                              getTeachers();
                            }
                          });
                        },
                        items: departmentItems,
                      ),
                    ),
                    const SizedBox(height: 30,),
                    Visibility(
                      visible: !progressData,
                      child: PrimaryButton(
                        width: double.infinity,
                        height: 50,
                        buttonMargin: const EdgeInsets.only(top: 10, bottom: 10),
                        buttonPadding: const EdgeInsets.all(12),
                        buttonText: "Generate Time Table",
                        buttonTextStyle: AppAssets.latoBold_whiteColor_16,
                        shadowColor: AppAssets.shadowColor,
                        buttonRadius: BorderRadius.circular(30),
                        onPress: () {
                          if(dptSelectedValue.departmentId == 0){
                            MyMessage.showFailedMessage("Please choose Department", context);
                          }else {
                            setState(() => progressData = true);
                            generateTimeTable(appProvider.workloadList, appProvider.teacherList, appProvider.roomList, appProvider.timeSlotList);
                          }
                        },
                      ),
                    ),
                    Visibility(visible: !progressData, child: Text("OR")),
                    Visibility(
                      visible: !progressData,
                      child: PrimaryButton(
                        width: double.infinity,
                        height: 50,
                        buttonMargin: const EdgeInsets.only(top: 10, bottom: 10),
                        buttonPadding: const EdgeInsets.all(12),
                        buttonText: "View Time Table",
                        buttonTextStyle: AppAssets.latoBold_whiteColor_16,
                        shadowColor: AppAssets.shadowColor,
                        buttonRadius: BorderRadius.circular(30),
                        onPress: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ViewTimeTablePage()));
                        },
                      ),
                    ),
                    Visibility(visible: !progressData, child: Text("OR")),
                    Visibility(
                      visible: !progressData,
                      child: PrimaryButton(
                        width: double.infinity,
                        height: 50,
                        buttonMargin: const EdgeInsets.only(top: 10, bottom: 10),
                        buttonPadding: const EdgeInsets.all(12),
                        buttonText: "Replace 2 Classes",
                        buttonTextStyle: AppAssets.latoBold_whiteColor_16,
                        shadowColor: AppAssets.shadowColor,
                        buttonRadius: BorderRadius.circular(30),
                        onPress: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SwapTimeTablePage()));
                        },
                      ),
                    ),
                    Visibility(visible: !progressData, child: Text("OR")),
                    Visibility(
                      visible: !progressData,
                      child: PrimaryButton(
                        width: double.infinity,
                        height: 50,
                        buttonMargin: const EdgeInsets.only(top: 10, bottom: 30),
                        buttonPadding: const EdgeInsets.all(12),
                        buttonText: "Let me decide",
                        buttonTextStyle: AppAssets.latoBold_whiteColor_16,
                        shadowColor: AppAssets.shadowColor,
                        buttonRadius: BorderRadius.circular(30),
                        onPress: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CustomTimeTablePage()));
                        },
                      ),
                    ),
                    Visibility(visible: progressData, child: const SizedBox(height:80, child: ProgressBarWidget())),
                  ],),
                ),
              ),
            ]),
          ),)
      ),
    );
  }

  void generateTimeTable(List<WorkloadAssignmentModel> workloadList, List<TeacherModel> teachersList, List<RoomsModel> roomsList, List<TimeSlotsModel> slotsList) {
    slotsList.sort((a, b) => a.timeslotId.compareTo(b.timeslotId));
    List<String> weekDays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"];

    List<WorkloadTimeTableModel> updatedList = [];

    if(workloadList.isNotEmpty){
      for(int i=0; i<workloadList.length; i++){
        if(workloadList[i].classRoutine == "Once a Week"){
          WorkloadTimeTableModel timeTableModel = WorkloadTimeTableModel.getInstance();
          timeTableModel.id = _randomUUID();
          timeTableModel.workloadAssignmentModel = workloadList[i];
          updatedList.add(timeTableModel);
        }else if(workloadList[i].classRoutine == "Two Times a Week"){
          WorkloadTimeTableModel timeTableModel1 = WorkloadTimeTableModel.getInstance();
          timeTableModel1.id = _randomUUID();
          timeTableModel1.workloadAssignmentModel = workloadList[i];
          updatedList.add(timeTableModel1);

          WorkloadTimeTableModel timeTableModel2 = WorkloadTimeTableModel.getInstance();
          timeTableModel2.id = _randomUUID();
          timeTableModel2.workloadAssignmentModel = workloadList[i];
          updatedList.add(timeTableModel2);
        }else if(workloadList[i].classRoutine == "Three Times a Week"){
          WorkloadTimeTableModel timeTableModel1 = WorkloadTimeTableModel.getInstance();
          timeTableModel1.id = _randomUUID();
          timeTableModel1.workloadAssignmentModel = workloadList[i];
          updatedList.add(timeTableModel1);

          WorkloadTimeTableModel timeTableModel2 = WorkloadTimeTableModel.getInstance();
          timeTableModel2.id = _randomUUID();
          timeTableModel2.workloadAssignmentModel = workloadList[i];
          updatedList.add(timeTableModel2);

          WorkloadTimeTableModel timeTableModel3 = WorkloadTimeTableModel.getInstance();
          timeTableModel3.id = _randomUUID();
          timeTableModel3.workloadAssignmentModel = workloadList[i];
          updatedList.add(timeTableModel3);
        }
      }
    }

    createAutoTimeTable(slotsList, weekDays, updatedList, roomsList);
  }

  void createAutoTimeTable(List<TimeSlotsModel> allSlotsList, List<String> weekDays, List<WorkloadTimeTableModel> workloadList, List<RoomsModel> roomsList) {

    //int count = departmentList.where((c) => c.departmentId == departmentModel.departmentId).toList().length;
    List<TimeSlotsModel> morningSlotsList = [];
    List<TimeSlotsModel> eveningSlotsList = [];
    for(int i=0; i<allSlotsList.length; i++){
      if(allSlotsList[i].timeslotType == "Morning"){
        morningSlotsList.add(allSlotsList[i]);
      } else{
        eveningSlotsList.add(allSlotsList[i]);
      }
    }

    List<WorkloadTimeTableModel> morningMondayClasses = [];
    List<WorkloadTimeTableModel> morningTuesdayClasses = [];
    List<WorkloadTimeTableModel> morningWednesdayClasses = [];
    List<WorkloadTimeTableModel> morningThursdayClasses = [];
    List<WorkloadTimeTableModel> morningFridayClasses = [];

    List<WorkloadTimeTableModel> eveningMondayClasses = [];
    List<WorkloadTimeTableModel> eveningTuesdayClasses = [];
    List<WorkloadTimeTableModel> eveningWednesdayClasses = [];
    List<WorkloadTimeTableModel> eveningThursdayClasses = [];
    List<WorkloadTimeTableModel> eveningFridayClasses = [];

    List<WorkloadTimeTableModel> allMondayClasses = [];
    List<WorkloadTimeTableModel> allTuesdayClasses = [];
    List<WorkloadTimeTableModel> allWednesdayClasses = [];
    List<WorkloadTimeTableModel> allThursdayClasses = [];
    List<WorkloadTimeTableModel> allFridayClasses = [];

    if(workloadList.isNotEmpty && roomsList.isNotEmpty && allSlotsList.isNotEmpty){
      //Monday
      for(int i=0; i<workloadList.length; i++){
        if(workloadList[i].workloadAssignmentModel.classModel.classType == "Morning"){
          if(morningMondayClasses.length < morningSlotsList.length){
              bool match = false;
              for(int j=0; j<morningMondayClasses.length; j++){
                if(morningMondayClasses[j].workloadAssignmentModel.userModel.userId == workloadList[i].workloadAssignmentModel.userModel.userId &&
                    morningMondayClasses[j].workloadAssignmentModel.classModel.classId == workloadList[i].workloadAssignmentModel.classModel.classId &&
                    morningMondayClasses[j].id == workloadList[i].id){
                  match = true;
                }
              }
              if(!match){
                morningMondayClasses.add(workloadList[i]);
                workloadList.removeWhere((item) => item.id == morningMondayClasses[morningMondayClasses.length-1].id);
              }
          }
        }
        else{
          if(eveningMondayClasses.length < eveningSlotsList.length){
            bool match = false;
            for(int j=0; j<eveningMondayClasses.length; j++){
              if(eveningMondayClasses[j].workloadAssignmentModel.userModel.userId == workloadList[i].workloadAssignmentModel.userModel.userId &&
                  eveningMondayClasses[j].workloadAssignmentModel.classModel.classId == workloadList[i].workloadAssignmentModel.classModel.classId &&
                  eveningMondayClasses[j].id == workloadList[i].id){
                match = true;
              }
            }
            if(!match){
              eveningMondayClasses.add(workloadList[i]);
              workloadList.removeWhere((item) => item.id == eveningMondayClasses[eveningMondayClasses.length-1].id);
            }
          }
        }
      }
      for(int i=0; i<morningMondayClasses.length; i++){
        allMondayClasses.add(morningMondayClasses[i]);
      }
      for(int i=0; i<eveningMondayClasses.length; i++){
        allMondayClasses.add(eveningMondayClasses[i]);
      }
      if(allMondayClasses.isNotEmpty && roomsList.isNotEmpty) {
        for (int i = 0; i < allMondayClasses.length; i++) {
          roomsList.shuffle();
          Random random = Random();
          allMondayClasses[i].workloadAssignmentModel.roomsModel.roomId = roomsList[random.nextInt(roomsList.length)].roomId;
          allMondayClasses[i].workloadAssignmentModel.roomsModel.roomName = roomsList[random.nextInt(roomsList.length)].roomName;
        }
      }

      //Tuesday
      for(int i=0; i<workloadList.length; i++){
        if(workloadList[i].workloadAssignmentModel.classModel.classType == "Morning"){
          if(morningTuesdayClasses.length < morningSlotsList.length){
            bool match = false;
            for(int j=0; j<morningTuesdayClasses.length; j++){
              if(morningTuesdayClasses[j].workloadAssignmentModel.userModel.userId == workloadList[i].workloadAssignmentModel.userModel.userId &&
                  morningTuesdayClasses[j].workloadAssignmentModel.classModel.classId == workloadList[i].workloadAssignmentModel.classModel.classId &&
                  morningTuesdayClasses[j].id == workloadList[i].id){
                match = true;
              }
            }
            if(!match){
              morningTuesdayClasses.add(workloadList[i]);
              workloadList.removeWhere((item) => item.id == morningTuesdayClasses[morningTuesdayClasses.length-1].id);
            }
          }
        }
        else{
          if(eveningTuesdayClasses.length < eveningSlotsList.length){
            bool match = false;
            for(int j=0; j<eveningTuesdayClasses.length; j++){
              if(eveningTuesdayClasses[j].workloadAssignmentModel.userModel.userId == workloadList[i].workloadAssignmentModel.userModel.userId &&
                  eveningTuesdayClasses[j].workloadAssignmentModel.classModel.classId == workloadList[i].workloadAssignmentModel.classModel.classId &&
                  eveningTuesdayClasses[j].id == workloadList[i].id){
                match = true;
              }
            }
            if(!match){
              eveningTuesdayClasses.add(workloadList[i]);
              workloadList.removeWhere((item) => item.id == eveningTuesdayClasses[eveningTuesdayClasses.length-1].id);
            }
          }
        }
      }
      for(int i=0; i<morningTuesdayClasses.length; i++){
        allTuesdayClasses.add(morningTuesdayClasses[i]);
      }
      for(int i=0; i<eveningTuesdayClasses.length; i++){
        allTuesdayClasses.add(eveningTuesdayClasses[i]);
      }
      if(allTuesdayClasses.isNotEmpty && roomsList.isNotEmpty) {
        for (int i = 0; i < allTuesdayClasses.length; i++) {
          roomsList.shuffle();
          Random random = Random();
          allTuesdayClasses[i].workloadAssignmentModel.roomsModel.roomId = roomsList[random.nextInt(roomsList.length)].roomId;
          allTuesdayClasses[i].workloadAssignmentModel.roomsModel.roomName = roomsList[random.nextInt(roomsList.length)].roomName;
        }
      }

      //Wednesday
      for(int i=0; i<workloadList.length; i++){
        if(workloadList[i].workloadAssignmentModel.classModel.classType == "Morning"){
          if(morningWednesdayClasses.length < morningSlotsList.length){
            bool match = false;
            for(int j=0; j<morningWednesdayClasses.length; j++){
              if(morningWednesdayClasses[j].workloadAssignmentModel.userModel.userId == workloadList[i].workloadAssignmentModel.userModel.userId &&
                  morningWednesdayClasses[j].workloadAssignmentModel.classModel.classId == workloadList[i].workloadAssignmentModel.classModel.classId &&
                  morningWednesdayClasses[j].id == workloadList[i].id){
                match = true;
              }
            }
            if(!match){
              morningWednesdayClasses.add(workloadList[i]);
              workloadList.removeWhere((item) => item.id == morningWednesdayClasses[morningWednesdayClasses.length-1].id);
            }
          }
        }
        else{
          if(eveningWednesdayClasses.length < eveningSlotsList.length){
            bool match = false;
            for(int j=0; j<eveningWednesdayClasses.length; j++){
              if(eveningWednesdayClasses[j].workloadAssignmentModel.userModel.userId == workloadList[i].workloadAssignmentModel.userModel.userId &&
                  eveningWednesdayClasses[j].workloadAssignmentModel.classModel.classId == workloadList[i].workloadAssignmentModel.classModel.classId &&
                  eveningWednesdayClasses[j].id == workloadList[i].id){
                match = true;
              }
            }
            if(!match){
              eveningWednesdayClasses.add(workloadList[i]);
              workloadList.removeWhere((item) => item.id == eveningWednesdayClasses[eveningWednesdayClasses.length-1].id);
            }
          }
        }
      }
      for(int i=0; i<morningWednesdayClasses.length; i++){
        allWednesdayClasses.add(morningWednesdayClasses[i]);
      }
      for(int i=0; i<eveningWednesdayClasses.length; i++){
        allWednesdayClasses.add(eveningWednesdayClasses[i]);
      }
      if(allWednesdayClasses.isNotEmpty && roomsList.isNotEmpty) {
        for (int i = 0; i < allWednesdayClasses.length; i++) {
          roomsList.shuffle();
          Random random = Random();
          allWednesdayClasses[i].workloadAssignmentModel.roomsModel.roomId = roomsList[random.nextInt(roomsList.length)].roomId;
          allWednesdayClasses[i].workloadAssignmentModel.roomsModel.roomName = roomsList[random.nextInt(roomsList.length)].roomName;
        }
      }

      //Thursday
      for(int i=0; i<workloadList.length; i++){
        if(workloadList[i].workloadAssignmentModel.classModel.classType == "Morning"){
          if(morningThursdayClasses.length < morningSlotsList.length){
            bool match = false;
            for(int j=0; j<morningThursdayClasses.length; j++){
              if(morningThursdayClasses[j].workloadAssignmentModel.userModel.userId == workloadList[i].workloadAssignmentModel.userModel.userId &&
                  morningThursdayClasses[j].workloadAssignmentModel.classModel.classId == workloadList[i].workloadAssignmentModel.classModel.classId &&
                  morningThursdayClasses[j].id == workloadList[i].id){
                match = true;
              }
            }
            if(!match){
              morningThursdayClasses.add(workloadList[i]);
              workloadList.removeWhere((item) => item.id == morningThursdayClasses[morningThursdayClasses.length-1].id);
            }
          }
        }
        else{
          if(eveningThursdayClasses.length < eveningSlotsList.length){
            bool match = false;
            for(int j=0; j<eveningThursdayClasses.length; j++){
              if(eveningThursdayClasses[j].workloadAssignmentModel.userModel.userId == workloadList[i].workloadAssignmentModel.userModel.userId &&
                  eveningThursdayClasses[j].workloadAssignmentModel.classModel.classId == workloadList[i].workloadAssignmentModel.classModel.classId &&
                  eveningThursdayClasses[j].id == workloadList[i].id){
                match = true;
              }
            }
            if(!match){
              eveningThursdayClasses.add(workloadList[i]);
              workloadList.removeWhere((item) => item.id == eveningThursdayClasses[eveningThursdayClasses.length-1].id);
            }
          }
        }
      }
      for(int i=0; i<morningThursdayClasses.length; i++){
        allThursdayClasses.add(morningThursdayClasses[i]);
      }
      for(int i=0; i<eveningThursdayClasses.length; i++){
        allThursdayClasses.add(eveningThursdayClasses[i]);
      }
      if(allThursdayClasses.isNotEmpty && roomsList.isNotEmpty) {
        for (int i = 0; i < allThursdayClasses.length; i++) {
          roomsList.shuffle();
          Random random = Random();
          allThursdayClasses[i].workloadAssignmentModel.roomsModel.roomId = roomsList[random.nextInt(roomsList.length)].roomId;
          allThursdayClasses[i].workloadAssignmentModel.roomsModel.roomName = roomsList[random.nextInt(roomsList.length)].roomName;
        }
      }

      //Friday
      for(int i=0; i<workloadList.length; i++){
        if(workloadList[i].workloadAssignmentModel.classModel.classType == "Morning"){
          if(morningFridayClasses.length < morningSlotsList.length){
            bool match = false;
            for(int j=0; j<morningFridayClasses.length; j++){
              if(morningFridayClasses[j].workloadAssignmentModel.userModel.userId == workloadList[i].workloadAssignmentModel.userModel.userId &&
                  morningFridayClasses[j].workloadAssignmentModel.classModel.classId == workloadList[i].workloadAssignmentModel.classModel.classId &&
                  morningFridayClasses[j].id == workloadList[i].id){
                match = true;
              }
            }
            if(!match){
              morningFridayClasses.add(workloadList[i]);
              workloadList.removeWhere((item) => item.id == morningFridayClasses[morningFridayClasses.length-1].id);
            }
          }
        }
        else{
          if(eveningFridayClasses.length < eveningSlotsList.length){
            bool match = false;
            for(int j=0; j<eveningFridayClasses.length; j++){
              if(eveningFridayClasses[j].workloadAssignmentModel.userModel.userId == workloadList[i].workloadAssignmentModel.userModel.userId &&
                  eveningFridayClasses[j].workloadAssignmentModel.classModel.classId == workloadList[i].workloadAssignmentModel.classModel.classId &&
                  eveningFridayClasses[j].id == workloadList[i].id){
                match = true;
              }
            }
            if(!match){
              eveningFridayClasses.add(workloadList[i]);
              workloadList.removeWhere((item) => item.id == eveningFridayClasses[eveningFridayClasses.length-1].id);
            }
          }
        }
      }
      for(int i=0; i<morningFridayClasses.length; i++){
        allFridayClasses.add(morningFridayClasses[i]);
      }
      for(int i=0; i<eveningFridayClasses.length; i++){
        allFridayClasses.add(eveningFridayClasses[i]);
      }
      if(allFridayClasses.isNotEmpty && roomsList.isNotEmpty) {
        for (int i = 0; i < allFridayClasses.length; i++) {
          roomsList.shuffle();
          Random random = Random();
          allFridayClasses[i].workloadAssignmentModel.roomsModel.roomId = roomsList[random.nextInt(roomsList.length)].roomId;
          allFridayClasses[i].workloadAssignmentModel.roomsModel.roomName = roomsList[random.nextInt(roomsList.length)].roomName;
        }
      }
    }

    List<TimeTableUploadModel> mondayTimeTableList = [];
    List<TimeTableUploadModel> tuesdayTimeTableList = [];
    List<TimeTableUploadModel> wednesdayTimeTableList = [];
    List<TimeTableUploadModel> thursdayTimeTableList = [];
    List<TimeTableUploadModel> fridayTimeTableList = [];
    List<TimeTableUploadModel> mainTimeTableList = [];

    var now = DateTime.now();
    var formatter = DateFormat('MMMM dd, yyyy');
    String formattedDate = formatter.format(now);

    List<TimeSlotsModel> mondayMSlots = [];
    List<TimeSlotsModel> mondayESlots = [];
    for(int i=0; i<morningSlotsList.length; i++){
      mondayMSlots.add(morningSlotsList[i]);
    }
    for(int i=0; i<eveningSlotsList.length; i++){
      mondayESlots.add(eveningSlotsList[i]);
    }

    for(int i=0; i<allMondayClasses.length; i++){
      TimeTableUploadModel uploadModel = TimeTableUploadModel.getInstance();
      uploadModel.workload_id = allMondayClasses[i].workloadAssignmentModel.workloadId;
      uploadModel.departmentId = allMondayClasses[i].workloadAssignmentModel.departmentModel.departmentId;
      uploadModel.roomId = allMondayClasses[i].workloadAssignmentModel.roomsModel.roomId;
      uploadModel.userId = allMondayClasses[i].workloadAssignmentModel.userModel.userId;
      uploadModel.day = "Monday";
      uploadModel.date = formattedDate;
      uploadModel.status = "Active";
      if(allMondayClasses[i].workloadAssignmentModel.classModel.classType == "Morning"){
        for(int j=0; j<mondayMSlots.length; j++){
            int count = mondayTimeTableList.where((c) => c.timeSlotId == mondayMSlots[j].timeslotId).toList().length;
            if(count == 0 && mondayTimeTableList.length < allMondayClasses.length){
              uploadModel.timeSlotId = mondayMSlots[j].timeslotId;
              mondayTimeTableList.add(uploadModel);
              mondayMSlots.removeWhere((item) => item.timeslotId == mondayTimeTableList[mondayTimeTableList.length-1].timeSlotId);
              break;
            }
        }
      }
      else{
        for(int j=0; j<mondayESlots.length; j++){
          int count = mondayTimeTableList.where((c) => c.timeSlotId == mondayESlots[j].timeslotId).toList().length;
          if(count == 0 && mondayTimeTableList.length < allMondayClasses.length){
            uploadModel.timeSlotId = mondayESlots[j].timeslotId;
            mondayTimeTableList.add(uploadModel);
            mondayESlots.removeWhere((item) => item.timeslotId == mondayTimeTableList[mondayTimeTableList.length-1].timeSlotId);
            break;
          }
        }
      }
    }

    for(int i=0; i<mondayTimeTableList.length; i++){
      print("______________ Monday Slot: ${mondayTimeTableList[i].timeSlotId}");
    }

    List<TimeSlotsModel> tuesdayMSlots = [];
    List<TimeSlotsModel> tuesdayESlots = [];
    for(int i=0; i<morningSlotsList.length; i++){
      tuesdayMSlots.add(morningSlotsList[i]);
    }
    for(int i=0; i<eveningSlotsList.length; i++){
      tuesdayMSlots.add(eveningSlotsList[i]);
    }
    for(int i=0; i<allTuesdayClasses.length; i++){
      TimeTableUploadModel uploadModel = TimeTableUploadModel.getInstance();
      uploadModel.workload_id = allTuesdayClasses[i].workloadAssignmentModel.workloadId;
      uploadModel.departmentId = allTuesdayClasses[i].workloadAssignmentModel.departmentModel.departmentId;
      uploadModel.roomId = allTuesdayClasses[i].workloadAssignmentModel.roomsModel.roomId;
      uploadModel.userId = allTuesdayClasses[i].workloadAssignmentModel.userModel.userId;
      uploadModel.day = "Tuesday";
      uploadModel.date = formattedDate;
      uploadModel.status = "Active";
      if(allTuesdayClasses[i].workloadAssignmentModel.classModel.classType == "Morning"){
        for(int j=0; j<tuesdayMSlots.length; j++){
          int count = tuesdayTimeTableList.where((c) => c.timeSlotId == tuesdayMSlots[j].timeslotId).toList().length;
          if(count == 0 && tuesdayTimeTableList.length < allTuesdayClasses.length){
            uploadModel.timeSlotId = tuesdayMSlots[j].timeslotId;
            tuesdayTimeTableList.add(uploadModel);
            tuesdayMSlots.removeWhere((item) => item.timeslotId == tuesdayTimeTableList[tuesdayTimeTableList.length-1].timeSlotId);
            break;
          }
        }
      }
      else{
        for(int j=0; j<tuesdayESlots.length; j++){
          int count = tuesdayTimeTableList.where((c) => c.timeSlotId == tuesdayESlots[j].timeslotId).toList().length;
          if(count == 0 && tuesdayTimeTableList.length < allTuesdayClasses.length){
            uploadModel.timeSlotId = tuesdayESlots[j].timeslotId;
            tuesdayTimeTableList.add(uploadModel);
            tuesdayESlots.removeWhere((item) => item.timeslotId == tuesdayTimeTableList[tuesdayTimeTableList.length-1].timeSlotId);
            break;
          }
        }
      }
    }


    List<TimeSlotsModel> wednesdayMSlots = [];
    List<TimeSlotsModel> wednesdayESlots = [];
    for(int i=0; i<morningSlotsList.length; i++){
      wednesdayMSlots.add(morningSlotsList[i]);
    }
    for(int i=0; i<eveningSlotsList.length; i++){
      wednesdayESlots.add(eveningSlotsList[i]);
    }

    for(int i=0; i<allWednesdayClasses.length; i++){
      TimeTableUploadModel uploadModel = TimeTableUploadModel.getInstance();
      uploadModel.workload_id = allWednesdayClasses[i].workloadAssignmentModel.workloadId;
      uploadModel.departmentId = allWednesdayClasses[i].workloadAssignmentModel.departmentModel.departmentId;
      uploadModel.roomId = allWednesdayClasses[i].workloadAssignmentModel.roomsModel.roomId;
      uploadModel.userId = allWednesdayClasses[i].workloadAssignmentModel.userModel.userId;
      uploadModel.day = "Wednesday";
      uploadModel.date = formattedDate;
      uploadModel.status = "Active";
      if(allWednesdayClasses[i].workloadAssignmentModel.classModel.classType == "Morning"){
        for(int j=0; j<wednesdayMSlots.length; j++){
          int count = wednesdayTimeTableList.where((c) => c.timeSlotId == wednesdayMSlots[j].timeslotId).toList().length;
          if(count == 0 && wednesdayTimeTableList.length < allWednesdayClasses.length){
            uploadModel.timeSlotId = wednesdayMSlots[j].timeslotId;
            wednesdayTimeTableList.add(uploadModel);
            wednesdayMSlots.removeWhere((item) => item.timeslotId == wednesdayTimeTableList[wednesdayTimeTableList.length-1].timeSlotId);
            break;
          }
        }
      }
      else{
        for(int j=0; j<wednesdayESlots.length; j++){
          int count = wednesdayTimeTableList.where((c) => c.timeSlotId == wednesdayESlots[j].timeslotId).toList().length;
          if(count == 0 && wednesdayTimeTableList.length < allWednesdayClasses.length){
            uploadModel.timeSlotId = wednesdayESlots[j].timeslotId;
            wednesdayTimeTableList.add(uploadModel);
            wednesdayESlots.removeWhere((item) => item.timeslotId == wednesdayTimeTableList[wednesdayTimeTableList.length-1].timeSlotId);
            break;
          }
        }
      }
    }

    List<TimeSlotsModel> thursdayMSlots = [];
    List<TimeSlotsModel> thursdayESlots = [];
    for(int i=0; i<morningSlotsList.length; i++){
      thursdayMSlots.add(morningSlotsList[i]);
    }
    for(int i=0; i<eveningSlotsList.length; i++){
      thursdayESlots.add(eveningSlotsList[i]);
    }

    for(int i=0; i<allThursdayClasses.length; i++){
      TimeTableUploadModel uploadModel = TimeTableUploadModel.getInstance();
      uploadModel.workload_id = allThursdayClasses[i].workloadAssignmentModel.workloadId;
      uploadModel.departmentId = allThursdayClasses[i].workloadAssignmentModel.departmentModel.departmentId;
      uploadModel.roomId = allThursdayClasses[i].workloadAssignmentModel.roomsModel.roomId;
      uploadModel.userId = allThursdayClasses[i].workloadAssignmentModel.userModel.userId;
      uploadModel.day = "Thursday";
      uploadModel.date = formattedDate;
      uploadModel.status = "Active";
      if(allThursdayClasses[i].workloadAssignmentModel.classModel.classType == "Morning"){
        for(int j=0; j<thursdayMSlots.length; j++){
          int count = thursdayTimeTableList.where((c) => c.timeSlotId == thursdayMSlots[j].timeslotId).toList().length;
          if(count == 0 && thursdayTimeTableList.length < allThursdayClasses.length){
            uploadModel.timeSlotId = thursdayMSlots[j].timeslotId;
            thursdayTimeTableList.add(uploadModel);
            thursdayMSlots.removeWhere((item) => item.timeslotId == thursdayTimeTableList[thursdayTimeTableList.length-1].timeSlotId);
            break;
          }
        }
      }
      else{
        for(int j=0; j<thursdayESlots.length; j++){
          int count = thursdayTimeTableList.where((c) => c.timeSlotId == thursdayESlots[j].timeslotId).toList().length;
          if(count == 0 && thursdayTimeTableList.length < allThursdayClasses.length){
            uploadModel.timeSlotId = thursdayESlots[j].timeslotId;
            thursdayTimeTableList.add(uploadModel);
            thursdayESlots.removeWhere((item) => item.timeslotId == thursdayTimeTableList[thursdayTimeTableList.length-1].timeSlotId);
            break;
          }
        }
      }
    }

    List<TimeSlotsModel> fridayMSlots = [];
    List<TimeSlotsModel> fridayESlots = [];
    for(int i=0; i<morningSlotsList.length; i++){
      fridayMSlots.add(morningSlotsList[i]);
    }
    for(int i=0; i<eveningSlotsList.length; i++){
      fridayESlots.add(eveningSlotsList[i]);
    }

    for(int i=0; i<allFridayClasses.length; i++){
      TimeTableUploadModel uploadModel = TimeTableUploadModel.getInstance();
      uploadModel.workload_id = allFridayClasses[i].workloadAssignmentModel.workloadId;
      uploadModel.departmentId = allFridayClasses[i].workloadAssignmentModel.departmentModel.departmentId;
      uploadModel.roomId = allFridayClasses[i].workloadAssignmentModel.roomsModel.roomId;
      uploadModel.userId = allFridayClasses[i].workloadAssignmentModel.userModel.userId;
      uploadModel.day = "Friday";
      uploadModel.date = formattedDate;
      uploadModel.status = "Active";
      if(allFridayClasses[i].workloadAssignmentModel.classModel.classType == "Morning"){
        for(int j=0; j<fridayMSlots.length; j++){
          int count = fridayTimeTableList.where((c) => c.timeSlotId == fridayMSlots[j].timeslotId).toList().length;
          if(count == 0 && fridayTimeTableList.length < allFridayClasses.length){
            uploadModel.timeSlotId = fridayMSlots[j].timeslotId;
            fridayTimeTableList.add(uploadModel);
            fridayMSlots.removeWhere((item) => item.timeslotId == fridayTimeTableList[fridayTimeTableList.length-1].timeSlotId);
            break;
          }
        }
      }
      else{
        for(int j=0; j<fridayESlots.length; j++){
          int count = fridayTimeTableList.where((c) => c.timeSlotId == fridayESlots[j].timeslotId).toList().length;
          if(count == 0 && fridayTimeTableList.length < allFridayClasses.length){
            uploadModel.timeSlotId = fridayESlots[j].timeslotId;
            fridayTimeTableList.add(uploadModel);
            fridayESlots.removeWhere((item) => item.timeslotId == fridayTimeTableList[fridayTimeTableList.length-1].timeSlotId);
            break;
          }
        }
      }
    }

    for(int i=0;i<mondayTimeTableList.length; i++){
      mainTimeTableList.add(mondayTimeTableList[i]);
    }for(int i=0;i<tuesdayTimeTableList.length; i++){
      mainTimeTableList.add(tuesdayTimeTableList[i]);
    }for(int i=0;i<wednesdayTimeTableList.length; i++){
      mainTimeTableList.add(wednesdayTimeTableList[i]);
    }for(int i=0;i<thursdayTimeTableList.length; i++){
      mainTimeTableList.add(thursdayTimeTableList[i]);
    }for(int i=0;i<fridayTimeTableList.length; i++){
      mainTimeTableList.add(fridayTimeTableList[i]);
    }

    print("______________: Monday: ${allMondayClasses.length} - ${mondayTimeTableList.length}");
    print("______________: Tuesday: ${allTuesdayClasses.length} - ${tuesdayTimeTableList.length}");
    print("______________: Wednesday: ${allWednesdayClasses.length} - ${wednesdayTimeTableList.length}");
    print("______________: Thursday: ${allThursdayClasses.length} - ${thursdayTimeTableList.length}");
    print("______________: Friday: ${allFridayClasses.length} - ${fridayTimeTableList.length}");
    print("______________: Main: ${mainTimeTableList.length}");

    var data = jsonEncode(mainTimeTableList.map((i) => i.toJson()).toList()).toString();
    print("______________: Data: ${data}");

    Provider.of<AppProvider>(context, listen: false)
        .addBulkTimeTable(data, authToken)
        .then((value) {
      if (value.isSuccess) {
        setState(() {
          progressData = false;
          dptSelectedValue = departmentList[0];
        });
        MyMessage.showSuccessMessage(value.message, context);
      } else {
        MyMessage.showFailedMessage(value.message, context);
      }
    });
  }

  String _randomUUID(){
    var uuid = Uuid();
    return uuid.v4().toString();
  }
}
