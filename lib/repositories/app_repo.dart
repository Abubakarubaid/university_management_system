import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:university_management_system/models/class_model.dart';
import 'package:university_management_system/models/datesheet_model.dart';
import 'package:university_management_system/models/dpt_model.dart';
import 'package:university_management_system/models/rooms_model.dart';
import 'package:university_management_system/models/subject_model.dart';
import 'package:university_management_system/models/teacher_model.dart';
import 'package:university_management_system/models/timeslots_model.dart';
import 'package:university_management_system/models/user_model.dart';
import 'package:university_management_system/models/workload_assignment_model.dart';

import '../models/attendance_model.dart';
import '../models/student_model.dart';
import '../utilities/base/api_response.dart';
import '../utilities/ip_configurations.dart';

class AppRepo{

  //----------------------------------------------------------------------------//
  /// Departments Repo
  Future<ApiResponse> addDepartment(String departmentName, String departmentType, String token)async{
    ApiResponse apiResponse;
    var response = await http.post(Uri.parse(IPConfigurations.addDepartmentApi),
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: {
          "name": departmentName,
          "type": departmentType,
        });
    if(response.body.isNotEmpty){
      apiResponse = ApiResponse(response,null,null);
      return apiResponse;
    }else{
      apiResponse = ApiResponse.withError("Error");
      return apiResponse;
    }
  }

  Future<ApiResponse> fetchAllDepartments(String token)async{
    ApiResponse apiResponse;
    var response = await http.get(Uri.parse(IPConfigurations.fetchDepartmentApi),
        headers: {
          'Authorization': 'Bearer $token',
        });
    if(response.body.isNotEmpty){
      apiResponse = ApiResponse(response,null,null);
      return apiResponse;
    }else{
      apiResponse = ApiResponse.withError("Error");
      return apiResponse;
    }
  }

  Future<ApiResponse> updateDepartment(DepartmentModel departmentModel, String token)async{
    ApiResponse apiResponse;
    var response = await http.put(Uri.parse(IPConfigurations.updateDepartmentApi + "/${departmentModel.departmentId.toString()}"),
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: {
          "name": departmentModel.departmentName,
          "type": departmentModel.departmentType,
        });
    if(response.body.isNotEmpty){
      apiResponse = ApiResponse(response,null,null);
      return apiResponse;
    }else{
      apiResponse = ApiResponse.withError("Error");
      return apiResponse;
    }
  }
//----------------------------------------------------------------------------//

  /// Subjects Repo
  Future<ApiResponse> addSubject(SubjectModel subjectModel, String token)async{
    ApiResponse apiResponse;
    var response = await http.post(Uri.parse(IPConfigurations.addSubjectApi),
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: {
          "department_id": subjectModel.departmentModel.departmentId.toString(),
          "code": subjectModel.subjectCode,
          "name": subjectModel.subjectName,
          "credit_hour": subjectModel.creditHours.toString(),
        });
    if(response.body.isNotEmpty){
      apiResponse = ApiResponse(response,null,null);
      return apiResponse;
    }else{
      apiResponse = ApiResponse.withError("Error");
      return apiResponse;
    }
  }

  Future<ApiResponse> fetchAllSubjects(String token)async{
    ApiResponse apiResponse;
    var response = await http.get(Uri.parse(IPConfigurations.fetchSubjectApi),
        headers: {
          'Authorization': 'Bearer $token',
        });
    if(response.body.isNotEmpty){
      apiResponse = ApiResponse(response,null,null);
      return apiResponse;
    }else{
      apiResponse = ApiResponse.withError("Error");
      return apiResponse;
    }
  }

  Future<ApiResponse> updateSubject(SubjectModel subjectModel, String token)async{
    ApiResponse apiResponse;
    var response = await http.put(Uri.parse(IPConfigurations.updateSubjectApi + "/${subjectModel.subjectId.toString()}"),
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: {
          "department_id": subjectModel.departmentModel.departmentId.toString(),
          "code": subjectModel.subjectCode,
          "name": subjectModel.subjectName,
          "credit_hour": subjectModel.creditHours.toString(),
        });
    if(response.body.isNotEmpty){
      apiResponse = ApiResponse(response,null,null);
      return apiResponse;
    }else{
      apiResponse = ApiResponse.withError("Error");
      return apiResponse;
    }
  }
  //---------------------------------------------------------------------------//

  /// Classes Repo
  Future<ApiResponse> fetchAllClasses(String token)async{
    ApiResponse apiResponse;
    var response = await http.get(Uri.parse(IPConfigurations.fetchClassesApi),
        headers: {
          'Authorization': 'Bearer $token',
        });
    if(response.body.isNotEmpty){
      apiResponse = ApiResponse(response,null,null);
      return apiResponse;
    }else{
      apiResponse = ApiResponse.withError("Error");
      return apiResponse;
    }
  }

  Future<ApiResponse> addClass(ClassModel classModel, String token)async{
    ApiResponse apiResponse;
    var response = await http.post(Uri.parse(IPConfigurations.addClassApi),
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: {
          "department_id": classModel.departmentModel.departmentId.toString(),
          "name": classModel.className,
          "type": classModel.classType,
          "semester": classModel.classSemester,
        });
    if(response.body.isNotEmpty){
      apiResponse = ApiResponse(response,null,null);
      return apiResponse;
    }else{
      apiResponse = ApiResponse.withError("Error");
      return apiResponse;
    }
  }

  Future<ApiResponse> updateClass(ClassModel classModel, String token)async{
    ApiResponse apiResponse;
    var response = await http.put(Uri.parse(IPConfigurations.updateClassApi + "/${classModel.classId.toString()}"),
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: {
          "department_id": classModel.departmentModel.departmentId.toString(),
          "name": classModel.className,
          "type": classModel.classType,
          "semester": classModel.classSemester,
        });
    if(response.body.isNotEmpty){
      apiResponse = ApiResponse(response,null,null);
      return apiResponse;
    }else{
      apiResponse = ApiResponse.withError("Error");
      return apiResponse;
    }
  }
//----------------------------------------------------------------------------//

  /// Rooms Repo
  Future<ApiResponse> fetchAllRooms(String token)async{
    ApiResponse apiResponse;
    var response = await http.get(Uri.parse(IPConfigurations.fetchRoomsApi),
        headers: {
          'Authorization': 'Bearer $token',
        });
    if(response.body.isNotEmpty){
      apiResponse = ApiResponse(response,null,null);
      return apiResponse;
    }else{
      apiResponse = ApiResponse.withError("Error");
      return apiResponse;
    }
  }

  Future<ApiResponse> addRoom(RoomsModel roomsModel, String token)async{
    ApiResponse apiResponse;
    var response = await http.post(Uri.parse(IPConfigurations.addRoomApi),
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: {
          "department_id": roomsModel.departmentModel.departmentId.toString(),
          "name": roomsModel.roomName,
        });
    if(response.body.isNotEmpty){
      apiResponse = ApiResponse(response,null,null);
      return apiResponse;
    }else{
      apiResponse = ApiResponse.withError("Error");
      return apiResponse;
    }
  }

  Future<ApiResponse> updateRoom(RoomsModel roomsModel, String token)async{
    ApiResponse apiResponse;
    var response = await http.put(Uri.parse(IPConfigurations.updateRoomApi + "/${roomsModel.roomId.toString()}"),
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: {
          "department_id": roomsModel.departmentModel.departmentId.toString(),
          "name": roomsModel.roomName,
        });
    if(response.body.isNotEmpty){
      apiResponse = ApiResponse(response,null,null);
      return apiResponse;
    }else{
      apiResponse = ApiResponse.withError("Error");
      return apiResponse;
    }
  }
//----------------------------------------------------------------------------//

  /// Time Slots Repo
  Future<ApiResponse> fetchAllTimeSlots(String token)async{
    ApiResponse apiResponse;
    var response = await http.get(Uri.parse(IPConfigurations.fetchTimeSlotsApi),
        headers: {
          'Authorization': 'Bearer $token',
        });
    if(response.body.isNotEmpty){
      apiResponse = ApiResponse(response,null,null);
      return apiResponse;
    }else{
      apiResponse = ApiResponse.withError("Error");
      return apiResponse;
    }
  }

  Future<ApiResponse> addTimeSlot(TimeSlotsModel timeSlotsModel, String token)async{
    ApiResponse apiResponse;
    var response = await http.post(Uri.parse(IPConfigurations.addTimeSlotApi),
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: {
          "department_id": timeSlotsModel.departmentModel.departmentId.toString(),
          "time_slot": timeSlotsModel.timeslot,
        });
    if(response.body.isNotEmpty){
      apiResponse = ApiResponse(response,null,null);
      return apiResponse;
    }else{
      apiResponse = ApiResponse.withError("Error");
      return apiResponse;
    }
  }

  Future<ApiResponse> updateTimeSlots(TimeSlotsModel timeSlotsModel, String token)async{
    ApiResponse apiResponse;
    var response = await http.put(Uri.parse(IPConfigurations.updateTimeSlotApi + "/${timeSlotsModel.timeslotId.toString()}"),
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: {
          "department_id": timeSlotsModel.departmentModel.departmentId.toString(),
          "time_slot": timeSlotsModel.timeslot,
        });
    if(response.body.isNotEmpty){
      apiResponse = ApiResponse(response,null,null);
      return apiResponse;
    }else{
      apiResponse = ApiResponse.withError("Error");
      return apiResponse;
    }
  }
//----------------------------------------------------------------------------//

  /// Students Repo
  Future<ApiResponse> fetchAllStudents(String type, String token)async{
    ApiResponse apiResponse;
    var response = await http.post(Uri.parse(IPConfigurations.fetchStudentsApi),
        headers: {
          'Authorization': 'Bearer $token',
        },body: {
          "type": type,
        });
    if(response.body.isNotEmpty){
      apiResponse = ApiResponse(response,null,null);
      return apiResponse;
    }else{
      apiResponse = ApiResponse.withError("Error");
      return apiResponse;
    }
  }

  Future<ApiResponse> addStudent(StudentModel studentModel, String token)async{
    ApiResponse apiResponse;
    var response = await http.post(Uri.parse(IPConfigurations.addStudentApi),
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: {
          "name": studentModel.userModel.userName,
          "email": studentModel.userModel.userEmail,
          "password": studentModel.userModel.userPassword,
          "type": studentModel.userModel.userType,
          "phone": studentModel.userModel.userPhone,
          "gender": studentModel.userModel.userGender,
          "fcm_token": "",
          "status": studentModel.userModel.userStatus,
          "department_id": "${studentModel.departmentModel.departmentId}",
          "qualification": studentModel.userModel.userQualification,
          "designation": studentModel.userModel.userDesignation,
          "session": studentModel.userModel.userSession,
          "roll_no": studentModel.userModel.userRollNo,
          "class_id": "${studentModel.classModel.classId}",
          "total_allowed_credit_hours": "${studentModel.userModel.totalAllowedCreditHours}",
        });
    if(response.body.isNotEmpty){
      apiResponse = ApiResponse(response,null,null);
      return apiResponse;
    }else{
      apiResponse = ApiResponse.withError("Error");
      return apiResponse;
    }
  }

  Future<ApiResponse> updateStudent(StudentModel studentModel, String token)async{
    ApiResponse apiResponse;
    var response = await http.post(Uri.parse(IPConfigurations.updateStudentApi),
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: {
          "id": studentModel.userModel.userId.toString(),
          "name": studentModel.userModel.userName,
          "password": studentModel.userModel.userPassword,
          "type": studentModel.userModel.userType,
          "phone": studentModel.userModel.userPhone,
          "gender": studentModel.userModel.userGender,
          "fcm_token": "",
          "status": studentModel.userModel.userStatus,
          "department_id": "${studentModel.departmentModel.departmentId}",
          "qualification": studentModel.userModel.userQualification,
          "designation": studentModel.userModel.userDesignation,
          "session": studentModel.userModel.userSession,
          "roll_no": studentModel.userModel.userRollNo,
          "class_id": "${studentModel.classModel.classId}",
          "total_allowed_credit_hours": "${studentModel.userModel.totalAllowedCreditHours}",
        });
    if(response.body.isNotEmpty){
      apiResponse = ApiResponse(response,null,null);
      return apiResponse;
    }else{
      apiResponse = ApiResponse.withError("Error");
      return apiResponse;
    }
  }
//----------------------------------------------------------------------------//

  /// Teachers Repo
  Future<ApiResponse> fetchAllTeachers(String type, String token)async{
    ApiResponse apiResponse;
    var response = await http.post(Uri.parse(IPConfigurations.fetchStudentsApi),
        headers: {
          'Authorization': 'Bearer $token',
        },body: {
          "type": type,
        });
    if(response.body.isNotEmpty){
      apiResponse = ApiResponse(response,null,null);
      return apiResponse;
    }else{
      apiResponse = ApiResponse.withError("Error");
      return apiResponse;
    }
  }

  Future<ApiResponse> approveTeacher(int userId, String status, String token)async{
    ApiResponse apiResponse;
    var response = await http.post(Uri.parse(IPConfigurations.approveTeacherApi),
        headers: {
          'Authorization': 'Bearer $token',
        },body: {
          "user_id": userId.toString(),
          "status": status,
        });
    if(response.body.isNotEmpty){
      apiResponse = ApiResponse(response,null,null);
      return apiResponse;
    }else{
      apiResponse = ApiResponse.withError("Error");
      return apiResponse;
    }
  }

  Future<ApiResponse> updateTeacher(TeacherModel teacherModel, String token)async{
    ApiResponse apiResponse;
    var response = await http.post(Uri.parse(IPConfigurations.updateTeacherApi),
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: {
          "id": teacherModel.userModel.userId.toString(),
          "name": teacherModel.userModel.userName,
          "phone": teacherModel.userModel.userPhone,
          "gender": teacherModel.userModel.userGender,
          "department_id": "${teacherModel.departmentModel.departmentId}",
          "qualification": teacherModel.userModel.userQualification,
          "designation": teacherModel.userModel.userDesignation,
          "type": teacherModel.userModel.userType,
          "status": teacherModel.userModel.userStatus,
          "total_allowed_credit_hours": "${teacherModel.userModel.totalAllowedCreditHours}",
          "address": teacherModel.userModel.userAddress,
          "address": teacherModel.userModel.userAddress,
        "userExaminationPassedMPhil": "M.Phil",
        "mPhilPassedExamSubject": teacherModel.userModel.mPhilPassedExamSubject,
        "mPhilPassedExamYear": teacherModel.userModel.mPhilPassedExamYear,
        "mPhilPassedExamDivision": teacherModel.userModel.mPhilPassedExamDivision,
        "mPhilPassedExamInstitute": teacherModel.userModel.mPhilPassedExamInstitute,
        "userExaminationPassedPhd": "PhD",
        "phdPassedExamSubject": teacherModel.userModel.phdPassedExamSubject,
        "phdPassedExamYear": teacherModel.userModel.phdPassedExamYear,
        "phdPassedExamDivision": teacherModel.userModel.phdPassedExamDivision,
        "phdPassedExamInstitute": teacherModel.userModel.phdPassedExamInstitute,
        "userSpecializedField": teacherModel.userModel.userSpecializedField,
        "userGraduationLevelExperience": teacherModel.userModel.userGraduationLevelExperience,
        "userPostGraduationLevelExperience": teacherModel.userModel.userPostGraduationLevelExperience,
        "cnic_no": teacherModel.userModel.userCnic,
        });
    if(response.body.isNotEmpty){
      apiResponse = ApiResponse(response,null,null);
      return apiResponse;
    }else{
      apiResponse = ApiResponse.withError("Error");
      return apiResponse;
    }
  }

  Future<ApiResponse> fetchSpecificTeacher(String type, int userId, String token)async{
    ApiResponse apiResponse;
    var response = await http.post(Uri.parse(IPConfigurations.fetchTeacherApi),
        headers: {
          'Authorization': 'Bearer $token',
        },body: {
          "id": userId.toString(),
          //"id": "17",
          "type": type,
        });
    if(response.body.isNotEmpty){
      apiResponse = ApiResponse(response,null,null);
      return apiResponse;
    }else{
      apiResponse = ApiResponse.withError("Error");
      return apiResponse;
    }
  }
//----------------------------------------------------------------------------//

  /// Workload Repo
  Future<ApiResponse> addWorkload(WorkloadAssignmentModel model, String token)async{
    ApiResponse apiResponse;
    var response = await http.post(Uri.parse(IPConfigurations.addWorkloadApi),
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: {
          "user_id": model.userModel.userId.toString(),
          "department_id": model.departmentModel.departmentId.toString(),
          "department_class_id": model.classModel.classId.toString(),
          "subject_id": model.subjectModel.subjectId.toString(),
          "work_demanded": model.workDemanded.toString(),
          "routine": model.classRoutine.toString(),
          "status": model.workloadStatus.toString(),
        });
    if(response.body.isNotEmpty){
      apiResponse = ApiResponse(response,null,null);
      return apiResponse;
    }else{
      apiResponse = ApiResponse.withError("Error");
      return apiResponse;
    }
  }

  Future<ApiResponse> fetchAllWorkload(DepartmentModel model, String token)async{
    ApiResponse apiResponse;
    var response = await http.get(Uri.parse(IPConfigurations.fetchWorkloadApi),
        headers: {
          'Authorization': 'Bearer $token',
        });
    if(response.body.isNotEmpty){
      apiResponse = ApiResponse(response,null,null);
      return apiResponse;
    }else{
      apiResponse = ApiResponse.withError("Error");
      return apiResponse;
    }
  }

  Future<ApiResponse> deleteWorkload(WorkloadAssignmentModel model, String token)async{
    ApiResponse apiResponse;
    var response = await http.delete(Uri.parse(IPConfigurations.deleteWorkloadApi + "/${model.workloadId}"),
        headers: {
          'Authorization': 'Bearer $token',
        });
    if(response.body.isNotEmpty){
      apiResponse = ApiResponse(response,null,null);
      return apiResponse;
    }else{
      apiResponse = ApiResponse.withError("Error");
      return apiResponse;
    }
  }
//----------------------------------------------------------------------------//

  /// DateSheet Repo
  Future<ApiResponse> addDateSheet(DatesheetModel model, String token)async{
    ApiResponse apiResponse;
    var response = await http.post(Uri.parse(IPConfigurations.addDateSheetApi),
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: {
          "department_id": model.departmentModel.departmentId.toString(),
          "department_class_id": model.classModel.classId.toString(),
          "subject_id": model.subjectModel.subjectId.toString(),
          "room_id": model.roomsModel.roomId.toString(),
          "start_time": model.sheetStartTime.toString(),
          "end_time": model.sheetEndTime.toString(),
          "date": model.sheetDate.toString(),
          "status": model.sheetStatus.toString(),
        });
    if(response.body.isNotEmpty){
      apiResponse = ApiResponse(response,null,null);
      return apiResponse;
    }else{
      apiResponse = ApiResponse.withError("Error");
      return apiResponse;
    }
  }

  Future<ApiResponse> fetchAllDateSheets(DepartmentModel model, String token)async{
    ApiResponse apiResponse;
    var response = await http.get(Uri.parse(IPConfigurations.fetchDateSheetApi),
        headers: {
          'Authorization': 'Bearer $token',
        });
    if(response.body.isNotEmpty){
      apiResponse = ApiResponse(response,null,null);
      return apiResponse;
    }else{
      apiResponse = ApiResponse.withError("Error");
      return apiResponse;
    }
  }

  Future<ApiResponse> deleteDateSheet(DatesheetModel model, String token)async{
    ApiResponse apiResponse;
    var response = await http.delete(Uri.parse(IPConfigurations.deleteDateSheetApi + "/${model.sheetId}"),
        headers: {
          'Authorization': 'Bearer $token',
        });
    if(response.body.isNotEmpty){
      apiResponse = ApiResponse(response,null,null);
      return apiResponse;
    }else{
      apiResponse = ApiResponse.withError("Error");
      return apiResponse;
    }
  }
//----------------------------------------------------------------------------//

  /// Attendance Repo
  Future<ApiResponse> addAttendance(AttendanceDetailModel model, String token)async{
    var data1 = jsonEncode(model.presentUsers);
    var data2 = jsonEncode(model.absentUsers);
    ApiResponse apiResponse;
    var response = await http.post(Uri.parse(IPConfigurations.addAttendanceApi),
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: {
          "workloads_id": model.workloadId.toString(),
          "present_students": data1,
          "absent_students": data2,
          "status": model.attendanceStatus.toString(),
          "date": model.attendanceDate.toString(),
          "time": model.attendanceTime.toString(),
        });
    if(response.body.isNotEmpty){
      apiResponse = ApiResponse(response,null,null);
      return apiResponse;
    }else{
      apiResponse = ApiResponse.withError("Error");
      return apiResponse;
    }
  }

  Future<ApiResponse> fetchAttendance(int workloadId, String token)async{
    ApiResponse apiResponse;
    var response = await http.get(Uri.parse("${IPConfigurations.fetchAttendanceApi}?workloads_id=$workloadId"),
        headers: {
          'Authorization': 'Bearer $token',
        });
    if(response.body.isNotEmpty){
      apiResponse = ApiResponse(response,null,null);
      return apiResponse;
    }else{
      apiResponse = ApiResponse.withError("Error");
      return apiResponse;
    }
  }
//----------------------------------------------------------------------------//
}