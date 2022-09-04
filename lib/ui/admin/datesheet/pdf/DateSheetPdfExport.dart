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
import '../../../../models/datesheet_model.dart';
import '../../../../models/rooms_model.dart';
import '../../../../models/timeslots_model.dart';
import 'package:uuid/uuid.dart';

import '../../../../models/workload_assignment_model.dart';
import '../../../../providers/app_provider.dart';

Future<Uint8List> makeDateSheetPdf(List<DatesheetModel> dateSheetList) async {
  final pdf = Document();
  //final imageLogo = MemoryImage((await rootBundle.load(AppAssets.attendanceColoredIcon)).buffer.asUint8List());
  dateSheetList.sort((a, b) => a.sheetDate.compareTo(b.sheetDate));

  pdf.addPage(
    MultiPage(pageTheme:
    const PageTheme(orientation: PageOrientation.landscape,),
        build: (context) {
          return <Widget> [
            Stack(children: [
              //Opacity(opacity: 0.3, child: Center( child: Container(margin: const EdgeInsets.only(top: 70), width: 300, height: 300, child: Image(imageLogo),),),),
              _headerLayout(dateSheetList),
            ]),

          ];
        })
  );
  return pdf.save();
}

_weekDaysTimeTable(String weekDay, List<DatesheetModel> dateSheetList) {

  List<DatesheetModel> filteredPapers = [];
  for(int i=0; i<dateSheetList.length; i++){
    if(dateSheetList[i].sheetDate == weekDay) {
      filteredPapers.add(dateSheetList[i]);
    }
  }

  return TableRow(children: [
    Expanded(flex: 1, child: Padding(padding: const EdgeInsets.all(6), child: Center( child: Text("${weekDay}", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),),),
    for(int index=0; index<filteredPapers.length; index++)
      Expanded(flex: 2, child: Padding(padding: const EdgeInsets.all(6),
        child: Column(children: [
            Text("${filteredPapers[index].classModel.className} ${filteredPapers[index].classModel.classSemester} ${filteredPapers[index].classModel.classType}", style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            Text(filteredPapers[index].subjectModel.subjectCode, style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            Text(filteredPapers[index].subjectModel.subjectName, style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            Text("${filteredPapers[index].sheetStartTime} - ${filteredPapers[index].sheetEndTime}", style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            Text(filteredPapers[index].roomsModel.roomName, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
        ]),
      )),
  ]);
}

_headerLayout(List<DatesheetModel> dateSheetList) {

  List<String> dateList = [];

  for(int i=0; i<dateSheetList.length; i++){
    String date = dateSheetList[i].sheetDate;
    int count = dateList.where((c) => c == date).toList().length;

    if(count == 0){
      dateList.add(date);
    }
  }

  var now = DateTime.now();
  var formatter = DateFormat('MMMM dd, yyyy');
  String formattedDate = formatter.format(now);

  return Stack(children: [
    Column(children: [
      Text("Date Sheet", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
      SizedBox(height: 4),
      Text("Department of Islamic Studies, University of Chakwal", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
      SizedBox(height: 4),
      Text(formattedDate, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
      SizedBox(height: 20),
      Table(
          border: TableBorder.all(color: PdfColors.black),
          children: [
            /*TableRow(children: [
              Expanded(flex: 1, child: Padding(padding: const EdgeInsets.all(6), child: Center( child: Text("Days", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),),),
              for(int index=0; index<slotsList.length; index++)
                Expanded(flex: 2, child: Padding(padding: const EdgeInsets.all(6), child: Center( child: Text("${slotsList[index].timeslot}", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),),),
            ]),*/
            for(int weekIndex=0; weekIndex<dateList.length; weekIndex++)
              _weekDaysTimeTable(dateList[weekIndex], dateSheetList)
          ]),
      SizedBox(height: 10),
      Text("Note: Please do not change your schedule paper without permission", style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
    ])
  ]);
}