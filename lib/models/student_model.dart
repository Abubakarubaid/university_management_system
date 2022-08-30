import 'package:university_management_system/models/class_model.dart';
import 'package:university_management_system/models/dpt_model.dart';
import 'package:university_management_system/models/user_model.dart';

class StudentModel {

  UserModel userModel = UserModel.getInstance();
  DepartmentModel departmentModel = DepartmentModel.getInstance();
  ClassModel classModel = ClassModel.getInstance();

  StudentModel.getInstance();

  StudentModel({
    required this.userModel,
    required this.departmentModel,
    required this.classModel
  });
}