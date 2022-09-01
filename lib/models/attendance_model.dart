import 'package:university_management_system/models/class_model.dart';
import 'package:university_management_system/models/dpt_model.dart';
import 'package:university_management_system/models/subject_model.dart';
import 'package:university_management_system/models/user_model.dart';

class AttendanceDetailModel {

  int attendanceId = 0;
  List<UserModel> presentStudents = [];
  List<UserModel> absentStudents = [];
  List<String> presentUsers = [];
  List<String> absentUsers = [];
  String attendanceDate = "";
  String attendanceTime = "";
  String attendanceStatus = "";
  int workloadId = 0;

  AttendanceDetailModel.getInstance();

  AttendanceDetailModel({
    required this.attendanceId,
    required this.presentStudents,
    required this.absentStudents,
    required this.attendanceDate,
    required this.attendanceTime,
    required this.attendanceStatus,
    required this.workloadId,
    required this.presentUsers,
    required this.absentUsers,
  });
}