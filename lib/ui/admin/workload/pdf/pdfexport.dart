import 'dart:typed_data';
import 'dart:ui';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:university_management_system/models/teacher_model.dart';
import '../../../../assets/app_assets.dart';
import '../../../../models/workload_assignment_model.dart';

Future<Uint8List> makePdf(List<WorkloadAssignmentModel> workloadList, List<TeacherModel> teachersList) async {
  final pdf = Document();
  final imageLogo = MemoryImage((await rootBundle.load(AppAssets.attendanceColoredIcon)).buffer.asUint8List());

  print("_________________: Length: ${workloadList.length}");

  final numberOfPages = (workloadList.length / 20).ceil();
  print("_________________: numberOfPages: ${numberOfPages}");

  pdf.addPage(
    MultiPage(
      pageTheme: const PageTheme(orientation: PageOrientation.landscape,),
      build: (context) {
        return <Widget> [
          _headerLayout(workloadList),
          for(int i=0; i<teachersList.length; i++)
            _fetchSingleTeacher(workloadList, teachersList[i].userModel.userId),
        ];
      }),
  );
  return pdf.save();
}

_fetchSingleTeacher(List<WorkloadAssignmentModel> workloadList, int userId) {
  List<WorkloadAssignmentModel> singleDemandedWorkloadList = [];
  List<WorkloadAssignmentModel> singleNotDemandedWorkloadList = [];
  List<WorkloadAssignmentModel> singleWorkloadList = [];

  for(int k=0; k<workloadList.length; k++){
    if(workloadList[k].userModel.userId == userId){
      if(workloadList[k].workDemanded == "Demanded") {
        print("_____: ${workloadList[k].userModel.userName}");
        singleDemandedWorkloadList.add(workloadList[k]);
        singleWorkloadList.add(workloadList[k]);
      }else{
        print("_____: ${workloadList[k].userModel.userName}");
        singleNotDemandedWorkloadList.add(workloadList[k]);
        singleWorkloadList.add(workloadList[k]);
      }
    }
  }

  return Table(
      border: TableBorder.all(color: PdfColors.black),
      children: [
        if(singleWorkloadList.isNotEmpty)
          TableRow(children: [
          Padding(padding: const EdgeInsets.only(left: 8, right: 8, top: 3), child: Text("1", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),
          Expanded(flex: 1, child: Padding(padding: const EdgeInsets.only(top: 3), child: Center( child: Text("${singleWorkloadList.isNotEmpty ? singleWorkloadList[0].userModel.userName : ""}\n${singleWorkloadList.isNotEmpty ? singleWorkloadList[0].userModel.userDesignation : ""}", style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),),),
          Expanded(flex: 4, child: Table(border: TableBorder.all(color: PdfColors.black), children: [

            if(singleDemandedWorkloadList.length > singleNotDemandedWorkloadList.length)
              if(singleDemandedWorkloadList.isNotEmpty && singleNotDemandedWorkloadList.isEmpty)
                for(int i=0; i<singleDemandedWorkloadList.length; i++)
                  TableRow(children: [
                    Expanded(flex: 1, child: _tableRow(singleDemandedWorkloadList[i]),),
                    Expanded(flex: 1, child: _emptyRow(),),
                  ]),
              if(singleDemandedWorkloadList.isNotEmpty && singleNotDemandedWorkloadList.isNotEmpty)
                for(int i=0; i<singleDemandedWorkloadList.length; i++)
                  TableRow(children: [
                    Expanded(flex: 1, child: _tableRow(singleDemandedWorkloadList[i]),),
                    if(i < singleNotDemandedWorkloadList.length)
                      Expanded(flex: 1, child: _tableRow(singleNotDemandedWorkloadList[i]),),
                  ]),

            if(singleDemandedWorkloadList.length < singleNotDemandedWorkloadList.length)
              if(singleDemandedWorkloadList.isEmpty && singleNotDemandedWorkloadList.isNotEmpty)
                for(int i=0; i<singleNotDemandedWorkloadList.length; i++)
                  TableRow(children: [
                    Expanded(flex: 1, child: _emptyRow(),),
                    Expanded(flex: 1, child: _tableRow(singleNotDemandedWorkloadList[i]),),
                  ]),
              if(singleDemandedWorkloadList.isNotEmpty && singleNotDemandedWorkloadList.isNotEmpty)
                for(int i=0; i<singleNotDemandedWorkloadList.length; i++)
                  TableRow(children: [
                    if(i < singleDemandedWorkloadList.length)
                      Expanded(flex: 1, child: _tableRow(singleDemandedWorkloadList[i]),),
                    Expanded(flex: 1, child: _tableRow(singleNotDemandedWorkloadList[i]),),
                  ]),


          ])),
        ]),
      ]);
}

_emptyRow() {
  return Table(border: TableBorder.all(color: PdfColors.black), children: [
    ]);
}

_tableRow(WorkloadAssignmentModel model) {
  return Table(border: TableBorder.all(color: PdfColors.black), children: [
      TableRow(children: [
        Expanded(child: Padding(padding: const EdgeInsets.all(4),
          child: Text(
              "1", style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center),),),
        Expanded(flex: 3,
          child: Padding(padding: const EdgeInsets.only(
              left: 4, right: 4, top: 8, bottom: 8),
            child: Text("${model.classModel.className}",
                style: TextStyle(fontSize: 8, fontWeight: FontWeight.normal),
                textAlign: TextAlign.center),),),
        Expanded(child: Padding(padding: const EdgeInsets.all(4),
          child: Text(
              "${model.classModel.classType == "Morning" ? "M" : "E"}",
              style: TextStyle(fontSize: 7, fontWeight: FontWeight.normal),
              textAlign: TextAlign.center),),),
        Expanded(flex: 3,
          child: Padding(padding: const EdgeInsets.only(
              left: 4, right: 4, top: 8, bottom: 8),
            child: Text("${model.subjectModel.subjectName}",
              style: TextStyle(fontSize: 8, fontWeight: FontWeight.normal),
              textAlign: TextAlign.center,),),),
        Expanded(flex: 2,
          child: Padding(padding: const EdgeInsets.only(
              left: 4, right: 4, top: 8, bottom: 8),
            child: Text("${model.subjectModel.subjectCode}",
                style: TextStyle(fontSize: 7, fontWeight: FontWeight.normal),
                textAlign: TextAlign.center),),),
        Expanded(child: Padding(padding: const EdgeInsets.all(4),
          child: Text("${model.subjectModel.creditHours}",
              style: TextStyle(fontSize: 8, fontWeight: FontWeight.normal),
              textAlign: TextAlign.center),),),
        Expanded(flex: 2,
          child: Padding(padding: const EdgeInsets.all(4),
            child: Text("${model.classModel.classSemester}",
                style: TextStyle(fontSize: 7, fontWeight: FontWeight.normal),
                textAlign: TextAlign.center),),),
      ]),
    ]);
}

_headerLayout(List<WorkloadAssignmentModel> workloadList){
  return Column(children: [
    Text("Course Duration Sep 21 to Feb 22", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
    SizedBox(height: 4),
    Text("Work load of all teaching faculty members (including visiting & Teaching Assistants)", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
    SizedBox(height: 4),
    Text("Department of Islamic Studies", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
    SizedBox(height: 10),
    Table(
        border: TableBorder.all(color: PdfColors.black),
        children: [
          TableRow(children: [
            Padding(padding: const EdgeInsets.only(left: 10, right: 10, top: 26), child: Text("#", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),
            Expanded(flex: 1, child: Padding(padding: const EdgeInsets.only(top: 26), child: Center( child: Text("Name & Designation", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),),),
            Expanded(flex:4, child: Table(border: TableBorder.all(color: PdfColors.black), children: [
              TableRow(children: [
                Expanded(child: Padding(padding: const EdgeInsets.all(4), child: Text("Name of Classes in own And other departments + course title for which payment will not be demanded+credit hours", style: TextStyle(fontSize: 7, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),),
                Padding(padding: const EdgeInsets.all(4), child: Text("Name of Classes in own And other departments + course title for which payment will be demanded+credit hours", style: TextStyle(fontSize: 7, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),
                ]),
              TableRow(children: [
                Padding(padding: const EdgeInsets.all(4), child: Text("Own/Other Departments", style: TextStyle(fontSize: 7, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),
                Padding(padding: const EdgeInsets.all(4), child: Text("Own/Other Departments", style: TextStyle(fontSize: 7, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),
              ]),
              TableRow(children: [
                Table(border: TableBorder.all(color: PdfColors.black), children: [
                  TableRow(children: [
                    Expanded(child: Padding(padding: const EdgeInsets.all(4), child: Text("Sr\n#", style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),),
                    Expanded(flex: 3, child: Padding(padding: const EdgeInsets.only(left: 4, right: 4, top: 8), child: Text("Class", style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),),
                    Expanded(child: Padding(padding: const EdgeInsets.all(4), child: Text("Reg/SS", style: TextStyle(fontSize: 7, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),),
                    Expanded(flex: 3, child: Padding(padding: const EdgeInsets.only(left: 4, right: 4, top: 8), child: Text("Course Title", style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),),),
                    Expanded(flex: 2, child: Padding(padding: const EdgeInsets.all(4), child: Text("Course Code", style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),),
                    Expanded(child: Padding(padding: const EdgeInsets.all(4), child: Text("Cr.Hr", style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),),
                    Expanded(flex: 2, child: Padding(padding: const EdgeInsets.all(4), child: Text("Semester/\nSession", style: TextStyle(fontSize: 7, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),),
                  ]),
                ]),
                Table(border: TableBorder.all(color: PdfColors.black), children: [
                  TableRow(children: [
                    Expanded(child: Padding(padding: const EdgeInsets.all(4), child: Text("Sr\n#", style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),),
                    Expanded(flex: 3, child: Padding(padding: const EdgeInsets.only(left: 4, right: 4, top: 8), child: Text("Class", style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),),
                    Expanded(child: Padding(padding: const EdgeInsets.all(4), child: Text("Reg/SS", style: TextStyle(fontSize: 7, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),),
                    Expanded(flex: 3, child: Padding(padding: const EdgeInsets.only(left: 4, right: 4, top: 8), child: Text("Course Title", style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),),),
                    Expanded(flex: 2, child: Padding(padding: const EdgeInsets.all(4), child: Text("Course Code", style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),),
                    Expanded(child: Padding(padding: const EdgeInsets.all(4), child: Text("Cr.Hr", style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),),
                    Expanded(flex: 2, child: Padding(padding: const EdgeInsets.all(4), child: Text("Semester/\nSession", style: TextStyle(fontSize: 7, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),),
                  ]),
                ]),
              ]),
            ])),
          ]),
        ]),
  ]);
}