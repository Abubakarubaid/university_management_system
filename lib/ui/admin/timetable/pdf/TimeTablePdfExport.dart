import 'dart:typed_data';
import 'dart:ui';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:university_management_system/models/teacher_model.dart';
import 'package:university_management_system/models/workload_assignment_model.dart';
import '../../../../assets/app_assets.dart';
import '../../../../models/rooms_model.dart';
import '../../../../models/timeslots_model.dart';

Future<Uint8List> makeTimeTablePdf(List<WorkloadAssignmentModel> workloadList, List<TeacherModel> teachersList, List<RoomsModel> roomsList, List<TimeSlotsModel> slotsList) async {
  final pdf = Document();
  //final imageLogo = MemoryImage((await rootBundle.load(AppAssets.attendanceColoredIcon)).buffer.asUint8List());

  List<String> weekDays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"];

  pdf.addPage(
    MultiPage(pageTheme:
    const PageTheme(orientation: PageOrientation.landscape,),
        build: (context) {
          return <Widget> [
            Stack(children: [
              //Opacity(opacity: 0.3, child: Center( child: Container(margin: const EdgeInsets.only(top: 70), width: 300, height: 300, child: Image(imageLogo),),),),
              _headerLayout(slotsList, weekDays, workloadList, roomsList),
            ]),

          ];
        })
  );
  return pdf.save();
}

_weekDaysTimeTable(String weekDay, List<TimeSlotsModel> slotsList, List<WorkloadAssignmentModel> workloadList, List<RoomsModel> roomsList) {
  return TableRow(children: [
    Expanded(flex: 1, child: Padding(padding: const EdgeInsets.all(6), child: Center( child: Text("${weekDay}", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),),),
    for(int index=0; index<workloadList.length; index++)
      Expanded(flex: 2, child: Padding(padding: const EdgeInsets.all(6),
        child: Column(children: [
            Text("${workloadList[index].classModel.className} ${workloadList[index].classModel.classSemester} ${workloadList[index].classModel.classType}", style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            Text(workloadList[index].userModel.userName, style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            Text(workloadList[index].roomsModel.roomName, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
        ]),
      )),
  ]);
}

_headerLayout(List<TimeSlotsModel> slotsList, List<String> weekDays, List<WorkloadAssignmentModel> workloadList, List<RoomsModel> roomsList) {
  //_calculate(slotsList, workloadList, roomsList);

  List<WorkloadAssignmentModel> mondayClasses = [];
  List<WorkloadAssignmentModel> tuesdayClasses = [];
  List<WorkloadAssignmentModel> wednesdayClasses = [];
  List<WorkloadAssignmentModel> thursdayClasses = [];
  List<WorkloadAssignmentModel> fridayClasses = [];

  if(workloadList.isNotEmpty){
    //Monday
    for(int i=0; i<workloadList.length; i++){
      if(mondayClasses.length < slotsList.length){
        bool match = false;
        for(int j=0; j<mondayClasses.length; j++){
          if(mondayClasses[j].userModel.userId == workloadList[i].userModel.userId){
            match = true;
          }
        }
        if(!match){
          mondayClasses.add(workloadList[i]);
          //workloadList[i].assignStatus = "assigned";
          workloadList.removeWhere((item) => item.workloadId == mondayClasses[mondayClasses.length-1].workloadId);
        }
      }
    }
    if(mondayClasses.isNotEmpty && roomsList.isNotEmpty && roomsList.length >= mondayClasses.length) {
      roomsList.shuffle();
      for (int i = 0; i < roomsList.length; i++) {
        if(i<mondayClasses.length){
          mondayClasses[i].roomsModel.roomId = roomsList[i].roomId;
          mondayClasses[i].roomsModel.roomName = roomsList[i].roomName;
        }
      }
    }


    //Tuesday
    for(int i=0; i<workloadList.length; i++){
      if(tuesdayClasses.length < slotsList.length){
        bool match = false;
        for(int j=0; j<tuesdayClasses.length; j++){
          if(tuesdayClasses[j].userModel.userId == workloadList[i].userModel.userId){
            match = true;
          }
        }
        if(!match){
          tuesdayClasses.add(workloadList[i]);
          //workloadList[i].assignStatus = "assigned";
          workloadList.removeWhere((item) => item.workloadId == tuesdayClasses[tuesdayClasses.length-1].workloadId);
        }
      }
    }
    if(tuesdayClasses.isNotEmpty && roomsList.isNotEmpty && roomsList.length >= tuesdayClasses.length) {
      roomsList.shuffle();
      for (int i = 0; i < roomsList.length; i++) {
        if(i<tuesdayClasses.length){
          tuesdayClasses[i].roomsModel.roomId = roomsList[i].roomId;
          tuesdayClasses[i].roomsModel.roomName = roomsList[i].roomName;
        }
      }
    }

    //Wednesday
    for(int i=0; i<workloadList.length; i++){
      if(wednesdayClasses.length < slotsList.length){
        bool match = false;
        for(int j=0; j<wednesdayClasses.length; j++){
          if(wednesdayClasses[j].userModel.userId == workloadList[i].userModel.userId){
            match = true;
          }
        }
        if(!match){
          wednesdayClasses.add(workloadList[i]);
          //workloadList[i].assignStatus = "assigned";
          workloadList.removeWhere((item) => item.workloadId == wednesdayClasses[wednesdayClasses.length-1].workloadId);
        }
      }
    }
    if(wednesdayClasses.isNotEmpty && roomsList.isNotEmpty && roomsList.length >= wednesdayClasses.length) {
      roomsList.shuffle();
      for (int i = 0; i < roomsList.length; i++) {
        if(i<wednesdayClasses.length){
          wednesdayClasses[i].roomsModel.roomId = roomsList[i].roomId;
          wednesdayClasses[i].roomsModel.roomName = roomsList[i].roomName;
        }
      }
    }

    //Thursday
    for(int i=0; i<workloadList.length; i++){
      if(thursdayClasses.length < slotsList.length){
        bool match = false;
        for(int j=0; j<thursdayClasses.length; j++){
          if(thursdayClasses[j].userModel.userId == workloadList[i].userModel.userId){
            match = true;
          }
        }
        if(!match){
          thursdayClasses.add(workloadList[i]);
          //workloadList[i].assignStatus = "assigned";
          workloadList.removeWhere((item) => item.workloadId == thursdayClasses[thursdayClasses.length-1].workloadId);
        }
      }
    }
    if(thursdayClasses.isNotEmpty && roomsList.isNotEmpty && roomsList.length >= thursdayClasses.length) {
      roomsList.shuffle();
      for (int i = 0; i < roomsList.length; i++) {
        if(i<thursdayClasses.length){
          thursdayClasses[i].roomsModel.roomId = roomsList[i].roomId;
          thursdayClasses[i].roomsModel.roomName = roomsList[i].roomName;
        }
      }
    }

    //Friday
    for(int i=0; i<workloadList.length; i++){
      if(fridayClasses.length < slotsList.length){
        bool match = false;
        for(int j=0; j<fridayClasses.length; j++){
          if(fridayClasses[j].userModel.userId == workloadList[i].userModel.userId){
            match = true;
          }
        }
        if(!match){
          fridayClasses.add(workloadList[i]);
          //workloadList[i].assignStatus = "assigned";
          workloadList.removeWhere((item) => item.workloadId == fridayClasses[fridayClasses.length-1].workloadId);
        }
      }
    }
    if(fridayClasses.isNotEmpty && roomsList.isNotEmpty && roomsList.length >= fridayClasses.length) {
      roomsList.shuffle();
      for (int i = 0; i < roomsList.length; i++) {
        if(i<fridayClasses.length){
          fridayClasses[i].roomsModel.roomId = roomsList[i].roomId;
          fridayClasses[i].roomsModel.roomName = roomsList[i].roomName;
        }
      }
    }
  }

  return Stack(children: [
    Column(children: [
      Text("Time Table", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
      SizedBox(height: 4),
      Text("Department of Islamic Studies, University of Chakwal", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
      SizedBox(height: 10),
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