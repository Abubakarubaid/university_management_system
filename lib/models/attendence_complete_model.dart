import 'package:university_management_system/models/user_model.dart';
import 'package:university_management_system/models/workload_assignment_model.dart';

class AttendanceCompleteModel {

  int attendanceId = 0;
  int workloadId = 0;
  String attendanceDate = "";
  String attendanceTime = "";
  String attendanceStatus = "";
  WorkloadAssignmentModel workloadAssignmentModel = WorkloadAssignmentModel.getInstance();
  List<UserModel> presentStudents = [];
  List<UserModel> absentStudents = [];

  AttendanceCompleteModel.getInstance();

  AttendanceCompleteModel({
    required this.attendanceId,
    required this.workloadId,
    required this.attendanceDate,
    required this.attendanceTime,
    required this.attendanceStatus,
    required this.workloadAssignmentModel,
    required this.presentStudents,
    required this.absentStudents
  });
}