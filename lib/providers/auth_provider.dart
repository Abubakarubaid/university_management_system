import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:university_management_system/models/teacher_model.dart';
import 'package:university_management_system/models/user_model.dart';
import 'package:university_management_system/repositories/auth_repo.dart';
import 'package:university_management_system/utilities/constants.dart';
import 'package:university_management_system/utilities/shared_preference_manager.dart';
import '../models/response_model.dart';
import '../utilities/base/api_response.dart';

class AuthProvider with ChangeNotifier{
  AuthRepo authRepo;
  AuthProvider({required this.authRepo});

  bool progress = false;
  UserModel userModel = UserModel.getInstance();
  String authNewToken = "";

  /// User Login
  Future<ResponseModel> userLogin(String userEmail, String userPassword)async{
    progress = true;
    notifyListeners();
    ResponseModel responseModel;
    userModel = UserModel.getInstance();

    ApiResponse apiResponse = await authRepo.userLogin(userEmail, userPassword);
    var parsedResponse = json.decode(apiResponse.response!.body);
    Constants.printMessage(Constants.USER_LOGIN, parsedResponse.toString());

    if (apiResponse.response != null && parsedResponse["success"] == true) {
      String authToken = parsedResponse["data"]["token"];

      if(parsedResponse["data"]["user"]["type"] == "admin"){
        var user = parsedResponse["data"]["user"];
        userModel.userId = user["id"];
        userModel.userName = user["name"].toString();
        userModel.userEmail = user["email"].toString();
        userModel.userPhone = user["phone"].toString();
        userModel.userGender = user["gender"].toString();
        userModel.userImage = user["image"].toString();
        userModel.userType = user["type"].toString();
        userModel.userStatus = user["status"].toString();
        userModel.userAddress = user["address"].toString();
        userModel.userCnic = user["cnic_no"].toString();
        SharedPreferenceManager.getInstance().setUser(userModel, authToken);
      } else{
        var user = parsedResponse["data"]["user"];
        var userDetails = parsedResponse["data"]["user_details"];

        userModel.userId = user["id"];
        userModel.userName = user["name"].toString();
        userModel.userEmail = user["email"].toString();
        userModel.userPhone = user["phone"].toString();
        userModel.userGender = user["gender"].toString();
        userModel.userImage = user["image"].toString();
        userModel.userType = user["type"].toString();
        userModel.userStatus = user["status"].toString();
        userModel.userAddress = user["address"].toString();
        userModel.userCnic = user["cnic_no"].toString();
        userModel.userExaminationPassedMPhil = userDetails["userExaminationPassedMPhil"].toString();
        userModel.mPhilPassedExamSubject = userDetails["mPhilPassedExamSubject"].toString();
        userModel.mPhilPassedExamYear = userDetails["mPhilPassedExamYear"].toString();
        userModel.mPhilPassedExamDivision = userDetails["mPhilPassedExamDivision"].toString();
        userModel.mPhilPassedExamInstitute = userDetails["mPhilPassedExamInstitute"].toString();
        userModel.userExaminationPassedPhd = userDetails["userExaminationPassedPhd"].toString();
        userModel.phdPassedExamSubject = userDetails["phdPassedExamSubject"].toString();
        userModel.phdPassedExamYear = userDetails["phdPassedExamYear"].toString();
        userModel.phdPassedExamDivision = userDetails["phdPassedExamDivision"].toString();
        userModel.phdPassedExamInstitute = userDetails["phdPassedExamInstitute"].toString();
        userModel.userSpecializedField = userDetails["userSpecializedField"].toString();
        userModel.userGraduationLevelExperience = userDetails["userGraduationLevelExperience"].toString();
        userModel.userPostGraduationLevelExperience = userDetails["userPostGraduationLevelExperience"].toString();
        userModel.userSignature = userDetails["Signature"].toString();
        userModel.userDepartment = userDetails["department_id"].toString();
        userModel.userQualification = userDetails["qualification"].toString();
        userModel.userDesignation = userDetails["designation"].toString();
        userModel.totalAllowedCreditHours = int.parse(userDetails["total_allowed_credit_hours"].toString());
        userModel.userDesignation = userDetails["designation"].toString();

        SharedPreferenceManager.getInstance().setUser(userModel, authToken);
      }

      responseModel = ResponseModel(true, parsedResponse["message"]);
      progress = false;
    } else {
      String errorMessage = parsedResponse["data"]["error"];
      responseModel = ResponseModel(false, errorMessage);
      progress = false;
    }
    notifyListeners();
    return responseModel;
  }

  /// User Logout
  Future<ResponseModel> userLogout(String token)async{
    progress = true;
    notifyListeners();
    ResponseModel responseModel;

    ApiResponse apiResponse = await authRepo.userLogout(token);
    var parsedResponse = json.decode(apiResponse.response!.body);
    Constants.printMessage(Constants.USER_LOGOUT, parsedResponse.toString());

    if (apiResponse.response != null && parsedResponse["success"] == true) {

      SharedPreferenceManager.getInstance().logout();
      responseModel = ResponseModel(true, parsedResponse["message"]);
      progress = false;
    } else {
      String errorMessage = parsedResponse["data"]["error"];
      responseModel = ResponseModel(false, errorMessage);
      progress = false;
    }
    notifyListeners();
    return responseModel;
  }

  /// Teacher Register
  Future<ResponseModel> teacherRegistration(UserModel model, var signatureBytes)async{
    progress = true;
    notifyListeners();
    ResponseModel responseModel;

    ApiResponse apiResponse = await authRepo.teacherRegistration(model, signatureBytes);

    var parsedResponse = json.decode(apiResponse.response!.body);
    Constants.printMessage(Constants.TEACHER_ADD, parsedResponse.toString());

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

  /// Request Reset Password
  Future<ResponseModel> requestResetPassword(String email)async{
    progress = true;
    notifyListeners();
    ResponseModel responseModel;

    ApiResponse apiResponse = await authRepo.requestResetPassword(email);
    var parsedResponse = json.decode(apiResponse.response!.body);
    Constants.printMessage(Constants.REQUEST_RESET_PASSWORD, parsedResponse.toString());

    if (apiResponse.response != null && parsedResponse["success"] == true) {
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

  /// Verify Reset Password
  Future<ResponseModel> verifyResetPassword(String email, String code)async{
    progress = true;
    notifyListeners();
    ResponseModel responseModel;

    authNewToken = "";

    ApiResponse apiResponse = await authRepo.verifyResetPassword(email, code);
    var parsedResponse = json.decode(apiResponse.response!.body);
    Constants.printMessage(Constants.VERIFY_RESET_PASSWORD, parsedResponse.toString());

    if (apiResponse.response != null && parsedResponse["success"] == true) {

      authNewToken = parsedResponse["data"]["token"];
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

  /// Request New Password
  Future<ResponseModel> requestNewPassword(String password, String token)async{
    progress = true;
    notifyListeners();
    ResponseModel responseModel;

    ApiResponse apiResponse = await authRepo.requestNewPassword(password, token);
    var parsedResponse = json.decode(apiResponse.response!.body);
    Constants.printMessage(Constants.REQUEST_NEW_PASSWORD, parsedResponse.toString());

    if (apiResponse.response != null && parsedResponse["success"] == true) {
      responseModel = ResponseModel(true, parsedResponse["message"]);
      progress = false;
    } else {
      String errorMessage = parsedResponse["data"]["error"];
      responseModel = ResponseModel(false, errorMessage);
      progress = false;
    }
    notifyListeners();
    return responseModel;
  }
}