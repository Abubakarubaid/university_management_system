import 'package:university_management_system/models/class_model.dart';
import 'package:university_management_system/models/dpt_model.dart';
import 'package:university_management_system/models/subject_model.dart';
import 'package:university_management_system/models/user_model.dart';

class AttendanceDetailModel {

  int attendanceId = 0;
  List<UserModel> presentStudents = [];
  List<UserModel> absentStudents = [];
  String attendanceDateAndTime = "";
  String attendanceStatus = "";

  UserModel teacher = UserModel.getInstance();
  ClassModel classModel = ClassModel.getInstance();
  SubjectModel subjectModel = SubjectModel.getInstance();
  DepartmentModel departmentModel = DepartmentModel.getInstance();

  AttendanceDetailModel.getInstance();

  AttendanceDetailModel({
    required this.attendanceId,
    required this.presentStudents,
    required this.absentStudents,
    required this.attendanceDateAndTime,
    required this.attendanceStatus,
    required this.teacher,
    required this.classModel,
    required this.subjectModel,
    required this.departmentModel,
  });
}