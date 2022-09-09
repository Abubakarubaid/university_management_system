import 'dpt_model.dart';

class TimeSlotsModel {
  int timeslotId = 0;
  String timeslot = "";
  String timeslotType = "";
  DepartmentModel departmentModel = DepartmentModel.getInstance();

  TimeSlotsModel.getInstance();

  TimeSlotsModel({
    required this.timeslotId,
    required this.timeslot,
    required this.departmentModel,
    required this.timeslotType,
  });

  TimeSlotsModel.fromJson(Map<String, dynamic> map){
    timeslotId = map["id"];
    timeslot = map["time_slot"];
    timeslotType = map["type"];
  }
}