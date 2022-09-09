import 'dpt_model.dart';

class TimeSlotsModelDay {
  int timeslotId = 0;
  String timeslot = "";
  String timeslotType = "";
  String day = "";
  DepartmentModel departmentModel = DepartmentModel.getInstance();

  TimeSlotsModelDay.getInstance();

  TimeSlotsModelDay({
    required this.timeslotId,
    required this.timeslot,
    required this.departmentModel,
    required this.timeslotType,
    required this.day,
  });
}