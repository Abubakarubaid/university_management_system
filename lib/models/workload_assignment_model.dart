import 'package:university_management_system/models/rooms_model.dart';
import 'package:university_management_system/models/subject_model.dart';
import 'package:university_management_system/models/user_model.dart';

import 'class_model.dart';
import 'dpt_model.dart';

class WorkloadAssignmentModel {
  UserModel userModel = UserModel.getInstance();
  DepartmentModel departmentModel = DepartmentModel.getInstance();
  DepartmentModel subDepartmentModel = DepartmentModel.getInstance();
  ClassModel classModel = ClassModel.getInstance();
  SubjectModel subjectModel = SubjectModel.getInstance();
  RoomsModel roomsModel = RoomsModel.getInstance();

  int workloadId = 0;
  String workloadStatus = "";
  String workDemanded = "";
  String classRoutine = "";
  int remainingCreditHours = 0;

  WorkloadAssignmentModel.getInstance();

  WorkloadAssignmentModel({
    required this.workloadId,
    required this.userModel,
    required this.departmentModel,
    required this.subDepartmentModel,
    required this.classModel,
    required this.subjectModel,
    required this.roomsModel,
    required this.workloadStatus,
    required this.workDemanded,
    required this.classRoutine,
    required this.remainingCreditHours,
  });
}