import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:university_management_system/assets/app_assets.dart';
import 'package:university_management_system/models/quotes_model.dart';
import 'package:university_management_system/models/user_model.dart';
import 'package:university_management_system/providers/app_provider.dart';
import 'package:university_management_system/ui/teacher/teacher_attendance/teacher_attendance.dart';
import 'package:university_management_system/ui/teacher/teacher_profile/teacher_profile.dart';
import 'package:university_management_system/ui/teacher/teacher_subjects/teacher_subjects.dart';
import 'package:university_management_system/ui/teacher/teacher_workload/fetch_teacher_workloads.dart';

import '../../utilities/constants.dart';
import '../../utilities/shared_preference_manager.dart';
import '../../widgets/no_data.dart';
import '../../widgets/progress_bar.dart';

class TeacherDashboard extends StatefulWidget {
  const TeacherDashboard({Key? key}) : super(key: key);

  @override
  State<TeacherDashboard> createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> {

  var quotesList = [
    QuotesModel("The purpose of our lives is to be happy", "_Dalai Lama"),
    QuotesModel("Life is what happens when you're busy making other plans", "_John Lennon"),
    QuotesModel("Get busy living or get busy dying", "_Stephen King"),
    QuotesModel("You only live once, but if you do it right, once is enough", "_Mae West"),
    QuotesModel("Many of life’s failures are people who did not realize how close they were to success when they gave up", "_Thomas A. Edison"),
  ];

  int randomNumber = 0;
  Timer? quotesTimer;

  UserModel myData = UserModel.getInstance();
  String authToken = "";

  @override
  void initState() {
    super.initState();

    Constants.getAuthToken().then((value) {
      authToken = value;
    });

    randomNumber = Random().nextInt(quotesList.length);
    quotesTimer = Timer.periodic(const Duration(seconds: 5), (Timer t) {
      setState(() {
        getRandomQuote();
      });
    });

    getMyData(false);

  }

  void getTeacherData() async {
    Provider.of<AppProvider>(context, listen: false).fetchSpecificTeacher("teacher", myData.userId, authToken);
  }

  void getMyData(bool check) async {
    await SharedPreferenceManager.getInstance().getUser().then((model) {
      myData = model;
      if(!check){
        getTeacherData();
      }
    });
    setState(() {});
  }

  void getRandomQuote() {
    setState(() {
      randomNumber = Random().nextInt(quotesList.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Consumer<AppProvider>(builder: (context, appProvider, child) {
            getMyData(true);
            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: AppAssets.backgroundColor,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    /*Container(
                      width: double.infinity,
                      height: 50,
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
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const TeacherProfile()));
                        }, child: Container(padding: const EdgeInsets.all(10), height: 50, width: 50, child: SvgPicture.asset(AppAssets.profileIcon, color: AppAssets.iconsTintDarkGreyColor,))),
                      ],),
                    ),*/
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(top: 80, left: 20, right: 20),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text("Hi ${myData.userName}", style: AppAssets.latoBold_textLightColor_20,),
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
                            ],),
                          ),
                        ],),
                      ),
                    ],),
                    Container(
                      height: 130,
                      width: double.infinity,
                      margin: const EdgeInsets.only(top: 40, left: 22, right: 22),
                      child: appProvider.progress ?
                      const Center(child: SizedBox(height: 80, child: ProgressBarWidget(),)) :
                      appProvider.singleTeacherModel.userModel.userId == 0 ?
                      const NoDataFound() :
                      Row(children: [
                        Expanded(child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => TeacherSubjects(teacherModel: appProvider.singleTeacherModel,)));
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
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => TeacherAttendance(teacherModel: appProvider.singleTeacherModel,)));
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
                                        colors: [AppAssets.darkYellowColor, AppAssets.lightYellowColor],
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
                        const SizedBox(width: 20,),
                        Expanded(child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => TeacherWorkload(teacherModel: appProvider.singleTeacherModel,)));
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
                                        colors: [AppAssets.lightBlueColor1, AppAssets.lightBlueColor2],
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
                      width: double.infinity,
                      height: 180,
                      padding: const EdgeInsets.all(18),
                      margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 22),
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
                        Text("Motivational Quotes", style: AppAssets.latoBold_textLightColor_16,),
                        Expanded(child: Center(child: Text(quotesList[randomNumber].quoteTitle, style: AppAssets.latoBold_textDarkColor_16, maxLines: 5, overflow: TextOverflow.ellipsis,))),
                        Align(alignment: Alignment.bottomRight, child: Text(quotesList[randomNumber].quoteAuthor, style: AppAssets.latoRegular_textLightColor_12,)),
                      ],),
                    ),
                  ],),
              ),
            );
          }),
      ),
    );
  }
}
