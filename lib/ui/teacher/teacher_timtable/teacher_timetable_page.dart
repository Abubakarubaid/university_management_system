import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:university_management_system/models/workload_model.dart';
import 'package:university_management_system/ui/admin/timetable/pdf/TimeTablePdfPreviewPage.dart';
import 'package:university_management_system/ui/admin/workload/pdf/PdfPreviewPage.dart';
import '../../../assets/app_assets.dart';
import '../../../models/dpt_model.dart';
import '../../../models/rooms_model.dart';
import '../../../models/teacher_model.dart';
import '../../../models/teacher_own_timetable_model.dart';
import '../../../models/timeslots_model.dart';
import '../../../models/user_model.dart';
import '../../../providers/app_provider.dart';
import '../../../utilities/constants.dart';
import '../../../utilities/shared_preference_manager.dart';
import '../../../widgets/no_data.dart';
import '../../../widgets/primary_search_field.dart';
import '../../../widgets/progress_bar.dart';
import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;

class TeacherTimeTablePage extends StatefulWidget {
  const TeacherTimeTablePage({Key? key}) : super(key: key);

  @override
  State<TeacherTimeTablePage> createState() => _TeacherTimeTablePageState();
}

class _TeacherTimeTablePageState extends State<TeacherTimeTablePage> {

  String authToken = "";
  List<TeacherOwnTimeTableModel> searchList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Constants.getAuthToken().then((value) {
      authToken = value;
    });

    getMyData();
  }

  void getMyData() async {
    await SharedPreferenceManager.getInstance().getUser().then((model) {
      Provider.of<AppProvider>(context, listen: false).fetchSingleTimeTable(model.userId, authToken);
    });
    setState(() {});
  }

  TextStyle unSelectedTextStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black45);
  TextStyle selectedTextStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppAssets.whiteColor);
  BoxDecoration unSelectedBoxDecoration = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 3,
            spreadRadius: 3,
            offset: const Offset(3,3)
        )]
  );
  BoxDecoration selectedBoxDecoration = BoxDecoration(
      color: AppAssets.primaryColor,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 3,
            spreadRadius: 3,
            offset: const Offset(3,3)
        )]
  );

  int selectedDay = 0;

  addFilter(String text){
    onFilterChange(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<AppProvider>(builder: (context, appProvider, child) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: AppAssets.backgroundColor,
            child: Stack(children: [
              Opacity(opacity: 0.1, child: Center(child: Image.asset(AppAssets.timetable_new,))),
              Container(
                height: double.infinity,
                margin: const EdgeInsets.only(top: 60, left: 20, right: 20),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 66,
                      margin: const EdgeInsets.only(top: 10),
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        child: Row(children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedDay = 0;
                                addFilter("All");
                              });
                            },
                            child: Container(
                              height: 50,
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                              margin: const EdgeInsets.only(right: 16),
                              decoration: selectedDay == 0 ? selectedBoxDecoration : unSelectedBoxDecoration,
                              child: Center(
                                child: Text("All", style: selectedDay == 0 ? selectedTextStyle : unSelectedTextStyle,),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedDay = 1;
                                addFilter("Monday");
                              });
                            },
                            child: Container(
                              height: 50,
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                              margin: const EdgeInsets.only(right: 16),
                              decoration: selectedDay == 1 ? selectedBoxDecoration : unSelectedBoxDecoration,
                              child: Center(
                                child: Text("Monday", style: selectedDay == 1 ? selectedTextStyle : unSelectedTextStyle,),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedDay = 2;
                                addFilter("Tuesday");
                              });
                            },
                            child: Container(
                              height: 50,
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                              margin: const EdgeInsets.only(right: 16),
                              decoration: selectedDay == 2 ? selectedBoxDecoration : unSelectedBoxDecoration,
                              child: Center(
                                child: Text("Tuesday", style: selectedDay == 2 ? selectedTextStyle : unSelectedTextStyle,),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedDay = 3;
                                addFilter("Wednesday");
                              });
                            },
                            child: Container(
                              height: 50,
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                              margin: const EdgeInsets.only(right: 16),
                              decoration: selectedDay == 3 ? selectedBoxDecoration : unSelectedBoxDecoration,
                              child: Center(
                                child: Text("Wednesday", style: selectedDay == 3 ? selectedTextStyle : unSelectedTextStyle,),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedDay = 4;
                                addFilter("Thursday");
                              });
                            },
                            child: Container(
                              height: 50,
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                              margin: const EdgeInsets.only(right: 16),
                              decoration: selectedDay == 4 ? selectedBoxDecoration : unSelectedBoxDecoration,
                              child: Center(
                                child: Text("Thursday", style: selectedDay == 4 ? selectedTextStyle : unSelectedTextStyle,),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedDay = 5;
                                addFilter("Friday");
                              });
                            },
                            child: Container(
                              height: 50,
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                              margin: const EdgeInsets.only(right: 16),
                              decoration: selectedDay == 5 ? selectedBoxDecoration : unSelectedBoxDecoration,
                              child: Center(
                                child: Text("Friday", style: selectedDay == 5 ? selectedTextStyle : unSelectedTextStyle,),
                              ),
                            ),
                          ),
                        ]),
                      ),
                    ),
                    Expanded(child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: appProvider.progress ?
                      const Center(child: SizedBox(height: 80, child: ProgressBarWidget(),)) :
                      searchList.isEmpty && selectedDay != 0 ? Container() :
                      searchList.isNotEmpty ?
                      ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: searchList.length,
                        itemBuilder: (context, index) =>
                            Container(
                              clipBehavior: Clip.antiAlias,
                              margin: index == searchList.length-1 ? const EdgeInsets.only(top: 20, bottom: 30) : const EdgeInsets.only(top: 20),
                              width: double.infinity,
                              height: 200,
                              decoration: BoxDecoration(
                                  color: AppAssets.whiteColor,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [BoxShadow(
                                    spreadRadius: 5,
                                    blurRadius: 5,
                                    offset: const Offset(0,3),
                                    color: AppAssets.shadowColor.withOpacity(0.5),
                                  )]
                              ),
                              child: Banner(
                                location: BannerLocation.topEnd,
                                message: searchList[index].workloadAssignmentModel.workDemanded == "Demanded" ? "Demanded" : "Free",
                                color: searchList[index].workloadAssignmentModel.workDemanded == "Demanded" ? Colors.red : Colors.green,
                                child: Stack(children: [
                                  Container(padding: const EdgeInsets.all(20), child: Opacity(opacity: 0.04, child: Align(alignment: Alignment.centerRight, child: Image.asset(AppAssets.workloadIcon,)))),
                                  Row(children: [
                                    Container(
                                      width: 10,
                                      height: double.infinity,
                                      color: AppAssets.primaryColor,
                                    ),
                                    Expanded(child: Container(
                                      height: double.infinity,
                                      padding: const EdgeInsets.all(12),
                                      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                                        Row(children: [
                                          const Icon(Icons.class_, color: AppAssets.textLightColor,),
                                          const SizedBox(width: 8,),
                                          Expanded(child: Text("${searchList[index].workloadAssignmentModel.classModel.className} ${searchList[index].workloadAssignmentModel.classModel.classSemester} ${searchList[index].workloadAssignmentModel.classModel.classType}", style: AppAssets.latoBold_textDarkColor_16, maxLines: 1, overflow: TextOverflow.ellipsis,)),
                                        ],),
                                        const SizedBox(height: 8,),
                                        Row(children: [
                                          const SizedBox(width: 6,),
                                          Text("Subject Code: ", style: AppAssets.latoBold_textDarkColor_14, maxLines: 1, overflow: TextOverflow.ellipsis,),
                                          const SizedBox(width: 8,),
                                          Expanded(child: Text(searchList[index].workloadAssignmentModel.subjectModel.subjectCode, style: AppAssets.latoRegular_textDarkColor_14, maxLines: 1, overflow: TextOverflow.ellipsis,)),
                                        ],),
                                        const SizedBox(height: 8,),
                                        Row(crossAxisAlignment: CrossAxisAlignment.start,children: [
                                          const SizedBox(width: 6,),
                                          Text("Subject Name: ", style: AppAssets.latoBold_textDarkColor_14, maxLines: 1, overflow: TextOverflow.ellipsis,),
                                          const SizedBox(width: 8,),
                                          Expanded(child: Text(searchList[index].workloadAssignmentModel.subjectModel.subjectName, style: AppAssets.latoRegular_textDarkColor_14, maxLines: 2, overflow: TextOverflow.ellipsis,)),
                                        ],),
                                        const SizedBox(height: 8,),
                                        Row(children: [
                                          const SizedBox(width: 6,),
                                          Text("Time Slot: ", style: AppAssets.latoBold_textDarkColor_14, maxLines: 1, overflow: TextOverflow.ellipsis,),
                                          const SizedBox(width: 8,),
                                          Expanded(child: Text(searchList[index].timeSlotsModel.timeslot, style: AppAssets.latoRegular_textDarkColor_14, maxLines: 1, overflow: TextOverflow.ellipsis,)),
                                        ],),
                                        const SizedBox(height: 8,),
                                        Row(children: [
                                          const SizedBox(width: 6,),
                                          Text("Room No: ", style: AppAssets.latoBold_textDarkColor_14, maxLines: 1, overflow: TextOverflow.ellipsis,),
                                          const SizedBox(width: 8,),
                                          Expanded(child: Text(searchList[index].roomsModel.roomName, style: AppAssets.latoRegular_textDarkColor_14, maxLines: 1, overflow: TextOverflow.ellipsis,)),
                                        ],),
                                        const SizedBox(height: 8,),
                                        Expanded(
                                          child: Row(crossAxisAlignment: CrossAxisAlignment.start,children: [
                                            const Icon(Icons.subject, color: AppAssets.textLightColor,),
                                            const SizedBox(width: 8,),
                                            Expanded(child: Text(searchList[index].workloadAssignmentModel.departmentModel.departmentName, style: AppAssets.latoRegular_textDarkColor_14, maxLines: 2, overflow: TextOverflow.ellipsis,)),
                                            const SizedBox(width: 6,),
                                          ],),
                                        ),
                                      ],),
                                    )),
                                    Container(
                                      width: 10,
                                      height: double.infinity,
                                      color: AppAssets.primaryColor,
                                    ),
                                  ],),
                                ],),
                              ),
                            ),
                      ) :
                      ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: appProvider.teacherTimeTableList.length,
                        itemBuilder: (context, index) =>
                            Container(
                              clipBehavior: Clip.antiAlias,
                              margin: index == appProvider.teacherTimeTableList.length-1 ? const EdgeInsets.only(top: 20, bottom: 30) : const EdgeInsets.only(top: 20),
                              width: double.infinity,
                              height: 200,
                              decoration: BoxDecoration(
                                  color: AppAssets.whiteColor,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [BoxShadow(
                                    spreadRadius: 5,
                                    blurRadius: 5,
                                    offset: const Offset(0,3),
                                    color: AppAssets.shadowColor.withOpacity(0.5),
                                  )]
                              ),
                              child: Banner(
                                location: BannerLocation.topEnd,
                                message: appProvider.teacherTimeTableList[index].workloadAssignmentModel.workDemanded == "Demanded" ? "Demanded" : "Free",
                                color: appProvider.teacherTimeTableList[index].workloadAssignmentModel.workDemanded == "Demanded" ? Colors.red : Colors.green,
                                child: Stack(children: [
                                  Container(padding: const EdgeInsets.all(20), child: Opacity(opacity: 0.04, child: Align(alignment: Alignment.centerRight, child: Image.asset(AppAssets.workloadIcon,)))),
                                  Row(children: [
                                    Container(
                                      width: 10,
                                      height: double.infinity,
                                      color: AppAssets.primaryColor,
                                    ),
                                    Expanded(child: Container(
                                      height: double.infinity,
                                      padding: const EdgeInsets.all(12),
                                      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                                        Row(children: [
                                          const Icon(Icons.class_, color: AppAssets.textLightColor,),
                                          const SizedBox(width: 8,),
                                          Expanded(child: Text("${appProvider.teacherTimeTableList[index].workloadAssignmentModel.classModel.className} ${appProvider.teacherTimeTableList[index].workloadAssignmentModel.classModel.classSemester} ${appProvider.teacherTimeTableList[index].workloadAssignmentModel.classModel.classType}", style: AppAssets.latoBold_textDarkColor_16, maxLines: 1, overflow: TextOverflow.ellipsis,)),
                                        ],),
                                        const SizedBox(height: 8,),
                                        Row(children: [
                                          const SizedBox(width: 6,),
                                          Text("Subject Code: ", style: AppAssets.latoBold_textDarkColor_14, maxLines: 1, overflow: TextOverflow.ellipsis,),
                                          const SizedBox(width: 8,),
                                          Expanded(child: Text(appProvider.teacherTimeTableList[index].workloadAssignmentModel.subjectModel.subjectCode, style: AppAssets.latoRegular_textDarkColor_14, maxLines: 1, overflow: TextOverflow.ellipsis,)),
                                        ],),
                                        const SizedBox(height: 8,),
                                        Row(crossAxisAlignment: CrossAxisAlignment.start,children: [
                                          const SizedBox(width: 6,),
                                          Text("Subject Name: ", style: AppAssets.latoBold_textDarkColor_14, maxLines: 1, overflow: TextOverflow.ellipsis,),
                                          const SizedBox(width: 8,),
                                          Expanded(child: Text(appProvider.teacherTimeTableList[index].workloadAssignmentModel.subjectModel.subjectName, style: AppAssets.latoRegular_textDarkColor_14, maxLines: 2, overflow: TextOverflow.ellipsis,)),
                                        ],),
                                        const SizedBox(height: 8,),
                                        Row(children: [
                                          const SizedBox(width: 6,),
                                          Text("Time Slot: ", style: AppAssets.latoBold_textDarkColor_14, maxLines: 1, overflow: TextOverflow.ellipsis,),
                                          const SizedBox(width: 8,),
                                          Expanded(child: Text(appProvider.teacherTimeTableList[index].timeSlotsModel.timeslot, style: AppAssets.latoRegular_textDarkColor_14, maxLines: 1, overflow: TextOverflow.ellipsis,)),
                                        ],),
                                        const SizedBox(height: 8,),
                                        Row(children: [
                                          const SizedBox(width: 6,),
                                          Text("Room No: ", style: AppAssets.latoBold_textDarkColor_14, maxLines: 1, overflow: TextOverflow.ellipsis,),
                                          const SizedBox(width: 8,),
                                          Expanded(child: Text(appProvider.teacherTimeTableList[index].roomsModel.roomName, style: AppAssets.latoRegular_textDarkColor_14, maxLines: 1, overflow: TextOverflow.ellipsis,)),
                                        ],),
                                        const SizedBox(height: 8,),
                                        Expanded(
                                          child: Row(crossAxisAlignment: CrossAxisAlignment.start,children: [
                                            const Icon(Icons.subject, color: AppAssets.textLightColor,),
                                            const SizedBox(width: 8,),
                                            Expanded(child: Text(appProvider.teacherTimeTableList[index].workloadAssignmentModel.departmentModel.departmentName, style: AppAssets.latoRegular_textDarkColor_14, maxLines: 2, overflow: TextOverflow.ellipsis,)),
                                            const SizedBox(width: 6,),
                                          ],),
                                        ),
                                      ],),
                                    )),
                                    Container(
                                      width: 10,
                                      height: double.infinity,
                                      color: AppAssets.primaryColor,
                                    ),
                                  ],),
                                ],),
                              ),
                            ),
                      ),
                    )),
                  ],
                ),
              ),
            ]),
          );
        })
      ),
    );
  }

  onFilterChange(String text) async {
    //print("______: ${Provider.of<AppProvider>(context, listen: false).teacherTimeTableList.length}");
    setState(() {searchList.clear();});
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    if(text.toLowerCase().isEmpty){
      setState(() {searchList.clear();});
      return;
    }


    Provider.of<AppProvider>(context, listen: false).teacherTimeTableList.forEach((data) {
      print("______: ${text} , ${data.day}");
      if (data.day.toLowerCase() == text.toLowerCase()) {
        setState(() {searchList.add(data);});
      }
    });
    print("______: ${searchList.length}");
  }
}
