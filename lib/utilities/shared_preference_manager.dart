import 'package:shared_preferences/shared_preferences.dart';
import 'package:university_management_system/models/user_model.dart';

class SharedPreferenceManager {
  String _id ="id";
  String _name="name";
  String _email="email";
  String _phone="phone";
  String _gender="gender";
  String _image="image";
  String _type="type";
  String _status="status";
  String _fcmToken = "fcmToken";
  String _authToken="token";
  String _isLoggedIn="isLoggedIn";
  String _session="session";
  String _rollno="rollno";
  String _department="department";
  String _class="class";
  String _qualification="qualification";
  String _designation="designation";
  String _totalAllowedCreditHours="totalAllowedCreditHours";

  String _userAddress="userAddress";
  String _userExaminationPassedMPhil="userExaminationPassedMPhil";
  String _mPhilPassedExamSubject="mPhilPassedExamSubject";
  String _mPhilPassedExamYear="mPhilPassedExamYear";
  String _mPhilPassedExamDivision="mPhilPassedExamDivision";
  String _mPhilPassedExamInstitute="mPhilPassedExamInstitute";
  String _userExaminationPassedPhd="userExaminationPassedPhd";
  String _phdPassedExamSubject="phdPassedExamSubject";
  String _phdPassedExamYear="phdPassedExamYear";
  String _phdPassedExamDivision="phdPassedExamDivision";
  String _phdPassedExamInstitute="phdPassedExamInstitute";
  String _userSpecializedField="userSpecializedField";
  String _userGraduationLevelExperience="userGraduationLevelExperience";
  String _userPostGraduationLevelExperience="userPostGraduationLevelExperience";
  String _userSignature="userSignature";
  String _userCnic="userCnic";

  late SharedPreferenceManager instance;

  SharedPreferenceManager.getInstance();

  setUser(UserModel user, String authToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(_isLoggedIn, true);
    prefs.setInt(_id, user.userId);
    prefs.setString(_name, user.userName);
    prefs.setString(_email, user.userEmail);
    prefs.setString(_phone, user.userPhone);
    prefs.setString(_gender, user.userGender);
    prefs.setString(_image, user.userImage);
    prefs.setString(_type, user.userType);
    prefs.setString(_status, user.userStatus);
    prefs.setString(_fcmToken, "");
    prefs.setString(_authToken, authToken);
    prefs.setString(_session, user.userSession);
    prefs.setString(_rollno, user.userRollNo);
    prefs.setString(_department, user.userDepartment);
    prefs.setString(_class, user.userClass);
    prefs.setString(_qualification, user.userQualification);
    prefs.setString(_designation, user.userDesignation);
    prefs.setInt(_totalAllowedCreditHours, user.totalAllowedCreditHours);
    prefs.setString(_userAddress, user.userAddress);
    prefs.setString(_userExaminationPassedMPhil, user.userExaminationPassedMPhil);
    prefs.setString(_mPhilPassedExamSubject, user.mPhilPassedExamSubject);
    prefs.setString(_mPhilPassedExamYear, user.mPhilPassedExamYear);
    prefs.setString(_mPhilPassedExamDivision, user.mPhilPassedExamDivision);
    prefs.setString(_mPhilPassedExamInstitute, user.mPhilPassedExamInstitute);
    prefs.setString(_userExaminationPassedPhd, user.userExaminationPassedPhd);
    prefs.setString(_phdPassedExamSubject, user.phdPassedExamSubject);
    prefs.setString(_phdPassedExamYear, user.phdPassedExamYear);
    prefs.setString(_phdPassedExamDivision, user.phdPassedExamDivision);
    prefs.setString(_phdPassedExamInstitute, user.phdPassedExamInstitute);
    prefs.setString(_userSpecializedField, user.userSpecializedField);
    prefs.setString(_userGraduationLevelExperience, user.userGraduationLevelExperience);
    prefs.setString(_userPostGraduationLevelExperience, user.userPostGraduationLevelExperience);
    prefs.setString(_userSignature, user.userSignature);
    prefs.setString(_userCnic, user.userCnic);
  }

  updateUser(UserModel user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(_isLoggedIn, true);
    prefs.setInt(_id, user.userId);
    prefs.setString(_name, user.userName);
    prefs.setString(_email, user.userEmail);
    prefs.setString(_phone, user.userPhone);
    prefs.setString(_gender, user.userGender);
    prefs.setString(_image, user.userImage);
    prefs.setString(_type, user.userType);
    prefs.setString(_status, user.userStatus);
    prefs.setString(_fcmToken, "");
    prefs.setString(_session, user.userSession);
    prefs.setString(_rollno, user.userRollNo);
    prefs.setString(_department, user.userDepartment);
    prefs.setString(_class, user.userClass);
    prefs.setString(_qualification, user.userQualification);
    prefs.setString(_designation, user.userDesignation);
    prefs.setInt(_totalAllowedCreditHours, user.totalAllowedCreditHours);
    prefs.setString(_userAddress, user.userAddress);
    prefs.setString(_userExaminationPassedMPhil, user.userExaminationPassedMPhil);
    prefs.setString(_mPhilPassedExamSubject, user.mPhilPassedExamSubject);
    prefs.setString(_mPhilPassedExamYear, user.mPhilPassedExamYear);
    prefs.setString(_mPhilPassedExamDivision, user.mPhilPassedExamDivision);
    prefs.setString(_mPhilPassedExamInstitute, user.mPhilPassedExamInstitute);
    prefs.setString(_userExaminationPassedPhd, user.userExaminationPassedPhd);
    prefs.setString(_phdPassedExamSubject, user.phdPassedExamSubject);
    prefs.setString(_phdPassedExamYear, user.phdPassedExamYear);
    prefs.setString(_phdPassedExamDivision, user.phdPassedExamDivision);
    prefs.setString(_phdPassedExamInstitute, user.phdPassedExamInstitute);
    prefs.setString(_userSpecializedField, user.userSpecializedField);
    prefs.setString(_userGraduationLevelExperience, user.userGraduationLevelExperience);
    prefs.setString(_userPostGraduationLevelExperience, user.userPostGraduationLevelExperience);
    prefs.setString(_userSignature, user.userSignature);
    prefs.setString(_userCnic, user.userCnic);
  }

  Future<UserModel> getUser() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    UserModel _user = UserModel(
        userId: int.parse(_prefs.getInt(_id).toString()),
        userName: _prefs.getString(_name).toString(),
        userEmail: _prefs.getString(_email).toString(),
        userPassword: "",
        userPhone: _prefs.getString(_phone).toString(),
        userSession: _prefs.getString(_session).toString(),
        userRollNo: _prefs.getString(_rollno).toString(),
        userGender: _prefs.getString(_gender).toString(),
        userDepartment: _prefs.getString(_department).toString(),
        userClass: _prefs.getString(_class).toString(),
        userQualification: _prefs.getString(_qualification).toString(),
        userDesignation: _prefs.getString(_designation).toString(),
        userImage: _prefs.getString(_image).toString(),
        userType: _prefs.getString(_type).toString(),
        userStatus: _prefs.getString(_status).toString(),
        totalAllowedCreditHours: int.parse(_prefs.getInt(_totalAllowedCreditHours).toString()),
      userAddress: _prefs.getString(_userAddress).toString(),
      userExaminationPassedMPhil: _prefs.getString(_userExaminationPassedMPhil).toString(),
      mPhilPassedExamSubject: _prefs.getString(_mPhilPassedExamSubject).toString(),
      mPhilPassedExamYear: _prefs.getString(_mPhilPassedExamYear).toString(),
      mPhilPassedExamDivision: _prefs.getString(_mPhilPassedExamDivision).toString(),
      mPhilPassedExamInstitute: _prefs.getString(_mPhilPassedExamInstitute).toString(),
      userExaminationPassedPhd: _prefs.getString(_userExaminationPassedPhd).toString(),
      phdPassedExamSubject: _prefs.getString(_phdPassedExamSubject).toString(),
      phdPassedExamYear: _prefs.getString(_phdPassedExamYear).toString(),
      phdPassedExamDivision: _prefs.getString(_phdPassedExamDivision).toString(),
      phdPassedExamInstitute: _prefs.getString(_phdPassedExamInstitute).toString(),
      userSpecializedField: _prefs.getString(_userSpecializedField).toString(),
      userGraduationLevelExperience: _prefs.getString(_userGraduationLevelExperience).toString(),
      userPostGraduationLevelExperience: _prefs.getString(_userPostGraduationLevelExperience).toString(),
      userSignature: _prefs.getString(_userSignature).toString(),
      userCnic: _prefs.getString(_userCnic).toString(),
    );

    return _user;
  }

  logout() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.clear();
  }

  /*String _userOTP = "otp";

  setOTP(String value) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.setString(_userOTP, value);
  }

  removeOTP(String value) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.remove(_userOTP);
  }

  getOTP() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    return await _prefs.getString(_userOTP)??"";

  }*/

}