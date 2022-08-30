class UserSmallModel {
  int userId = 0;
  String userName = "";
  String userRollNo = "";

  UserSmallModel.getInstance();

  UserSmallModel({
    required this.userId,
    required this.userName,
    required this.userRollNo,
  });

  UserSmallModel.fromJson(Map<String, dynamic> map){
    userId = map["userId"];
    userName = map["userName"];
    userRollNo = map["userRollNo"];
  }
}