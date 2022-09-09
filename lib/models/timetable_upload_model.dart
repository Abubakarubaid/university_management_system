import 'package:flutter/material.dart';
import 'package:university_management_system/models/rooms_model.dart';
import 'package:university_management_system/models/subject_model.dart';
import 'package:university_management_system/models/user_model.dart';

import 'class_model.dart';
import 'dpt_model.dart';

class TimeTableUploadModel {
  int timetable_id = 0;
  int workload_id = 0;
  int departmentId = 0;
  int userId = 0;
  int roomId = 0;
  int timeSlotId = 0;
  String day = "";
  String date = "";
  String status = "";


  TimeTableUploadModel.getInstance();

  TimeTableUploadModel({
    required this.workload_id,
    required this.departmentId,
    required this.userId,
    required this.roomId,
    required this.timeSlotId,
    required this.day,
    required this.date,
    required this.status
  });

  Map<String,dynamic> toJson(){
    return {
      "workload_id": workload_id,
      "department_id": departmentId,
      "user_id": userId,
      "room_id": roomId,
      "time_slot_id": timeSlotId,
      "day": day,
      "date": date,
      "status": status,
    };
  }

  Map<String,dynamic> toReplaceJson(){
    return {
      "id": timetable_id,
      "workload_id": workload_id,
      "department_id": departmentId,
      "user_id": userId,
      "room_id": roomId,
      "time_slot_id": timeSlotId,
      "day": day,
      "date": date,
      "status": status,
    };
  }
}