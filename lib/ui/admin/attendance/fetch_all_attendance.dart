import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:university_management_system/models/subject_model.dart';
import 'package:university_management_system/models/user_model_attendance.dart';
import 'package:university_management_system/ui/admin/attendance/pdf/attendance_pdf_preview_age.dart';

import '../../../assets/app_assets.dart';
import '../../../models/attendance_model.dart';
import '../../../models/attendence_complete_model.dart';
import '../../../models/user_model.dart';
import '../../../models/user_small_model.dart';
import '../../../models/workload_assignment_model.dart';
import '../../../providers/app_provider.dart';
import '../../../utilities/base/my_message.dart';
import '../../../utilities/constants.dart';
import '../../../widgets/no_data.dart';
import '../../../widgets/primary_dropdown_field.dart';
import '../../../widgets/progress_bar.dart';
import 'admin_attendance_details.dart';

class FetchAllAttendance extends StatefulWidget {
  WorkloadAssignmentModel workloadModel;
  FetchAllAttendance({required this.workloadModel, Key? key}) : super(key: key);

  @override
  State<FetchAllAttendance> createState() => _FetchAllAttendanceState();
}

class _FetchAllAttendanceState extends State<FetchAllAttendance> {

  String authToken = "";
  List<UserModel> usersList = [];

  @override
  void initState() {
    super.initState();

    Constants.getAuthToken().then((value) {
      authToken = value;
    });

    getAttendances();
  }

  void getAttendances() async {
    Provider.of<AppProvider>(context, listen: false).fetchAttendance(widget.workloadModel.workloadId, authToken).then((value) {
      if(value.isSuccess){
        addData(Provider.of<AppProvider>(context, listen: false).attendanceList);
      }
    });
  }

  addData(List<AttendanceCompleteModel> data) {
    if(data.isNotEmpty){
      data[0].presentStudents.forEach((element) {
        usersList.add(element);
      });
      data[0].absentStudents.forEach((element) {
        usersList.add(element);
      });
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<AppProvider>(builder: (context, appProvider, child) => Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: AppAssets.backgroundColor,
          child: Stack(children: [
            Opacity(opacity: 0.05, child: Center(child: Image.asset(AppAssets.attendanceColoredIcon,))),
            Container(
              height: double.infinity,
              margin: const EdgeInsets.only(top: 60, left: 20, right: 20),
              child: appProvider.progress ?
              const Center(child: SizedBox(height: 80, child: ProgressBarWidget(),)) :
              appProvider.attendanceList.isEmpty ?
              const NoDataFound() :
              ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: appProvider.attendanceList.length,
                itemBuilder: (context, index) =>
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => AdminAttendanceDetails(attendanceCompleteModel: appProvider.attendanceList[index], completeList:  appProvider.attendanceList,)));
                      },
                      child: Container(
                        clipBehavior: Clip.antiAlias,
                        margin: index == appProvider.attendanceList.length-1 ? const EdgeInsets.only(top: 20, bottom: 30) : const EdgeInsets.only(top: 20),
                        width: double.infinity,
                        height: 150,
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
                        child: Stack(children: [
                          Container(padding: EdgeInsets.all(20), child: Opacity(opacity: 0.06, child: Align(alignment: Alignment.centerRight, child: Image.asset(AppAssets.attendanceColoredIcon,)))),
                          Row(children: [
                            Container(
                              width: 100,
                              height: double.infinity,
                              color: AppAssets.primaryColor,
                              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                Text("${DateFormat('yyyy-MM-dd').parse(appProvider.attendanceList[index].attendanceDate).day}", style: AppAssets.latoBold_whiteColor_26, maxLines: 1, overflow: TextOverflow.ellipsis,),
                                Text("${DateFormat().add_MMM().format(DateFormat('yyyy-MM-dd').parse(appProvider.attendanceList[index].attendanceDate))}", style: AppAssets.latoRegular_whiteColor_20, maxLines: 1, overflow: TextOverflow.ellipsis,),
                                const SizedBox(height: 30,),
                                Text("${DateFormat().add_jm().format(DateFormat('hh:mm:s a').parse(appProvider.attendanceList[index].attendanceTime))}", style: AppAssets.latoRegular_whiteColor_16, maxLines: 1, overflow: TextOverflow.ellipsis,),
                              ],),
                            ),
                            Expanded(child: Container(
                              height: double.infinity,
                              padding: const EdgeInsets.all(12),
                              child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                                Row(children: [
                                  const Icon(Icons.class_, color: AppAssets.textLightColor,),
                                  const SizedBox(width: 8,),
                                  Expanded(child: Text("${appProvider.attendanceList[index].workloadAssignmentModel.classModel.className} ${appProvider.attendanceList[index].workloadAssignmentModel.classModel.classSemester} ${appProvider.attendanceList[index].workloadAssignmentModel.classModel.classType}", style: AppAssets.latoRegular_textDarkColor_14, maxLines: 1, overflow: TextOverflow.ellipsis,)),
                                ],),
                                const SizedBox(height: 8,),
                                Expanded(
                                  child: Row(children: [
                                    const Icon(Icons.subject, color: AppAssets.textLightColor,),
                                    const SizedBox(width: 8,),
                                    Expanded(child: Text(appProvider.attendanceList[index].workloadAssignmentModel.departmentModel.departmentName, style: AppAssets.latoRegular_textDarkColor_14, maxLines: 2, overflow: TextOverflow.ellipsis,)),
                                  ],),
                                ),
                                const SizedBox(height: 8,),
                                Row(children: [
                                  const SizedBox(width: 6,),
                                  Text("Present: ", style: AppAssets.latoBold_textDarkColor_14, maxLines: 1, overflow: TextOverflow.ellipsis,),
                                  const SizedBox(width: 8,),
                                  Text(appProvider.attendanceList[index].presentStudents.length.toString(), style: AppAssets.latoBold_textDarkColor_14, maxLines: 1, overflow: TextOverflow.ellipsis,),
                                ],),
                                const SizedBox(height: 8,),
                                Row(children: [
                                  const SizedBox(width: 6,),
                                  Text("Absent: ", style: AppAssets.latoBold_textDarkColor_14, maxLines: 1, overflow: TextOverflow.ellipsis,),
                                  const SizedBox(width: 8,),
                                  Text(appProvider.attendanceList[index].absentStudents.length.toString(), style: AppAssets.latoBold_textDarkColor_14, maxLines: 1, overflow: TextOverflow.ellipsis,),
                                ],),
                              ],),
                            )),
                          ],),
                        ],),
                      ),
                    ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 60,
              padding: const EdgeInsets.only(left: 0, right: 10),
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
                GestureDetector(onTap: () {Navigator.of(context).pop();}, child: Container(padding: const EdgeInsets.all(16), height: 50, width: 50, child: SvgPicture.asset(AppAssets.backArrowIcon, color: AppAssets.iconsTintDarkGreyColor,))),
                Expanded(child: Container(padding: const EdgeInsets.only(left: 20, right: 20), child: Center(child: Text("All Attendance", style: AppAssets.latoBold_textDarkColor_20)))),
                Visibility(
                  visible: appProvider.attendanceList.isNotEmpty,
                  child: GestureDetector(
                      onTap: () async {
                        usersList.sort((a, b) => a.userName.compareTo(b.userName));
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => AttendancePdfPreview(detailsList: appProvider.attendanceList, allStudents: usersList,)));
                      },
                      child: Container(padding: const EdgeInsets.all(10), height: 50, width: 50, child: Icon(Icons.picture_as_pdf, color: Colors.blue,))),
                ),
              ],),
            ),
          ]),
        ),)
      ),
    );
  }
}
