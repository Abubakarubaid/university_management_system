import 'dart:ui';
import 'package:flutter/material.dart';

class AppAssets{

  /// Fonts
  static String latoBlack="Lato-Black";
  static String latoBlackItalic="Lato-BlackItalic";
  static String latoBold="Lato-Bold";
  static String latoBoldItalic="Lato-BoldItalic";
  static String latoItalic="Lato-Italic";
  static String latoLight="Lato-Light";
  static String latoLightItalic="Lato-LightItalic";
  static String latoRegular="Lato-Regular";
  static String latoThin="Lato-Thin";
  static String latoThinItalic="Lato-ThinItalic";

  /// Icons
  static const String addButtonIcon="assets/icons/add_button.png";
  static const String dashboardIcon="assets/icons/dashboard_icon.svg";
  static const String profileIcon="assets/icons/profile_icon.svg";
  static const String booksIcon="assets/icons/books_icon.svg";
  static const String attendanceIcon="assets/icons/attendance.png";
  static const String workloadIcon="assets/icons/workload.png";
  static const String workIllustration="assets/icons/work_illustration.svg";
  static const String dateSheetIcon="assets/icons/datesheet_icon.svg";
  static const String departmentIcon="assets/icons/department_icon.svg";
  static const String othersIcon="assets/icons/others_icon.svg";
  static const String reportsIcon="assets/icons/reports_icon.svg";
  static const String studentsIcon="assets/icons/students_icon.svg";
  static const String teachersIcon="assets/icons/teacher_icon.svg";
  static const String addIcon="assets/icons/add_icon.svg";
  static const String editIcon="assets/icons/edit_icon.svg";
  static const String approveIcon="assets/icons/approve_icon.svg";
  static const String rejectIcon="assets/icons/reject_icon.svg";
  static const String roomDoorIcon="assets/icons/room_door.svg";
  static const String noDataIcon="assets/icons/nodata_icon.png";
  static const String foldersIcon="assets/icons/folders.png";
  static const String folderIcon="assets/icons/folder.png";
  static const String loginIcon="assets/icons/login.png";
  static const String resetPasswordIcon="assets/icons/reset_password.png";
  static const String attendanceColoredIcon="assets/icons/attendance_colored.png";
  static const String dateSheetColored="assets/icons/datesheet_illustration.png";
  static const String overloadIcon="assets/icons/overload.png";
  static const String appDoodle="assets/icons/app_doodle.png";
  static const String placeholder="assets/icons/placeholder.png";
  static const String registrationDummy="assets/icons/registration_dummy.png";
  static const String loginIllustration="assets/icons/login_illustration.png";
  static const String maleAvatar="assets/icons/male_avatar.svg";
  static const String timetableIcon="assets/icons/timetable_icon.svg";
  static const String femaleAvatar="assets/icons/female_avatar.svg";
  static const String backArrowIcon="assets/icons/back_arrow.svg";
  static const String progressDots="assets/media/progress_dots.json";
  static const String department_new="assets/icons/department_new.png";
  static const String subject_new="assets/icons/subject_new.png";
  static const String students_new="assets/icons/students_new.png";
  static const String teachers_new="assets/icons/teachers_new.png";
  static const String classes_new="assets/icons/classes_new.png";
  static const String workload_new="assets/icons/workload_new.png";
  static const String room_new="assets/icons/room_new.png";
  static const String timeslot_new="assets/icons/timeslot_new.png";
  static const String datesheet_new="assets/icons/datesheet_new.png";
  static const String timetable_new="assets/icons/timetable_new.png";

  /// Medias
  //static String demoMedia="assets/media/demo.mp4";

  /// Colors
  static const Color backgroundColor = Color(0XFFF0F2F4); //light White color
  static const Color primaryColor = Color(0XFF51C3fE); // Dark Blue
  static const Color successColor = Color(0XFF50C13C); // light Green
  static const Color failureColor = Color(0XFFF53700); // light Red
  static const Color warningColor = Color(0XFFF6B03D); // light Orange
  static const Color greyColor = Color(0XFF8C8C8C); // Dark Grey (Close to black)
  static const Color textDarkColor = Color(0xFF232323); // Dark Grey
  static const Color textLightColor = Color(0XFFB6B6B6); // Light Grey
  static const Color textPrimaryColor = Color(0XFF51C3fE); // Dark Blue
  static const Color iconsTintGreyColor = Color(0XFFB6B6B6); // Light Grey
  static const Color iconsTintDarkGreyColor = Color(0XFF5C5C5C); // Dark Grey
  static const Color iconsTintPrimaryColor = Color(0XFFB6B6B6); // Light Grey
  static const Color buttonLightColor = Color(0XFFF1F6F7); // Light Blue and Grey (close to white)
  static const Color buttonPrimaryColor = Color(0XFF0165FF); // Dark Blue
  static const Color shadowColor = Color(0XFFE4E6E9); // Gray type
  static const Color whiteColor = Color(0XFFFFFFFF); // White
  static const Color blackColor = Color(0XFF000000); // Black
  static const Color darkPinkColor = Color(0XFFFF55FF); // Dark Pink
  static const Color lightPinkColor = Color(0XFFF7BAFC); // Light Pink
  static const Color darkYellowColor = Color(0XFFFCA844); // Dark Yellow
  static const Color lightYellowColor = Color(0XFFF8C89F); // Light Yellow
  static const Color lightBlueColor1 = Color(0XFF35D4F4); // Light Blue Shade 1
  static const Color lightBlueColor2 = Color(0XFFB9E4FE); // Light Blue Shade 2
  static const Color transparentColor = Color(0X00FFFFFF); // Light Blue Shade 2

  /// Text Styles
  static TextStyle latoBold_textCustomColor_16 = TextStyle(fontSize: 16, fontFamily: AppAssets.latoBold, color: Color(0xFF424242));

  static TextStyle latoRegular_textDarkColor_10 = TextStyle(fontSize: 10, fontFamily: AppAssets.latoRegular, color: AppAssets.textDarkColor);
  static TextStyle latoRegular_textDarkColor_12 = TextStyle(fontSize: 12, fontFamily: AppAssets.latoRegular, color: AppAssets.textDarkColor);
  static TextStyle latoRegular_textDarkColor_14 = TextStyle(fontSize: 14, fontFamily: AppAssets.latoRegular, color: AppAssets.textDarkColor);
  static TextStyle latoRegular_textDarkColor_16 = TextStyle(fontSize: 16, fontFamily: AppAssets.latoRegular, color: AppAssets.textDarkColor);
  static TextStyle latoRegular_textDarkColor_18 = TextStyle(fontSize: 18, fontFamily: AppAssets.latoRegular, color: AppAssets.textDarkColor);
  static TextStyle latoRegular_textDarkColor_20 = TextStyle(fontSize: 20, fontFamily: AppAssets.latoRegular, color: AppAssets.textDarkColor);

  static TextStyle latoRegular_textLightColor_10 = TextStyle(fontSize: 10, fontFamily: AppAssets.latoRegular, color: AppAssets.textLightColor);
  static TextStyle latoRegular_textLightColor_12 = TextStyle(fontSize: 12, fontFamily: AppAssets.latoRegular, color: AppAssets.textLightColor);
  static TextStyle latoRegular_textLightColor_14 = TextStyle(fontSize: 14, fontFamily: AppAssets.latoRegular, color: AppAssets.textLightColor);
  static TextStyle latoRegular_textLightColor_16 = TextStyle(fontSize: 16, fontFamily: AppAssets.latoRegular, color: AppAssets.textLightColor);
  static TextStyle latoRegular_textLightColor_18 = TextStyle(fontSize: 18, fontFamily: AppAssets.latoRegular, color: AppAssets.textLightColor);
  static TextStyle latoRegular_textLightColor_20 = TextStyle(fontSize: 20, fontFamily: AppAssets.latoRegular, color: AppAssets.textLightColor);

  static TextStyle latoBold_textDarkColor_10 = TextStyle(fontSize: 10, fontFamily: AppAssets.latoBold, color: AppAssets.textDarkColor);
  static TextStyle latoBold_textDarkColor_12 = TextStyle(fontSize: 12, fontFamily: AppAssets.latoBold, color: AppAssets.textDarkColor);
  static TextStyle latoBold_whiteColor_12 = TextStyle(fontSize: 12, fontFamily: AppAssets.latoBold, color: AppAssets.whiteColor);
  static TextStyle latoBold_textDarkColor_14 = TextStyle(fontSize: 14, fontFamily: AppAssets.latoBold, color: AppAssets.textDarkColor);
  static TextStyle latoBold_textDarkColor_16 = TextStyle(fontSize: 16, fontFamily: AppAssets.latoBold, color: AppAssets.textDarkColor);
  static TextStyle latoBold_successColor_16 = TextStyle(fontSize: 16, fontFamily: AppAssets.latoBold, color: AppAssets.successColor);
  static TextStyle latoBold_failureColor_16 = TextStyle(fontSize: 16, fontFamily: AppAssets.latoBold, color: AppAssets.failureColor);
  static TextStyle latoBold_whiteColor_16 = TextStyle(fontSize: 16, fontFamily: AppAssets.latoBold, color: AppAssets.whiteColor);
  static TextStyle latoBold_whiteColor_18 = TextStyle(fontSize: 18, fontFamily: AppAssets.latoBold, color: AppAssets.whiteColor);
  static TextStyle latoRegular_whiteColor_16 = TextStyle(fontSize: 16, fontFamily: AppAssets.latoRegular, color: AppAssets.whiteColor, fontWeight: FontWeight.w900);
  static TextStyle latoRegular_whiteColor_20 = TextStyle(fontSize: 20, fontFamily: AppAssets.latoRegular, color: AppAssets.whiteColor, fontWeight: FontWeight.w900);
  static TextStyle latoBold_whiteColor_26 = TextStyle(fontSize: 26, fontFamily: AppAssets.latoBold, color: AppAssets.whiteColor, fontWeight: FontWeight.w900);
  static TextStyle latoBold_whiteColor_30 = TextStyle(fontSize: 30, fontFamily: AppAssets.latoBold, color: AppAssets.whiteColor, fontWeight: FontWeight.w900);
  static TextStyle latoBold_textDarkColor_18 = TextStyle(fontSize: 18, fontFamily: AppAssets.latoBold, color: AppAssets.textDarkColor);
  static TextStyle latoBold_textDarkColor_20 = TextStyle(fontSize: 20, fontFamily: AppAssets.latoBold, color: AppAssets.textDarkColor);
  static TextStyle latoBold_textDarkColor_24 = TextStyle(fontSize: 24, fontFamily: AppAssets.latoBold, color: AppAssets.textDarkColor);
  static TextStyle latoExtraBold_textDarkColor_22 = TextStyle(fontSize: 30, fontFamily: AppAssets.latoBold, color: AppAssets.textDarkColor, fontWeight: FontWeight.w900);

  static TextStyle latoBold_successColor_24 = TextStyle(fontSize: 24, fontFamily: AppAssets.latoBold, color: AppAssets.successColor);
  static TextStyle latoBold_failureColor_24 = TextStyle(fontSize: 24, fontFamily: AppAssets.latoBold, color: AppAssets.failureColor);
  static TextStyle latoBold_blueColor_24 = TextStyle(fontSize: 24, fontFamily: AppAssets.latoBold, color: Colors.blue);

  static TextStyle latoBold_textLightColor_10 = TextStyle(fontSize: 10, fontFamily: AppAssets.latoBold, color: AppAssets.textLightColor);
  static TextStyle latoBold_textLightColor_12 = TextStyle(fontSize: 12, fontFamily: AppAssets.latoBold, color: AppAssets.textLightColor);
  static TextStyle latoBold_textLightColor_14 = TextStyle(fontSize: 14, fontFamily: AppAssets.latoBold, color: AppAssets.textLightColor);
  static TextStyle latoBold_textLightColor_16 = TextStyle(fontSize: 16, fontFamily: AppAssets.latoBold, color: AppAssets.textLightColor);
  static TextStyle latoBold_textLightColor_18 = TextStyle(fontSize: 18, fontFamily: AppAssets.latoBold, color: AppAssets.textLightColor);
  static TextStyle latoBold_textLightColor_20 = TextStyle(fontSize: 20, fontFamily: AppAssets.latoBold, color: AppAssets.textLightColor);

  static TextStyle latoBlack_textDarkColor_10 = TextStyle(fontSize: 10, fontFamily: AppAssets.latoBlack, color: AppAssets.textDarkColor);
  static TextStyle latoBlack_textDarkColor_12 = TextStyle(fontSize: 12, fontFamily: AppAssets.latoBlack, color: AppAssets.textDarkColor);
  static TextStyle latoBlack_textDarkColor_14 = TextStyle(fontSize: 14, fontFamily: AppAssets.latoBlack, color: AppAssets.textDarkColor);
  static TextStyle latoBlack_textDarkColor_16 = TextStyle(fontSize: 16, fontFamily: AppAssets.latoBlack, color: AppAssets.textDarkColor);
  static TextStyle latoBlack_textDarkColor_18 = TextStyle(fontSize: 18, fontFamily: AppAssets.latoBlack, color: AppAssets.textDarkColor);
  static TextStyle latoBlack_textDarkColor_20 = TextStyle(fontSize: 20, fontFamily: AppAssets.latoBlack, color: AppAssets.textDarkColor);

  static TextStyle latoBlack_textLightColor_10 = TextStyle(fontSize: 10, fontFamily: AppAssets.latoBlack, color: AppAssets.textLightColor);
  static TextStyle latoBlack_textLightColor_12 = TextStyle(fontSize: 12, fontFamily: AppAssets.latoBlack, color: AppAssets.textLightColor);
  static TextStyle latoBlack_textLightColor_14 = TextStyle(fontSize: 14, fontFamily: AppAssets.latoBlack, color: AppAssets.textLightColor);
  static TextStyle latoBlack_textLightColor_16 = TextStyle(fontSize: 16, fontFamily: AppAssets.latoBlack, color: AppAssets.textLightColor);
  static TextStyle latoBlack_textLightColor_18 = TextStyle(fontSize: 18, fontFamily: AppAssets.latoBlack, color: AppAssets.textLightColor);
  static TextStyle latoBlack_textLightColor_20 = TextStyle(fontSize: 20, fontFamily: AppAssets.latoBlack, color: AppAssets.textLightColor);

  static TextStyle latoRegular_primaryColor_10 = TextStyle(fontSize: 10, fontFamily: AppAssets.latoRegular, color: AppAssets.primaryColor);
  static TextStyle latoRegular_primaryColor_12 = TextStyle(fontSize: 12, fontFamily: AppAssets.latoRegular, color: AppAssets.primaryColor);
  static TextStyle latoRegular_primaryColor_14 = TextStyle(fontSize: 14, fontFamily: AppAssets.latoRegular, color: AppAssets.primaryColor);
  static TextStyle latoRegular_primaryColor_16 = TextStyle(fontSize: 16, fontFamily: AppAssets.latoRegular, color: AppAssets.primaryColor);
  static TextStyle latoRegular_primaryColor_18 = TextStyle(fontSize: 18, fontFamily: AppAssets.latoRegular, color: AppAssets.primaryColor);
  static TextStyle latoRegular_primaryColor_20 = TextStyle(fontSize: 20, fontFamily: AppAssets.latoRegular, color: AppAssets.primaryColor);

  static TextStyle latoRegular_primarytColor_10 = TextStyle(fontSize: 10, fontFamily: AppAssets.latoRegular, color: AppAssets.primaryColor);
  static TextStyle latoRegular_primarytColor_12 = TextStyle(fontSize: 12, fontFamily: AppAssets.latoRegular, color: AppAssets.primaryColor);
  static TextStyle latoRegular_primarytColor_14 = TextStyle(fontSize: 14, fontFamily: AppAssets.latoRegular, color: AppAssets.primaryColor);
  static TextStyle latoRegular_primarytColor_16 = TextStyle(fontSize: 16, fontFamily: AppAssets.latoRegular, color: AppAssets.primaryColor);
  static TextStyle latoRegular_primarytColor_18 = TextStyle(fontSize: 18, fontFamily: AppAssets.latoRegular, color: AppAssets.primaryColor);
  static TextStyle latoRegular_primarytColor_20 = TextStyle(fontSize: 20, fontFamily: AppAssets.latoRegular, color: AppAssets.primaryColor);

  static TextStyle latoBold_primaryColor_10 = TextStyle(fontSize: 10, fontFamily: AppAssets.latoBold, color: AppAssets.primaryColor);
  static TextStyle latoBold_primaryColor_12 = TextStyle(fontSize: 12, fontFamily: AppAssets.latoBold, color: AppAssets.primaryColor);
  static TextStyle latoBold_primaryColor_14 = TextStyle(fontSize: 14, fontFamily: AppAssets.latoBold, color: AppAssets.primaryColor);
  static TextStyle latoBold_primaryColor_16 = TextStyle(fontSize: 16, fontFamily: AppAssets.latoBold, color: AppAssets.primaryColor);
  static TextStyle latoBold_primaryColor_18 = TextStyle(fontSize: 18, fontFamily: AppAssets.latoBold, color: AppAssets.primaryColor);
  static TextStyle latoBold_primaryColor_20 = TextStyle(fontSize: 20, fontFamily: AppAssets.latoBold, color: AppAssets.primaryColor);
  static TextStyle latoBold_primaryColor_30 = TextStyle(fontSize: 30, fontFamily: AppAssets.latoBold, color: AppAssets.primaryColor);

  static TextStyle latoBold_primarytColor_10 = TextStyle(fontSize: 10, fontFamily: AppAssets.latoBold, color: AppAssets.primaryColor);
  static TextStyle latoBold_primarytColor_12 = TextStyle(fontSize: 12, fontFamily: AppAssets.latoBold, color: AppAssets.primaryColor);
  static TextStyle latoBold_primarytColor_14 = TextStyle(fontSize: 14, fontFamily: AppAssets.latoBold, color: AppAssets.primaryColor);
  static TextStyle latoBold_primarytColor_16 = TextStyle(fontSize: 16, fontFamily: AppAssets.latoBold, color: AppAssets.primaryColor);
  static TextStyle latoBold_primarytColor_18 = TextStyle(fontSize: 18, fontFamily: AppAssets.latoBold, color: AppAssets.primaryColor);
  static TextStyle latoBold_primarytColor_20 = TextStyle(fontSize: 20, fontFamily: AppAssets.latoBold, color: AppAssets.primaryColor);

  static TextStyle latoBlack_primaryColor_10 = TextStyle(fontSize: 10, fontFamily: AppAssets.latoBlack, color: AppAssets.primaryColor);
  static TextStyle latoBlack_primaryColor_12 = TextStyle(fontSize: 12, fontFamily: AppAssets.latoBlack, color: AppAssets.primaryColor);
  static TextStyle latoBlack_primaryColor_14 = TextStyle(fontSize: 14, fontFamily: AppAssets.latoBlack, color: AppAssets.primaryColor);
  static TextStyle latoBlack_primaryColor_16 = TextStyle(fontSize: 16, fontFamily: AppAssets.latoBlack, color: AppAssets.primaryColor);
  static TextStyle latoBlack_failureColor_15 = TextStyle(fontSize: 15, fontFamily: AppAssets.latoBlack, color: AppAssets.failureColor);
  static TextStyle latoBlack_primaryColor_18 = TextStyle(fontSize: 18, fontFamily: AppAssets.latoBlack, color: AppAssets.primaryColor);
  static TextStyle latoBlack_primaryColor_20 = TextStyle(fontSize: 20, fontFamily: AppAssets.latoBlack, color: AppAssets.primaryColor);

  static TextStyle latoBlack_primarytColor_10 = TextStyle(fontSize: 10, fontFamily: AppAssets.latoBlack, color: AppAssets.primaryColor);
  static TextStyle latoBlack_primarytColor_12 = TextStyle(fontSize: 12, fontFamily: AppAssets.latoBlack, color: AppAssets.primaryColor);
  static TextStyle latoBlack_primarytColor_14 = TextStyle(fontSize: 14, fontFamily: AppAssets.latoBlack, color: AppAssets.primaryColor);
  static TextStyle latoBlack_primarytColor_16 = TextStyle(fontSize: 16, fontFamily: AppAssets.latoBlack, color: AppAssets.primaryColor);
  static TextStyle latoBlack_primarytColor_18 = TextStyle(fontSize: 18, fontFamily: AppAssets.latoBlack, color: AppAssets.primaryColor);
  static TextStyle latoBlack_primarytColor_20 = TextStyle(fontSize: 20, fontFamily: AppAssets.latoBlack, color: AppAssets.primaryColor);
}
