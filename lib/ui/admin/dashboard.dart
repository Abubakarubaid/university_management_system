import 'dart:async';
import 'dart:math';

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:university_management_system/assets/app_assets.dart';
import 'package:university_management_system/models/quotes_model.dart';
import 'package:university_management_system/ui/admin/admin_dashboard_new.dart';
import 'package:university_management_system/ui/admin/classes/view_classes.dart';
import 'package:university_management_system/ui/admin/departments/view_departments.dart';
import 'package:university_management_system/ui/admin/rooms/view_rooms.dart';
import 'package:university_management_system/ui/admin/students/view_students.dart';
import 'package:university_management_system/ui/admin/subjects/view_subjects.dart';
import 'package:university_management_system/ui/admin/teachers/view_teachers.dart';
import 'package:university_management_system/ui/admin/timeslots/view_timeslots.dart';
import 'package:university_management_system/ui/admin/timetable/timetable_page.dart';
import 'package:university_management_system/ui/admin/timetable/timetable_page_new.dart';
import 'package:university_management_system/ui/admin/timetable/timtable_assignment.dart';
import 'package:university_management_system/ui/admin/workload/workload_assignment.dart';
import 'package:university_management_system/ui/profile/user_profile.dart';
import 'package:university_management_system/ui/settings_screen.dart';

import '../../models/dashboard_model.dart';
import '../../models/user_model.dart';
import '../../utilities/shared_preference_manager.dart';
import 'admin_dashboard.dart';
import 'admin_profile.dart';
import 'attendance/select_attendance.dart';
import 'datesheet/datesheet_assignment.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  int _currentIndex = 0;
  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: AppAssets.backgroundColor,
          child: Stack(children: [
            SizedBox.expand(
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _currentIndex = index);
                },
                children: const <Widget>[
                  AdminDashboardNew(),
                  SelectAttendance(),
                  //TimeTablePage(),
                  TimeTablePageNew(),
                  SettingsScreen(),
                ],
              ),
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
                Container(padding: const EdgeInsets.all(10), height: 50, width: 50, child: Image.asset(AppAssets.main_app_logo, color: AppAssets.iconsTintDarkGreyColor,)),
                Expanded(child: Container(padding: const EdgeInsets.only(left: 20, right: 20), child: Center(child: Text("Dashboard", style: AppAssets.latoBold_textDarkColor_20)))),
                GestureDetector(onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AdminProfile()));
                }, child: Container(padding: const EdgeInsets.all(10), height: 50, width: 50, child: SvgPicture.asset(AppAssets.profileIcon, color: AppAssets.iconsTintDarkGreyColor,))),
              ],),
            ),
          ]),
        ),
      ),

        bottomNavigationBar: BottomNavyBar(
          selectedIndex: _currentIndex,
          showElevation: true, // use this to remove appBar's elevation
          onItemSelected: (index) => setState(() {
            _currentIndex = index;
            _pageController.animateToPage(index,
                duration: const Duration(milliseconds: 300), curve: Curves.ease);
          }),
          items: [
            BottomNavyBarItem(
              icon: Icon(Icons.home),
              title: Text('Home'),
              activeColor: Colors.blue,
              inactiveColor: AppAssets.textLightColor,
            ),
            BottomNavyBarItem(
                icon: Icon(Icons.calendar_month),
                title: Text('Attendance'),
                activeColor: Colors.blue,
                inactiveColor: AppAssets.textLightColor,
            ),
            BottomNavyBarItem(
                icon: Icon(Icons.more_time),
                title: Text('Time Table'),
                activeColor: Colors.blue,
                inactiveColor: AppAssets.textLightColor,
            ),
            BottomNavyBarItem(
                icon: Icon(Icons.settings),
                title: Text('Settings'),
                activeColor: Colors.blue,
                inactiveColor: AppAssets.textLightColor,
            ),
          ],
        )
    );
  }
}
