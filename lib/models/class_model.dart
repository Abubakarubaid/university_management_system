import 'dpt_model.dart';

class ClassModel {
  int classId = 0;
  String className = "";
  String classSemester = "";
  String classType = "";
  DepartmentModel departmentModel = DepartmentModel.getInstance();

  ClassModel.getInstance();

  ClassModel({
    required this.classId,
    required this.className,
    required this.classSemester,
    required this.classType,
    required this.departmentModel,
  });

  ClassModel.fromJson(Map<String, dynamic> map){
    classId = map["id"];
    className = map["name"];
    classSemester = map["semester"];
    classType = map["type"];
  }
}