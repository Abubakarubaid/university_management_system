import 'dart:typed_data';
import 'dart:ui';
import 'package:http/http.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:printing/printing.dart';
import 'package:university_management_system/models/teacher_model.dart';
import 'package:university_management_system/utilities/ip_configurations.dart';
import '../../../../assets/app_assets.dart';
import '../../../../models/workload_assignment_model.dart';

Future<Uint8List> individualMakePdf(TeacherModel teacherModel) async {
  final pdf = Document();
  if(teacherModel.userModel.userSignature != "null") {
    await networkImage(
        "${IPConfigurations.serverImagePath}${teacherModel.userModel
            .userSignature}").then((value) {
      pdf.addPage(
          MultiPage(pageTheme:
          const PageTheme(orientation: PageOrientation.portrait,
              margin: EdgeInsets.only(
                  top: 30, left: 40, right: 40, bottom: 30)),
              build: (context) {
                return <Widget>[
                  _headerLayout(teacherModel, value, true),
                ];
              })
      );
    });
    return pdf.save();
  }else{
    pdf.addPage(
        MultiPage(pageTheme:
        const PageTheme(orientation: PageOrientation.portrait,
            margin: EdgeInsets.only(
                top: 30, left: 40, right: 40, bottom: 30)),
            build: (context) {
              return <Widget>[
                _headerLayout(teacherModel, "", false),
              ];
            })
    );
    return pdf.save();
  }


}

_headerLayout(TeacherModel teacherModel, var imageLogo, bool check) {
  int notDemandedCount = teacherModel.workloadList.where((c) => c.workDemanded != "Demanded").toList().length;
  int demandedCount = teacherModel.workloadList.where((c) => c.workDemanded == "Demanded").toList().length;

  return Column(children: [
    Text("WORKLOAD PROFORMA FOR FALL-2022", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
    SizedBox(height: 4),
    Text("UNIVERSITY OF CHAKWAL, CHAKWAL", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
    SizedBox(height: 6),
    Text("Department of Islamic Studies", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
    SizedBox(height: 20),
    Table(
        border: TableBorder.all(color: PdfColors.black),
        children: [
          TableRow(children: [
            Expanded(flex: 1, child: Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8), child:Align( alignment: Alignment.centerLeft, child: Text("Name with Designation:", style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),),),
            Expanded(flex: 3, child: Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8), child: Align( alignment: Alignment.centerLeft, child: Text("${teacherModel.userModel.userName}, (${teacherModel.userModel.userDesignation})", style: TextStyle(fontSize: 9, fontWeight: FontWeight.normal), textAlign: TextAlign.center),),),),
          ]),
          TableRow(children: [
            Expanded(flex: 1, child: Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8), child: Align( alignment: Alignment.centerLeft, child: Text("Department:", style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold), textAlign: TextAlign.left),),),),
            Expanded(flex: 3, child: Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8), child: Align( alignment: Alignment.centerLeft, child: Text(teacherModel.departmentModel.departmentName, style: TextStyle(fontSize: 9, fontWeight: FontWeight.normal), textAlign: TextAlign.center),),),),
          ]),
          TableRow(children: [
            Expanded(flex: 1, child: Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8), child: Align( alignment: Alignment.centerLeft, child: Text("Address:", style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold), textAlign: TextAlign.left),),),),
            Expanded(flex: 3, child: Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8), child: Align( alignment: Alignment.centerLeft, child: Text(teacherModel.userModel.userAddress == "null" ? "" : teacherModel.userModel.userAddress, style: TextStyle(fontSize: 9, fontWeight: FontWeight.normal), textAlign: TextAlign.center),),),),
          ]),
          TableRow(children: [
            Expanded(flex: 1, child: Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8), child: Align( alignment: Alignment.centerLeft, child: Text("Qualification:", style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold), textAlign: TextAlign.left),),),),
            Expanded(flex: 3, child: Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8), child: Align( alignment: Alignment.centerLeft, child: Text(teacherModel.userModel.userQualification == "null" ? "" : teacherModel.userModel.userQualification, style: TextStyle(fontSize: 9, fontWeight: FontWeight.normal), textAlign: TextAlign.center),),),),
          ]),
          TableRow(children: [
            Expanded(flex: 1, child: Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8), child: Align( alignment: Alignment.centerLeft, child: Text("Contact:", style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold), textAlign: TextAlign.left),),),),
            Expanded(flex: 3, child: Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8), child: Align( alignment: Alignment.centerLeft, child: Text(teacherModel.userModel.userPhone == "null" ? "" : teacherModel.userModel.userPhone, style: TextStyle(fontSize: 9, fontWeight: FontWeight.normal), textAlign: TextAlign.center),),),),
          ]),
          TableRow(children: [
            Expanded(flex: 1, child: Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8), child: Align( alignment: Alignment.centerLeft, child: Text("Email:", style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold), textAlign: TextAlign.left),),),),
            Expanded(flex: 3, child: Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8), child: Align( alignment: Alignment.centerLeft, child: Text(teacherModel.userModel.userEmail, style: TextStyle(fontSize: 9, fontWeight: FontWeight.normal), textAlign: TextAlign.center),),),),
          ]),
        ]),
    SizedBox(height: 3),
    Table(
        border: TableBorder.all(color: PdfColors.white),
        children: [
          TableRow(children: [
            Expanded(flex: 2, child: Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8), child:Align( alignment: Alignment.center, child: Text("Examination", style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),),),
            Expanded(flex: 4, child: Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8), child: Align( alignment: Alignment.center, child: Text("Subject Field", style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),),),
            Expanded(flex: 2, child: Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8), child: Align( alignment: Alignment.center, child: Text("Year", style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),),),
            Expanded(flex: 2, child: Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8), child: Align( alignment: Alignment.center, child: Text("Division", style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),),),
            Expanded(flex: 3, child: Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8), child: Align( alignment: Alignment.center, child: Text("Name of University", style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),),),
          ]),
        ]),
    SizedBox(height: 3),
    Table(
        border: TableBorder.all(color: PdfColors.black),
        children: [
          TableRow(children: [
            Expanded(flex: 2, child: Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8), child:Align( alignment: Alignment.center, child: Text("M.Phil", style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),),),
            Expanded(flex: 4, child: Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8), child: Align( alignment: Alignment.centerLeft, child: Text(teacherModel.userModel.mPhilPassedExamSubject == "null" ? "" : teacherModel.userModel.mPhilPassedExamSubject, style: TextStyle(fontSize: 9, fontWeight: FontWeight.normal), textAlign: TextAlign.center),),),),
            Expanded(flex: 2, child: Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8), child: Align( alignment: Alignment.center, child: Text(teacherModel.userModel.mPhilPassedExamYear == "null" ? "" : teacherModel.userModel.mPhilPassedExamYear, style: TextStyle(fontSize: 9, fontWeight: FontWeight.normal), textAlign: TextAlign.center),),),),
            Expanded(flex: 2, child: Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8), child: Align( alignment: Alignment.center, child: Text(teacherModel.userModel.mPhilPassedExamDivision == "null" ? "" : teacherModel.userModel.mPhilPassedExamDivision, style: TextStyle(fontSize: 9, fontWeight: FontWeight.normal), textAlign: TextAlign.center),),),),
            Expanded(flex: 3, child: Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8), child: Align( alignment: Alignment.centerLeft, child: Text(teacherModel.userModel.mPhilPassedExamInstitute == "null" ? "" : teacherModel.userModel.mPhilPassedExamInstitute, style: TextStyle(fontSize: 9, fontWeight: FontWeight.normal), textAlign: TextAlign.center),),),),
          ]),
          TableRow(children: [
            Expanded(flex: 2, child: Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8), child:Align( alignment: Alignment.center, child: Text("PhD", style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),),),
            Expanded(flex: 4, child: Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8), child: Align( alignment: Alignment.centerLeft, child: Text(teacherModel.userModel.phdPassedExamSubject == "null" ? "" : teacherModel.userModel.phdPassedExamSubject, style: TextStyle(fontSize: 9, fontWeight: FontWeight.normal), textAlign: TextAlign.center),),),),
            Expanded(flex: 2, child: Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8), child: Align( alignment: Alignment.center, child: Text(teacherModel.userModel.phdPassedExamYear == "null" ? "" : teacherModel.userModel.phdPassedExamYear, style: TextStyle(fontSize: 9, fontWeight: FontWeight.normal), textAlign: TextAlign.center),),),),
            Expanded(flex: 2, child: Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8), child: Align( alignment: Alignment.center, child: Text(teacherModel.userModel.phdPassedExamDivision == "null" ? "" : teacherModel.userModel.phdPassedExamDivision, style: TextStyle(fontSize: 9, fontWeight: FontWeight.normal), textAlign: TextAlign.center),),),),
            Expanded(flex: 3, child: Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8), child: Align( alignment: Alignment.centerLeft, child: Text(teacherModel.userModel.phdPassedExamInstitute == "null" ? "" : teacherModel.userModel.phdPassedExamInstitute, style: TextStyle(fontSize: 9, fontWeight: FontWeight.normal), textAlign: TextAlign.center),),),),
          ]),
        ]),
    SizedBox(height: 20),
    Table(
        border: TableBorder.all(color: PdfColors.black),
        children: [
          TableRow(children: [
            Expanded(flex: 1, child: Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8), child:Align( alignment: Alignment.centerLeft, child: Text("Field of Specialization:", style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),),),
            Expanded(flex: 3, child: Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8), child: Align( alignment: Alignment.centerLeft, child: Text(teacherModel.userModel.userSpecializedField == "null" ? "" : teacherModel.userModel.userSpecializedField, style: TextStyle(fontSize: 9, fontWeight: FontWeight.normal), textAlign: TextAlign.center),),),),
          ]),
        ]),
    SizedBox(height: 3),
    Table(
        border: TableBorder.all(color: PdfColors.white),
        children: [
          TableRow(children: [
            Expanded(flex: 2, child: Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 0), child:Align( alignment: Alignment.centerLeft, child: Text("Experience", style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),),),
          ]),
        ]),
    Table(
        border: TableBorder.all(color: PdfColors.black),
        children: [
          TableRow(children: [
            Expanded(flex: 1, child: Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8), child:Align( alignment: Alignment.centerLeft, child: Text("i) Graduation Level:", style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),),),
            Expanded(flex: 1, child: Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8), child: Align( alignment: Alignment.centerLeft, child: Text(teacherModel.userModel.userGraduationLevelExperience == "null" ? "" : teacherModel.userModel.userGraduationLevelExperience, style: TextStyle(fontSize: 9, fontWeight: FontWeight.normal), textAlign: TextAlign.center),),),),
            Expanded(flex: 1, child: Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8), child:Align( alignment: Alignment.centerLeft, child: Text("ii) Post-Graduation Level:", style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),),),
            Expanded(flex: 1, child: Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8), child: Align( alignment: Alignment.centerLeft, child: Text(teacherModel.userModel.userPostGraduationLevelExperience == "null" ? "" : teacherModel.userModel.userPostGraduationLevelExperience, style: TextStyle(fontSize: 9, fontWeight: FontWeight.normal), textAlign: TextAlign.center),),),),
          ]),
        ]),
    SizedBox(height: 20),
    Table(
        border: TableBorder.all(color: PdfColors.black),
        children: [
          TableRow(children: [
            Expanded(flex: 1, child: Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8), child:Align( alignment: Alignment.centerLeft, child: Text("Class Commence on Date:", style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),),),
            Expanded(flex: 3, child: Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8), child: Align( alignment: Alignment.centerLeft, child: Text("", style: TextStyle(fontSize: 9, fontWeight: FontWeight.normal), textAlign: TextAlign.center),),),),
          ]),
        ]),
    SizedBox(height: 8),
    Table(
        border: TableBorder.all(color: PdfColors.white),
        children: [
          TableRow(children: [
            Expanded(flex: 2, child: Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 0), child:Align( alignment: Alignment.centerLeft, child: Text("Classes in own department or other department for which payment has not been demanded (for regular faculty):", style: TextStyle(fontSize: 8, fontWeight: FontWeight.normal), textAlign: TextAlign.center),),),),
          ]),
        ]),
    Table(
        border: TableBorder.all(color: PdfColors.black),
        children: [
          TableRow(children: [
            Expanded(flex: 1, child: Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 3), child:Align( alignment: Alignment.center, child: Text("Sr #", style: TextStyle(fontSize: 7, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),),),
            Expanded(flex: 4, child: Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 3), child: Align( alignment: Alignment.center, child: Text("Degree Program", style: TextStyle(fontSize: 7, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),),),
            Expanded(flex: 2, child: Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 3), child:Align( alignment: Alignment.center, child: Text("Session", style: TextStyle(fontSize: 7, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),),),
            Expanded(flex: 2, child: Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 3), child: Align( alignment: Alignment.center, child: Text("Semester", style: TextStyle(fontSize: 7, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),),),
            Expanded(flex: 1, child: Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 3), child: Align( alignment: Alignment.center, child: Text("Shift", style: TextStyle(fontSize: 6, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),),),
            Expanded(flex: 5, child: Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 3), child: Align( alignment: Alignment.center, child: Text("Course Title", style: TextStyle(fontSize: 7, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),),),
            Expanded(flex: 2, child: Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 3), child: Align( alignment: Alignment.center, child: Text("Course Code", style: TextStyle(fontSize: 7, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),),),
            Expanded(flex: 2, child: Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 3), child: Align( alignment: Alignment.center, child: Text("Credit Hour", style: TextStyle(fontSize: 7, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),),),
            Expanded(flex: 4, child: Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 3), child: Align( alignment: Alignment.center, child: Text("Own/Borrowed Department Name", style: TextStyle(fontSize: 7, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),),),
          ]),
          for(int j=0; j<teacherModel.workloadList.length; j++)
            if(teacherModel.workloadList[j].workDemanded != "Demanded")
              TableRow(children: [
                Expanded(flex: 1, child: Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 3), child:Align( alignment: Alignment.center, child: Text("${j+1}", style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),),),
                Expanded(flex: 4, child: Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 3), child: Align( alignment: Alignment.center, child: Text(teacherModel.workloadList[j].classModel.className, style: TextStyle(fontSize: 7, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),),),
                Expanded(flex: 2, child: Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 3), child:Align( alignment: Alignment.center, child: Text("Session", style: TextStyle(fontSize: 7, fontWeight: FontWeight.normal), textAlign: TextAlign.center),),),),
                Expanded(flex: 2, child: Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 3), child: Align( alignment: Alignment.center, child: Text(teacherModel.workloadList[j].classModel.classSemester, style: TextStyle(fontSize: 7, fontWeight: FontWeight.normal), textAlign: TextAlign.center),),),),
                Expanded(flex: 1, child: Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 3), child: Align( alignment: Alignment.center, child: Text(teacherModel.workloadList[j].classModel.classType == "Morning" ? "M" : "E", style: TextStyle(fontSize: 6, fontWeight: FontWeight.normal), textAlign: TextAlign.center),),),),
                Expanded(flex: 5, child: Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 3), child: Align( alignment: Alignment.center, child: Text(teacherModel.workloadList[j].subjectModel.subjectName, style: TextStyle(fontSize: 7, fontWeight: FontWeight.normal), textAlign: TextAlign.center),),),),
                Expanded(flex: 2, child: Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 3), child: Align( alignment: Alignment.center, child: Text(teacherModel.workloadList[j].subjectModel.subjectCode, style: TextStyle(fontSize: 7, fontWeight: FontWeight.normal), textAlign: TextAlign.center),),),),
                Expanded(flex: 2, child: Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 3), child: Align( alignment: Alignment.center, child: Text("${teacherModel.workloadList[j].subjectModel.creditHours}", style: TextStyle(fontSize: 7, fontWeight: FontWeight.normal), textAlign: TextAlign.center),),),),
                Expanded(flex: 4, child: Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 3), child: Align( alignment: Alignment.center, child: Text(teacherModel.workloadList[j].departmentModel.departmentId == teacherModel.workloadList[j].subDepartmentModel.departmentId ? "${teacherModel.workloadList[j].subDepartmentModel.departmentName} (own)" : "${teacherModel.workloadList[j].subDepartmentModel.departmentName} (other)", style: TextStyle(fontSize: 7, fontWeight: FontWeight.normal), textAlign: TextAlign.center),),),),
              ]),
          for(int i=0; i<4-notDemandedCount; i++)
            TableRow(children: [
              Expanded(flex: 1, child: Padding(padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 3), child:Align( alignment: Alignment.center, child: Text("", style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),),),
              Expanded(flex: 4, child: Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 3), child: Align( alignment: Alignment.center, child: Text("", style: TextStyle(fontSize: 7, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),),),
              Expanded(flex: 2, child: Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 3), child:Align( alignment: Alignment.center, child: Text("", style: TextStyle(fontSize: 7, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),),),
              Expanded(flex: 2, child: Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 3), child: Align( alignment: Alignment.center, child: Text("", style: TextStyle(fontSize: 7, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),),),
              Expanded(flex: 1, child: Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 3), child: Align( alignment: Alignment.center, child: Text("", style: TextStyle(fontSize: 6, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),),),
              Expanded(flex: 5, child: Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 3), child: Align( alignment: Alignment.center, child: Text("", style: TextStyle(fontSize: 7, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),),),
              Expanded(flex: 2, child: Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 3), child: Align( alignment: Alignment.center, child: Text("", style: TextStyle(fontSize: 7, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),),),
              Expanded(flex: 2, child: Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 3), child: Align( alignment: Alignment.center, child: Text("", style: TextStyle(fontSize: 7, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),),),
              Expanded(flex: 4, child: Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 3), child: Align( alignment: Alignment.center, child: Text("", style: TextStyle(fontSize: 7, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),),),
            ]),
        ]),
    SizedBox(height: 8),
    Table(
        border: TableBorder.all(color: PdfColors.white),
        children: [
          TableRow(children: [
            Expanded(flex: 2, child: Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 0), child:Align( alignment: Alignment.centerLeft, child: Text("Classes in own department or other department for which payment has been demanded (for regular and visiting faculty):", style: TextStyle(fontSize: 8, fontWeight: FontWeight.normal), textAlign: TextAlign.center),),),),
          ]),
        ]),
    Table(
        border: TableBorder.all(color: PdfColors.black),
        children: [
          TableRow(children: [
            Expanded(flex: 1, child: Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 3), child:Align( alignment: Alignment.center, child: Text("Sr #", style: TextStyle(fontSize: 7, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),),),
            Expanded(flex: 4, child: Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 3), child: Align( alignment: Alignment.center, child: Text("Degree Program", style: TextStyle(fontSize: 7, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),),),
            Expanded(flex: 2, child: Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 3), child:Align( alignment: Alignment.center, child: Text("Session", style: TextStyle(fontSize: 7, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),),),
            Expanded(flex: 2, child: Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 3), child: Align( alignment: Alignment.center, child: Text("Semester", style: TextStyle(fontSize: 7, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),),),
            Expanded(flex: 1, child: Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 3), child: Align( alignment: Alignment.center, child: Text("Shift", style: TextStyle(fontSize: 6, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),),),
            Expanded(flex: 5, child: Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 3), child: Align( alignment: Alignment.center, child: Text("Course Title", style: TextStyle(fontSize: 7, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),),),
            Expanded(flex: 2, child: Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 3), child: Align( alignment: Alignment.center, child: Text("Course Code", style: TextStyle(fontSize: 7, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),),),
            Expanded(flex: 2, child: Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 3), child: Align( alignment: Alignment.center, child: Text("Credit Hour", style: TextStyle(fontSize: 7, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),),),
            Expanded(flex: 4, child: Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 3), child: Align( alignment: Alignment.center, child: Text("Own/Borrowed Department Name", style: TextStyle(fontSize: 7, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),),),
          ]),
          for(int j=0; j<teacherModel.workloadList.length; j++)
            if(teacherModel.workloadList[j].workDemanded == "Demanded")
              TableRow(children: [
                Expanded(flex: 1, child: Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 3), child:Align( alignment: Alignment.center, child: Text("${j+1}", style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),),),
                Expanded(flex: 4, child: Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 3), child: Align( alignment: Alignment.center, child: Text(teacherModel.workloadList[j].classModel.className, style: TextStyle(fontSize: 7, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),),),
                Expanded(flex: 2, child: Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 3), child:Align( alignment: Alignment.center, child: Text("Session", style: TextStyle(fontSize: 7, fontWeight: FontWeight.normal), textAlign: TextAlign.center),),),),
                Expanded(flex: 2, child: Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 3), child: Align( alignment: Alignment.center, child: Text(teacherModel.workloadList[j].classModel.classSemester, style: TextStyle(fontSize: 7, fontWeight: FontWeight.normal), textAlign: TextAlign.center),),),),
                Expanded(flex: 1, child: Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 3), child: Align( alignment: Alignment.center, child: Text(teacherModel.workloadList[j].classModel.classType == "Morning" ? "M" : "E", style: TextStyle(fontSize: 6, fontWeight: FontWeight.normal), textAlign: TextAlign.center),),),),
                Expanded(flex: 5, child: Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 3), child: Align( alignment: Alignment.center, child: Text(teacherModel.workloadList[j].subjectModel.subjectName, style: TextStyle(fontSize: 7, fontWeight: FontWeight.normal), textAlign: TextAlign.center),),),),
                Expanded(flex: 2, child: Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 3), child: Align( alignment: Alignment.center, child: Text(teacherModel.workloadList[j].subjectModel.subjectCode, style: TextStyle(fontSize: 7, fontWeight: FontWeight.normal), textAlign: TextAlign.center),),),),
                Expanded(flex: 2, child: Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 3), child: Align( alignment: Alignment.center, child: Text("${teacherModel.workloadList[j].subjectModel.creditHours}", style: TextStyle(fontSize: 7, fontWeight: FontWeight.normal), textAlign: TextAlign.center),),),),
                Expanded(flex: 4, child: Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 3), child: Align( alignment: Alignment.center, child: Text(teacherModel.workloadList[j].departmentModel.departmentId == teacherModel.workloadList[j].subDepartmentModel.departmentId ? "${teacherModel.workloadList[j].subDepartmentModel.departmentName} (own)" : "${teacherModel.workloadList[j].subDepartmentModel.departmentName} (other)", style: TextStyle(fontSize: 7, fontWeight: FontWeight.normal), textAlign: TextAlign.center),),),),
              ]),
          for(int i=0; i<4-demandedCount; i++)
            TableRow(children: [
              Expanded(flex: 1, child: Padding(padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 3), child:Align( alignment: Alignment.center, child: Text("", style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),),),
              Expanded(flex: 4, child: Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 3), child: Align( alignment: Alignment.center, child: Text("", style: TextStyle(fontSize: 7, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),),),
              Expanded(flex: 2, child: Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 3), child:Align( alignment: Alignment.center, child: Text("", style: TextStyle(fontSize: 7, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),),),
              Expanded(flex: 2, child: Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 3), child: Align( alignment: Alignment.center, child: Text("", style: TextStyle(fontSize: 7, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),),),
              Expanded(flex: 1, child: Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 3), child: Align( alignment: Alignment.center, child: Text("", style: TextStyle(fontSize: 6, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),),),
              Expanded(flex: 5, child: Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 3), child: Align( alignment: Alignment.center, child: Text("", style: TextStyle(fontSize: 7, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),),),
              Expanded(flex: 2, child: Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 3), child: Align( alignment: Alignment.center, child: Text("", style: TextStyle(fontSize: 7, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),),),
              Expanded(flex: 2, child: Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 3), child: Align( alignment: Alignment.center, child: Text("", style: TextStyle(fontSize: 7, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),),),
              Expanded(flex: 4, child: Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 3), child: Align( alignment: Alignment.center, child: Text("", style: TextStyle(fontSize: 7, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),),),
            ]),
        ]),
    SizedBox(height: 50),
    Table(
        children: [
          TableRow(children: [
            Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 0), child:Align( alignment: Alignment.centerLeft, child: Text("Signature of the Teacher concerned", style: TextStyle(fontSize: 9, fontWeight: FontWeight.normal), textAlign: TextAlign.center),),),
            SizedBox(width: 20),
            Expanded(child:
                Column(children: [
                  Container(width: 100, height: 30, child: check ? Image(imageLogo) : Text("")),
                  Container(
                    width: double.infinity,
                    height: 1,
                    color: PdfColors.black,
                  ),
                ])
            ),
          ]),
        ]),
    SizedBox(height: 20),
    Table(
        children: [
          TableRow(children: [
            Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 0), child:Align( alignment: Alignment.centerLeft, child: Text("Recommendation of the HOD/Chairman/Principal/Director of own Department/College:", style: TextStyle(fontSize: 7, fontWeight: FontWeight.normal), textAlign: TextAlign.center),),),
            SizedBox(width: 20),
            Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: 20),
                  width: double.infinity,
                  height: 1,
                  color: PdfColors.black,
                )),
          ]),
          TableRow(children: [
            Align( alignment: Alignment.centerLeft, child: Text("(Note: All the faculty member(s) shall fill only one workload proforma for all courses)", style: TextStyle(fontSize: 7, fontWeight: FontWeight.normal), textAlign: TextAlign.center),),
          ]),
        ]),
  ]);
}