import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:university_management_system/assets/app_assets.dart';
import 'package:university_management_system/models/quotes_model.dart';
import 'package:university_management_system/ui/admin/classes/view_classes.dart';
import 'package:university_management_system/ui/admin/departments/view_departments.dart';
import 'package:university_management_system/ui/admin/rooms/view_rooms.dart';
import 'package:university_management_system/ui/admin/students/view_students.dart';
import 'package:university_management_system/ui/admin/subjects/view_subjects.dart';
import 'package:university_management_system/ui/admin/teachers/view_teachers.dart';
import 'package:university_management_system/ui/admin/timeslots/view_timeslots.dart';
import 'package:university_management_system/ui/admin/timetable/timetable_page.dart';
import 'package:university_management_system/ui/admin/workload/workload_assignment.dart';
import 'package:university_management_system/ui/profile/user_profile.dart';

import 'attendance/select_attendance.dart';
import 'datesheet/datesheet_assignment.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: AppAssets.backgroundColor,
          child: Stack(children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 80, left: 20, right: 20),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text("Hi Abu Bakar", style: AppAssets.latoBold_textLightColor_20,),
                      const SizedBox(height: 6,),
                      Text("Manage your work", style: AppAssets.latoExtraBold_textDarkColor_22, maxLines: 1, overflow: TextOverflow.ellipsis,),
                    ],),
                  ),
                  Stack(children: [
                    Container(
                      width: double.infinity,
                      height: 170,
                      margin: const EdgeInsets.only(top: 26, left: 36, right: 36),
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(20)),
                          boxShadow: [
                            BoxShadow(
                              color: AppAssets.primaryColor.withOpacity(0.3),
                              spreadRadius: 8,
                              blurRadius: 12,
                              offset: const Offset(0, 10), // changes position of shadow
                            ),
                          ]
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(20),
                      width: double.infinity,
                      height: 170,
                      margin: const EdgeInsets.only(top: 26, left: 20, right: 20),
                      decoration: const BoxDecoration(
                        color: AppAssets.primaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Row(children: [
                        Expanded(child: Image.asset(AppAssets.workloadIcon, color: AppAssets.whiteColor,)),
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: [
                            Text("You can manage", style: AppAssets.latoBold_whiteColor_12,),
                            const SizedBox(height: 20,),
                            Text("Work Load", style: AppAssets.latoBold_whiteColor_16,),
                            Text("Attendance", style: AppAssets.latoBold_whiteColor_16,),
                            Text("Subjects", style: AppAssets.latoBold_whiteColor_16,),
                            Text("Others", style: AppAssets.latoBold_whiteColor_16,),
                          ],),
                        ),
                      ],),
                    ),
                  ],),
                  Container(
                    height: 130,
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 40, left: 22, right: 22),
                    child: Row(children: [
                      Expanded(child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ViewDepartments()));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: AppAssets.whiteColor,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: AppAssets.shadowColor.withOpacity(0.3),
                                blurRadius: 8,
                                spreadRadius: 5,
                                offset: const Offset(0, 6),
                              )],
                          ),
                          child: Column(children: [
                            Stack( children: [
                              Container(
                                height: 60,
                                width: 60,
                                margin: const EdgeInsets.only(left: 8, right: 8),
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppAssets.darkPinkColor.withOpacity(0.3),
                                      blurRadius: 8,
                                      spreadRadius: 3,
                                      offset: const Offset(0, 6),
                                    )],
                                ),
                              ),
                              Container(
                                height: 60,
                                width: 70,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppAssets.primaryColor,
                                  gradient: const LinearGradient(
                                      colors: [AppAssets.darkPinkColor, AppAssets.lightPinkColor],
                                      begin: FractionalOffset(0.6, 0.8),
                                      end: FractionalOffset(0.0, 0.0),
                                      stops: [0.0, 1.0],
                                      tileMode: TileMode.clamp
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: SvgPicture.asset(AppAssets.departmentIcon, color: AppAssets.whiteColor,),
                              ),
                            ],),
                            const SizedBox(height: 16,),
                            Expanded(child: Center(child: Text("Department", style: AppAssets.latoBold_textDarkColor_12, maxLines: 1, overflow: TextOverflow.ellipsis,))),
                          ],),
                        ),
                      )),
                      const SizedBox(width: 20,),
                      Expanded(child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ViewSubjects()));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: AppAssets.whiteColor,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: AppAssets.shadowColor.withOpacity(0.3),
                                blurRadius: 8,
                                spreadRadius: 5,
                                offset: const Offset(0, 6),
                              )],
                          ),
                          child: Column(children: [
                            Stack( children: [
                              Container(
                                height: 60,
                                width: 60,
                                margin: const EdgeInsets.only(left: 8, right: 8),
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppAssets.darkYellowColor.withOpacity(0.3),
                                      blurRadius: 8,
                                      spreadRadius: 3,
                                      offset: const Offset(0, 6),
                                    )],
                                ),
                              ),
                              Container(
                                height: 60,
                                width: 70,
                                padding: const EdgeInsets.all(13),
                                decoration: BoxDecoration(
                                  color: AppAssets.primaryColor,
                                  gradient: const LinearGradient(
                                      colors: [AppAssets.darkYellowColor, AppAssets.lightYellowColor],
                                      begin: FractionalOffset(0.6, 0.8),
                                      end: FractionalOffset(0.0, 0.0),
                                      stops: [0.0, 1.0],
                                      tileMode: TileMode.clamp
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: SvgPicture.asset(AppAssets.booksIcon, color: AppAssets.whiteColor,),
                              ),
                            ],),
                            const SizedBox(height: 16,),
                            Expanded(child: Center(child: Text("Subjects", style: AppAssets.latoBold_textDarkColor_12, maxLines: 1, overflow: TextOverflow.ellipsis,))),
                          ],),
                        ),
                      )),
                      const SizedBox(width: 20,),
                      Expanded(child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ViewStudents()));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: AppAssets.whiteColor,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: AppAssets.shadowColor.withOpacity(0.3),
                                blurRadius: 8,
                                spreadRadius: 5,
                                offset: const Offset(0, 6),
                              )],
                          ),
                          child: Column(children: [
                            Stack( children: [
                              Container(
                                height: 60,
                                width: 60,
                                margin: const EdgeInsets.only(left: 8, right: 8),
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppAssets.primaryColor.withOpacity(0.3),
                                      blurRadius: 8,
                                      spreadRadius: 3,
                                      offset: const Offset(0, 6),
                                    )],
                                ),
                              ),
                              Container(
                                height: 60,
                                width: 70,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppAssets.primaryColor,
                                  gradient: const LinearGradient(
                                      colors: [AppAssets.lightBlueColor1, AppAssets.lightBlueColor2],
                                      begin: FractionalOffset(0.6, 0.8),
                                      end: FractionalOffset(0.0, 0.0),
                                      stops: [0.0, 1.0],
                                      tileMode: TileMode.clamp
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: SvgPicture.asset(AppAssets.studentsIcon, color: AppAssets.whiteColor,),
                              ),
                            ],),
                            const SizedBox(height: 16,),
                            Expanded(child: Center(child: Text("Students", style: AppAssets.latoBold_textDarkColor_12, maxLines: 1, overflow: TextOverflow.ellipsis,))),
                          ],),
                        ),
                      )),
                    ],),
                  ),
                  Container(
                    height: 130,
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 20, left: 22, right: 22),
                    child: Row(children: [
                      Expanded(child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ViewTeachers()));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: AppAssets.whiteColor,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: AppAssets.shadowColor.withOpacity(0.3),
                                blurRadius: 8,
                                spreadRadius: 5,
                                offset: const Offset(0, 6),
                              )],
                          ),
                          child: Column(children: [
                            Stack( children: [
                              Container(
                                height: 60,
                                width: 60,
                                margin: const EdgeInsets.only(left: 8, right: 8),
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppAssets.primaryColor.withOpacity(0.3),
                                      blurRadius: 8,
                                      spreadRadius: 3,
                                      offset: const Offset(0, 6),
                                    )],
                                ),
                              ),
                              Container(
                                height: 60,
                                width: 70,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppAssets.primaryColor,
                                  gradient: const LinearGradient(
                                      colors: [AppAssets.lightBlueColor1, AppAssets.lightBlueColor2],
                                      begin: FractionalOffset(0.6, 0.8),
                                      end: FractionalOffset(0.0, 0.0),
                                      stops: [0.0, 1.0],
                                      tileMode: TileMode.clamp
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: SvgPicture.asset(AppAssets.teachersIcon, color: AppAssets.whiteColor,),
                              ),
                            ],),
                            const SizedBox(height: 16,),
                            Expanded(child: Center(child: Text("Teachers", style: AppAssets.latoBold_textDarkColor_12, maxLines: 1, overflow: TextOverflow.ellipsis,))),
                          ],),
                        ),
                      )),
                      const SizedBox(width: 20,),
                      Expanded(child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ViewClasses()));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: AppAssets.whiteColor,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: AppAssets.shadowColor.withOpacity(0.3),
                                blurRadius: 8,
                                spreadRadius: 5,
                                offset: const Offset(0, 6),
                              )],
                          ),
                          child: Column(children: [
                            Stack( children: [
                              Container(
                                height: 60,
                                width: 60,
                                margin: const EdgeInsets.only(left: 8, right: 8),
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppAssets.darkPinkColor.withOpacity(0.3),
                                      blurRadius: 8,
                                      spreadRadius: 3,
                                      offset: const Offset(0, 6),
                                    )],
                                ),
                              ),
                              Container(
                                height: 60,
                                width: 70,
                                padding: const EdgeInsets.all(13),
                                decoration: BoxDecoration(
                                  color: AppAssets.primaryColor,
                                  gradient: const LinearGradient(
                                      colors: [AppAssets.darkPinkColor, AppAssets.lightPinkColor],
                                      begin: FractionalOffset(0.6, 0.8),
                                      end: FractionalOffset(0.0, 0.0),
                                      stops: [0.0, 1.0],
                                      tileMode: TileMode.clamp
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: SvgPicture.asset(AppAssets.othersIcon, color: AppAssets.whiteColor,),
                              ),
                            ],),
                            const SizedBox(height: 16,),
                            Expanded(child: Center(child: Text("Classes", style: AppAssets.latoBold_textDarkColor_12, maxLines: 1, overflow: TextOverflow.ellipsis,))),
                          ],),
                        ),
                      )),
                      const SizedBox(width: 20,),
                      Expanded(child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const WorkloadAssignment()));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: AppAssets.whiteColor,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: AppAssets.shadowColor.withOpacity(0.3),
                                blurRadius: 8,
                                spreadRadius: 5,
                                offset: const Offset(0, 6),
                              )],
                          ),
                          child: Column(children: [
                            Stack( children: [
                              Container(
                                height: 60,
                                width: 60,
                                margin: const EdgeInsets.only(left: 8, right: 8),
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppAssets.darkYellowColor.withOpacity(0.3),
                                      blurRadius: 8,
                                      spreadRadius: 3,
                                      offset: const Offset(0, 6),
                                    )],
                                ),
                              ),
                              Container(
                                height: 60,
                                width: 70,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppAssets.primaryColor,
                                  gradient: const LinearGradient(
                                      colors: [AppAssets.darkYellowColor, AppAssets.lightYellowColor],
                                      begin: FractionalOffset(0.6, 0.8),
                                      end: FractionalOffset(0.0, 0.0),
                                      stops: [0.0, 1.0],
                                      tileMode: TileMode.clamp
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Image.asset(AppAssets.workloadIcon, color: AppAssets.whiteColor,),
                              ),
                            ],),
                            const SizedBox(height: 16,),
                            Expanded(child: Center(child: Text("Work Load", style: AppAssets.latoBold_textDarkColor_12, maxLines: 1, overflow: TextOverflow.ellipsis,))),
                          ],),
                        ),
                      )),
                    ],),
                  ),
                  Container(
                    height: 130,
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 20, left: 22, right: 22),
                    child: Row(children: [
                      Expanded(child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ViewRooms()));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: AppAssets.whiteColor,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: AppAssets.shadowColor.withOpacity(0.3),
                                blurRadius: 8,
                                spreadRadius: 5,
                                offset: const Offset(0, 6),
                              )],
                          ),
                          child: Column(children: [
                            Stack( children: [
                              Container(
                                height: 60,
                                width: 60,
                                margin: const EdgeInsets.only(left: 8, right: 8),
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppAssets.darkYellowColor.withOpacity(0.3),
                                      blurRadius: 8,
                                      spreadRadius: 3,
                                      offset: const Offset(0, 6),
                                    )],
                                ),
                              ),
                              Container(
                                height: 60,
                                width: 70,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppAssets.primaryColor,
                                  gradient: const LinearGradient(
                                      colors: [AppAssets.darkYellowColor, AppAssets.lightYellowColor],
                                      begin: FractionalOffset(0.6, 0.8),
                                      end: FractionalOffset(0.0, 0.0),
                                      stops: [0.0, 1.0],
                                      tileMode: TileMode.clamp
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: SvgPicture.asset(AppAssets.roomDoorIcon, color: AppAssets.whiteColor,),
                              ),
                            ],),
                            const SizedBox(height: 16,),
                            Expanded(child: Center(child: Text("Rooms", style: AppAssets.latoBold_textDarkColor_12, maxLines: 1, overflow: TextOverflow.ellipsis,))),
                          ],),
                        ),
                      )),
                      const SizedBox(width: 20,),
                      Expanded(child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ViewTimeSlots()));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: AppAssets.whiteColor,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: AppAssets.shadowColor.withOpacity(0.3),
                                blurRadius: 8,
                                spreadRadius: 5,
                                offset: const Offset(0, 6),
                              )],
                          ),
                          child: Column(children: [
                            Stack( children: [
                              Container(
                                height: 60,
                                width: 60,
                                margin: const EdgeInsets.only(left: 8, right: 8),
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppAssets.primaryColor.withOpacity(0.3),
                                      blurRadius: 8,
                                      spreadRadius: 3,
                                      offset: const Offset(0, 6),
                                    )],
                                ),
                              ),
                              Container(
                                height: 60,
                                width: 70,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppAssets.primaryColor,
                                  gradient: const LinearGradient(
                                      colors: [AppAssets.lightBlueColor1, AppAssets.lightBlueColor2],
                                      begin: FractionalOffset(0.6, 0.8),
                                      end: FractionalOffset(0.0, 0.0),
                                      stops: [0.0, 1.0],
                                      tileMode: TileMode.clamp
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(Icons.timer, color: AppAssets.whiteColor),
                              ),
                            ],),
                            const SizedBox(height: 16,),
                            Expanded(child: Center(child: Text("Time Slots", style: AppAssets.latoBold_textDarkColor_12, maxLines: 1, overflow: TextOverflow.ellipsis,))),
                          ],),
                        ),
                      )),
                      const SizedBox(width: 20,),
                      Expanded(child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SelectAttendance()));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: AppAssets.whiteColor,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: AppAssets.shadowColor.withOpacity(0.3),
                                blurRadius: 8,
                                spreadRadius: 5,
                                offset: const Offset(0, 6),
                              )],
                          ),
                          child: Column(children: [
                            Stack( children: [
                              Container(
                                height: 60,
                                width: 60,
                                margin: const EdgeInsets.only(left: 8, right: 8),
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppAssets.darkPinkColor.withOpacity(0.3),
                                      blurRadius: 8,
                                      spreadRadius: 3,
                                      offset: const Offset(0, 6),
                                    )],
                                ),
                              ),
                              Container(
                                height: 60,
                                width: 70,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppAssets.primaryColor,
                                  gradient: const LinearGradient(
                                      colors: [AppAssets.darkPinkColor, AppAssets.lightPinkColor],
                                      begin: FractionalOffset(0.6, 0.8),
                                      end: FractionalOffset(0.0, 0.0),
                                      stops: [0.0, 1.0],
                                      tileMode: TileMode.clamp
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Image.asset(AppAssets.attendanceIcon, color: AppAssets.whiteColor,),
                              ),
                            ],),
                            const SizedBox(height: 16,),
                            Expanded(child: Center(child: Text("Attendance", style: AppAssets.latoBold_textDarkColor_12, maxLines: 1, overflow: TextOverflow.ellipsis,))),
                          ],),
                        ),
                      )),
                    ],),
                  ),
                  Container(
                    height: 130,
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 20, left: 22, right: 22, bottom: 20),
                    child: Row(children: [
                      Expanded(child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const DatesheetAssignment()));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: AppAssets.whiteColor,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: AppAssets.shadowColor.withOpacity(0.3),
                                blurRadius: 8,
                                spreadRadius: 5,
                                offset: const Offset(0, 6),
                              )],
                          ),
                          child: Column(children: [
                            Stack( children: [
                              Container(
                                height: 60,
                                width: 60,
                                margin: const EdgeInsets.only(left: 8, right: 8),
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppAssets.darkYellowColor.withOpacity(0.3),
                                      blurRadius: 8,
                                      spreadRadius: 3,
                                      offset: const Offset(0, 6),
                                    )],
                                ),
                              ),
                              Container(
                                height: 60,
                                width: 70,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppAssets.primaryColor,
                                  gradient: const LinearGradient(
                                      colors: [AppAssets.darkYellowColor, AppAssets.lightYellowColor],
                                      begin: FractionalOffset(0.6, 0.8),
                                      end: FractionalOffset(0.0, 0.0),
                                      stops: [0.0, 1.0],
                                      tileMode: TileMode.clamp
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: SvgPicture.asset(AppAssets.dateSheetIcon, color: AppAssets.whiteColor,),
                              ),
                            ],),
                            const SizedBox(height: 16,),
                            Expanded(child: Center(child: Text("Date Sheet", style: AppAssets.latoBold_textDarkColor_12, maxLines: 1, overflow: TextOverflow.ellipsis,))),
                          ],),
                        ),
                      )),
                      const SizedBox(width: 20,),
                      Expanded(child: GestureDetector(
                        onTap: () {

                        },
                        child: Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: AppAssets.whiteColor,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: AppAssets.shadowColor.withOpacity(0.3),
                                blurRadius: 8,
                                spreadRadius: 5,
                                offset: const Offset(0, 6),
                              )],
                          ),
                          child: Column(children: [
                            Stack( children: [
                              Container(
                                height: 60,
                                width: 60,
                                margin: const EdgeInsets.only(left: 8, right: 8),
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppAssets.primaryColor.withOpacity(0.3),
                                      blurRadius: 8,
                                      spreadRadius: 3,
                                      offset: const Offset(0, 6),
                                    )],
                                ),
                              ),
                              Container(
                                height: 60,
                                width: 70,
                                padding: const EdgeInsets.all(13),
                                decoration: BoxDecoration(
                                  color: AppAssets.primaryColor,
                                  gradient: const LinearGradient(
                                      colors: [AppAssets.lightBlueColor1, AppAssets.lightBlueColor2],
                                      begin: FractionalOffset(0.6, 0.8),
                                      end: FractionalOffset(0.0, 0.0),
                                      stops: [0.0, 1.0],
                                      tileMode: TileMode.clamp
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: SvgPicture.asset(AppAssets.reportsIcon, color: AppAssets.whiteColor,),
                              ),
                            ],),
                            const SizedBox(height: 16,),
                            Expanded(child: Center(child: Text("Reports", style: AppAssets.latoBold_textDarkColor_12, maxLines: 1, overflow: TextOverflow.ellipsis,))),
                          ],),
                        ),
                      )),
                      const SizedBox(width: 20,),
                      Expanded(child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => TimeTablePage()));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: AppAssets.whiteColor,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: AppAssets.shadowColor.withOpacity(0.3),
                                blurRadius: 8,
                                spreadRadius: 5,
                                offset: const Offset(0, 6),
                              )],
                          ),
                          child: Column(children: [
                            Stack( children: [
                              Container(
                                height: 60,
                                width: 60,
                                margin: const EdgeInsets.only(left: 8, right: 8),
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppAssets.darkPinkColor.withOpacity(0.3),
                                      blurRadius: 8,
                                      spreadRadius: 3,
                                      offset: const Offset(0, 6),
                                    )],
                                ),
                              ),
                              Container(
                                height: 60,
                                width: 70,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppAssets.primaryColor,
                                  gradient: const LinearGradient(
                                      colors: [AppAssets.darkPinkColor, AppAssets.lightPinkColor],
                                      begin: FractionalOffset(0.6, 0.8),
                                      end: FractionalOffset(0.0, 0.0),
                                      stops: [0.0, 1.0],
                                      tileMode: TileMode.clamp
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: SvgPicture.asset(AppAssets.timetableIcon, color: AppAssets.whiteColor,),
                              ),
                            ],),
                            const SizedBox(height: 16,),
                            Expanded(child: Center(child: Text("Time Table", style: AppAssets.latoBold_textDarkColor_12, maxLines: 1, overflow: TextOverflow.ellipsis,))),
                          ],),
                        ),
                      )),
                    ],),
                  ),
                ],),
            ),
            Container(
              width: double.infinity,
              height: 60,
              padding: const EdgeInsets.only(left: 10, right: 10),
              decoration: BoxDecoration(
                  color: AppAssets.whiteColor,
                  boxShadow: [
                    BoxShadow(
                      color: AppAssets.shadowColor.withOpacity(0.3),
                      spreadRadius: 6,
                      blurRadius: 12,
                      offset: const Offset(0, 6), // changes position of shadow
                    )]
              ),
              child: Row(children: [
                Container(padding: const EdgeInsets.all(10), height: 50, width: 50, child: SvgPicture.asset(AppAssets.dashboardIcon, color: AppAssets.iconsTintDarkGreyColor,)),
                Expanded(child: Container(padding: const EdgeInsets.only(left: 20, right: 20), child: Center(child: Text("Dashboard", style: AppAssets.latoBold_textDarkColor_20)))),
                GestureDetector(onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const UserProfile()));
                }, child: Container(padding: const EdgeInsets.all(10), height: 50, width: 50, child: SvgPicture.asset(AppAssets.profileIcon, color: AppAssets.iconsTintDarkGreyColor,))),
              ],),
            ),
          ]),
        ),
      ),
    );
  }
}
