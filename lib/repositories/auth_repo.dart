import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:university_management_system/models/class_model.dart';
import 'package:university_management_system/models/dpt_model.dart';

import '../models/user_model.dart';
import '../utilities/base/api_response.dart';
import '../utilities/ip_configurations.dart';

class AuthRepo{

  /// User Login
  Future<ApiResponse> userLogin(String userEmail, String userPassword)async{
    ApiResponse apiResponse;
    var response = await http.post(Uri.parse(IPConfigurations.loginApi),
       /* headers: {
          'Authorization': 'Bearer $token',
        },*/
        body: {
          "email" : userEmail,
          "password" : userPassword,
        });
    if(response.body.isNotEmpty){
      apiResponse = ApiResponse(response,null,null);
      return apiResponse;
    }else{
      apiResponse = ApiResponse.withError("Error");
      return apiResponse;
    }
  }

  /// User Logout
  Future<ApiResponse> userLogout(String token)async{
    ApiResponse apiResponse;
    var response = await http.post(Uri.parse(IPConfigurations.logoutApi),
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

  /// Teacher Register
  Future<ApiResponse> teacherRegistration(UserModel registrationModel, var signatureBytes) async{
    ApiResponse apiResponse;

    var request = http.MultipartRequest("POST", Uri.parse(IPConfigurations.registrationApi));

    request.fields['name'] = registrationModel.userName;
    request.fields['email'] = registrationModel.userEmail;
    request.fields['password'] = registrationModel.userPassword;
    request.fields['type'] = registrationModel.userType;
    request.fields['phone'] = registrationModel.userPhone;
    request.fields['gender'] = registrationModel.userGender == "Male" ? "male" : registrationModel.userGender == "Female" ? "female" : "others";
    request.fields['fcm_token'] = "";
    request.fields['status'] = registrationModel.userStatus;
    request.fields['department_id'] = registrationModel.userDepartment;
    request.fields['qualification'] = registrationModel.userQualification;
    request.fields['designation'] = registrationModel.userDesignation;
    request.fields['total_allowed_credit_hours'] = registrationModel.totalAllowedCreditHours.toString();
    request.fields['address'] = registrationModel.userAddress;
    request.fields['cnic_no'] = registrationModel.userCnic;
    request.fields['userExaminationPassedMPhil'] = registrationModel.userExaminationPassedMPhil;
    request.fields['mPhilPassedExamSubject'] = registrationModel.mPhilPassedExamSubject;
    request.fields['mPhilPassedExamYear'] = registrationModel.mPhilPassedExamYear;
    request.fields['mPhilPassedExamDivision'] = registrationModel.mPhilPassedExamDivision;
    request.fields['mPhilPassedExamInstitute'] = registrationModel.mPhilPassedExamInstitute;
    request.fields['userExaminationPassedPhd'] = registrationModel.userExaminationPassedPhd;
    request.fields['phdPassedExamSubject'] = registrationModel.phdPassedExamSubject;
    request.fields['phdPassedExamYear'] = registrationModel.phdPassedExamYear;
    request.fields['phdPassedExamDivision'] = registrationModel.phdPassedExamDivision;
    request.fields['phdPassedExamInstitute'] = registrationModel.phdPassedExamInstitute;
    request.fields['userSpecializedField'] = registrationModel.userSpecializedField;
    request.fields['userGraduationLevelExperience'] = registrationModel.userGraduationLevelExperience;
    request.fields['userPostGraduationLevelExperience'] = registrationModel.userPostGraduationLevelExperience;

   //request.files.add(await http.MultipartFile.fromPath("Signature", registrationModel.image,));
    request.files.add(await http.MultipartFile.fromBytes('Signature', signatureBytes, filename: 'myImage.png'));
   var response = await request.send();
    if(response!=null){
      apiResponse = ApiResponse(await http.Response.fromStream(response), response ,null);
      return apiResponse;
    }else{
      apiResponse = ApiResponse.withError("Error");
      return apiResponse;
    }

  }
}