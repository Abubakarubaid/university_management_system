import 'package:university_management_system/models/rooms_model.dart';
import 'package:university_management_system/models/subject_model.dart';
import 'package:university_management_system/models/user_model.dart';
import 'package:university_management_system/models/workload_assignment_model.dart';

import 'class_model.dart';
import 'dpt_model.dart';

class WorkloadTimeTableModel {
  String id = "";
  WorkloadAssignmentModel workloadAssignmentModel = WorkloadAssignmentModel.getInstance();

  WorkloadTimeTableModel.getInstance();

  WorkloadTimeTableModel({
    required this.id,
    required this.workloadAssignmentModel,
  });
}