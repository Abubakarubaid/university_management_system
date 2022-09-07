import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:university_management_system/models/workload_model.dart';
import 'package:university_management_system/ui/admin/timetable/pdf/TimeTablePdfPreviewPage.dart';
import 'package:university_management_system/ui/admin/timetable/timtable_assignment.dart';
import 'package:university_management_system/ui/admin/workload/pdf/PdfPreviewPage.dart';
import '../../../assets/app_assets.dart';
import '../../../models/dpt_model.dart';
import '../../../models/rooms_model.dart';
import '../../../models/teacher_model.dart';
import '../../../models/timeslots_model.dart';
import '../../../models/user_model.dart';
import '../../../providers/app_provider.dart';
import '../../../utilities/base/my_message.dart';
import '../../../utilities/constants.dart';
import '../../../widgets/no_data.dart';
import '../../../widgets/primary_button.dart';
import '../../../widgets/primary_search_field.dart';
import '../../../widgets/progress_bar.dart';
import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;

class TimeTablePage extends StatefulWidget {
  const TimeTablePage({Key? key}) : super(key: key);

  @override
  State<TimeTablePage> createState() => _TimeTablePageState();
}

class _TimeTablePageState extends State<TimeTablePage> {

  var searchController = TextEditingController();

  String authToken = "";
  List<DepartmentModel> departmentList = [];
  DepartmentModel dptSelectedValue = DepartmentModel(departmentId: 0, departmentName: "Select Department", departmentType: "Demo");
  var departmentItems;

  bool progressData = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Provider.of<AppProvider>(context, listen: false).departmentList.clear();

    Constants.getAuthToken().then((value) {
      authToken = value;
    });

    getDepartments(false);
  }

  void getDepartments(bool specific) async {
    if(!specific){
      Provider.of<AppProvider>(context, listen: false).fetchAllDepartments(Constants.getAuthToken().toString()).then((value) {
        setState(() {
          if(value.isSuccess){
            departmentList.clear();
            departmentList = Provider.of<AppProvider>(context, listen: false).departmentList;
            departmentList.add(dptSelectedValue);
            departmentList.sort((a, b) => a.departmentId.compareTo(b.departmentId));

            departmentItems = departmentList.map((item) {
              return DropdownMenuItem<DepartmentModel>(
                child: Text(item.departmentName),
                value: item,
              );
            }).toList();

            // if list is empty, create a dummy item
            if (departmentItems.isEmpty) {
              departmentItems = [
                DropdownMenuItem(
                  child: Text(dptSelectedValue.departmentName),
                  value: dptSelectedValue,
                )
              ];
            }else{
              dptSelectedValue = departmentList[0];
            }
          }
        });
      });
    }
    else{
      setState(() {
        dptSelectedValue = departmentList[0];
      });
    }

  }

  getTeachers() async {
    Provider.of<AppProvider>(context, listen: false).fetchAllTeachers(true, "teacher", authToken).then((value) {
      if(value.isSuccess){
        getRooms();
      }
    });
  }

  getRooms() async {
    Provider.of<AppProvider>(context, listen: false).fetchAllRooms(authToken).then((value) {
      if(value.isSuccess){
        getTimeSlots();
      }
    });
  }

  getTimeSlots() async {
    Provider.of<AppProvider>(context, listen: false).fetchAllTimeSlots(authToken).then((value) {
      if(value.isSuccess){
        getWorkloads();
      }
    });
  }

  getWorkloads() async {
    Provider.of<AppProvider>(context, listen: false).fetchAttendanceWorkload(dptSelectedValue, authToken);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<AppProvider>(builder: (context, appProvider, child) {

          appProvider.checkUploadingData().then((value) {
            if(value.isSuccess){
              progressData = true;
            }else{
              progressData = false;
            }
          });

          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: AppAssets.backgroundColor,
            child: Stack(children: [
              Opacity(opacity: 0.05, child: Center(child: Image.asset(AppAssets.workloadIcon,))),
              Container(
                height: double.infinity,
                margin: const EdgeInsets.only(top: 60, left: 20, right: 20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            height: 50,
                            margin: const EdgeInsets.only(top: 20),
                            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AppAssets.whiteColor,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppAssets.textLightColor, width: 1),
                              boxShadow: [
                                BoxShadow(
                                  color: AppAssets.shadowColor.withOpacity(0.5),
                                  spreadRadius: 4,
                                  blurRadius: 8,
                                  offset: const Offset(0, 6),
                                )],
                            ),
                            child: DropdownButton<DepartmentModel>(
                              value: dptSelectedValue,
                              icon: const Icon(Icons.arrow_drop_down),
                              underline: Container(
                                height: 0,
                                color: Colors.transparent,
                              ),
                              isExpanded: true,
                              onChanged: (value) {
                                setState(() {
                                  dptSelectedValue = value!;
                                  if(dptSelectedValue.departmentId != 0){
                                    getTeachers();
                                  }
                                });
                              },
                              items: departmentItems,
                            ),
                          ),
                        ),
                        GestureDetector(
                            onTap: () async {
                              /*setState(() {
                              dptSelectedValue = departmentList[0];
                            });*/
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => TimeTablePdfPreviewPage(workloadList: appProvider.workloadList, teachersList: appProvider.teacherList, roomsList: appProvider.roomList, slotsList: appProvider.timeSlotList,)));
                            },
                            child: Container(alignment: Alignment.center, padding: const EdgeInsets.all(10), margin: const EdgeInsets.only(top: 20), height: 50, width: 50, child: Center(child: Icon(Icons.picture_as_pdf, color: Colors.blue,)))),
                      ],
                    ),
                    Visibility(
                      visible: progressData,
                      child: PrimaryButton(
                        width: double.infinity,
                        height: 50,
                        buttonMargin: const EdgeInsets.only(top: 20, bottom: 10),
                        buttonPadding: const EdgeInsets.all(12),
                        buttonText: "Upload Time Table",
                        buttonTextStyle: AppAssets.latoBold_whiteColor_16,
                        shadowColor: AppAssets.shadowColor,
                        buttonRadius: BorderRadius.circular(30),
                        onPress: () async {
                          await SharedPreferences.getInstance().then((pref) {
                            String model = pref.getString("time_table_bulk_data").toString();
                            Provider.of<AppProvider>(context, listen: false)
                                .addBulkTimeTable(model, authToken)
                                .then((value) {
                              if (value.isSuccess) {
                                setState(() {
                                  pref.setString("time_table_bulk_data", "");
                                });
                                MyMessage.showSuccessMessage(value.message, context);
                              } else {
                                MyMessage.showFailedMessage(value.message, context);
                              }
                            });
                          });
                        }
                      ),
                    ),
                    Expanded(
                      child: appProvider.progress ?
                      const Center(child: SizedBox(height: 80, child: ProgressBarWidget(),)) :
                      appProvider.workloadList.isEmpty ?
                      const NoDataFound() :
                      ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: appProvider.workloadList.length,
                        itemBuilder: (context, index) =>
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => TimeTableAssignment(workloadModel: appProvider.workloadList[index],)));
                              },
                              child: Container(
                                clipBehavior: Clip.antiAlias,
                                margin: index == appProvider.workloadList.length-1 ? const EdgeInsets.only(top: 20, bottom: 30) : const EdgeInsets.only(top: 20),
                                width: double.infinity,
                                height: 180,
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
                                  message: appProvider.workloadList[index].workDemanded == "Demanded" ? "Demanded" : "Free",
                                  color: appProvider.workloadList[index].workDemanded == "Demanded" ? Colors.red : Colors.green,
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
                                            Expanded(child: Text("${appProvider.workloadList[index].classModel.className} ${appProvider.workloadList[index].classModel.classSemester} ${appProvider.workloadList[index].classModel.classType}", style: AppAssets.latoBold_textDarkColor_16, maxLines: 1, overflow: TextOverflow.ellipsis,)),
                                          ],),
                                          const SizedBox(height: 8,),
                                          Row(children: [
                                            const SizedBox(width: 6,),
                                            Text("Subject Code: ", style: AppAssets.latoBold_textDarkColor_14, maxLines: 1, overflow: TextOverflow.ellipsis,),
                                            const SizedBox(width: 8,),
                                            Expanded(child: Text(appProvider.workloadList[index].subjectModel.subjectCode, style: AppAssets.latoRegular_textDarkColor_14, maxLines: 1, overflow: TextOverflow.ellipsis,)),
                                          ],),
                                          const SizedBox(height: 8,),
                                          Row(crossAxisAlignment: CrossAxisAlignment.start,children: [
                                            const SizedBox(width: 6,),
                                            Text("Subject Name: ", style: AppAssets.latoBold_textDarkColor_14, maxLines: 1, overflow: TextOverflow.ellipsis,),
                                            const SizedBox(width: 8,),
                                            Expanded(child: Text(appProvider.workloadList[index].subjectModel.subjectName, style: AppAssets.latoRegular_textDarkColor_14, maxLines: 2, overflow: TextOverflow.ellipsis,)),
                                          ],),
                                          const SizedBox(height: 8,),
                                          Row(children: [
                                            const SizedBox(width: 6,),
                                            Text("Teacher: ", style: AppAssets.latoBold_textDarkColor_14, maxLines: 1, overflow: TextOverflow.ellipsis,),
                                            const SizedBox(width: 8,),
                                            Expanded(child: Text(appProvider.workloadList[index].userModel.userName, style: AppAssets.latoRegular_textDarkColor_14, maxLines: 1, overflow: TextOverflow.ellipsis,)),
                                          ],),
                                          const SizedBox(height: 8,),
                                          Expanded(
                                            child: Row(crossAxisAlignment: CrossAxisAlignment.start,children: [
                                              const Icon(Icons.subject, color: AppAssets.textLightColor,),
                                              const SizedBox(width: 8,),
                                              Expanded(child: Text(appProvider.workloadList[index].departmentModel.departmentId == appProvider.workloadList[index].subDepartmentModel.departmentId ? "${appProvider.workloadList[index].subDepartmentModel.departmentName} (own)" : "${appProvider.workloadList[index].subDepartmentModel.departmentName} (other)", style: AppAssets.latoRegular_textDarkColor_14, maxLines: 2, overflow: TextOverflow.ellipsis,)),
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
                      ),
                    ),
                  ],
                ),
              ),
              /*Container(
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
                Expanded(child: Container(padding: const EdgeInsets.only(left: 20, right: 20), child: Center(child: Text("Time Table", style: AppAssets.latoBold_textDarkColor_20)))),
                GestureDetector(
                    onTap: () async {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => TimeTablePdfPreviewPage(workloadList: appProvider.workloadList, teachersList: appProvider.teacherList, roomsList: appProvider.roomList, slotsList: appProvider.timeSlotList,)));
                    },
                    child: Container(padding: const EdgeInsets.all(10), height: 50, width: 50, child: Icon(Icons.picture_as_pdf, color: Colors.blue,))),
              ],),
            ),*/
            ]),
          );
        }),
      ),
    );
  }
}
