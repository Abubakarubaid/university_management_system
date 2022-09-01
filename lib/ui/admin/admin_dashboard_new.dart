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

import '../../models/dashboard_model.dart';
import '../../models/user_model.dart';
import '../../utilities/shared_preference_manager.dart';
import 'admin_profile.dart';
import 'attendance/select_attendance.dart';
import 'datesheet/datesheet_assignment.dart';

class AdminDashboardNew extends StatefulWidget {
  const AdminDashboardNew({Key? key}) : super(key: key);

  @override
  State<AdminDashboardNew> createState() => _AdminDashboardNewState();
}

class _AdminDashboardNewState extends State<AdminDashboardNew> {

  UserModel myData = UserModel.getInstance();
  List<DashboardModel> dashboardList = [
    DashboardModel(id: 1, title: "Department", type: "Department", icon: AppAssets.department_new),
    DashboardModel(id: 2, title: "Subjects", type: "Subjects", icon: AppAssets.subject_new),
    DashboardModel(id: 3, title: "Classes", type: "Classes", icon: AppAssets.classes_new),
    DashboardModel(id: 4, title: "Rooms", type: "Rooms", icon: AppAssets.room_new),
    DashboardModel(id: 5, title: "Time Slots", type: "Time Slots", icon: AppAssets.timeslot_new),
  ];

  @override
  void initState() {
    super.initState();
  }

  void getUserData() async {
    SharedPreferenceManager.getInstance().getUser().then((value) {
      myData = value;
      setState(() {});
    });
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
            Column(
              children: [
                const SizedBox(height: 56,),
                Stack(children: [
                  Container(
                    width: double.infinity,
                    height: 160,
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
                    height: 160,
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
                  height: 110,
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 30),
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: dashboardList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          switch(index){
                            case 0:
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ViewDepartments()));
                              break;
                            case 1:
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ViewSubjects()));
                              break;
                            case 2:
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ViewClasses()));
                              break;
                            case 3:
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ViewRooms()));
                              break;
                            case 4:
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ViewTimeSlots()));
                              break;
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.only(left: 20),
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  Container(
                                    height: 70,
                                    padding: EdgeInsets.all(index == 1 ? 16 : 12),
                                    decoration: BoxDecoration(
                                      color: AppAssets.whiteColor,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppAssets.shadowColor.withOpacity(0.3),
                                          blurRadius: 8,
                                          spreadRadius: 5,
                                          offset: const Offset(0, 6),
                                        )],
                                    ),
                                    child: Image.asset(dashboardList[index].icon),
                                  ),
                                  const SizedBox(height: 12,),
                                  Center(child: Text(dashboardList[index].title, style: AppAssets.latoBold_textDarkColor_12, maxLines: 1, overflow: TextOverflow.ellipsis,)),
                                ],
                              ),
                              const SizedBox(width: 20,),
                              index == dashboardList.length-1 ? Container() : Container(margin: const EdgeInsets.only(top: 10, bottom: 10), width: 2, height: double.infinity, color: AppAssets.textLightColor.withOpacity(0.2),),
                            ],
                          ),
                        ),
                      );
                    }),
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 14, left: 22, right: 22, bottom: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ViewTeachers()));
                              },
                              child: Container(
                                height: 100,
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
                                  Container(height: 40, child: Image.asset(AppAssets.teachers_new),),
                                  SizedBox(height: 6,),
                                  Expanded(child: Center(child: Text("Teachers", style: AppAssets.latoBold_textDarkColor_12, maxLines: 1, overflow: TextOverflow.ellipsis,))),
                                ],),
                              ),
                            ),
                            const SizedBox(width: 20,),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const WorkloadAssignment()));
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(18),
                                  margin: const EdgeInsets.only(top: 14),
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
                                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                    SizedBox(height: 40, child: Image.asset(AppAssets.workload_new),),
                                    const SizedBox(height: 16,),
                                    Center(child: Text("Work Load", style: AppAssets.latoBold_textDarkColor_12, maxLines: 1, overflow: TextOverflow.ellipsis,)),
                                  ],),
                                ),
                              ),
                            ),
                          ],),
                        ),
                        const SizedBox(width: 14,),
                        Expanded(
                          child: Column(children: [
                            Expanded(
                              child: GestureDetector(
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
                                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                    SizedBox(height: 40, child: Image.asset(AppAssets.students_new),),
                                    const SizedBox(height: 16,),
                                    Center(child: Text("Students", style: AppAssets.latoBold_textDarkColor_12, maxLines: 1, overflow: TextOverflow.ellipsis,)),
                                  ],),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const DatesheetAssignment()));
                              },
                              child: Container(
                                padding: const EdgeInsets.all(18),
                                margin: const EdgeInsets.only(top: 14),
                                height: 100,
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
                                  Container(height: 40, child: Image.asset(AppAssets.datesheet_new),),
                                  SizedBox(height: 6,),
                                  Expanded(child: Center(child: Text("Date Sheet", style: AppAssets.latoBold_textDarkColor_12, maxLines: 1, overflow: TextOverflow.ellipsis,))),
                                ],),
                              ),
                            ),
                          ],),
                        ),
                      ],),
                  ),
                ),
              ],),
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
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AdminProfile()));
                }, child: Container(padding: const EdgeInsets.all(10), height: 50, width: 50, child: SvgPicture.asset(AppAssets.profileIcon, color: AppAssets.iconsTintDarkGreyColor,))),
              ],),
            ),
          ]),
        ),
      ),
    );
  }
}
