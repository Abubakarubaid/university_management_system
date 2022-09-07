import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:university_management_system/models/rooms_model.dart';
import 'package:university_management_system/models/subject_model.dart';
import 'package:university_management_system/models/teacher_model.dart';
import 'package:university_management_system/models/timeslots_model.dart';
import 'package:university_management_system/models/timetable_upload_model.dart';
import 'package:university_management_system/models/workload_assignment_model.dart';
import 'package:university_management_system/ui/teacher/teacher_attendance/fetch_attendance.dart';
import 'package:university_management_system/ui/teacher/teacher_subjects/teacher_classes.dart';
import 'package:university_management_system/widgets/no_data.dart';
import 'package:university_management_system/widgets/primary_button.dart';
import 'package:university_management_system/widgets/primary_text_field.dart';
import '../../../assets/app_assets.dart';
import '../../../models/class_model.dart';
import '../../../models/dpt_model.dart';
import '../../../models/teacher_model_credithours.dart';
import '../../../models/user_model.dart';
import '../../../providers/app_provider.dart';
import '../../../utilities/base/my_message.dart';
import '../../../utilities/constants.dart';
import '../../../widgets/primary_dropdown_field.dart';
import '../../../widgets/progress_bar.dart';

class TimeTableAssignment extends StatefulWidget {
  WorkloadAssignmentModel workloadModel;
  TimeTableAssignment({required this.workloadModel, Key? key}) : super(key: key);

  @override
  State<TimeTableAssignment> createState() => _TimeTableAssignmentState();
}

class _TimeTableAssignmentState extends State<TimeTableAssignment> {

  var itemsDays = [
    "Select Day",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
  ];
  String daySelectedValue = "Select Day";

  List<TimeSlotsModel> timeslotList = [];
  TimeSlotsModel slotSelectedValue = TimeSlotsModel(timeslotId: 0, timeslot: "Select Time Slot", departmentModel: DepartmentModel.getInstance());
  var timeslotItems;

  List<RoomsModel> roomList = [];
  RoomsModel roomSelectedValue = RoomsModel(roomId: 0, roomName: "Select Room", departmentModel: DepartmentModel.getInstance());
  var roomItems;

  String authToken = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Constants.getAuthToken().then((value) {
      authToken = value;
    });

    getTimeSlots();
    getRooms();
  }

  void getTimeSlots() async {
    Provider.of<AppProvider>(context, listen: false).fetchAllTimeSlots_Department(widget.workloadModel.departmentModel, Constants.getAuthToken().toString()).then((value) {
      setState(() {
        if(value.isSuccess){
          timeslotList.clear();
          timeslotList = Provider.of<AppProvider>(context, listen: false).timeSlotList;
          timeslotList.add(slotSelectedValue);
          timeslotList.sort((a, b) => a.timeslotId.compareTo(b.timeslotId));

          timeslotItems = timeslotList.map((item) {
            return DropdownMenuItem<TimeSlotsModel>(
              child: Text(item.timeslot),
              value: item,
            );
          }).toList();

          // if list is empty, create a dummy item
          if (timeslotItems.isEmpty) {
            timeslotItems = [
              DropdownMenuItem(
                child: Text(slotSelectedValue.timeslot),
                value: slotSelectedValue,
              )
            ];
          }else{
            slotSelectedValue = timeslotList[0];
          }
        }
      });
    });
  }

  void helloWorld () {

  }
  void getRooms() async {
    Provider.of<AppProvider>(context, listen: false).fetchAllRooms_Department(widget.workloadModel.departmentModel, Constants.getAuthToken().toString()).then((value) {
      setState(() {
        if(value.isSuccess){
          roomList.clear();
          roomList = Provider.of<AppProvider>(context, listen: false).roomList;
          roomList.add(roomSelectedValue);
          roomList.sort((a, b) => a.roomId.compareTo(b.roomId));

          roomItems = roomList.map((item) {
            return DropdownMenuItem<RoomsModel>(
              child: Text(item.roomName),
              value: item,
            );
          }).toList();

          // if list is empty, create a dummy item
          if (roomItems.isEmpty) {
            roomItems = [
              DropdownMenuItem(
                child: Text(roomSelectedValue.roomName),
                value: roomSelectedValue,
              )
            ];
          }else{
            roomSelectedValue = roomList[0];
          }
        }
      });
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
            Opacity(opacity: 0.05, child: Center(child: Image.asset(AppAssets.overloadIcon,))),
            Container(
              height: double.infinity,
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(children: [
                  const SizedBox(height: 80,),
                  Image.asset(AppAssets.overloadIcon, width: 100, height: 100,),
                  const SizedBox(height: 30,),
                  Text("Please Select Day, Time Slot & Room to create Time Table", textAlign: TextAlign.center, style: AppAssets.latoBold_textDarkColor_20,),
                  const SizedBox(height: 30,),
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
                    child: DropdownButton<RoomsModel>(
                      value: roomSelectedValue,
                      icon: const Icon(Icons.arrow_drop_down),
                      underline: Container(
                        height: 0,
                        color: Colors.transparent,
                      ),
                      isExpanded: true,
                      onChanged: (value) {
                        setState(() {
                          roomSelectedValue = value!;
                        });
                      },
                      items: roomItems,
                    ),
                  ),
                  const SizedBox(height: 20,),
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
                    child: DropdownButton<TimeSlotsModel>(
                      value: slotSelectedValue,
                      icon: const Icon(Icons.arrow_drop_down),
                      underline: Container(
                        height: 0,
                        color: Colors.transparent,
                      ),
                      isExpanded: true,
                      onChanged: (value) {
                        setState(() {
                          slotSelectedValue = value!;
                        });
                      },
                      items: timeslotItems,
                    ),
                  ),
                  const SizedBox(height: 20,),
                  PrimaryDropDownFiled(
                      hint: "Select Day",
                      selectedValue: daySelectedValue,
                      items: itemsDays,
                      onChange: (text) {
                        setState(() {
                          daySelectedValue = text.toString();
                        });
                      }
                  ),
                  const SizedBox(height: 30,),
                  Visibility(
                    visible: !appProvider.progress,
                    child: PrimaryButton(
                      width: double.infinity,
                      height: 50,
                      buttonMargin: const EdgeInsets.only(top: 20, bottom: 10),
                      buttonPadding: const EdgeInsets.all(12),
                      buttonText: "Add into Time Table",
                      buttonTextStyle: AppAssets.latoBold_whiteColor_16,
                      shadowColor: AppAssets.shadowColor,
                      buttonRadius: BorderRadius.circular(30),
                      onPress: () {
                        if(roomSelectedValue.roomId == 0){
                          MyMessage.showFailedMessage("Please choose Room", context);
                        }else if(slotSelectedValue.timeslotId == 0){
                          MyMessage.showFailedMessage("Please choose Time Slot", context);
                        }else if(daySelectedValue == "Select Day"){
                          MyMessage.showFailedMessage("Please choose Day", context);
                        }else {

                          var now = DateTime.now();
                          var formatter = DateFormat('MMMM dd, yyyy');
                          String formattedDate = formatter.format(now);

                          TimeTableUploadModel model = TimeTableUploadModel.getInstance();
                          model.workload_id = widget.workloadModel.workloadId;
                          model.userId = widget.workloadModel.userModel.userId;
                          model.departmentId = widget.workloadModel.departmentModel.departmentId;
                          model.roomId = roomSelectedValue.roomId;
                          model.timeSlotId = slotSelectedValue.timeslotId;
                          model.day = daySelectedValue;
                          model.date = formattedDate;
                          model.status = "Active";

                          Provider.of<AppProvider>(context, listen: false).addSingleTimeTable(model, authToken).then((value) {
                            if(value.isSuccess){
                              setState(() {
                                model = TimeTableUploadModel.getInstance();
                                daySelectedValue = "Select Day";
                                roomSelectedValue = roomList[0];
                                slotSelectedValue = timeslotList[0];
                              });
                              MyMessage.showSuccessMessage(value.message, context);
                            }else{
                              MyMessage.showFailedMessage(value.message, context);
                            }
                          });
                        }
                      },
                    ),
                  ),
                  Visibility(visible: appProvider.progress, child: const SizedBox(height:80, child: ProgressBarWidget())),
                ],),
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
                Expanded(child: Container(padding: const EdgeInsets.only(left: 20, right: 20), child: Center(child: Text("Time Table Assignment", style: AppAssets.latoBold_textDarkColor_18)))),
                Container(padding: const EdgeInsets.all(10), height: 50, width: 50,),
              ],),
            ),
          ]),
        ),),
      ),
    );
  }
}
