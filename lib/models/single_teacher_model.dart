import 'package:university_management_system/models/class_model.dart';
import 'package:university_management_system/models/dpt_model.dart';
import 'package:university_management_system/models/teacher_workload_model.dart';
import 'package:university_management_system/models/user_model.dart';
import 'package:university_management_system/models/workload_assignment_model.dart';

class SingleTeacherModel {
  UserModel userModel = UserModel.getInstance();
  DepartmentModel departmentModel = DepartmentModel.getInstance();
  List<TeacherWorkloadModel> workloadList = [];

  SingleTeacherModel.getInstance();

  SingleTeacherModel({
    required this.userModel,
    required this.departmentModel,
    required this.workloadList,
  });
}