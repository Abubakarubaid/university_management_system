class MarkAttendanceModel {
  int userId = 0;
  String userName = "";
  String userEmail = "";
  String userPassword = "";
  String userPhone = "";
  String userSession = "";
  String userRollNo = "";
  String userGender = "";
  String userDepartment = "";
  String userClass = "";
  String userQualification = "";
  String userDesignation = "";
  String userImage = "";
  String userType = "";
  String userStatus = "";
  String studentRollNo = "";
  String attendanceStatus = "";

  MarkAttendanceModel.getInstance();

  MarkAttendanceModel({
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.userPassword,
    required this.userPhone,
    required this.userSession,
    required this.userRollNo,
    required this.userGender,
    required this.userDepartment,
    required this.userClass,
    required this.userQualification,
    required this.userDesignation,
    required this.userImage,
    required this.userType,
    required this.userStatus,
    required this.studentRollNo,
    required this.attendanceStatus,
  });

  MarkAttendanceModel.fromJson(Map<String, dynamic> map){
    userId = map["userId"];
    userName = map["userName"];
    userEmail = map["userEmail"];
    userPassword = map["userPassword"];
    userPhone = map["userPhone"];
    userSession = map["userSession"];
    userRollNo = map["userRollNo"];
    userGender = map["userGender"];
    userDepartment = map["userDepartment"];
    userClass = map["userClass"];
    userQualification = map["userQualification"];
    userDesignation = map["userDesignation"];
    userImage = map["userImage"];
    userType = map["userType"];
    userStatus = map["userStatus"];
    studentRollNo = map["studentRollNo"];
    attendanceStatus = map["attendanceStatus"];
  }
}