import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../../../../assets/app_assets.dart';
import '../../../../models/attendance_model.dart';
import '../../../../models/user_model_attendance.dart';
import '../../../../models/user_small_model.dart';

Future<Uint8List> makeAttendancePdf(List<AttendanceDetailModel> detailsList, List<UserSmallModel> allStudents) async {
  final pdf = Document();
  final imageLogo = MemoryImage((await rootBundle.load(AppAssets.attendanceColoredIcon)).buffer.asUint8List());

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

_attendanceLayout(List<AttendanceDetailModel> detailsList, List<UserSmallModel> allStudents){
  return Table(
      border: TableBorder.all(color: PdfColors.black),
      children: [
        for(int i=0; i<allStudents.length; i++)
          TableRow(children: [
          Expanded(child: Text("${i+1}", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),
          Expanded(flex: 8, child: Text(allStudents[i].userName, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),),
          Expanded(flex: 6, child: Text(allStudents[i].userRollNo, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),

          for(int k=0; k<detailsList.length; k++)
            _fetchAttendance(_combineLists(detailsList[k]), allStudents[i].userRollNo),

          Expanded(flex: 2, child: Text("${_getPercentage(detailsList, allStudents[i].userRollNo)}", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),
        ]),
      ]);
}

_getPercentage(List<AttendanceDetailModel> detailsList, String userRollNo){
  List<UserModelAttendance> presentList = [];
  for(int i=0; i<detailsList.length; i++){
    detailsList[i].presentStudents.forEach((element) {
      if(element.userRollNo == userRollNo){
        //presentList.add(element);
      }
    });
  }

  double percentage = (presentList.length/detailsList.length)*100;
  return percentage.toStringAsFixed(0);
}

_combineLists(AttendanceDetailModel detailModel){
  List<UserModelAttendance> list = [];
  detailModel.presentStudents.forEach((element) {
    //list.add(element);
  });
  detailModel.absentStudents.forEach((element) {
    //list.add(element);
  });

  return list;
}

_fetchAttendance(List<UserModelAttendance> usersList, String userRollNo){
  Widget textWidget = Expanded(child: Text("", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold), textAlign: TextAlign.center),);

  for(int i=0; i<usersList.length; i++){
    if(usersList[i].userRollNo == userRollNo){
      textWidget = Expanded(child: Text(usersList[i].attendanceStatus == "Present" ? "P" : "A", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold), textAlign: TextAlign.center),);
      break;
    }
  }

  return textWidget;
}

_headerLayout(List<AttendanceDetailModel> detailsList){
  return Column(children: [
    Text("Attendance Report", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
    SizedBox(height: 10),
    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      //Text(detailsList[0].teacherName, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
      //Text("${detailsList[0].className} ${detailsList[0].classSemester} ${detailsList[0].classType}", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
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
              Expanded(child: Text("${DateFormat('yyyy-MM-dd').parse(detailsList[i].attendanceDateAndTime).day}\n${DateFormat('yyyy-MM-dd').parse(detailsList[i].attendanceDateAndTime).month}", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),

            Expanded(flex: 2, child: Text("%", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),
          ]),
        ]),
  ]);
}