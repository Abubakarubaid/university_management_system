import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:university_management_system/models/user_model.dart';
import '../../../../assets/app_assets.dart';
import '../../../../models/attendence_complete_model.dart';

Future<Uint8List> makeAttendancePdf(List<AttendanceCompleteModel> detailsList, List<UserModel> allStudents) async {
  final pdf = Document();
  final imageLogo = MemoryImage((await rootBundle.load(AppAssets.attendanceColoredIcon)).buffer.asUint8List());

  print("_______________________: detailsList : ${detailsList.length} - userList: ${allStudents.length}");

  pdf.addPage(
    MultiPage(pageTheme:
    const PageTheme(orientation: PageOrientation.landscape,),
        build: (context) {
          return <Widget> [
            _headerLayout(detailsList),
            _attendanceLayout(detailsList, allStudents),
          ];
        })
  );
  return pdf.save();
}

_attendanceLayout(List<AttendanceCompleteModel> detailsList, List<UserModel> allStudents){
  return Table(
      border: TableBorder.all(color: PdfColors.black),
      children: [
        for(int i=0; i<allStudents.length; i++)
          TableRow(children: [
          Expanded(child: Text("${i+1}", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),
          Expanded(flex: 8, child: Text(allStudents[i].userName, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),),
          Expanded(flex: 6, child: Text(allStudents[i].userRollNo, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),

          for(int k=0; k<detailsList.length; k++)
            _fetchAttendance(_combineLists(detailsList[k], detailsList), allStudents[i].userRollNo),

          Expanded(flex: 2, child: Text("${_getPercentage(detailsList, allStudents[i].userRollNo)}", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),
        ]),
      ]);
}

_getPercentage(List<AttendanceCompleteModel> detailsList, String userRollNo){
  List<UserModel> presentList = [];
  for(int i=0; i<detailsList.length; i++){
    detailsList[i].presentStudents.forEach((element) {
      if(element.userRollNo == userRollNo){
        presentList.add(element);
      }
    });
  }

  double percentage = (presentList.length/detailsList.length)*100;
  return percentage.toStringAsFixed(0);
}

_combineLists(AttendanceCompleteModel detailModel, List<AttendanceCompleteModel> completeList){
  List<UserModel> list = [];
  detailModel.presentStudents.forEach((element) {
    int count = 0;
    completeList.forEach((data) {
      count = count + data.presentStudents.where((c) => c.userId == element.userId).toList().length;
    });

    double value = (count/completeList.length)*100;
    String inString = value.toStringAsFixed(1);
    element.overAllAttendancePercentage = double.parse(inString);
    element.attendanceStatus = "Present";
    list.add(element);
  });

  detailModel.absentStudents.forEach((element) {
    int count = 0;
    completeList.forEach((data) {
      count = count + data.presentStudents.where((c) => c.userId == element.userId).toList().length;
    });

    double value = (count/completeList.length)*100;
    String inString = value.toStringAsFixed(1);
    element.overAllAttendancePercentage = double.parse(inString);
    element.attendanceStatus = "Absent";
    list.add(element);
  });

  return list;
}

_fetchAttendance(List<UserModel> usersList, String userRollNo){
  Widget textWidget = Expanded(child: Text("", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold), textAlign: TextAlign.center),);

  for(int i=0; i<usersList.length; i++){
    if(usersList[i].userRollNo == userRollNo){
      textWidget = Expanded(child: Text(usersList[i].attendanceStatus == "Present" ? "P" : "A", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold), textAlign: TextAlign.center),);
      break;
    }
  }

  return textWidget;
}

_headerLayout(List<AttendanceCompleteModel> detailsList){
  return Column(children: [
    Text("Attendance Report", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
    SizedBox(height: 10),
    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(detailsList[0].workloadAssignmentModel.userModel.userName, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
      Text("${detailsList[0].workloadAssignmentModel.classModel.className} ${detailsList[0].workloadAssignmentModel.classModel.classSemester} ${detailsList[0].workloadAssignmentModel.classModel.classType}", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
      Text("Total Lectures: ${detailsList.length}", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
    ]),
    SizedBox(height: 10),
    Table(
        border: TableBorder.all(color: PdfColors.black),
        children: [
          TableRow(children: [
            Expanded(child: Text("#", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),
            Expanded(flex: 8, child: Text("Names", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),),
            Expanded(flex: 6, child: Text("Roll No", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),

            for(int i=0; i<detailsList.length; i++)
              Expanded(child: Text("${DateFormat('yyyy-MM-dd').parse(detailsList[i].attendanceDate).day}\n${DateFormat('yyyy-MM-dd').parse(detailsList[i].attendanceDate).month}", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),

            Expanded(flex: 2, child: Text("%", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),
          ]),
        ]),
  ]);
}