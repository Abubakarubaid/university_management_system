import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Constants{
  static const  String map_key = "AIzaSyD1-pjN6OGA80NaUTe8IS9McCWHlMvUcHA";

  static const String USER_LOGIN = "USER_LOGIN: ";
  static const String USER_REGISTRATION = "USER_REGISTRATION: ";
  static const String USER_LOGOUT = "USER_LOGOUT: ";

  static const String DEPARTMENT_ADD = "DEPARTMENT_ADD: ";
  static const String DEPARTMENT_UPDATE = "DEPARTMENT_UPDATE: ";
  static const String DEPARTMENT_FETCH = "DEPARTMENT_FECTH: ";

  static const String CLASS_ADD = "CLASS_ADD: ";
  static const String CLASS_UPDATE = "CLASS_UPDATE: ";
  static const String CLASS_FETCH = "CLASS_FETCH: ";

  static const String SUBJECT_ADD = "SUBJECT_ADD: ";
  static const String SUBJECT_UPDATE = "SUBJECT_UPDATE: ";
  static const String SUBJECT_FETCH = "SUBJECT_FETCH: ";

  static const String ROOM_ADD = "ROOM_ADD: ";
  static const String ROOM_UPDATE = "ROOM_UPDATE: ";
  static const String ROOM_FETCH = "ROOM_FETCH: ";

  static const String TIMESLOT_ADD = "TIMESLOT_ADD: ";
  static const String TIMESLOT_UPDATE = "TIMESLOT_UPDATE: ";
  static const String TIMESLOT_FETCH = "TIMESLOT_FETCH: ";

  static const String TEACHER_ADD = "TEACHER_ADD: ";
  static const String TEACHER_FETCH = "TEACHER_FETCH: ";
  static const String TEACHER_UPDATE = "TEACHER_UPDATE: ";

  static const String STUDENT_ADD = "STUDENT_ADD: ";
  static const String STUDENT_UPDATE = "STUDENT_UPDATE: ";
  static const String STUDENT_FETCH = "STUDENT_FETCH: ";

  static const String WORKLOAD_ADD = "WORKLOAD_ADD: ";
  static const String WORKLOAD_UPDATE = "WORKLOAD_UPDATE: ";
  static const String WORKLOAD_FETCH = "WORKLOAD_FETCH: ";
  static const String WORKLOAD_DELETE = "WORKLOAD_DELETE: ";

  static const String DATESHEET_ADD = "DATESHEET_ADD: ";
  static const String DATESHEET_FETCH = "DATESHEET_FETCH: ";
  static const String DATESHEET_DELETE = "DATESHEET_DELETE: ";

  static const String ATTENDANCE_ADD = "ATTENDANCE_ADD: ";
  static const String ATTENDANCE_FETCH = "ATTENDANCE_FETCH: ";

  static const String REQUEST_RESET_PASSWORD = "REQUEST_RESET_PASSWORD: ";
  static const String VERIFY_RESET_PASSWORD = "VERIFY_RESET_PASSWORD: ";
  static const String REQUEST_NEW_PASSWORD = "REQUEST_NEW_PASSWORD: ";

  static const String SINGLE_TIMETABLE_ADD = "SINGLE_TIMETABLE_ADD: ";
  static const String BULK_TIMETABLE_ADD = "BULK_TIMETABLE_ADD: ";

  static void printMessage(String type, String message){
    print("$type$message");
  }

  static Future<String> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("token").toString();
  }

  static String capitalize(String string) {
    if (string.isEmpty) {
      return string;
    }

    return string[0].toUpperCase() + string.substring(1);
  }
}