class UserModel {
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
  int totalAllowedCreditHours = 0;
  double overAllAttendancePercentage = 0.0;
  String attendanceStatus = "";

  String userAddress = "";
  String userExaminationPassedMPhil = "";
  String mPhilPassedExamSubject = "";
  String mPhilPassedExamYear = "";
  String mPhilPassedExamDivision = "";
  String mPhilPassedExamInstitute = "";
  String userExaminationPassedPhd = "";
  String phdPassedExamSubject = "";
  String phdPassedExamYear = "";
  String phdPassedExamDivision = "";
  String phdPassedExamInstitute = "";
  String userSpecializedField = "";
  String userGraduationLevelExperience = "";
  String userPostGraduationLevelExperience = "";
  String userSignature = "";
  String userCnic = "";

  UserModel.getInstance();

  UserModel({
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
    required this.totalAllowedCreditHours,
    required this.userAddress,
    required this.userExaminationPassedMPhil,
    required this.mPhilPassedExamSubject,
    required this.mPhilPassedExamYear,
    required this.mPhilPassedExamDivision,
    required this.mPhilPassedExamInstitute,
    required this.userExaminationPassedPhd,
    required this.phdPassedExamSubject,
    required this.phdPassedExamYear,
    required this.phdPassedExamDivision,
    required this.phdPassedExamInstitute,
    required this.userSpecializedField,
    required this.userGraduationLevelExperience,
    required this.userPostGraduationLevelExperience,
    required this.userSignature,
    required this.userCnic,
  });

  UserModel.fromJsonUser(Map<String, dynamic> map){
    userId = map["id"];
    userName = map["name"].toString();
    userEmail = map["email"].toString();
    userPassword = "";
    userPhone = map["phone"].toString();
    userGender = map["gender"].toString();
    userImage = "";
    userType = map["type"].toString();
    userStatus = map["status"].toString();
  }

  UserModel.fromJsonStudentProfile(Map<String, dynamic> map){
    userSession = map["session"].toString();
    userRollNo = map["roll_no"].toString();
    userDepartment = map["department_id"].toString();
    userClass = map["class_id"].toString();
  }

  UserModel.fromJsonTeacherProfile(Map<String, dynamic> map){
    userDepartment = map["department_id"].toString();
    userQualification = map["qualification"].toString();
    userDesignation = map["designation"].toString();
    totalAllowedCreditHours = int.parse(map["total_allowed_credit_hours"].toString());
  }
}