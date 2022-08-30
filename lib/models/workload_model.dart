class WorkloadModel {
  int workId = 0;
  int userId = 0;
  String userName = "";
  String userEmail = "";
  String userDesignation = "";

  int subjectId = 0;
  String subjectCode = "";
  String subjectName = "";
  int creditHours = 0;

  int departmentId = 0;
  String departmentName = "";

  int classId = 0;
  String className = "";
  String classSemester = "";
  String classType = "";

  String workloadStatus = "";
  String workDemanded = "";
  String classRoutine = "";
  String assignStatus = "";
  int remainingCreditHours = 0;

  int roomId = 0;
  String roomAssignment = "";

  WorkloadModel.getInstance();

  WorkloadModel({
    required this.workId,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.userDesignation,
    required this.subjectId,
    required this.subjectCode,
    required this.subjectName,
    required this.creditHours,
    required this.departmentId,
    required this.departmentName,
    required this.classId,
    required this.className,
    required this.classSemester,
    required this.classType,
    required this.workloadStatus,
    required this.workDemanded,
    required this.classRoutine,
    required this.assignStatus,
    required this.remainingCreditHours,
    required this.roomId,
    required this.roomAssignment,
  });

  WorkloadModel.fromJson(Map<String, dynamic> map){
    workId = map["workId"];
    userId = map["userId"];
    userName = map["userName"];
    userEmail = map["userEmail"];
    userDesignation = map["userDesignation"];
    subjectId = map["subjectId"];
    subjectCode = map["subjectCode"];
    subjectName = map["subjectName"];
    creditHours = map["creditHours"];
    departmentId = map["departmentId"];
    departmentName = map["departmentName"];
    classId = map["classId"];
    className = map["className"];
    classSemester = map["classSemester"];
    classType = map["classType"];
    workloadStatus = map["workloadStatus"];
    workDemanded = map["workDemanded"];
    classRoutine = map["classRoutine"];
    assignStatus = map["assignStatus"];
    remainingCreditHours = map["remainingCreditHours"];
    roomId = map["roomId"];
    roomAssignment = map["roomAssignment"];
  }
}