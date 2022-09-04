import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:university_management_system/main.dart';
import 'package:university_management_system/models/teacher_model.dart';
import 'package:university_management_system/models/timetable_upload_model.dart';
import 'package:university_management_system/models/workload_timtable_model.dart';
import '../../../../assets/app_assets.dart';
import '../../../../models/rooms_model.dart';
import '../../../../models/timeslots_model.dart';
import 'package:uuid/uuid.dart';

import '../../../../models/workload_assignment_model.dart';
import '../../../../providers/app_provider.dart';

Future<Uint8List> makeTimeTablePdf(List<WorkloadAssignmentModel> workloadList, List<TeacherModel> teachersList, List<RoomsModel> roomsList, List<TimeSlotsModel> slotsList) async {
  final pdf = Document();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //final imageLogo = MemoryImage((await rootBundle.load(AppAssets.attendanceColoredIcon)).buffer.asUint8List());

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

  pdf.addPage(
    MultiPage(pageTheme:
    const PageTheme(orientation: PageOrientation.landscape,),
        build: (context) {
          return <Widget> [
            Stack(children: [
              //Opacity(opacity: 0.3, child: Center( child: Container(margin: const EdgeInsets.only(top: 70), width: 300, height: 300, child: Image(imageLogo),),),),
              _headerLayout(slotsList, weekDays, updatedList, roomsList, prefs),
            ]),

          ];
        })
  );
  return pdf.save();
}

String _randomUUID(){
  var uuid = Uuid();
  return uuid.v4().toString();
}

_weekDaysTimeTable(String weekDay, List<TimeSlotsModel> slotsList, List<WorkloadTimeTableModel> workloadList, List<RoomsModel> roomsList) {
  return TableRow(children: [
    Expanded(flex: 1, child: Padding(padding: const EdgeInsets.all(6), child: Center( child: Text("${weekDay}", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),),),
    for(int index=0; index<workloadList.length; index++)
      Expanded(flex: 2, child: Padding(padding: const EdgeInsets.all(6),
        child: Column(children: [
            Text("${workloadList[index].workloadAssignmentModel.classModel.className} ${workloadList[index].workloadAssignmentModel.classModel.classSemester} ${workloadList[index].workloadAssignmentModel.classModel.classType}", style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            Text(workloadList[index].workloadAssignmentModel.userModel.userName, style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            Text(workloadList[index].workloadAssignmentModel.roomsModel.roomName, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
        ]),
      )),
  ]);
}

_headerLayout(List<TimeSlotsModel> slotsList, List<String> weekDays, List<WorkloadTimeTableModel> workloadList, List<RoomsModel> roomsList, SharedPreferences prefs) {
  //_calculate(slotsList, workloadList, roomsList);

  List<WorkloadTimeTableModel> mondayClasses = [];
  List<WorkloadTimeTableModel> tuesdayClasses = [];
  List<WorkloadTimeTableModel> wednesdayClasses = [];
  List<WorkloadTimeTableModel> thursdayClasses = [];
  List<WorkloadTimeTableModel> fridayClasses = [];

  if(workloadList.isNotEmpty){
    //Monday
    for(int i=0; i<workloadList.length; i++){
      if(mondayClasses.length < slotsList.length){
        bool match = false;
        for(int j=0; j<mondayClasses.length; j++){
          if(mondayClasses[j].workloadAssignmentModel.userModel.userId == workloadList[i].workloadAssignmentModel.userModel.userId &&
              mondayClasses[j].workloadAssignmentModel.classModel.classId == workloadList[i].workloadAssignmentModel.classModel.classId &&
              mondayClasses[j].id == workloadList[i].id){
            match = true;
          }
        }
        if(!match){
          mondayClasses.add(workloadList[i]);
          //workloadList[i].assignStatus = "assigned";
          //workloadList.removeWhere((item) => item.workloadId == mondayClasses[mondayClasses.length-1].workloadId);
          workloadList.removeWhere((item) => item.id == mondayClasses[mondayClasses.length-1].id);
        }
      }
    }
    if(mondayClasses.isNotEmpty && roomsList.isNotEmpty && roomsList.length >= mondayClasses.length) {
      roomsList.shuffle();
      for (int i = 0; i < roomsList.length; i++) {
        if(i<mondayClasses.length){
          mondayClasses[i].workloadAssignmentModel.roomsModel.roomId = roomsList[i].roomId;
          mondayClasses[i].workloadAssignmentModel.roomsModel.roomName = roomsList[i].roomName;
        }
      }
    }

    //Tuesday
    for(int i=0; i<workloadList.length; i++){
      if(tuesdayClasses.length < slotsList.length){
        bool match = false;
        for(int j=0; j<tuesdayClasses.length; j++){
          if(tuesdayClasses[j].workloadAssignmentModel.userModel.userId == workloadList[i].workloadAssignmentModel.userModel.userId &&
              tuesdayClasses[j].workloadAssignmentModel.classModel.classId == workloadList[i].workloadAssignmentModel.classModel.classId &&
              tuesdayClasses[j].id == workloadList[i].id){
            match = true;
          }
        }
        if(!match){
          tuesdayClasses.add(workloadList[i]);
          //workloadList[i].assignStatus = "assigned";
          // workloadList.removeWhere((item) => item.workloadId == tuesdayClasses[tuesdayClasses.length-1].workloadId);
          workloadList.removeWhere((item) => item.id == tuesdayClasses[tuesdayClasses.length-1].id);
        }
      }
    }
    if(tuesdayClasses.isNotEmpty && roomsList.isNotEmpty && roomsList.length >= tuesdayClasses.length) {
      roomsList.shuffle();
      for (int i = 0; i < roomsList.length; i++) {
        if(i<tuesdayClasses.length){
          tuesdayClasses[i].workloadAssignmentModel.roomsModel.roomId = roomsList[i].roomId;
          tuesdayClasses[i].workloadAssignmentModel.roomsModel.roomName = roomsList[i].roomName;
        }
      }
    }

    //Wednesday
    for(int i=0; i<workloadList.length; i++){
      if(wednesdayClasses.length < slotsList.length){
        bool match = false;
        for(int j=0; j<wednesdayClasses.length; j++){
          if(wednesdayClasses[j].workloadAssignmentModel.userModel.userId == workloadList[i].workloadAssignmentModel.userModel.userId &&
              wednesdayClasses[j].workloadAssignmentModel.classModel.classId == workloadList[i].workloadAssignmentModel.classModel.classId &&
              wednesdayClasses[j].id == workloadList[i].id){
            match = true;
          }
        }
        if(!match){
          wednesdayClasses.add(workloadList[i]);
          //workloadList[i].assignStatus = "assigned";
          // workloadList.removeWhere((item) => item.workloadId == wednesdayClasses[wednesdayClasses.length-1].workloadId);
          workloadList.removeWhere((item) => item.id == wednesdayClasses[wednesdayClasses.length-1].id);
        }
      }
    }
    if(wednesdayClasses.isNotEmpty && roomsList.isNotEmpty && roomsList.length >= wednesdayClasses.length) {
      roomsList.shuffle();
      for (int i = 0; i < roomsList.length; i++) {
        if(i<wednesdayClasses.length){
          wednesdayClasses[i].workloadAssignmentModel.roomsModel.roomId = roomsList[i].roomId;
          wednesdayClasses[i].workloadAssignmentModel.roomsModel.roomName = roomsList[i].roomName;
        }
      }
    }

    //Thursday
    for(int i=0; i<workloadList.length; i++){
      if(thursdayClasses.length < slotsList.length){
        bool match = false;
        for(int j=0; j<thursdayClasses.length; j++){
          if(thursdayClasses[j].workloadAssignmentModel.userModel.userId == workloadList[i].workloadAssignmentModel.userModel.userId &&
              thursdayClasses[j].workloadAssignmentModel.classModel.classId == workloadList[i].workloadAssignmentModel.classModel.classId &&
              thursdayClasses[j].id == workloadList[i].id){
            match = true;
          }
        }
        if(!match){
          thursdayClasses.add(workloadList[i]);
          //workloadList[i].assignStatus = "assigned";
          // workloadList.removeWhere((item) => item.workloadId == thursdayClasses[thursdayClasses.length-1].workloadId);
          workloadList.removeWhere((item) => item.id == thursdayClasses[thursdayClasses.length-1].id);
        }
      }
    }
    if(thursdayClasses.isNotEmpty && roomsList.isNotEmpty && roomsList.length >= thursdayClasses.length) {
      roomsList.shuffle();
      for (int i = 0; i < roomsList.length; i++) {
        if(i<thursdayClasses.length){
          thursdayClasses[i].workloadAssignmentModel.roomsModel.roomId = roomsList[i].roomId;
          thursdayClasses[i].workloadAssignmentModel.roomsModel.roomName = roomsList[i].roomName;
        }
      }
    }

    //Friday
    for(int i=0; i<workloadList.length; i++){
      if(fridayClasses.length < slotsList.length){
        bool match = false;
        for(int j=0; j<fridayClasses.length; j++){
          if(fridayClasses[j].workloadAssignmentModel.userModel.userId == workloadList[i].workloadAssignmentModel.userModel.userId &&
              fridayClasses[j].workloadAssignmentModel.classModel.classId == workloadList[i].workloadAssignmentModel.classModel.classId &&
              fridayClasses[j].id == workloadList[i].id){
            match = true;
          }
        }
        if(!match){
          fridayClasses.add(workloadList[i]);
          //workloadList[i].assignStatus = "assigned";
          // workloadList.removeWhere((item) => item.workloadId == fridayClasses[fridayClasses.length-1].workloadId);
          workloadList.removeWhere((item) => item.id == fridayClasses[fridayClasses.length-1].id);
        }
      }
    }
    if(fridayClasses.isNotEmpty && roomsList.isNotEmpty && roomsList.length >= fridayClasses.length) {
      roomsList.shuffle();
      for (int i = 0; i < roomsList.length; i++) {
        if(i<fridayClasses.length){
          fridayClasses[i].workloadAssignmentModel.roomsModel.roomId = roomsList[i].roomId;
          fridayClasses[i].workloadAssignmentModel.roomsModel.roomName = roomsList[i].roomName;
        }
      }
    }
  }

  List<TimeTableUploadModel> mainTimeTableList = [];
  var now = DateTime.now();
  var formatter = DateFormat('MMMM dd, yyyy');
  String formattedDate = formatter.format(now);
  for(int i=0; i<mondayClasses.length; i++){
    TimeTableUploadModel uploadModel = TimeTableUploadModel.getInstance();
    uploadModel.workload_id = mondayClasses[i].workloadAssignmentModel.workloadId;
    uploadModel.departmentId = mondayClasses[i].workloadAssignmentModel.departmentModel.departmentId;
    uploadModel.roomId = mondayClasses[i].workloadAssignmentModel.roomsModel.roomId;
    uploadModel.userId = mondayClasses[i].workloadAssignmentModel.userModel.userId;
    uploadModel.day = "Monday";
    uploadModel.date = formattedDate;
    uploadModel.status = "Active";
    uploadModel.timeSlotId = slotsList.length > i ? slotsList[i].timeslotId : 0;
    mainTimeTableList.add(uploadModel);
  }
  for(int i=0; i<tuesdayClasses.length; i++){
    TimeTableUploadModel uploadModel = TimeTableUploadModel.getInstance();
    uploadModel.workload_id = tuesdayClasses[i].workloadAssignmentModel.workloadId;
    uploadModel.departmentId = tuesdayClasses[i].workloadAssignmentModel.departmentModel.departmentId;
    uploadModel.roomId = tuesdayClasses[i].workloadAssignmentModel.roomsModel.roomId;
    uploadModel.userId = tuesdayClasses[i].workloadAssignmentModel.userModel.userId;
    uploadModel.day = "Tuesday";
    uploadModel.date = formattedDate;
    uploadModel.status = "Active";
    uploadModel.timeSlotId = slotsList.length > i ? slotsList[i].timeslotId : 0;
    mainTimeTableList.add(uploadModel);
  }
  for(int i=0; i<wednesdayClasses.length; i++){
    TimeTableUploadModel uploadModel = TimeTableUploadModel.getInstance();
    uploadModel.workload_id = wednesdayClasses[i].workloadAssignmentModel.workloadId;
    uploadModel.departmentId = wednesdayClasses[i].workloadAssignmentModel.departmentModel.departmentId;
    uploadModel.roomId = wednesdayClasses[i].workloadAssignmentModel.roomsModel.roomId;
    uploadModel.userId = wednesdayClasses[i].workloadAssignmentModel.userModel.userId;
    uploadModel.day = "Wednesday";
    uploadModel.date = formattedDate;
    uploadModel.status = "Active";
    uploadModel.timeSlotId = slotsList.length > i ? slotsList[i].timeslotId : 0;
    mainTimeTableList.add(uploadModel);
  }
  for(int i=0; i<thursdayClasses.length; i++){
    TimeTableUploadModel uploadModel = TimeTableUploadModel.getInstance();
    uploadModel.workload_id = thursdayClasses[i].workloadAssignmentModel.workloadId;
    uploadModel.departmentId = thursdayClasses[i].workloadAssignmentModel.departmentModel.departmentId;
    uploadModel.roomId = thursdayClasses[i].workloadAssignmentModel.roomsModel.roomId;
    uploadModel.userId = thursdayClasses[i].workloadAssignmentModel.userModel.userId;
    uploadModel.day = "Thursday";
    uploadModel.date = formattedDate;
    uploadModel.status = "Active";
    uploadModel.timeSlotId = slotsList.length > i ? slotsList[i].timeslotId : 0;
    mainTimeTableList.add(uploadModel);
  }
  for(int i=0; i<fridayClasses.length; i++){
    TimeTableUploadModel uploadModel = TimeTableUploadModel.getInstance();
    uploadModel.workload_id = fridayClasses[i].workloadAssignmentModel.workloadId;
    uploadModel.departmentId = fridayClasses[i].workloadAssignmentModel.departmentModel.departmentId;
    uploadModel.roomId = fridayClasses[i].workloadAssignmentModel.roomsModel.roomId;
    uploadModel.userId = fridayClasses[i].workloadAssignmentModel.userModel.userId;
    uploadModel.day = "Friday";
    uploadModel.date = formattedDate;
    uploadModel.status = "Active";
    uploadModel.timeSlotId = slotsList.length > i ? slotsList[i].timeslotId : 0;
    mainTimeTableList.add(uploadModel);
  }

  print("______________: Monday: ${mondayClasses.length}");
  print("______________: Tuesday: ${tuesdayClasses.length}");
  print("______________: Wednesday: ${wednesdayClasses.length}");
  print("______________: Thursday: ${thursdayClasses.length}");
  print("______________: Friday: ${fridayClasses.length}");
  print("______________: Main: ${mainTimeTableList.length}");

  var data = jsonEncode(mainTimeTableList.map((i) => i.toJson()).toList()).toString();
  print("______________: Data: ${data}");

  prefs.setString("time_table_bulk_data", data);

  return Stack(children: [
    Column(children: [
      Text("Time Table", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
      SizedBox(height: 4),
      Text("Department of Islamic Studies, University of Chakwal", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
      SizedBox(height: 4),
      Text(formattedDate, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
      SizedBox(height: 20),
      Table(
          border: TableBorder.all(color: PdfColors.black),
          children: [
            TableRow(children: [
              Expanded(flex: 1, child: Padding(padding: const EdgeInsets.all(6), child: Center( child: Text("Days", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),),),
              for(int index=0; index<slotsList.length; index++)
                Expanded(flex: 2, child: Padding(padding: const EdgeInsets.all(6), child: Center( child: Text("${slotsList[index].timeslot}", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),),),
            ]),
            for(int weekIndex=0; weekIndex<weekDays.length; weekIndex++)
              _weekDaysTimeTable(weekDays[weekIndex], slotsList, weekDays[weekIndex] == "Monday" ? mondayClasses : weekDays[weekIndex] == "Tuesday" ? tuesdayClasses : weekDays[weekIndex] == "Wednesday" ? wednesdayClasses : weekDays[weekIndex] == "Thursday" ? thursdayClasses : fridayClasses, roomsList)
          ]),
      SizedBox(height: 10),
      Text("Note: Please do not change your schedule without permission", style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
    ])
  ]);
}