import 'dpt_model.dart';

class TimeSlotsModel {
  int timeslotId = 0;
  String timeslot = "";
  DepartmentModel departmentModel = DepartmentModel.getInstance();

  TimeSlotsModel.getInstance();

  TimeSlotsModel({
    required this.timeslotId,
    required this.timeslot,
    required this.departmentModel
  });

  TimeSlotsModel.fromJson(Map<String, dynamic> map){
    timeslotId = map["id"];
    timeslot = map["time_slot"];
  }
}