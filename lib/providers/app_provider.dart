import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:university_management_system/models/attendence_complete_model.dart';
import 'package:university_management_system/models/class_model.dart';
import 'package:university_management_system/models/datesheet_model.dart';
import 'package:university_management_system/models/datesheet_upload_model.dart';
import 'package:university_management_system/models/demo_model.dart';
import 'package:university_management_system/models/rooms_model.dart';
import 'package:university_management_system/models/student_model.dart';
import 'package:university_management_system/models/subject_model.dart';
import 'package:university_management_system/models/timeslots_model.dart';
import 'package:university_management_system/models/timetable_upload_model.dart';
import 'package:university_management_system/models/user_model.dart';
import 'package:university_management_system/models/workload_assignment_model.dart';
import 'package:university_management_system/repositories/app_repo.dart';
import 'package:university_management_system/utilities/constants.dart';
import 'package:university_management_system/utilities/ip_configurations.dart';
import 'package:uuid/uuid.dart';

import '../models/attendance_model.dart';
import '../models/dpt_model.dart';
import '../models/response_model.dart';
import '../models/single_teacher_model.dart';
import '../models/teacher_model.dart';
import '../models/teacher_own_timetable_model.dart';
import '../models/teacher_workload_model.dart';
import '../utilities/base/api_response.dart';
import '../utilities/shared_preference_manager.dart';

class AppProvider with ChangeNotifier{
  AppRepo appRepo;
  AppProvider({required this.appRepo});

  bool progress = false;
  bool uploadProgress = false;
  bool studentProgress = false;
  bool dialogProgress = false;
  bool statusApprovalProgress = false;
  bool datesheetProgress = false;
  List<DepartmentModel> departmentList = [];
  List<SubjectModel> subjectList = [];
  List<ClassModel> classList = [];
  List<RoomsModel> roomList = [];
  List<TimeSlotsModel> timeSlotList = [];
  List<StudentModel> studentList = [];
  StudentModel studentUpdatedModel = StudentModel.getInstance();
  TeacherModel teacherUpdatedModel = TeacherModel.getInstance();
  List<TeacherModel> teacherList = [];
  List<WorkloadAssignmentModel> workloadList = [];
  List<DatesheetModel> dateSheetList = [];
  SingleTeacherModel singleTeacherModel = SingleTeacherModel.getInstance();
  List<AttendanceCompleteModel> attendanceList = [];
  List<TeacherOwnTimeTableModel> teacherTimeTableList = [];
  DateSheetUploadModel dateSheetUploadModel = DateSheetUploadModel.getInstance();

//----------------------------------------------------------------------------//

  /// Department Provider
  Future<ResponseModel> addDepartment(String departmentName, String departmentType, String token)async{
    dialogProgress = true;
    notifyListeners();
    ResponseModel responseModel;

    ApiResponse apiResponse = await appRepo.addDepartment(departmentName, departmentType, token);

    var parsedResponse = json.decode(apiResponse.response!.body);
    Constants.printMessage(Constants.DEPARTMENT_ADD, parsedResponse.toString());

    if (apiResponse.response != null && parsedResponse["success"]) {

      DepartmentModel departmentModel = DepartmentModel.getInstance();
      departmentModel = DepartmentModel.fromJson(parsedResponse["data"]);
      departmentList.add(departmentModel);

      responseModel = ResponseModel(true, parsedResponse["message"]);
      dialogProgress = false;
    } else {
      String errorMessage = parsedResponse["message"];
      responseModel = ResponseModel(false, errorMessage);
      dialogProgress = false;
    }
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> fetchAllDepartments(String token)async{
    progress = true;
    notifyListeners();
    ResponseModel responseModel;
    departmentList.clear();

    ApiResponse apiResponse = await appRepo.fetchAllDepartments(token);

    var parsedResponse = json.decode(apiResponse.response!.body);
    Constants.printMessage(Constants.DEPARTMENT_FETCH, parsedResponse.toString());

    if (apiResponse.response != null && parsedResponse["success"]) {
      parsedResponse["data"].forEach((e) {
        DepartmentModel departmentModel = DepartmentModel.getInstance();
        departmentModel = DepartmentModel.fromJson(e);
        departmentList.add(departmentModel);
      });

      responseModel = ResponseModel(true, parsedResponse["message"]);
      progress = false;
    } else {
      String errorMessage = parsedResponse["message"];
      responseModel = ResponseModel(false, errorMessage);
      progress = false;
    }
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> updateDepartment(DepartmentModel departmentModel, String token)async{
    dialogProgress = true;
    notifyListeners();
    ResponseModel responseModel;

    ApiResponse apiResponse = await appRepo.updateDepartment(departmentModel, token);

    var parsedResponse = json.decode(apiResponse.response!.body);
    Constants.printMessage(Constants.DEPARTMENT_UPDATE, parsedResponse.toString());

    if (apiResponse.response != null && parsedResponse["success"]) {

      DepartmentModel departmentModel = DepartmentModel.getInstance();
      departmentModel = DepartmentModel.fromJson(parsedResponse["data"]);
      departmentList[departmentList.indexWhere((element) => element.departmentId == departmentModel.departmentId)];

      responseModel = ResponseModel(true, parsedResponse["message"]);
      dialogProgress = false;
    } else {
      String errorMessage = parsedResponse["message"];
      responseModel = ResponseModel(false, errorMessage);
      dialogProgress = false;
    }
    notifyListeners();
    return responseModel;
  }
//----------------------------------------------------------------------------//

  /// Subject Provider
  Future<ResponseModel> addSubject(SubjectModel subjectModel, String token)async{
    dialogProgress = true;
    notifyListeners();
    ResponseModel responseModel;

    ApiResponse apiResponse = await appRepo.addSubject(subjectModel, token);

    var parsedResponse = json.decode(apiResponse.response!.body);
    Constants.printMessage(Constants.SUBJECT_ADD, parsedResponse.toString());

    if (apiResponse.response != null && parsedResponse["success"]) {

      parsedResponse["data"].forEach((e) {
        SubjectModel subjectModel = SubjectModel.getInstance();
        subjectModel = SubjectModel.fromJson(e);
        DepartmentModel departmentModel = DepartmentModel.getInstance();
        departmentModel = DepartmentModel.fromJson(e["department"]);
        subjectModel.departmentModel = departmentModel;

        subjectList.add(subjectModel);
      });

      responseModel = ResponseModel(true, parsedResponse["message"]);
      dialogProgress = false;
    } else {
      String errorMessage = parsedResponse["message"];
      responseModel = ResponseModel(false, errorMessage);
      dialogProgress = false;
    }
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> fetchAllSubjects(String token)async{
    progress = true;
    notifyListeners();
    ResponseModel responseModel;
    subjectList = [];

    ApiResponse apiResponse = await appRepo.fetchAllSubjects(token);

    var parsedResponse = json.decode(apiResponse.response!.body);
    Constants.printMessage(Constants.SUBJECT_FETCH, parsedResponse.toString());

    if (apiResponse.response != null && parsedResponse["success"]) {
      parsedResponse["data"].forEach((e) {
        SubjectModel subjectModel = SubjectModel.getInstance();
        subjectModel = SubjectModel.fromJson(e);
        DepartmentModel departmentModel = DepartmentModel.getInstance();
        departmentModel = DepartmentModel.fromJson(e["department"]);
        subjectModel.departmentModel = departmentModel;

        subjectList.add(subjectModel);
      });

      responseModel = ResponseModel(true, parsedResponse["message"]);
      progress = false;
    } else {
      String errorMessage = parsedResponse["message"];
      responseModel = ResponseModel(false, errorMessage);
      progress = false;
    }
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> updateSubject(SubjectModel subjectModel, String token)async{
    dialogProgress = true;
    notifyListeners();
    ResponseModel responseModel;

    ApiResponse apiResponse = await appRepo.updateSubject(subjectModel, token);

    var parsedResponse = json.decode(apiResponse.response!.body);
    Constants.printMessage(Constants.SUBJECT_UPDATE, parsedResponse.toString());

    if (apiResponse.response != null && parsedResponse["success"]) {

      parsedResponse["data"].forEach((e) {
        SubjectModel subjectModel = SubjectModel.getInstance();
        subjectModel = SubjectModel.fromJson(e);
        DepartmentModel departmentModel = DepartmentModel.getInstance();
        departmentModel = DepartmentModel.fromJson(e["department"]);
        subjectModel.departmentModel = departmentModel;

        subjectList[subjectList.indexWhere((element) => element.subjectId == subjectModel.subjectId)];
      });

      responseModel = ResponseModel(true, parsedResponse["message"]);
      dialogProgress = false;
    } else {
      String errorMessage = parsedResponse["message"];
      responseModel = ResponseModel(false, errorMessage);
      dialogProgress = false;
    }
    notifyListeners();
    return responseModel;
  }
//----------------------------------------------------------------------------//

  /// Classes Provider
  Future<ResponseModel> fetchAllClasses(String token)async{
    progress = true;
    notifyListeners();
    ResponseModel responseModel;
    classList = [];

    ApiResponse apiResponse = await appRepo.fetchAllClasses(token);

    var parsedResponse = json.decode(apiResponse.response!.body);
    Constants.printMessage(Constants.CLASS_FETCH, parsedResponse.toString());

    if (apiResponse.response != null && parsedResponse["success"]) {
      parsedResponse["data"].forEach((e) {
        ClassModel classModel = ClassModel.getInstance();
        classModel = ClassModel.fromJson(e);
        DepartmentModel departmentModel = DepartmentModel.getInstance();
        departmentModel = DepartmentModel.fromJson(e["department"]);
        classModel.departmentModel = departmentModel;

        classList.add(classModel);
      });

      responseModel = ResponseModel(true, parsedResponse["message"]);
      progress = false;
    } else {
      String errorMessage = parsedResponse["message"];
      responseModel = ResponseModel(false, errorMessage);
      progress = false;
    }
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> addClass(ClassModel classModel, String token)async{
    dialogProgress = true;
    notifyListeners();
    ResponseModel responseModel;

    ApiResponse apiResponse = await appRepo.addClass(classModel, token);

    var parsedResponse = json.decode(apiResponse.response!.body);
    Constants.printMessage(Constants.CLASS_ADD, parsedResponse.toString());

    if (apiResponse.response != null && parsedResponse["success"]) {

      parsedResponse["data"].forEach((e) {
        ClassModel classModel = ClassModel.getInstance();
        classModel = ClassModel.fromJson(e);
        DepartmentModel departmentModel = DepartmentModel.getInstance();
        departmentModel = DepartmentModel.fromJson(e["department"]);
        classModel.departmentModel = departmentModel;

        classList.add(classModel);
      });

      responseModel = ResponseModel(true, parsedResponse["message"]);
      dialogProgress = false;
    } else {
      String errorMessage = parsedResponse["message"];
      responseModel = ResponseModel(false, errorMessage);
      dialogProgress = false;
    }
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> updateClass(ClassModel classModel, String token)async{
    dialogProgress = true;
    notifyListeners();
    ResponseModel responseModel;

    ApiResponse apiResponse = await appRepo.updateClass(classModel, token);

    var parsedResponse = json.decode(apiResponse.response!.body);
    Constants.printMessage(Constants.CLASS_UPDATE, parsedResponse.toString());

    if (apiResponse.response != null && parsedResponse["success"]) {

      parsedResponse["data"].forEach((e) {
        ClassModel classModel = ClassModel.getInstance();
        classModel = ClassModel.fromJson(e);
        DepartmentModel departmentModel = DepartmentModel.getInstance();
        departmentModel = DepartmentModel.fromJson(e["department"]);
        classModel.departmentModel = departmentModel;

        classList[classList.indexWhere((element) => element.classId == classModel.classId)];
      });

      responseModel = ResponseModel(true, parsedResponse["message"]);
      dialogProgress = false;
    } else {
      String errorMessage = parsedResponse["message"];
      responseModel = ResponseModel(false, errorMessage);
      dialogProgress = false;
    }
    notifyListeners();
    return responseModel;
  }
//----------------------------------------------------------------------------//

  /// Rooms Provider
  Future<ResponseModel> fetchAllRooms(String token)async{
    progress = true;
    notifyListeners();
    ResponseModel responseModel;
    roomList = [];

    ApiResponse apiResponse = await appRepo.fetchAllRooms(token);

    var parsedResponse = json.decode(apiResponse.response!.body);
    Constants.printMessage(Constants.ROOM_FETCH, parsedResponse.toString());

    if (apiResponse.response != null && parsedResponse["success"]) {
      parsedResponse["data"].forEach((e) {
        RoomsModel roomsModel = RoomsModel.getInstance();
        roomsModel = RoomsModel.fromJson(e);
        DepartmentModel departmentModel = DepartmentModel.getInstance();
        departmentModel = DepartmentModel.fromJson(e["department"]);
        roomsModel.departmentModel = departmentModel;

        roomList.add(roomsModel);
      });

      responseModel = ResponseModel(true, parsedResponse["message"]);
      progress = false;
    } else {
      String errorMessage = parsedResponse["message"];
      responseModel = ResponseModel(false, errorMessage);
      progress = false;
    }
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> fetchAllRooms_Department(DepartmentModel model, String token)async{
    progress = true;
    notifyListeners();
    ResponseModel responseModel;
    roomList = [];

    ApiResponse apiResponse = await appRepo.fetchAllRooms(token);

    var parsedResponse = json.decode(apiResponse.response!.body);
    Constants.printMessage(Constants.ROOM_FETCH, parsedResponse.toString());

    if (apiResponse.response != null && parsedResponse["success"]) {
      parsedResponse["data"].forEach((e) {
        RoomsModel roomsModel = RoomsModel.getInstance();
        roomsModel = RoomsModel.fromJson(e);
        DepartmentModel departmentModel = DepartmentModel.getInstance();
        departmentModel = DepartmentModel.fromJson(e["department"]);
        roomsModel.departmentModel = departmentModel;

        if(departmentModel.departmentId == model.departmentId) {
          roomList.add(roomsModel);
        }
      });

      responseModel = ResponseModel(true, parsedResponse["message"]);
      progress = false;
    } else {
      String errorMessage = parsedResponse["message"];
      responseModel = ResponseModel(false, errorMessage);
      progress = false;
    }
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> addRoom(RoomsModel roomsModel, String token)async{
    dialogProgress = true;
    notifyListeners();
    ResponseModel responseModel;

    ApiResponse apiResponse = await appRepo.addRoom(roomsModel, token);

    var parsedResponse = json.decode(apiResponse.response!.body);
    Constants.printMessage(Constants.ROOM_ADD, parsedResponse.toString());

    if (apiResponse.response != null && parsedResponse["success"]) {

      parsedResponse["data"].forEach((e) {
        RoomsModel roomsModel = RoomsModel.getInstance();
        roomsModel = RoomsModel.fromJson(e);
        DepartmentModel departmentModel = DepartmentModel.getInstance();
        departmentModel = DepartmentModel.fromJson(e["department"]);
        roomsModel.departmentModel = departmentModel;

        roomList.add(roomsModel);
      });

      responseModel = ResponseModel(true, parsedResponse["message"]);
      dialogProgress = false;
    } else {
      String errorMessage = parsedResponse["message"];
      responseModel = ResponseModel(false, errorMessage);
      dialogProgress = false;
    }
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> updateRoom(RoomsModel roomsModel, String token)async{
    dialogProgress = true;
    notifyListeners();
    ResponseModel responseModel;

    ApiResponse apiResponse = await appRepo.updateRoom(roomsModel, token);

    var parsedResponse = json.decode(apiResponse.response!.body);
    Constants.printMessage(Constants.ROOM_UPDATE, parsedResponse.toString());

    if (apiResponse.response != null && parsedResponse["success"]) {

      parsedResponse["data"].forEach((e) {
        RoomsModel roomsModel = RoomsModel.getInstance();
        roomsModel = RoomsModel.fromJson(e);
        DepartmentModel departmentModel = DepartmentModel.getInstance();
        departmentModel = DepartmentModel.fromJson(e["department"]);
        roomsModel.departmentModel = departmentModel;

        roomList[roomList.indexWhere((element) => element.roomId == roomsModel.roomId)];
      });

      responseModel = ResponseModel(true, parsedResponse["message"]);
      dialogProgress = false;
    } else {
      String errorMessage = parsedResponse["message"];
      responseModel = ResponseModel(false, errorMessage);
      dialogProgress = false;
    }
    notifyListeners();
    return responseModel;
  }
//----------------------------------------------------------------------------//

  /// Time Slots Provider
  Future<ResponseModel> fetchAllTimeSlots(String token)async{
    progress = true;
    notifyListeners();
    ResponseModel responseModel;
    timeSlotList = [];

    ApiResponse apiResponse = await appRepo.fetchAllTimeSlots(token);

    var parsedResponse = json.decode(apiResponse.response!.body);
    Constants.printMessage(Constants.TIMESLOT_FETCH, parsedResponse.toString());

    if (apiResponse.response != null && parsedResponse["success"]) {
      parsedResponse["data"].forEach((e) {
        TimeSlotsModel timeSlotsModel = TimeSlotsModel.getInstance();
        timeSlotsModel = TimeSlotsModel.fromJson(e);
        DepartmentModel departmentModel = DepartmentModel.getInstance();
        departmentModel = DepartmentModel.fromJson(e["department"]);
        timeSlotsModel.departmentModel = departmentModel;

        timeSlotList.add(timeSlotsModel);
      });

      responseModel = ResponseModel(true, parsedResponse["message"]);
      progress = false;
    } else {
      String errorMessage = parsedResponse["message"];
      responseModel = ResponseModel(false, errorMessage);
      progress = false;
    }
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> fetchAllTimeSlots_Department(DepartmentModel model, String token)async{
    progress = true;
    notifyListeners();
    ResponseModel responseModel;
    timeSlotList = [];

    ApiResponse apiResponse = await appRepo.fetchAllTimeSlots(token);

    var parsedResponse = json.decode(apiResponse.response!.body);
    Constants.printMessage(Constants.TIMESLOT_FETCH, parsedResponse.toString());

    if (apiResponse.response != null && parsedResponse["success"]) {
      parsedResponse["data"].forEach((e) {
        TimeSlotsModel timeSlotsModel = TimeSlotsModel.getInstance();
        timeSlotsModel = TimeSlotsModel.fromJson(e);
        DepartmentModel departmentModel = DepartmentModel.getInstance();
        departmentModel = DepartmentModel.fromJson(e["department"]);
        timeSlotsModel.departmentModel = departmentModel;

        if(departmentModel.departmentId == model.departmentId) {
          timeSlotList.add(timeSlotsModel);
        }
      });

      responseModel = ResponseModel(true, parsedResponse["message"]);
      progress = false;
    } else {
      String errorMessage = parsedResponse["message"];
      responseModel = ResponseModel(false, errorMessage);
      progress = false;
    }
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> addTimeSlot(TimeSlotsModel timeSlotsModel, String token)async{
    dialogProgress = true;
    notifyListeners();
    ResponseModel responseModel;

    ApiResponse apiResponse = await appRepo.addTimeSlot(timeSlotsModel, token);

    var parsedResponse = json.decode(apiResponse.response!.body);
    Constants.printMessage(Constants.TIMESLOT_ADD, parsedResponse.toString());

    if (apiResponse.response != null && parsedResponse["success"]) {

      parsedResponse["data"].forEach((e) {
        TimeSlotsModel timeSlotsModel = TimeSlotsModel.getInstance();
        timeSlotsModel = TimeSlotsModel.fromJson(e);
        DepartmentModel departmentModel = DepartmentModel.getInstance();
        departmentModel = DepartmentModel.fromJson(e["department"]);
        timeSlotsModel.departmentModel = departmentModel;

        timeSlotList.add(timeSlotsModel);
      });

      responseModel = ResponseModel(true, parsedResponse["message"]);
      dialogProgress = false;
    } else {
      String errorMessage = parsedResponse["message"];
      responseModel = ResponseModel(false, errorMessage);
      dialogProgress = false;
    }
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> updateTimeSlots(TimeSlotsModel timeSlotsModel, String token)async{
    dialogProgress = true;
    notifyListeners();
    ResponseModel responseModel;

    ApiResponse apiResponse = await appRepo.updateTimeSlots(timeSlotsModel, token);

    var parsedResponse = json.decode(apiResponse.response!.body);
    Constants.printMessage(Constants.TIMESLOT_UPDATE, parsedResponse.toString());

    if (apiResponse.response != null && parsedResponse["success"]) {

      parsedResponse["data"].forEach((e) {
        TimeSlotsModel timeSlotsModel = TimeSlotsModel.getInstance();
        timeSlotsModel = TimeSlotsModel.fromJson(e);
        DepartmentModel departmentModel = DepartmentModel.getInstance();
        departmentModel = DepartmentModel.fromJson(e["department"]);
        timeSlotsModel.departmentModel = departmentModel;

        timeSlotList[timeSlotList.indexWhere((element) => element.timeslotId == timeSlotsModel.timeslotId)];
      });

      responseModel = ResponseModel(true, parsedResponse["message"]);
      dialogProgress = false;
    } else {
      String errorMessage = parsedResponse["message"];
      responseModel = ResponseModel(false, errorMessage);
      dialogProgress = false;
    }
    notifyListeners();
    return responseModel;
  }
//----------------------------------------------------------------------------//

  /// Students Provider
  Future<ResponseModel> fetchAllStudents(String type, String token)async{
    studentProgress = true;
    notifyListeners();
    ResponseModel responseModel;

    studentList = [];

    ApiResponse apiResponse = await appRepo.fetchAllStudents(type, token);

    var parsedResponse = json.decode(apiResponse.response!.body);
    Constants.printMessage(Constants.STUDENT_FETCH, parsedResponse.toString());

    if (apiResponse.response != null && parsedResponse["success"]) {

      parsedResponse["data"].forEach((element) {
        StudentModel studentModel = StudentModel.getInstance();
        UserModel userModel = UserModel.getInstance();
        DepartmentModel departmentModel = DepartmentModel.getInstance();
        ClassModel classModel = ClassModel.getInstance();

        userModel.userId = element["id"];
        userModel.userName = element["name"].toString();
        userModel.userEmail = element["email"].toString();
        userModel.userPhone = element["phone"].toString();
        userModel.userGender = element["gender"].toString();
        userModel.userImage = element["image"].toString();
        userModel.userType = element["type"].toString();
        userModel.userStatus = element["status"].toString();
        userModel.userDepartment = element["student"]["department_id"].toString();
        userModel.userSession = element["student"]["session"].toString();
        userModel.userRollNo = element["student"]["roll_no"].toString();
        userModel.userClass = element["student"]["class_id"].toString();
        departmentModel = DepartmentModel.fromJson(element["student"]["department"]);
        classModel = ClassModel.fromJson(element["student"]["class"]);

        studentModel.userModel = userModel;
        studentModel.departmentModel = departmentModel;
        studentModel.classModel = classModel;

        studentList.add(studentModel);
      });

      responseModel = ResponseModel(true, parsedResponse["message"]);
      studentProgress = false;
    } else {
      String errorMessage = parsedResponse["message"];
      responseModel = ResponseModel(false, errorMessage);
      studentProgress = false;
    }
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> addStudent(StudentModel studentModel, String token)async{
    progress = true;
    notifyListeners();
    ResponseModel responseModel;

    ApiResponse apiResponse = await appRepo.addStudent(studentModel, token);

    var parsedResponse = json.decode(apiResponse.response!.body);
    Constants.printMessage(Constants.STUDENT_ADD, parsedResponse.toString());

    if (apiResponse.response != null && parsedResponse["success"]) {

      StudentModel studentModel = StudentModel.getInstance();
      UserModel userModel = UserModel.getInstance();
      DepartmentModel departmentModel = DepartmentModel.getInstance();
      ClassModel classModel = ClassModel.getInstance();

      userModel.userId = parsedResponse["data"]["user"]["id"];
      userModel.userName = parsedResponse["data"]["user"]["name"].toString();
      userModel.userEmail = parsedResponse["data"]["user"]["email"].toString();
      userModel.userPhone = parsedResponse["data"]["user"]["phone"].toString();
      userModel.userGender = parsedResponse["data"]["user"]["gender"].toString();
      userModel.userImage = parsedResponse["data"]["user"]["image"].toString();
      userModel.userType = parsedResponse["data"]["user"]["type"].toString();
      userModel.userStatus = parsedResponse["data"]["user"]["status"].toString();
      userModel.userDepartment = parsedResponse["data"]["user_details"]["department_id"].toString();
      userModel.userSession = parsedResponse["data"]["user_details"]["session"].toString();
      userModel.userRollNo = parsedResponse["data"]["user_details"]["roll_no"].toString();
      userModel.userClass = parsedResponse["data"]["user_details"]["class_id"].toString();
      departmentModel = DepartmentModel.fromJson(parsedResponse["data"]["user_details"]["department"]);
      classModel = ClassModel.fromJson(parsedResponse["data"]["user_details"]["class"]);

      studentModel.userModel = userModel;
      studentModel.departmentModel = departmentModel;
      studentModel.classModel = classModel;

      studentList.add(studentModel);

      responseModel = ResponseModel(true, parsedResponse["message"]);
      progress = false;
    } else {
      String errorMessage = parsedResponse["message"];
      responseModel = ResponseModel(false, errorMessage);
      progress = false;
    }
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> updateStudent(StudentModel studentModel, String token)async{
    progress = true;
    notifyListeners();
    ResponseModel responseModel;

    studentUpdatedModel = StudentModel.getInstance();
    ApiResponse apiResponse = await appRepo.updateStudent(studentModel, token);

    var parsedResponse = json.decode(apiResponse.response!.body);
    Constants.printMessage(Constants.STUDENT_UPDATE, parsedResponse.toString());

    if (apiResponse.response != null && parsedResponse["success"]) {

      StudentModel studentModel = StudentModel.getInstance();
      UserModel userModel = UserModel.getInstance();
      DepartmentModel departmentModel = DepartmentModel.getInstance();
      ClassModel classModel = ClassModel.getInstance();

      userModel.userId = parsedResponse["data"]["user"]["id"];
      userModel.userName = parsedResponse["data"]["user"]["name"].toString();
      userModel.userEmail = parsedResponse["data"]["user"]["email"].toString();
      userModel.userPhone = parsedResponse["data"]["user"]["phone"].toString();
      userModel.userGender = parsedResponse["data"]["user"]["gender"].toString();
      userModel.userImage = parsedResponse["data"]["user"]["image"].toString();
      userModel.userType = parsedResponse["data"]["user"]["type"].toString();
      userModel.userStatus = parsedResponse["data"]["user"]["status"].toString();
      userModel.userAddress = parsedResponse["data"]["user"]["address"].toString();
      userModel.userCnic = parsedResponse["data"]["user"]["cnic_no"].toString();
      userModel.userDepartment = parsedResponse["data"]["user_details"]["department_id"].toString();
      userModel.userSession = parsedResponse["data"]["user_details"]["session"].toString();
      userModel.userRollNo = parsedResponse["data"]["user_details"]["roll_no"].toString();
      userModel.userClass = parsedResponse["data"]["user_details"]["class_id"].toString();
      departmentModel = DepartmentModel.fromJson(parsedResponse["data"]["user_details"]["department"]);
      classModel = ClassModel.fromJson(parsedResponse["data"]["user_details"]["class"]);

      studentModel.userModel = userModel;
      studentModel.departmentModel = departmentModel;
      studentModel.classModel = classModel;

      studentUpdatedModel = studentModel;

      studentList[studentList.indexWhere((element) => element.userModel.userId == studentModel.userModel.userId)] = studentModel;

      responseModel = ResponseModel(true, parsedResponse["message"]);
      progress = false;
    } else {
      String errorMessage = parsedResponse["message"];
      responseModel = ResponseModel(false, errorMessage);
      progress = false;
    }
    notifyListeners();
    return responseModel;
  }
//----------------------------------------------------------------------------//

  /// Teachers Provider
  Future<ResponseModel> fetchAllTeachers(bool notify, String type, String token)async{
    studentProgress = true;
    if(notify) {
      notifyListeners();
    }
    ResponseModel responseModel;

    teacherList = [];

    ApiResponse apiResponse = await appRepo.fetchAllTeachers(type, token);

    var parsedResponse = json.decode(apiResponse.response!.body);
    Constants.printMessage(Constants.TEACHER_FETCH, parsedResponse.toString());

    if (apiResponse.response != null && parsedResponse["success"]) {

      parsedResponse["data"].forEach((element) {
        TeacherModel teacherModel = TeacherModel.getInstance();
        UserModel userModel = UserModel.getInstance();
        DepartmentModel departmentModel = DepartmentModel.getInstance();
        WorkloadAssignmentModel workloadAssignmentModel = WorkloadAssignmentModel.getInstance();

        userModel.userId = element["id"];
        userModel.userName = element["name"].toString();
        userModel.userEmail = element["email"].toString();
        userModel.userPhone = element["phone"].toString();
        userModel.userGender = element["gender"].toString();
        userModel.userImage = element["image"].toString();
        userModel.userType = element["type"].toString();
        userModel.userStatus = element["status"].toString();
        userModel.userAddress = element["address"].toString();
        userModel.userCnic = element["cnic_no"].toString();
        if(element["staff"].toString() != "null") {
          userModel.userExaminationPassedMPhil =
              element["staff"]["userExaminationPassedMPhil"].toString();
          userModel.mPhilPassedExamSubject =
              element["staff"]["mPhilPassedExamSubject"].toString();
          userModel.mPhilPassedExamYear =
              element["staff"]["mPhilPassedExamYear"].toString();
          userModel.mPhilPassedExamDivision =
              element["staff"]["mPhilPassedExamDivision"].toString();
          userModel.mPhilPassedExamInstitute =
              element["staff"]["mPhilPassedExamInstitute"].toString();
          userModel.userExaminationPassedPhd =
              element["staff"]["userExaminationPassedPhd"].toString();
          userModel.phdPassedExamSubject =
              element["staff"]["phdPassedExamSubject"].toString();
          userModel.phdPassedExamYear =
              element["staff"]["phdPassedExamYear"].toString();
          userModel.phdPassedExamDivision =
              element["staff"]["phdPassedExamDivision"].toString();
          userModel.phdPassedExamInstitute =
              element["staff"]["phdPassedExamInstitute"].toString();
          userModel.userSpecializedField =
              element["staff"]["userSpecializedField"].toString();
          userModel.userGraduationLevelExperience =
              element["staff"]["userGraduationLevelExperience"].toString();
          userModel.userPostGraduationLevelExperience =
              element["staff"]["userPostGraduationLevelExperience"].toString();
          userModel.userSignature = element["staff"]["Signature"].toString();
          userModel.userDepartment =
              element["staff"]["department_id"].toString();
          userModel.userQualification =
              element["staff"]["qualification"].toString();
          userModel.userDesignation =
              element["staff"]["designation"].toString();
          userModel.totalAllowedCreditHours = int.parse(
              element["staff"]["total_allowed_credit_hours"].toString());
          userModel.userDesignation =
              element["staff"]["designation"].toString();

          departmentModel = DepartmentModel.fromJson(element["staff"]["department"]);
        }

        List<WorkloadAssignmentModel> newWorkLoad = [];
        element["workloads"].forEach((workLoadElement) {
          workloadAssignmentModel =  WorkloadAssignmentModel.getInstance();
          DepartmentModel departmentModel = DepartmentModel.getInstance();
          ClassModel classModel = ClassModel.getInstance();
          SubjectModel subjectModel = SubjectModel.getInstance();
          RoomsModel roomsModel = RoomsModel.getInstance();

          departmentModel = DepartmentModel.fromJson(workLoadElement["department"]);
          classModel = ClassModel.fromJson(workLoadElement["department_class"]);
          subjectModel = SubjectModel.fromJson(workLoadElement["subject"]);

          workloadAssignmentModel.userModel = userModel;
          workloadAssignmentModel.departmentModel = departmentModel;
          workloadAssignmentModel.subjectModel = subjectModel;
          workloadAssignmentModel.classModel = classModel;
          workloadAssignmentModel.roomsModel = roomsModel;

          workloadAssignmentModel.workloadId = workLoadElement["id"];
          workloadAssignmentModel.workloadStatus = workLoadElement["status"];
          workloadAssignmentModel.workDemanded = workLoadElement["work_demanded"];
          workloadAssignmentModel.classRoutine = workLoadElement["routine"];

          if(workloadAssignmentModel.workloadStatus == "Active") {
            newWorkLoad.add(workloadAssignmentModel);
          }
        });

        teacherModel.userModel = userModel;
        teacherModel.departmentModel = departmentModel;
        teacherModel.workloadList = newWorkLoad;

        teacherList.add(teacherModel);
      });

      responseModel = ResponseModel(true, parsedResponse["message"]);
      studentProgress = false;
    } else {
      String errorMessage = parsedResponse["message"];
      responseModel = ResponseModel(false, errorMessage);
      studentProgress = false;
    }
    if(notify) {
      notifyListeners();
    }
    return responseModel;
  }

  Future<ResponseModel> approveTeacher(int userId, String status, String token)async{
    dialogProgress = true;
    notifyListeners();
    ResponseModel responseModel;

    ApiResponse apiResponse = await appRepo.approveTeacher(userId, status, token);

    var parsedResponse = json.decode(apiResponse.response!.body);
    Constants.printMessage(Constants.STUDENT_FETCH, parsedResponse.toString());

    if (apiResponse.response != null && parsedResponse["success"]) {

      parsedResponse["data"].forEach((element) {
        TeacherModel teacherModel = TeacherModel.getInstance();
        UserModel userModel = UserModel.getInstance();
        DepartmentModel departmentModel = DepartmentModel.getInstance();

        userModel.userId = element["id"];
        userModel.userName = element["name"].toString();
        userModel.userEmail = element["email"].toString();
        userModel.userPhone = element["phone"].toString();
        userModel.userGender = element["gender"].toString();
        userModel.userImage = element["image"].toString();
        userModel.userType = element["type"].toString();
        userModel.userStatus = element["status"].toString();
        userModel.userDepartment = element["staff"]["department_id"].toString();
        userModel.userQualification = element["staff"]["qualification"].toString();
        userModel.userDesignation = element["staff"]["designation"].toString();
        userModel.totalAllowedCreditHours = int.parse(element["staff"]["total_allowed_credit_hours"].toString());
        departmentModel = DepartmentModel.fromJson(element["staff"]["department"]);

        teacherModel.userModel = userModel;
        teacherModel.departmentModel = departmentModel;

        teacherList[teacherList.indexWhere((element) => element.userModel.userId == userId)] = teacherModel;
      });

      responseModel = ResponseModel(true, parsedResponse["message"]);
      dialogProgress = false;
    } else {
      String errorMessage = parsedResponse["message"];
      responseModel = ResponseModel(false, errorMessage);
      dialogProgress = false;
    }
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> updateTeacher(TeacherModel teacherModel, String token)async{
    progress = true;
    notifyListeners();
    ResponseModel responseModel;

    teacherUpdatedModel = TeacherModel.getInstance();
    ApiResponse apiResponse = await appRepo.updateTeacher(teacherModel, token);

    var parsedResponse = json.decode(apiResponse.response!.body);
    Constants.printMessage(Constants.TEACHER_UPDATE, parsedResponse.toString());

    if (apiResponse.response != null && parsedResponse["success"]) {

      TeacherModel teacherModel = TeacherModel.getInstance();
      UserModel userModel = UserModel.getInstance();
      DepartmentModel departmentModel = DepartmentModel.getInstance();

      userModel.userId = parsedResponse["data"]["user"]["id"];
      userModel.userName = parsedResponse["data"]["user"]["name"].toString();
      userModel.userEmail = parsedResponse["data"]["user"]["email"].toString();
      userModel.userPhone = parsedResponse["data"]["user"]["phone"].toString();
      userModel.userGender = parsedResponse["data"]["user"]["gender"].toString();
      userModel.userImage = parsedResponse["data"]["user"]["image"].toString();
      userModel.userType = parsedResponse["data"]["user"]["type"].toString();
      userModel.userStatus = parsedResponse["data"]["user"]["status"].toString();
      userModel.userCnic = parsedResponse["data"]["user"]["cnic_no"].toString();
      userModel.userAddress = parsedResponse["data"]["user"]["address"].toString();
      userModel.userDepartment = parsedResponse["data"]["user_details"]["department_id"].toString();
      userModel.userQualification = parsedResponse["data"]["user_details"]["qualification"].toString();
      userModel.userDesignation = parsedResponse["data"]["user_details"]["designation"].toString();
      userModel.totalAllowedCreditHours = int.parse(parsedResponse["data"]["user_details"]["total_allowed_credit_hours"].toString());
      userModel.userExaminationPassedMPhil = "M.Phil";
      userModel.mPhilPassedExamSubject = parsedResponse["data"]["user_details"]["mPhilPassedExamSubject"].toString();
      userModel.mPhilPassedExamYear = parsedResponse["data"]["user_details"]["mPhilPassedExamYear"].toString();
      userModel.mPhilPassedExamDivision = parsedResponse["data"]["user_details"]["mPhilPassedExamDivision"].toString();
      userModel.mPhilPassedExamInstitute = parsedResponse["data"]["user_details"]["mPhilPassedExamInstitute"].toString();
      userModel.userExaminationPassedPhd = parsedResponse["data"]["user_details"]["userExaminationPassedPhd"].toString();
      userModel.phdPassedExamSubject = parsedResponse["data"]["user_details"]["phdPassedExamSubject"].toString();
      userModel.phdPassedExamYear = parsedResponse["data"]["user_details"]["phdPassedExamYear"].toString();
      userModel.phdPassedExamDivision = parsedResponse["data"]["user_details"]["phdPassedExamDivision"].toString();
      userModel.phdPassedExamInstitute = parsedResponse["data"]["user_details"]["phdPassedExamInstitute"].toString();
      userModel.userSpecializedField = parsedResponse["data"]["user_details"]["userSpecializedField"].toString();
      userModel.userGraduationLevelExperience = parsedResponse["data"]["user_details"]["userGraduationLevelExperience"].toString();
      userModel.userPostGraduationLevelExperience = parsedResponse["data"]["user_details"]["userPostGraduationLevelExperience"].toString();
      userModel.userSignature = parsedResponse["data"]["user_details"]["Signature"].toString();
      departmentModel = DepartmentModel.fromJson(parsedResponse["data"]["user_details"]["department"]);

      teacherModel.userModel = userModel;
      teacherModel.departmentModel = departmentModel;

      teacherList[teacherList.indexWhere((element) => element.userModel.userId == teacherModel.userModel.userId)] = teacherModel;

      responseModel = ResponseModel(true, parsedResponse["message"]);
      progress = false;
    } else {
      String errorMessage = parsedResponse["message"];
      responseModel = ResponseModel(false, errorMessage);
      progress = false;
    }
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> updateTeacherProfile(TeacherModel teacherModel, var signatureBytes, String token)async{
    progress = true;
    notifyListeners();
    ResponseModel responseModel;

    teacherUpdatedModel = TeacherModel.getInstance();
    ApiResponse apiResponse = await appRepo.updateTeacherProfile(teacherModel, signatureBytes, token);

    var parsedResponse = json.decode(apiResponse.response!.body);
    Constants.printMessage(Constants.TEACHER_UPDATE, parsedResponse.toString());

    if (apiResponse.response != null && parsedResponse["success"]) {

      TeacherModel teacherModel = TeacherModel.getInstance();
      UserModel userModel = UserModel.getInstance();
      DepartmentModel departmentModel = DepartmentModel.getInstance();

      userModel.userId = parsedResponse["data"]["user"]["id"];
      userModel.userName = parsedResponse["data"]["user"]["name"].toString();
      userModel.userEmail = parsedResponse["data"]["user"]["email"].toString();
      userModel.userPhone = parsedResponse["data"]["user"]["phone"].toString();
      userModel.userGender = parsedResponse["data"]["user"]["gender"].toString();
      userModel.userImage = parsedResponse["data"]["user"]["image"].toString();
      userModel.userType = parsedResponse["data"]["user"]["type"].toString();
      userModel.userStatus = parsedResponse["data"]["user"]["status"].toString();
      userModel.userCnic = parsedResponse["data"]["user"]["cnic_no"].toString();
      userModel.userAddress = parsedResponse["data"]["user"]["address"].toString();
      userModel.userDepartment = parsedResponse["data"]["user_details"]["department_id"].toString();
      userModel.userQualification = parsedResponse["data"]["user_details"]["qualification"].toString();
      userModel.userDesignation = parsedResponse["data"]["user_details"]["designation"].toString();
      userModel.totalAllowedCreditHours = int.parse(parsedResponse["data"]["user_details"]["total_allowed_credit_hours"].toString());
      userModel.userExaminationPassedMPhil = "M.Phil";
      userModel.mPhilPassedExamSubject = parsedResponse["data"]["user_details"]["mPhilPassedExamSubject"].toString();
      userModel.mPhilPassedExamYear = parsedResponse["data"]["user_details"]["mPhilPassedExamYear"].toString();
      userModel.mPhilPassedExamDivision = parsedResponse["data"]["user_details"]["mPhilPassedExamDivision"].toString();
      userModel.mPhilPassedExamInstitute = parsedResponse["data"]["user_details"]["mPhilPassedExamInstitute"].toString();
      userModel.userExaminationPassedPhd = parsedResponse["data"]["user_details"]["userExaminationPassedPhd"].toString();
      userModel.phdPassedExamSubject = parsedResponse["data"]["user_details"]["phdPassedExamSubject"].toString();
      userModel.phdPassedExamYear = parsedResponse["data"]["user_details"]["phdPassedExamYear"].toString();
      userModel.phdPassedExamDivision = parsedResponse["data"]["user_details"]["phdPassedExamDivision"].toString();
      userModel.phdPassedExamInstitute = parsedResponse["data"]["user_details"]["phdPassedExamInstitute"].toString();
      userModel.userSpecializedField = parsedResponse["data"]["user_details"]["userSpecializedField"].toString();
      userModel.userGraduationLevelExperience = parsedResponse["data"]["user_details"]["userGraduationLevelExperience"].toString();
      userModel.userPostGraduationLevelExperience = parsedResponse["data"]["user_details"]["userPostGraduationLevelExperience"].toString();
      userModel.userSignature = parsedResponse["data"]["user_details"]["Signature"].toString();
      departmentModel = DepartmentModel.fromJson(parsedResponse["data"]["user_details"]["department"]);

      teacherModel.userModel = userModel;
      teacherModel.departmentModel = departmentModel;

      SharedPreferenceManager.getInstance().updateUser(userModel);

      //teacherList[teacherList.indexWhere((element) => element.userModel.userId == teacherModel.userModel.userId)] = teacherModel;

      responseModel = ResponseModel(true, parsedResponse["message"]);
      progress = false;
    } else {
      String errorMessage = parsedResponse["message"];
      responseModel = ResponseModel(false, errorMessage);
      progress = false;
    }
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> fetchSpecificTeacher(String type, int userId, String token)async{
    progress = true;
    notifyListeners();
    ResponseModel responseModel;

    singleTeacherModel = SingleTeacherModel.getInstance();

    ApiResponse apiResponse = await appRepo.fetchSpecificTeacher(type, userId, token);

    var parsedResponse = json.decode(apiResponse.response!.body);
    Constants.printMessage(Constants.TEACHER_FETCH, parsedResponse.toString());

    if (apiResponse.response != null && parsedResponse["success"]) {

      parsedResponse["data"].forEach((element) {
        singleTeacherModel = SingleTeacherModel.getInstance();
        UserModel userModel = UserModel.getInstance();
        DepartmentModel departmentModel = DepartmentModel.getInstance();
        TeacherWorkloadModel teacherWorkloadModel = TeacherWorkloadModel.getInstance();

        userModel.userId = element["id"];
        userModel.userName = element["name"].toString();
        userModel.userEmail = element["email"].toString();
        userModel.userPhone = element["phone"].toString();
        userModel.userGender = element["gender"].toString();
        userModel.userImage = element["image"].toString();
        userModel.userType = element["type"].toString();
        userModel.userStatus = element["status"].toString();
        userModel.userAddress = element["address"].toString();
        userModel.userCnic = element["cnic_no"].toString();
        userModel.userExaminationPassedMPhil = element["staff"]["userExaminationPassedMPhil"].toString();
        userModel.mPhilPassedExamSubject = element["staff"]["mPhilPassedExamSubject"].toString();
        userModel.mPhilPassedExamYear = element["staff"]["mPhilPassedExamYear"].toString();
        userModel.mPhilPassedExamDivision = element["staff"]["mPhilPassedExamDivision"].toString();
        userModel.mPhilPassedExamInstitute = element["staff"]["mPhilPassedExamInstitute"].toString();
        userModel.userExaminationPassedPhd = element["staff"]["userExaminationPassedPhd"].toString();
        userModel.phdPassedExamSubject = element["staff"]["phdPassedExamSubject"].toString();
        userModel.phdPassedExamYear = element["staff"]["phdPassedExamYear"].toString();
        userModel.phdPassedExamDivision = element["staff"]["phdPassedExamDivision"].toString();
        userModel.phdPassedExamInstitute = element["staff"]["phdPassedExamInstitute"].toString();
        userModel.userSpecializedField = element["staff"]["userSpecializedField"].toString();
        userModel.userGraduationLevelExperience = element["staff"]["userGraduationLevelExperience"].toString();
        userModel.userPostGraduationLevelExperience = element["staff"]["userPostGraduationLevelExperience"].toString();
        userModel.userSignature = element["staff"]["Signature"].toString();
        userModel.userDepartment = element["staff"]["department_id"].toString();
        userModel.userQualification = element["staff"]["qualification"].toString();
        userModel.userDesignation = element["staff"]["designation"].toString();
        userModel.totalAllowedCreditHours = int.parse(element["staff"]["total_allowed_credit_hours"].toString());
        userModel.userDesignation = element["staff"]["designation"].toString();

        SharedPreferenceManager.getInstance().updateUser(userModel);
        departmentModel = DepartmentModel.fromJson(element["staff"]["department"]);

        List<TeacherWorkloadModel> newWorkLoad = [];
        element["workloads"].forEach((workLoadElement) {
          teacherWorkloadModel =  TeacherWorkloadModel.getInstance();
          DepartmentModel departmentModel = DepartmentModel.getInstance();
          ClassModel classModel = ClassModel.getInstance();
          SubjectModel subjectModel = SubjectModel.getInstance();
          RoomsModel roomsModel = RoomsModel.getInstance();

          departmentModel = DepartmentModel.fromJson(workLoadElement["department"]);
          classModel = ClassModel.fromJson(workLoadElement["department_class"]);
          subjectModel = SubjectModel.fromJson(workLoadElement["subject"]);

          teacherWorkloadModel.departmentModel = departmentModel;
          teacherWorkloadModel.subjectModel = subjectModel;
          teacherWorkloadModel.classModel = classModel;
          teacherWorkloadModel.roomsModel = roomsModel;

          teacherWorkloadModel.workloadId = workLoadElement["id"];
          teacherWorkloadModel.workloadStatus = workLoadElement["status"];
          teacherWorkloadModel.workDemanded = workLoadElement["work_demanded"];
          teacherWorkloadModel.classRoutine = workLoadElement["routine"];

          workLoadElement["department_class"]["students"].forEach((student) {
            UserModel studentModel = UserModel.getInstance();
            studentModel.userId = int.parse(student["user_id"]);
            studentModel.userName = student["student_profile"]["name"].toString();
            studentModel.userEmail = student["student_profile"]["email"].toString();
            studentModel.userPhone = student["student_profile"]["phone"].toString();
            studentModel.userGender = student["student_profile"]["gender"].toString();
            studentModel.userImage = student["student_profile"]["image"].toString();
            studentModel.userType = student["student_profile"]["type"].toString();
            studentModel.userStatus = student["student_profile"]["status"].toString();
            studentModel.userAddress = student["student_profile"]["address"].toString();
            studentModel.userCnic = student["student_profile"]["cnic_no"].toString();
            studentModel.userDepartment = student["department_id"].toString();
            studentModel.userSession = student["session"].toString();
            studentModel.userRollNo = student["roll_no"].toString();
            studentModel.userClass = student["class_id"].toString();

            teacherWorkloadModel.studentList.add(studentModel);
          });

          //teacherWorkloadModel.studentList = newStudent;
          if(teacherWorkloadModel.workloadStatus == "Active") {
            newWorkLoad.add(teacherWorkloadModel);
          }
          print("___________: Class: ${teacherWorkloadModel.classModel.classId} - Students: ${teacherWorkloadModel.studentList.length}");
        });

        singleTeacherModel.userModel = userModel;
        singleTeacherModel.departmentModel = departmentModel;
        singleTeacherModel.workloadList = newWorkLoad;
      });

      //print("___________: User Id: ${singleTeacherModel.userModel.userId}");
      //print("___________: Department Id: ${singleTeacherModel.departmentModel.departmentId}");
      //print("___________: WorkloadList Length: ${singleTeacherModel.workloadList.length}");
      //print("___________: Student Length: ${singleTeacherModel.workloadList[2].studentList[0].userName}");
      //print("___________: Student Length: ${singleTeacherModel.workloadList[2].studentList[1].userName}");


      responseModel = ResponseModel(true, parsedResponse["message"]);
      progress = false;
    } else {
      String errorMessage = parsedResponse["message"];
      responseModel = ResponseModel(false, errorMessage);
      progress = false;
    }

    notifyListeners();
    return responseModel;
  }
//----------------------------------------------------------------------------//

  /// Workloads Provider
  Future<ResponseModel> addWorkload(WorkloadAssignmentModel model, String token)async{
    progress = true;
    notifyListeners();
    ResponseModel responseModel;

    ApiResponse apiResponse = await appRepo.addWorkload(model, token);

    var parsedResponse = json.decode(apiResponse.response!.body);
    Constants.printMessage(Constants.WORKLOAD_ADD, parsedResponse.toString());

    if (apiResponse.response != null && parsedResponse["success"]) {

      parsedResponse["data"].forEach((element) {
        WorkloadAssignmentModel workloadAssignmentModel =  WorkloadAssignmentModel.getInstance();
        UserModel userModel = UserModel.getInstance();
        DepartmentModel departmentModel = DepartmentModel.getInstance();
        ClassModel classModel = ClassModel.getInstance();
        SubjectModel subjectModel = SubjectModel.getInstance();
        RoomsModel roomsModel = RoomsModel.getInstance();

        userModel.userId = element["user"]["id"];
        userModel.userName = element["user"]["name"].toString();
        userModel.userEmail = element["user"]["email"].toString();
        userModel.userPhone = element["user"]["phone"].toString();
        userModel.userGender = element["user"]["gender"].toString();
        userModel.userImage = element["user"]["image"].toString();
        userModel.userType = element["user"]["type"].toString();
        userModel.userStatus = element["user"]["status"].toString();
        userModel.userDepartment = element["user"]["staff"]["department_id"].toString();
        userModel.userQualification = element["user"]["staff"]["qualification"].toString();
        userModel.userDesignation = element["user"]["staff"]["designation"].toString();
        userModel.totalAllowedCreditHours = int.parse(element["user"]["staff"]["total_allowed_credit_hours"].toString());
        departmentModel = DepartmentModel.fromJson(element["department"]);
        classModel = ClassModel.fromJson(element["department_class"]);
        subjectModel = SubjectModel.fromJson(element["subject"]);

        workloadAssignmentModel.userModel = userModel;
        workloadAssignmentModel.departmentModel = departmentModel;
        workloadAssignmentModel.subjectModel = subjectModel;
        workloadAssignmentModel.classModel = classModel;
        workloadAssignmentModel.roomsModel = roomsModel;

        workloadAssignmentModel.workloadId = element["id"];
        workloadAssignmentModel.workloadStatus = element["status"];
        workloadAssignmentModel.workDemanded = element["work_demanded"];
        workloadAssignmentModel.classRoutine = element["routine"];

        if(workloadAssignmentModel.workloadStatus == "Active") {
          workloadList.add(workloadAssignmentModel);
        }
      });

      responseModel = ResponseModel(true, parsedResponse["message"]);
      progress = false;
    } else {
      String errorMessage = parsedResponse["message"];
      responseModel = ResponseModel(false, errorMessage);
      progress = false;
    }
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> fetchAllWorkload(DepartmentModel model, String token)async{
    progress = true;
    notifyListeners();
    workloadList.clear();
    ResponseModel responseModel;

    ApiResponse apiResponse = await appRepo.fetchAllWorkload(model, token);

    var parsedResponse = json.decode(apiResponse.response!.body);
    Constants.printMessage(Constants.WORKLOAD_FETCH, parsedResponse.toString());

    if (apiResponse.response != null && parsedResponse["success"]) {

      parsedResponse["data"].forEach((element) {
        WorkloadAssignmentModel workloadAssignmentModel =  WorkloadAssignmentModel.getInstance();
        UserModel userModel = UserModel.getInstance();
        DepartmentModel departmentModel = DepartmentModel.getInstance();
        ClassModel classModel = ClassModel.getInstance();
        SubjectModel subjectModel = SubjectModel.getInstance();
        RoomsModel roomsModel = RoomsModel.getInstance();

        userModel.userId = element["user"]["id"];
        userModel.userName = element["user"]["name"].toString();
        userModel.userEmail = element["user"]["email"].toString();
        userModel.userPhone = element["user"]["phone"].toString();
        userModel.userGender = element["user"]["gender"].toString();
        userModel.userImage = element["user"]["image"].toString();
        userModel.userType = element["user"]["type"].toString();
        userModel.userStatus = element["user"]["status"].toString();
        userModel.userDepartment = element["user"]["staff"]["department_id"].toString();
        userModel.userQualification = element["user"]["staff"]["qualification"].toString();
        userModel.userDesignation = element["user"]["staff"]["designation"].toString();
        userModel.totalAllowedCreditHours = int.parse(element["user"]["staff"]["total_allowed_credit_hours"].toString());
        departmentModel = DepartmentModel.fromJson(element["department"]);
        classModel = ClassModel.fromJson(element["department_class"]);
        subjectModel = SubjectModel.fromJson(element["subject"]);

        workloadAssignmentModel.userModel = userModel;
        workloadAssignmentModel.departmentModel = departmentModel;
        workloadAssignmentModel.subjectModel = subjectModel;
        workloadAssignmentModel.classModel = classModel;
        workloadAssignmentModel.roomsModel = roomsModel;

        workloadAssignmentModel.workloadId = element["id"];
        workloadAssignmentModel.workloadStatus = element["status"];
        workloadAssignmentModel.workDemanded = element["work_demanded"];
        workloadAssignmentModel.classRoutine = element["routine"];

        if(departmentModel.departmentId == model.departmentId && workloadAssignmentModel.workloadStatus == "Active") {
            workloadList.add(workloadAssignmentModel);
        }
      });

      responseModel = ResponseModel(true, parsedResponse["message"]);
      progress = false;
    } else {
      String errorMessage = parsedResponse["message"];
      responseModel = ResponseModel(false, errorMessage);
      progress = false;
    }
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> deleteWorkload(WorkloadAssignmentModel model, String token)async{
    dialogProgress = true;
    notifyListeners();
    ResponseModel responseModel;

    ApiResponse apiResponse = await appRepo.deleteWorkload(model, token);

    var parsedResponse = json.decode(apiResponse.response!.body);
    Constants.printMessage(Constants.WORKLOAD_DELETE, parsedResponse.toString());

    if (apiResponse.response != null && parsedResponse["success"]) {
      workloadList.removeWhere((element) => element.workloadId == model.workloadId);
      responseModel = ResponseModel(true, parsedResponse["message"]);
      dialogProgress = false;
    } else {
      String errorMessage = parsedResponse["message"];
      responseModel = ResponseModel(false, errorMessage);
      dialogProgress = false;
    }
    notifyListeners();
    return responseModel;
  }
//----------------------------------------------------------------------------//

  /// DateSheet Provider
  Future<ResponseModel> addDateSheet(DatesheetModel model, String token)async{
    progress = true;
    notifyListeners();
    ResponseModel responseModel;

    ApiResponse apiResponse = await appRepo.addDateSheet(model, token);

    var parsedResponse = json.decode(apiResponse.response!.body);
    Constants.printMessage(Constants.DATESHEET_ADD, parsedResponse.toString());

    if (apiResponse.response != null && parsedResponse["success"]) {

      parsedResponse["data"].forEach((element) {
        DatesheetModel datesheetModel =  DatesheetModel.getInstance();
        DepartmentModel departmentModel = DepartmentModel.getInstance();
        ClassModel classModel = ClassModel.getInstance();
        SubjectModel subjectModel = SubjectModel.getInstance();
        RoomsModel roomsModel = RoomsModel.getInstance();

        datesheetModel.sheetId = element["id"];
        datesheetModel.sheetStatus = element["status"];
        datesheetModel.sheetDate = element["date"];
        datesheetModel.sheetStartTime = element["start_time"];
        datesheetModel.sheetEndTime = element["end_time"];
        departmentModel = DepartmentModel.fromJson(element["department"]);
        classModel = ClassModel.fromJson(element["department_class"]);
        subjectModel = SubjectModel.fromJson(element["subject"]);
        roomsModel = RoomsModel.fromJson(element["room"]);

        datesheetModel.departmentModel = departmentModel;
        datesheetModel.subjectModel = subjectModel;
        datesheetModel.classModel = classModel;
        datesheetModel.roomsModel = roomsModel;
      });

      responseModel = ResponseModel(true, parsedResponse["message"]);
      progress = false;
    } else {
      String errorMessage = parsedResponse["message"];
      responseModel = ResponseModel(false, errorMessage);
      progress = false;
    }
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> fetchAllDateSheets(int departmentId, String token)async{
    datesheetProgress = true;
    notifyListeners();
    dateSheetList.clear();
    ResponseModel responseModel;

    ApiResponse apiResponse = await appRepo.fetchAllDateSheets(departmentId, token);

    var parsedResponse = json.decode(apiResponse.response!.body);
    Constants.printMessage(Constants.DATESHEET_FETCH, parsedResponse.toString());

    if (apiResponse.response != null && parsedResponse["success"]) {

      parsedResponse["data"].forEach((element) {
        DatesheetModel datesheetModel =  DatesheetModel.getInstance();
        DepartmentModel departmentModel = DepartmentModel.getInstance();
        ClassModel classModel = ClassModel.getInstance();
        SubjectModel subjectModel = SubjectModel.getInstance();
        RoomsModel roomsModel = RoomsModel.getInstance();

        datesheetModel.sheetId = element["id"];
        datesheetModel.sheetStatus = element["status"];
        datesheetModel.sheetDate = element["date"];
        datesheetModel.sheetStartTime = element["start_time"];
        datesheetModel.sheetEndTime = element["end_time"];
        departmentModel = DepartmentModel.fromJson(element["department"]);
        classModel = ClassModel.fromJson(element["department_class"]);
        subjectModel = SubjectModel.fromJson(element["subject"]);
        roomsModel = RoomsModel.fromJson(element["room"]);

        datesheetModel.departmentModel = departmentModel;
        datesheetModel.subjectModel = subjectModel;
        datesheetModel.classModel = classModel;
        datesheetModel.roomsModel = roomsModel;

        if(departmentModel.departmentId == departmentId) {
          dateSheetList.add(datesheetModel);
        }
      });

      responseModel = ResponseModel(true, parsedResponse["message"]);
      datesheetProgress = false;
    } else {
      String errorMessage = parsedResponse["message"];
      responseModel = ResponseModel(false, errorMessage);
      datesheetProgress = false;
    }
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> fetchAllDateSheetsTeachers(String departmentId, String token)async{
    datesheetProgress = true;
    notifyListeners();
    dateSheetList.clear();
    ResponseModel responseModel;

    ApiResponse apiResponse = await appRepo.fetchAllDateSheetsTeachers(departmentId, token);

    var parsedResponse = json.decode(apiResponse.response!.body);
    Constants.printMessage(Constants.DATESHEET_FETCH, parsedResponse.toString());

    if (apiResponse.response != null && parsedResponse["success"]) {

      parsedResponse["data"].forEach((element) {
        DatesheetModel datesheetModel =  DatesheetModel.getInstance();
        DepartmentModel departmentModel = DepartmentModel.getInstance();
        ClassModel classModel = ClassModel.getInstance();
        SubjectModel subjectModel = SubjectModel.getInstance();
        RoomsModel roomsModel = RoomsModel.getInstance();

        datesheetModel.sheetId = element["id"];
        datesheetModel.sheetStatus = element["status"];
        datesheetModel.sheetDate = element["date"];
        datesheetModel.sheetStartTime = element["start_time"];
        datesheetModel.sheetEndTime = element["end_time"];
        departmentModel = DepartmentModel.fromJson(element["department"]);
        classModel = ClassModel.fromJson(element["department_class"]);
        subjectModel = SubjectModel.fromJson(element["subject"]);
        roomsModel = RoomsModel.fromJson(element["room"]);

        datesheetModel.departmentModel = departmentModel;
        datesheetModel.subjectModel = subjectModel;
        datesheetModel.classModel = classModel;
        datesheetModel.roomsModel = roomsModel;

        if(departmentModel.departmentId == int.parse(departmentId)) {
          dateSheetList.add(datesheetModel);
        }
      });

      responseModel = ResponseModel(true, parsedResponse["message"]);
      datesheetProgress = false;
    } else {
      String errorMessage = parsedResponse["message"];
      responseModel = ResponseModel(false, errorMessage);
      datesheetProgress = false;
    }
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> deleteDateSheet(DatesheetModel model, String token)async{
    dialogProgress = true;
    notifyListeners();
    ResponseModel responseModel;

    ApiResponse apiResponse = await appRepo.deleteDateSheet(model, token);

    var parsedResponse = json.decode(apiResponse.response!.body);
    Constants.printMessage(Constants.DATESHEET_DELETE, parsedResponse.toString());

    if (apiResponse.response != null && parsedResponse["success"]) {
      dateSheetList.removeWhere((element) => element.sheetId == model.sheetId);
      responseModel = ResponseModel(true, parsedResponse["message"]);
      dialogProgress = false;
    } else {
      String errorMessage = parsedResponse["message"];
      responseModel = ResponseModel(false, errorMessage);
      dialogProgress = false;
    }
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> addDateSheetPdf(DateSheetUploadModel model, String token)async{
    uploadProgress = true;
    notifyListeners();
    ResponseModel responseModel;

    ApiResponse apiResponse = await appRepo.addDateSheetPdf(model, token);

    var parsedResponse = json.decode(apiResponse.response!.body);
    Constants.printMessage(Constants.DATESHEET_ADD, parsedResponse.toString());

    if (apiResponse.response != null && parsedResponse["success"]) {

      parsedResponse["data"].forEach((element) {
        if(element["status"] == "Active"){
          dateSheetUploadModel = DateSheetUploadModel.getInstance();
          DepartmentModel departmentModel = DepartmentModel.getInstance();
          departmentModel = DepartmentModel.fromJson(element["department"]);

          dateSheetUploadModel.dateSheetId = element["id"];
          dateSheetUploadModel.dateSheetFile = element["file"];
          dateSheetUploadModel.dateSheetStatus = element["status"];
          dateSheetUploadModel.dateSheetDate = element["date"];
          dateSheetUploadModel.departmentModel = departmentModel;
        }
      });

      responseModel = ResponseModel(true, parsedResponse["message"]);
      uploadProgress = false;
    } else {
      String errorMessage = parsedResponse["message"];
      responseModel = ResponseModel(false, errorMessage);
      uploadProgress = false;
    }
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> fetchDateSheetPdf(String departmentId, String token)async{
    progress = true;
    notifyListeners();
    ResponseModel responseModel;

    ApiResponse apiResponse = await appRepo.fetchDateSheetPdf(departmentId, token);

    var parsedResponse = json.decode(apiResponse.response!.body);
    Constants.printMessage(Constants.DATESHEET_DELETE, parsedResponse.toString());

    if (apiResponse.response != null && parsedResponse["success"]) {

      parsedResponse["data"].forEach((element) {
        dateSheetUploadModel = DateSheetUploadModel.getInstance();
        DepartmentModel departmentModel = DepartmentModel.getInstance();
        departmentModel = DepartmentModel.fromJson(element["department"]);

        dateSheetUploadModel.dateSheetId = element["id"];
        dateSheetUploadModel.dateSheetFile = element["file"];
        dateSheetUploadModel.dateSheetStatus = element["status"];
        dateSheetUploadModel.dateSheetDate = element["date"];
        dateSheetUploadModel.departmentModel = departmentModel;
      });

      responseModel = ResponseModel(true, parsedResponse["message"]);
      progress = false;
    } else {
      String errorMessage = parsedResponse["message"];
      responseModel = ResponseModel(false, errorMessage);
      progress = false;
    }
    notifyListeners();
    return responseModel;
  }
//----------------------------------------------------------------------------//

  /// Attendance Provider
  Future<ResponseModel> addAttendance(AttendanceDetailModel model, String token)async{
    progress = true;
    notifyListeners();
    ResponseModel responseModel;

    ApiResponse apiResponse = await appRepo.addAttendance(model, token);

    var parsedResponse = json.decode(apiResponse.response!.body);
    Constants.printMessage(Constants.ATTENDANCE_ADD, parsedResponse.toString());

    if (apiResponse.response != null && parsedResponse["success"]) {
      responseModel = ResponseModel(true, parsedResponse["message"]);
      progress = false;
    } else {
      String errorMessage = parsedResponse["message"];
      responseModel = ResponseModel(false, errorMessage);
      progress = false;
    }
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> fetchAttendance(int workloadId, String token)async{
    progress = true;
    notifyListeners();
    attendanceList.clear();
    ResponseModel responseModel;

    ApiResponse apiResponse = await appRepo.fetchAttendance(workloadId, token);

    var parsedResponse = json.decode(apiResponse.response!.body);
    Constants.printMessage(Constants.ATTENDANCE_FETCH, parsedResponse.toString());

    if (apiResponse.response != null && parsedResponse["success"]) {

      parsedResponse["data"].forEach((element) {
        AttendanceCompleteModel attendanceCompleteModel =  AttendanceCompleteModel.getInstance();
        attendanceCompleteModel.attendanceId = element["id"];
        attendanceCompleteModel.workloadId = int.parse(element["workloads_id"]);
        attendanceCompleteModel.attendanceDate = element["date"];
        attendanceCompleteModel.attendanceTime = element["time"];
        attendanceCompleteModel.attendanceStatus = element["status"];

        List<UserModel> presentList = [];
        element["present"].forEach((present) {
          UserModel userModel = UserModel.getInstance();
          userModel.userId = present["id"];
          userModel.userName = present["name"].toString();
          userModel.userEmail = present["email"].toString();
          userModel.userPhone = present["phone"].toString();
          userModel.userGender = present["gender"].toString();
          userModel.userImage = present["image"].toString();
          userModel.userType = present["type"].toString();
          userModel.userStatus = present["status"].toString();
          userModel.userCnic = present["cnic_no"].toString();
          userModel.userAddress = present["address"].toString();
          userModel.userDepartment = present["student"]["department_id"].toString();
          userModel.userClass = present["student"]["class_id"].toString();
          userModel.userSession = present["student"]["session"].toString();
          userModel.userRollNo = present["student"]["roll_no"].toString();
          presentList.add(userModel);
        });

        List<UserModel> absentList = [];
        element["absent"].forEach((absent) {
          UserModel userModel = UserModel.getInstance();
          userModel.userId = absent["id"];
          userModel.userName = absent["name"].toString();
          userModel.userEmail = absent["email"].toString();
          userModel.userPhone = absent["phone"].toString();
          userModel.userGender = absent["gender"].toString();
          userModel.userImage = absent["image"].toString();
          userModel.userType = absent["type"].toString();
          userModel.userStatus = absent["status"].toString();
          userModel.userCnic = absent["cnic_no"].toString();
          userModel.userAddress = absent["address"].toString();
          userModel.userDepartment = absent["student"]["department_id"].toString();
          userModel.userClass = absent["student"]["class_id"].toString();
          userModel.userSession = absent["student"]["session"].toString();
          userModel.userRollNo = absent["student"]["roll_no"].toString();
          absentList.add(userModel);
        });

        WorkloadAssignmentModel workloadAssignmentModel = WorkloadAssignmentModel.getInstance();
        UserModel userModel = UserModel.getInstance();
        DepartmentModel departmentModel = DepartmentModel.getInstance();
        ClassModel classModel = ClassModel.getInstance();
        SubjectModel subjectModel = SubjectModel.getInstance();
        RoomsModel roomsModel = RoomsModel.getInstance();

        userModel.userId = element["workloads"]["user"]["id"];
        userModel.userName = element["workloads"]["user"]["name"].toString();
        userModel.userEmail = element["workloads"]["user"]["email"].toString();
        userModel.userPhone = element["workloads"]["user"]["phone"].toString();
        userModel.userGender = element["workloads"]["user"]["gender"].toString();
        userModel.userImage = element["workloads"]["user"]["image"].toString();
        userModel.userType = element["workloads"]["user"]["type"].toString();
        userModel.userStatus = element["workloads"]["user"]["status"].toString();
        userModel.userDepartment = element["workloads"]["user"]["staff"]["department_id"].toString();
        userModel.userQualification = element["workloads"]["user"]["staff"]["qualification"].toString();
        userModel.userDesignation = element["workloads"]["user"]["staff"]["designation"].toString();
        userModel.totalAllowedCreditHours = int.parse(element["workloads"]["user"]["staff"]["total_allowed_credit_hours"].toString());
        departmentModel = DepartmentModel.fromJson(element["workloads"]["department"]);
        classModel = ClassModel.fromJson(element["workloads"]["department_class"]);
        subjectModel = SubjectModel.fromJson(element["workloads"]["subject"]);

        workloadAssignmentModel.userModel = userModel;
        workloadAssignmentModel.departmentModel = departmentModel;
        workloadAssignmentModel.subjectModel = subjectModel;
        workloadAssignmentModel.classModel = classModel;
        workloadAssignmentModel.roomsModel = roomsModel;

        workloadAssignmentModel.workloadId = element["workloads"]["id"];
        workloadAssignmentModel.workloadStatus = element["workloads"]["status"];
        workloadAssignmentModel.workDemanded = element["workloads"]["work_demanded"];
        workloadAssignmentModel.classRoutine = element["workloads"]["routine"];

        attendanceCompleteModel.workloadAssignmentModel = workloadAssignmentModel;
        attendanceCompleteModel.presentStudents = presentList;
        attendanceCompleteModel.absentStudents = absentList;

        if(workloadAssignmentModel.workloadStatus == "Active") {
          attendanceList.add(attendanceCompleteModel);
        }
      });


      responseModel = ResponseModel(true, parsedResponse["message"]);
      progress = false;
    } else {
      String errorMessage = parsedResponse["message"];
      responseModel = ResponseModel(false, errorMessage);
      progress = false;
    }
    notifyListeners();
    return responseModel;
  }
//----------------------------------------------------------------------------//

  /// TimeTable Provider
  Future<ResponseModel> addSingleTimeTable(TimeTableUploadModel model, String token)async{
    progress = true;
    notifyListeners();
    ResponseModel responseModel;

    ApiResponse apiResponse = await appRepo.addSingleTimeTable(model, token);

    var parsedResponse = json.decode(apiResponse.response!.body);
    Constants.printMessage(Constants.SINGLE_TIMETABLE_ADD, parsedResponse.toString());

    if (apiResponse.response != null && parsedResponse["success"]) {
      responseModel = ResponseModel(true, parsedResponse["message"]);
      progress = false;
    } else {
      String errorMessage = parsedResponse["data"];
      responseModel = ResponseModel(false, errorMessage);
      progress = false;
    }
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> addBulkTimeTable(String data, String token)async{
    progress = true;
    notifyListeners();
    ResponseModel responseModel;

    ApiResponse apiResponse = await appRepo.addBulkTimeTable(data, token);

    var parsedResponse = json.decode(apiResponse.response!.body);
    Constants.printMessage(Constants.BULK_TIMETABLE_ADD, parsedResponse.toString());

    if (apiResponse.response != null && parsedResponse["success"]) {
      responseModel = ResponseModel(true, parsedResponse["message"]);
      progress = false;
    } else {
      String errorMessage = parsedResponse["message"];
      responseModel = ResponseModel(false, errorMessage);
      progress = false;
    }
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> fetchSingleTimeTable(int userId, String token)async{
    progress = true;
    teacherTimeTableList.clear();
    notifyListeners();
    ResponseModel responseModel;

    ApiResponse apiResponse = await appRepo.fetchSingleTimeTable(userId, token);

    var parsedResponse = json.decode(apiResponse.response!.body);
    Constants.printMessage(Constants.SINGLE_TIMETABLE_ADD, parsedResponse.toString());

    if (apiResponse.response != null && parsedResponse["success"]) {

      parsedResponse["data"].forEach((element) {
        UserModel userModel = UserModel.getInstance();
        userModel.userId = element["id"];
        userModel.userName = element["name"].toString();
        userModel.userEmail = element["email"].toString();
        userModel.userPhone = element["phone"].toString();
        userModel.userGender = element["gender"].toString();
        userModel.userImage = element["image"].toString();
        userModel.userType = element["type"].toString();
        userModel.userStatus = element["status"].toString();
        userModel.userAddress = element["address"].toString();
        userModel.userCnic = element["cnic_no"].toString();
        if(element["staff"] != "null"){
          userModel.userExaminationPassedMPhil = "M.Phill";
          userModel.mPhilPassedExamSubject = element["user"]["staff"]["mPhilPassedExamSubject"].toString();
          userModel.mPhilPassedExamYear = element["user"]["staff"]["mPhilPassedExamYear"].toString();
          userModel.mPhilPassedExamDivision = element["user"]["staff"]["mPhilPassedExamDivision"].toString();
          userModel.mPhilPassedExamInstitute = element["user"]["staff"]["mPhilPassedExamInstitute"].toString();
          userModel.userExaminationPassedPhd = element["user"]["staff"]["userExaminationPassedPhd"].toString();
          userModel.phdPassedExamSubject = element["user"]["staff"]["phdPassedExamSubject"].toString();
          userModel.phdPassedExamYear = element["user"]["staff"]["phdPassedExamYear"].toString();
          userModel.phdPassedExamDivision = element["user"]["staff"]["phdPassedExamDivision"].toString();
          userModel.phdPassedExamInstitute = element["user"]["staff"]["phdPassedExamInstitute"].toString();
          userModel.userSpecializedField = element["user"]["staff"]["userSpecializedField"].toString();
          userModel.userGraduationLevelExperience = element["user"]["staff"]["userGraduationLevelExperience"].toString();
          userModel.userPostGraduationLevelExperience = element["user"]["staff"]["userPostGraduationLevelExperience"].toString();
          userModel.userSignature = element["user"]["staff"]["Signature"].toString();
          userModel.userDepartment = element["user"]["staff"]["department_id"].toString();
          userModel.userQualification = element["user"]["staff"]["qualification"].toString();
          userModel.userDesignation = element["user"]["staff"]["designation"].toString();
          userModel.totalAllowedCreditHours = int.parse(element["user"]["staff"]["total_allowed_credit_hours"].toString());
          userModel.userDesignation = element["user"]["staff"]["designation"].toString();
        }

        WorkloadAssignmentModel workloadAssignmentModel = WorkloadAssignmentModel.getInstance();
        workloadAssignmentModel.workloadId = element["workloads"]["id"];
        workloadAssignmentModel.workDemanded = element["workloads"]["work_demanded"];
        workloadAssignmentModel.workloadStatus = element["workloads"]["status"];
        workloadAssignmentModel.classRoutine = element["workloads"]["routine"];

        ClassModel classModel = ClassModel.getInstance();
        classModel.classId = element["workloads"]["department_class"]["id"];
        classModel.className = element["workloads"]["department_class"]["name"];
        classModel.classSemester = element["workloads"]["department_class"]["semester"];
        classModel.classType = element["workloads"]["department_class"]["type"];

        DepartmentModel departmentModel = DepartmentModel.getInstance();
        departmentModel.departmentId = element["workloads"]["department"]["id"];
        departmentModel.departmentName = element["workloads"]["department"]["name"];
        departmentModel.departmentType = element["workloads"]["department"]["type"];

        SubjectModel subjectModel = SubjectModel.getInstance();
        subjectModel.subjectId = element["workloads"]["subject"]["id"];
        subjectModel.subjectName = element["workloads"]["subject"]["name"];
        subjectModel.subjectCode = element["workloads"]["subject"]["code"];
        subjectModel.creditHours = int.parse(element["workloads"]["subject"]["credit_hour"]);

        workloadAssignmentModel.classModel = classModel;
        workloadAssignmentModel.departmentModel = departmentModel;
        workloadAssignmentModel.subjectModel = subjectModel;

        RoomsModel roomsModel = RoomsModel.getInstance();
        roomsModel.roomId = element["room"]["id"];
        roomsModel.roomName = element["room"]["name"];

        TimeSlotsModel timeSlotsModel = TimeSlotsModel.getInstance();
        timeSlotsModel.timeslotId = element["timeslot"]["id"];
        timeSlotsModel.timeslot = element["timeslot"]["time_slot"];

        TeacherOwnTimeTableModel timeTableModel = TeacherOwnTimeTableModel.getInstance();
        timeTableModel.timeTableId = element["id"];
        timeTableModel.workloadId = int.parse(element["workload_id"]);
        timeTableModel.roomId = int.parse(element["room_id"]);
        timeTableModel.timeSlotId = int.parse(element["time_slot_id"]);
        timeTableModel.userId = int.parse(element["user_id"]);
        timeTableModel.date = element["date"];
        timeTableModel.day = element["day"];
        timeTableModel.status = element["status"];
        timeTableModel.roomsModel = roomsModel;
        timeTableModel.userModel = userModel;
        timeTableModel.timeSlotsModel = timeSlotsModel;
        timeTableModel.workloadAssignmentModel = workloadAssignmentModel;

        if(timeTableModel.status == "Active") {
          teacherTimeTableList.add(timeTableModel);
        }
      });

      responseModel = ResponseModel(true, parsedResponse["message"]);
      progress = false;
    } else {
      String errorMessage = parsedResponse["data"];
      responseModel = ResponseModel(false, errorMessage);
      progress = false;
    }
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> checkUploadingData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ResponseModel responseModel;

    if(prefs.getString("time_table_bulk_data").toString().isEmpty){
      responseModel = ResponseModel(false, "");
    }else {
      responseModel = ResponseModel(true, "");
    }

    notifyListeners();
    return responseModel;
  }
//----------------------------------------------------------------------------//

  dialogProgressReset(){
    dialogProgress = false;
    notifyListeners();
  }
  progressReset(){
    progress = false;
    notifyListeners();
  }
}