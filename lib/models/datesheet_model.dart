import 'package:university_management_system/models/class_model.dart';
import 'package:university_management_system/models/rooms_model.dart';
import 'package:university_management_system/models/subject_model.dart';

import 'dpt_model.dart';

class DatesheetModel {
  int sheetId = 0;

  DepartmentModel departmentModel = DepartmentModel.getInstance();
  SubjectModel subjectModel = SubjectModel.getInstance();
  ClassModel classModel = ClassModel.getInstance();
  RoomsModel roomsModel = RoomsModel.getInstance();

  String sheetStatus = "";
  String sheetDate = "";
  String sheetStartTime = "";
  String sheetEndTime = "";

  DatesheetModel.getInstance();

  DatesheetModel({
    required this.sheetId,
    required this.departmentModel,
    required this.subjectModel,
    required this.classModel,
    required this.roomsModel,
    required this.sheetStatus,
    required this.sheetDate,
    required this.sheetStartTime,
    required this.sheetEndTime,
  });

  DatesheetModel.fromJson(Map<String, dynamic> map){
    sheetId = map["sheetId"];
    sheetStatus = map["sheetStatus"];
    sheetDate = map["sheetDate"];
    sheetStartTime = map["sheetStartTime"];
    sheetEndTime = map["sheetEndTime"];
  }
}