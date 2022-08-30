class DepartmentModel {
  int departmentId = 0;
  String departmentName = "";
  String departmentType = "";

  DepartmentModel.getInstance();

  DepartmentModel({
    required this.departmentId,
    required this.departmentName,
    required this.departmentType,
  });

  DepartmentModel.fromJson(Map<String, dynamic> map){
    departmentId = map["id"];
    departmentName = map["name"].toString();
    departmentType = map["type"].toString();
  }
}