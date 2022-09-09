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
import '../../../../assets/app_assets.dart';
import '../../../../models/rooms_model.dart';
import '../../../../models/teacher_own_timetable_model.dart';
import '../../../../models/timeslots_model.dart';
import 'package:uuid/uuid.dart';

import '../../../../models/user_model.dart';
import '../../../../models/workload_assignment_model.dart';
import '../../../../providers/app_provider.dart';

Future<Uint8List> makeTimeTablePdf(List<TeacherOwnTimeTableModel> teacherTimeTableList, List<TimeSlotsModel> slotsList) async {
  final pdf = Document();
  //final imageLogo = MemoryImage((await rootBundle.load(AppAssets.attendanceColoredIcon)).buffer.asUint8List());

  slotsList.sort((a, b) => a.timeslotId.compareTo(b.timeslotId));
  List<String> weekDays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"];

  pdf.addPage(
    MultiPage(pageTheme:
    const PageTheme(orientation: PageOrientation.landscape,),
        build: (context) {
          return <Widget> [
            Stack(children: [
              //Opacity(opacity: 0.3, child: Center( child: Container(margin: const EdgeInsets.only(top: 70), width: 300, height: 300, child: Image(imageLogo),),),),
              _headerLayout(slotsList, weekDays, teacherTimeTableList),
            ]),

          ];
        })
  );
  return pdf.save();
}

_weekDaysTimeTable(String weekDay, List<TeacherOwnTimeTableModel> workloadList) {
  return TableRow(children: [
    Expanded(flex: 1, child: Padding(padding: const EdgeInsets.all(6), child: Center( child: Text("${weekDay}", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),),),
    for(int index=0; index<workloadList.length; index++)
      Expanded(flex: 2, child: Padding(padding: const EdgeInsets.all(6),
        child: _returnCell(workloadList[index]),
      )),
  ]);
}

_returnCell(TeacherOwnTimeTableModel workloadList) {
  if(workloadList.timeTableId == 0){
    return Column(children: []);
  }else{
    return Column(children: [
      Text("${workloadList.workloadAssignmentModel.classModel.className} ${workloadList.workloadAssignmentModel.classModel.classSemester} ${workloadList.workloadAssignmentModel.classModel.classType}", style: TextStyle(fontSize: 7, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
      Text(workloadList.userModel.userName, style: TextStyle(fontSize: 7, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
      Text("(${workloadList.workloadAssignmentModel.subjectModel.subjectCode}) ${workloadList.workloadAssignmentModel.subjectModel.subjectName}", style: TextStyle(fontSize: 7, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
      Text(workloadList.roomsModel.roomName, style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
    ]);
  }
}

_headerLayout(List<TimeSlotsModel> slotsList, List<String> weekDays, List<TeacherOwnTimeTableModel> workloadList) {
  //_calculate(slotsList, workloadList, roomsList);
  List<TeacherOwnTimeTableModel> mondayClasses = [];
  List<TeacherOwnTimeTableModel> tuesdayClasses = [];
  List<TeacherOwnTimeTableModel> wednesdayClasses = [];
  List<TeacherOwnTimeTableModel> thursdayClasses = [];
  List<TeacherOwnTimeTableModel> fridayClasses = [];

  for(int i=0; i<workloadList.length; i++){
    if(workloadList[i].day == "Monday"){
      mondayClasses.add(workloadList[i]);
    } else if(workloadList[i].day == "Tuesday"){
      tuesdayClasses.add(workloadList[i]);
    } else if(workloadList[i].day == "Wednesday"){
      wednesdayClasses.add(workloadList[i]);
    } else if(workloadList[i].day == "Thursday"){
      thursdayClasses.add(workloadList[i]);
    } else if(workloadList[i].day == "Friday"){
      fridayClasses.add(workloadList[i]);
    }
  }

  mondayClasses.sort((a, b) => a.timeSlotId.compareTo(b.timeSlotId));
  tuesdayClasses.sort((a, b) => a.timeSlotId.compareTo(b.timeSlotId));
  wednesdayClasses.sort((a, b) => a.timeSlotId.compareTo(b.timeSlotId));
  thursdayClasses.sort((a, b) => a.timeSlotId.compareTo(b.timeSlotId));
  fridayClasses.sort((a, b) => a.timeSlotId.compareTo(b.timeSlotId));

  List<TeacherOwnTimeTableModel> mondayClassesNew = [];
  List<TeacherOwnTimeTableModel> tuesdayClassesNew = [];
  List<TeacherOwnTimeTableModel> wednesdayClassesNew = [];
  List<TeacherOwnTimeTableModel> thursdayClassesNew = [];
  List<TeacherOwnTimeTableModel> fridayClassesNew = [];

  for(int i=0;i<slotsList.length; i++){
    TeacherOwnTimeTableModel ttSelectedValue1 = TeacherOwnTimeTableModel(timeTableId: 0, workloadId: 0, departmentId: 0, userId: 0, roomId: 0, timeSlotId: 0, day: "Select ID", date: "", status: "No", userModel: UserModel.getInstance(), roomsModel: RoomsModel.getInstance(), timeSlotsModel: TimeSlotsModel.getInstance(), workloadAssignmentModel: WorkloadAssignmentModel.getInstance());
    TeacherOwnTimeTableModel ttSelectedValue2 = TeacherOwnTimeTableModel(timeTableId: 0, workloadId: 0, departmentId: 0, userId: 0, roomId: 0, timeSlotId: 0, day: "Select ID", date: "", status: "Yes", userModel: UserModel.getInstance(), roomsModel: RoomsModel.getInstance(), timeSlotsModel: TimeSlotsModel.getInstance(), workloadAssignmentModel: WorkloadAssignmentModel.getInstance());
    int count = mondayClasses.where((c) => c.timeSlotId == slotsList[i].timeslotId).toList().length;
    if(count == 0){
      mondayClassesNew.insert(i, ttSelectedValue1);
    }else{
      ttSelectedValue2.timeSlotId = slotsList[i].timeslotId;
      mondayClassesNew.insert(i, ttSelectedValue2);
    }
  }
  for(int i=0;i<mondayClasses.length; i++){
    mondayClassesNew[mondayClassesNew.indexWhere((element) => element.timeSlotId == mondayClasses[i].timeSlotId)] = mondayClasses[i];
  }

  for(int i=0;i<slotsList.length; i++){
    TeacherOwnTimeTableModel ttSelectedValue1 = TeacherOwnTimeTableModel(timeTableId: 0, workloadId: 0, departmentId: 0, userId: 0, roomId: 0, timeSlotId: 0, day: "Select ID", date: "", status: "No", userModel: UserModel.getInstance(), roomsModel: RoomsModel.getInstance(), timeSlotsModel: TimeSlotsModel.getInstance(), workloadAssignmentModel: WorkloadAssignmentModel.getInstance());
    TeacherOwnTimeTableModel ttSelectedValue2 = TeacherOwnTimeTableModel(timeTableId: 0, workloadId: 0, departmentId: 0, userId: 0, roomId: 0, timeSlotId: 0, day: "Select ID", date: "", status: "Yes", userModel: UserModel.getInstance(), roomsModel: RoomsModel.getInstance(), timeSlotsModel: TimeSlotsModel.getInstance(), workloadAssignmentModel: WorkloadAssignmentModel.getInstance());
    int count = tuesdayClasses.where((c) => c.timeSlotId == slotsList[i].timeslotId).toList().length;
    if(count == 0){
      tuesdayClassesNew.insert(i, ttSelectedValue1);
    }else{
      ttSelectedValue2.timeSlotId = slotsList[i].timeslotId;
      tuesdayClassesNew.insert(i, ttSelectedValue2);
    }
  }
  for(int i=0;i<tuesdayClasses.length; i++){
    tuesdayClassesNew[tuesdayClassesNew.indexWhere((element) => element.timeSlotId == tuesdayClasses[i].timeSlotId)] = tuesdayClasses[i];
  }

  for(int i=0;i<slotsList.length; i++){
    TeacherOwnTimeTableModel ttSelectedValue1 = TeacherOwnTimeTableModel(timeTableId: 0, workloadId: 0, departmentId: 0, userId: 0, roomId: 0, timeSlotId: 0, day: "Select ID", date: "", status: "No", userModel: UserModel.getInstance(), roomsModel: RoomsModel.getInstance(), timeSlotsModel: TimeSlotsModel.getInstance(), workloadAssignmentModel: WorkloadAssignmentModel.getInstance());
    TeacherOwnTimeTableModel ttSelectedValue2 = TeacherOwnTimeTableModel(timeTableId: 0, workloadId: 0, departmentId: 0, userId: 0, roomId: 0, timeSlotId: 0, day: "Select ID", date: "", status: "Yes", userModel: UserModel.getInstance(), roomsModel: RoomsModel.getInstance(), timeSlotsModel: TimeSlotsModel.getInstance(), workloadAssignmentModel: WorkloadAssignmentModel.getInstance());
    int count = wednesdayClasses.where((c) => c.timeSlotId == slotsList[i].timeslotId).toList().length;
    if(count == 0){
      wednesdayClassesNew.insert(i, ttSelectedValue1);
    }else{
      ttSelectedValue2.timeSlotId = slotsList[i].timeslotId;
      wednesdayClassesNew.insert(i, ttSelectedValue2);
    }
  }
  for(int i=0;i<wednesdayClasses.length; i++){
    wednesdayClassesNew[wednesdayClassesNew.indexWhere((element) => element.timeSlotId == wednesdayClasses[i].timeSlotId)] = wednesdayClasses[i];
  }

  for(int i=0;i<slotsList.length; i++){
    TeacherOwnTimeTableModel ttSelectedValue1 = TeacherOwnTimeTableModel(timeTableId: 0, workloadId: 0, departmentId: 0, userId: 0, roomId: 0, timeSlotId: 0, day: "Select ID", date: "", status: "No", userModel: UserModel.getInstance(), roomsModel: RoomsModel.getInstance(), timeSlotsModel: TimeSlotsModel.getInstance(), workloadAssignmentModel: WorkloadAssignmentModel.getInstance());
    TeacherOwnTimeTableModel ttSelectedValue2 = TeacherOwnTimeTableModel(timeTableId: 0, workloadId: 0, departmentId: 0, userId: 0, roomId: 0, timeSlotId: 0, day: "Select ID", date: "", status: "Yes", userModel: UserModel.getInstance(), roomsModel: RoomsModel.getInstance(), timeSlotsModel: TimeSlotsModel.getInstance(), workloadAssignmentModel: WorkloadAssignmentModel.getInstance());
    int count = thursdayClasses.where((c) => c.timeSlotId == slotsList[i].timeslotId).toList().length;
    if(count == 0){
      thursdayClassesNew.insert(i, ttSelectedValue1);
    }else{
      ttSelectedValue2.timeSlotId = slotsList[i].timeslotId;
      thursdayClassesNew.insert(i, ttSelectedValue2);
    }
  }
  for(int i=0;i<thursdayClasses.length; i++){
    thursdayClassesNew[thursdayClassesNew.indexWhere((element) => element.timeSlotId == thursdayClasses[i].timeSlotId)] = thursdayClasses[i];
  }

  for(int i=0;i<slotsList.length; i++){
    TeacherOwnTimeTableModel ttSelectedValue1 = TeacherOwnTimeTableModel(timeTableId: 0, workloadId: 0, departmentId: 0, userId: 0, roomId: 0, timeSlotId: 0, day: "Select ID", date: "", status: "No", userModel: UserModel.getInstance(), roomsModel: RoomsModel.getInstance(), timeSlotsModel: TimeSlotsModel.getInstance(), workloadAssignmentModel: WorkloadAssignmentModel.getInstance());
    TeacherOwnTimeTableModel ttSelectedValue2 = TeacherOwnTimeTableModel(timeTableId: 0, workloadId: 0, departmentId: 0, userId: 0, roomId: 0, timeSlotId: 0, day: "Select ID", date: "", status: "Yes", userModel: UserModel.getInstance(), roomsModel: RoomsModel.getInstance(), timeSlotsModel: TimeSlotsModel.getInstance(), workloadAssignmentModel: WorkloadAssignmentModel.getInstance());
    int count = fridayClasses.where((c) => c.timeSlotId == slotsList[i].timeslotId).toList().length;
    if(count == 0){
      fridayClassesNew.insert(i, ttSelectedValue1);
    }else{
      ttSelectedValue2.timeSlotId = slotsList[i].timeslotId;
      fridayClassesNew.insert(i, ttSelectedValue2);
    }
  }
  for(int i=0;i<fridayClasses.length; i++){
    fridayClassesNew[fridayClassesNew.indexWhere((element) => element.timeSlotId == fridayClasses[i].timeSlotId)] = fridayClasses[i];
  }

  var now = DateTime.now();
  var formatter = DateFormat('MMMM dd, yyyy');
  String formattedDate = formatter.format(now);

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
              _weekDaysTimeTable(weekDays[weekIndex], weekDays[weekIndex] == "Monday" ? mondayClassesNew : weekDays[weekIndex] == "Tuesday" ? tuesdayClassesNew : weekDays[weekIndex] == "Wednesday" ? wednesdayClassesNew : weekDays[weekIndex] == "Thursday" ? thursdayClassesNew : fridayClassesNew)
          ]),
      SizedBox(height: 10),
      Text("Note: Please do not change your schedule without permission", style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
    ])
  ]);
}