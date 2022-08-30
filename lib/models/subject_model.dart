import 'package:university_management_system/models/dpt_model.dart';

class SubjectModel {
  int subjectId = 0;
  String subjectCode = "";
  String subjectName = "";
  int creditHours = 0;
  DepartmentModel departmentModel = DepartmentModel.getInstance();

  SubjectModel.getInstance();

  SubjectModel({
    required this.subjectId,
    required this.subjectCode,
    required this.subjectName,
    required this.creditHours,
    required this.departmentModel,
  });

  SubjectModel.fromJson(Map<String, dynamic> map){
    subjectId = map["id"];
    subjectName = map["name"];
    subjectCode = map["code"];
    creditHours = int.parse(map["credit_hour"].toString());
  }
}