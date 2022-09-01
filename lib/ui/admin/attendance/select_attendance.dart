import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:university_management_system/models/subject_model.dart';
import 'package:university_management_system/ui/admin/attendance/attendance_workloads.dart';
import 'package:university_management_system/ui/teacher/teacher_attendance/fetch_attendance.dart';
import 'package:university_management_system/ui/teacher/teacher_subjects/teacher_classes.dart';
import 'package:university_management_system/widgets/no_data.dart';
import 'package:university_management_system/widgets/primary_button.dart';
import 'package:university_management_system/widgets/primary_text_field.dart';
import '../../../assets/app_assets.dart';
import '../../../models/class_model.dart';
import '../../../models/dpt_model.dart';
import '../../../providers/app_provider.dart';
import '../../../utilities/base/my_message.dart';
import '../../../utilities/constants.dart';
import '../../../widgets/primary_dropdown_field.dart';
import '../../../widgets/progress_bar.dart';
import 'fetch_all_attendance.dart';

class SelectAttendance extends StatefulWidget {
  const SelectAttendance({Key? key}) : super(key: key);

  @override
  State<SelectAttendance> createState() => _SelectAttendanceState();
}

class _SelectAttendanceState extends State<SelectAttendance> {

  List<DepartmentModel> departmentList = [];
  DepartmentModel dptSelectedValue = DepartmentModel(departmentId: 0, departmentName: "Select Department", departmentType: "Demo");
  var departmentItems;

  String authToken = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Constants.getAuthToken().then((value) {
      authToken = value;
    });

    getDepartments();
  }

  void getDepartments() async {
    Provider.of<AppProvider>(context, listen: false).fetchAllDepartments(authToken).then((value) {
      if(value.isSuccess){

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
      }else{
        dptSelectedValue = departmentList[0];
      }
    });
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
              margin: const EdgeInsets.only(top: 0),
              padding: const EdgeInsets.only(left: 30, right: 30, top: 30),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Image.asset(AppAssets.attendanceColoredIcon, width: 100, height: 100,),
                const SizedBox(height: 50,),
                Text("Please Select Department, Class & Subject to Mark Attendance", textAlign: TextAlign.center, style: AppAssets.latoBold_textDarkColor_20,),
                const SizedBox(height: 50,),
                Container(
                  width: double.infinity,
                  height: 50,
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
                      });
                    },
                    items: departmentItems,
                  ),
                ),
                const SizedBox(height: 30,),
                Visibility(
                  visible: !appProvider.progress,
                  child: PrimaryButton(
                    width: double.infinity,
                    height: 50,
                    buttonMargin: const EdgeInsets.only(top: 10, bottom: 30),
                    buttonPadding: const EdgeInsets.all(12),
                    buttonText: "Search Attendance",
                    buttonTextStyle: AppAssets.latoBold_whiteColor_16,
                    shadowColor: AppAssets.shadowColor,
                    buttonRadius: BorderRadius.circular(30),
                    onPress: () {
                      if(dptSelectedValue.departmentId == 0){
                        MyMessage.showFailedMessage("Please choose Department", context);
                      }else {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => AttendanceWorkload(departmentModel: dptSelectedValue,)));
                      }
                    },
                  ),
                ),
                Visibility(visible: appProvider.progress, child: const SizedBox(height:80, child: ProgressBarWidget())),
              ],),
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
                Expanded(child: Container(padding: const EdgeInsets.only(left: 20, right: 20), child: Center(child: Text("Attendance", style: AppAssets.latoBold_textDarkColor_20)))),
                Container(padding: const EdgeInsets.all(10), height: 50, width: 50,),
              ],),
            ),
          ]),
        ),)
      ),
    );
  }
}
