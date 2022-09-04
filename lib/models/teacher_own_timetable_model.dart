import 'package:flutter/material.dart';
import 'package:university_management_system/models/rooms_model.dart';
import 'package:university_management_system/models/subject_model.dart';
import 'package:university_management_system/models/timeslots_model.dart';
import 'package:university_management_system/models/user_model.dart';
import 'package:university_management_system/models/workload_assignment_model.dart';

import 'class_model.dart';
import 'dpt_model.dart';

class TeacherOwnTimeTableModel {
  int timeTableId = 0;
  int workloadId = 0;
  int departmentId = 0;
  int userId = 0;
  int roomId = 0;
  int timeSlotId = 0;
  String day = "";
  String date = "";
  String status = "";
  UserModel userModel = UserModel.getInstance();
  RoomsModel roomsModel = RoomsModel.getInstance();
  DepartmentModel departmentModel = DepartmentModel.getInstance();
  ClassModel classModel = ClassModel.getInstance();
  SubjectModel subjectModel = SubjectModel.getInstance();
  TimeSlotsModel timeSlotsModel = TimeSlotsModel.getInstance();
  WorkloadAssignmentModel workloadAssignmentModel = WorkloadAssignmentModel.getInstance();

  TeacherOwnTimeTableModel.getInstance();

  TeacherOwnTimeTableModel({
    required this.timeTableId,
    required this.workloadId,
    required this.departmentId,
    required this.userId,
    required this.roomId,
    required this.timeSlotId,
    required this.day,
    required this.date,
    required this.status,
    required this.userModel,
    required this.roomsModel,
    required this.timeSlotsModel,
    required this.workloadAssignmentModel,
  });

}