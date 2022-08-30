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

  /// User Login
  /*Future<ResponseModel> userLogin(String userEmail, String userPassword)async{
    progress = true;
    notifyListeners();
    ResponseModel responseModel;
    userModel = UserModel.getInstance();

    ApiResponse apiResponse = await authRepo.userLogin(userEmail, userPassword);
    var parsedResponse = json.decode(apiResponse.response!.body);
    Constants.printMessage(Constants.USER_LOGIN, parsedResponse.toString());

    if (apiResponse.response != null && parsedResponse["success"] == true) {
      String authToken = parsedResponse["data"]["token"];

      if(parsedResponse["data"]["user_details"].toString() == "null" && parsedResponse["data"]["user"]["type"] == "admin"){
        userModel = UserModel(
            userId: parsedResponse["data"]["user"]["id"],
            userName: parsedResponse["data"]["user"]["name"],
            userEmail: parsedResponse["data"]["user"]["email"],
            userPassword: "",
            userPhone: parsedResponse["data"]["user"]["phone"].toString() == "null" ? "" : parsedResponse["data"]["user"]["phone"],
            userSession: "",
            userRollNo: "",
            userGender: parsedResponse["data"]["user"]["gender"],
            userDepartment: "",
            userClass: "",
            userQualification: "",
            userDesignation: "",
            userImage: parsedResponse["data"]["user"]["image"].toString() == "null" ? "" : parsedResponse["data"]["user"]["image"],
            userType: parsedResponse["data"]["user"]["type"],
            userStatus: parsedResponse["data"]["user"]["status"].toString() == "null" ? "" : parsedResponse["data"]["user"]["status"],
            totalAllowedCreditHours: 0);
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
  }*/

  /// User Login
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
}