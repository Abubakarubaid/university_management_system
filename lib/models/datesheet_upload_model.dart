import 'package:university_management_system/models/class_model.dart';
import 'package:university_management_system/models/dpt_model.dart';
import 'package:university_management_system/models/subject_model.dart';
import 'package:university_management_system/models/user_model.dart';

class DateSheetUploadModel {

  int dateSheetId = 0;
  String dateSheetFile = "";
  String dateSheetDate = "";
  String dateSheetStatus = "";
  DepartmentModel departmentModel = DepartmentModel.getInstance();

  DateSheetUploadModel.getInstance();

  DateSheetUploadModel({
    required this.dateSheetId,
    required this.dateSheetFile,
    required this.dateSheetDate,
    required this.dateSheetStatus,
    required this.departmentModel
  });
}