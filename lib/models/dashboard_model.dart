import 'package:university_management_system/models/class_model.dart';
import 'package:university_management_system/models/dpt_model.dart';
import 'package:university_management_system/models/subject_model.dart';
import 'package:university_management_system/models/user_model.dart';

class DashboardModel {

  int id = 0;
  String title = "";
  String type = "";
  String icon = "";

  DashboardModel.getInstance();

  DashboardModel({
    required this.id,
    required this.title,
    required this.type,
    required this.icon,
  });
}