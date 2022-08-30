import 'dpt_model.dart';

class RoomsModel {
  int roomId = 0;
  String roomName = "";
  DepartmentModel departmentModel = DepartmentModel.getInstance();

  RoomsModel.getInstance();

  RoomsModel({
    required this.roomId,
    required this.roomName,
    required this.departmentModel,
  });

  RoomsModel.fromJson(Map<String, dynamic> map){
    roomId = map["id"];
    roomName = map["name"];
  }
}