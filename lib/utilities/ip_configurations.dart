class IPConfigurations{

  //Server Address
  static String serverIp = "https://unisversitysystem.netcabledeals.com/api/v1/";
  static String serverImagePath = "https://unisversitysystem.netcabledeals.com/";

  static String loginApi = "${serverIp}login";
  static String registrationApi = "${serverIp}register";
  static String logoutApi = "${serverIp}logout";

  static String addDepartmentApi = "${serverIp}departments";
  static String fetchDepartmentApi = "${serverIp}departments";
  static String updateDepartmentApi = "${serverIp}departments";

  static String addSubjectApi = "${serverIp}subjects";
  static String fetchSubjectApi = "${serverIp}subjects";
  static String updateSubjectApi = "${serverIp}subjects";

  static String fetchClassesApi = "${serverIp}classes";
  static String addClassApi = "${serverIp}classes";
  static String updateClassApi = "${serverIp}classes";

  static String fetchRoomsApi = "${serverIp}rooms";
  static String addRoomApi = "${serverIp}rooms";
  static String updateRoomApi = "${serverIp}rooms";

  static String fetchTimeSlotsApi = "${serverIp}timeslots";
  static String addTimeSlotApi = "${serverIp}timeslots";
  static String updateTimeSlotApi = "${serverIp}timeslots";

  static String fetchStudentsApi = "${serverIp}fetch-student";
  static String addStudentApi = "${serverIp}register";
  static String updateStudentApi = "${serverIp}update-user";

  static String fetchTeachersApi = "${serverIp}fetch-student";
  static String fetchTeacherApi = "${serverIp}fetch-teacher";
  static String approveTeacherApi = "${serverIp}update-status";
  static String updateTeacherApi = "${serverIp}update-user";

  static String addWorkloadApi = "${serverIp}workloads";
  static String fetchWorkloadApi = "${serverIp}workloads";
  static String deleteWorkloadApi = "${serverIp}workloads";

  static String addDateSheetApi = "${serverIp}datesheets";
  static String addDateSheetPdfApi = "${serverIp}datesheetuplods";
  static String fetchDateSheetApi = "${serverIp}datesheets";
  static String fetchDateSheetPdfApi = "${serverIp}datesheetuplods";
  static String deleteDateSheetApi = "${serverIp}datesheets";

  static String addAttendanceApi = "${serverIp}attendences";
  static String fetchAttendanceApi = "${serverIp}attendences";

  static String addTimeTableApi = "${serverIp}timetables";
  static String addBulkTimeTableApi = "${serverIp}add-bulk-timetable";
  static String fetchSingleTeacherTimeTableApi = "${serverIp}timetables";
  static String fetchAllTimeTableApi = "${serverIp}fetch-timetable";

  static String requestResetPasswordApi = "${serverIp}request-password-reset";
  static String verifyResetPasswordApi = "${serverIp}verify-password-reset";
  static String requestNewPasswordApi = "${serverIp}request-new-password";

}