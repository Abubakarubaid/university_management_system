import 'dart:async';
import 'dart:math';

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:university_management_system/assets/app_assets.dart';
import 'package:university_management_system/ui/admin/timetable/timetable_page.dart';
import 'package:university_management_system/ui/settings_screen.dart';
import 'package:university_management_system/ui/teacher/teacher_dashboard.dart';
import 'package:university_management_system/ui/teacher/teacher_datesheet/fetch_datesheets.dart';
import 'package:university_management_system/ui/teacher/teacher_setting/teacher_settings_screen.dart';
import 'package:university_management_system/ui/teacher/teacher_timtable/teacher_timetable_page.dart';

class MainTeacherDashboard extends StatefulWidget {
  const MainTeacherDashboard({Key? key}) : super(key: key);

  @override
  State<MainTeacherDashboard> createState() => _MainTeacherDashboardState();
}

class _MainTeacherDashboardState extends State<MainTeacherDashboard> {

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
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _currentIndex = index);
                },
                children: const <Widget>[
                  TeacherDashboard(),
                  TeacherDatesheets(),
                  TeacherTimeTablePage(),
                  TeacherSettingsScreen(),
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
                Container(padding: const EdgeInsets.all(10), height: 50, width: 50, child: SvgPicture.asset(AppAssets.dashboardIcon, color: AppAssets.iconsTintDarkGreyColor,)),
                Expanded(child: Container(padding: const EdgeInsets.only(left: 20, right: 20), child: Center(child: Text("Dashboard", style: AppAssets.latoBold_textDarkColor_20)))),
                Container(padding: const EdgeInsets.all(10), height: 50, width: 50, ),
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
                title: Text('Date Sheet'),
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
