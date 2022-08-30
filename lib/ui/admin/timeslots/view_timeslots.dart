import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:university_management_system/models/timeslots_model.dart';
import 'package:university_management_system/widgets/no_data.dart';
import 'package:university_management_system/widgets/primary_button.dart';
import 'package:university_management_system/widgets/primary_text_field.dart';
import '../../../assets/app_assets.dart';
import '../../../models/dpt_model.dart';
import '../../../providers/app_provider.dart';
import '../../../utilities/base/my_message.dart';
import '../../../utilities/constants.dart';
import '../../../widgets/progress_bar.dart';

class ViewTimeSlots extends StatefulWidget {
  const ViewTimeSlots({Key? key}) : super(key: key);

  @override
  State<ViewTimeSlots> createState() => _ViewTimeSlotsState();
}

class _ViewTimeSlotsState extends State<ViewTimeSlots> {

  String startTime = "Start Time";
  String endTime = "End Time";

  List<DepartmentModel> departmentList = [];
  DepartmentModel dptSelectedValue = DepartmentModel(departmentId: 0, departmentName: "Select Department", departmentType: "Demo");
  var items;

  @override
  void initState() {
    super.initState();

    Provider.of<AppProvider>(context, listen: false).dialogProgressReset();

    getTimeSlots();
    getDepartments();
  }

  void getTimeSlots() async {
    Provider.of<AppProvider>(context, listen: false).fetchAllTimeSlots(Constants.getAuthToken().toString());
  }

  void getDepartments() async {
    Provider.of<AppProvider>(context, listen: false).fetchAllDepartments(Constants.getAuthToken().toString()).then((value) {
      setState(() {
        if(value.isSuccess){
          departmentList = Provider.of<AppProvider>(context, listen: false).departmentList;
          departmentList.add(dptSelectedValue);
          departmentList.sort((a, b) => a.departmentId.compareTo(b.departmentId));

          items = departmentList.map((item) {
            return DropdownMenuItem<DepartmentModel>(
              child: Text(item.departmentName),
              value: item,
            );
          }).toList();

          // if list is empty, create a dummy item
          if (items.isEmpty) {
            items = [
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

  Future<void> _addSlotsDialog(TimeSlotsModel timeSlotsModel) async {

    dptSelectedValue = departmentList[0];

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppAssets.backgroundColor,
          title: Center(child: Text(startTime == "Start Time" ? 'Add new TimeSlot' : 'Edit TImeSlot', style: AppAssets.latoBlack_textDarkColor_20,)),
          content: StatefulBuilder(
            builder: (context, setState) => SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                Visibility(visible: startTime != "Start Time",child: Container(margin: EdgeInsets.only(top: 20), child: Text(timeSlotsModel.departmentModel.departmentName))),
                const SizedBox(height: 20,),
                Container(
                  child: Container(
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
                      items: items,
                    ),
                  ),
                ),
                const SizedBox(height: 20,),
                GestureDetector(
                  onTap: () {
                    DatePicker.showTime12hPicker(context,
                        showTitleActions: true,
                        onConfirm: (date) {
                          setState(() {
                            startTime = DateFormat.jm().format(date);
                          });
                        }, locale: LocaleType.en);
                  },
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppAssets.whiteColor,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppAssets.textLightColor, width: 1),
                      boxShadow: [BoxShadow(
                          color: AppAssets.shadowColor.withOpacity(0.5),
                          spreadRadius: 4,
                          blurRadius: 8,
                          offset: const Offset(0, 6),
                        )],
                    ),
                    child: Row(children: [
                      Icon(Icons.timer, color: AppAssets.textLightColor),
                      SizedBox(width: 12,),
                      Expanded(child: Text(startTime, maxLines: 1, overflow: TextOverflow.ellipsis,)),
                    ],),
                  ),
                ),
                const SizedBox(height: 20,),
                GestureDetector(
                  onTap: () {
                    DatePicker.showTime12hPicker(context,
                        showTitleActions: true,
                        onConfirm: (date) {
                          setState(() {
                            endTime = DateFormat.jm().format(date);
                          });
                        }, locale: LocaleType.en);
                  },
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppAssets.whiteColor,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppAssets.textLightColor, width: 1),
                      boxShadow: [BoxShadow(
                        color: AppAssets.shadowColor.withOpacity(0.5),
                        spreadRadius: 4,
                        blurRadius: 8,
                        offset: const Offset(0, 6),
                      )],
                    ),
                    child: Row(children: [
                      Icon(Icons.timer, color: AppAssets.textLightColor),
                      SizedBox(width: 12,),
                      Expanded(child: Text(endTime, maxLines: 1, overflow: TextOverflow.ellipsis,)),
                    ],),
                  ),
                ),
                Visibility(visible: Provider.of<AppProvider>(context, listen: true).dialogProgress, child: const SizedBox(height: 80,child: ProgressBarWidget())),
              ],),
            )
          ),
          actions: true ? <Widget>[
            Visibility(
              visible: startTime == "Start Time",
              child: TextButton(
                child: Text('Add', style: AppAssets.latoBlack_primaryColor_16,),
                onPressed: () {
                  if(startTime == "Start Time"){
                    MyMessage.showFailedMessage("Start time is missing", context);
                  } else if(endTime == "End Time"){
                    MyMessage.showFailedMessage("End time is missing", context);
                  } else if(dptSelectedValue.departmentName == "Select Department"){
                    MyMessage.showFailedMessage("Please Select Department", context);
                  }else{
                    timeSlotsModel.timeslot = "${startTime} - ${endTime}";
                    timeSlotsModel.departmentModel = dptSelectedValue;
                    Provider.of<AppProvider>(context, listen: false).addTimeSlot(timeSlotsModel, Constants.getAuthToken().toString()).then((value) {
                      if(value.isSuccess){
                        MyMessage.showSuccessMessage(value.message, context);
                        setState(() {
                          startTime = "Start Time";
                          endTime = "End Time";
                        });
                        Navigator.of(context).pop();
                      }else{
                        MyMessage.showFailedMessage(value.message, context);
                      }
                    });
                  }
                },
              ),
            ),
            Visibility(
              visible: startTime != "Start Time",
              child: TextButton(
                child: Text('Update', style: AppAssets.latoBlack_primaryColor_16,),
                onPressed: () {
                  if(startTime == "Start Time"){
                    MyMessage.showFailedMessage("Start time is missing", context);
                  } else if(endTime == "End Time"){
                    MyMessage.showFailedMessage("End time is missing", context);
                  }else{
                    if(dptSelectedValue.departmentName != "Select Department"){
                      timeSlotsModel.departmentModel = dptSelectedValue;
                    }
                    timeSlotsModel.timeslot = "${startTime} - ${endTime}";

                    Provider.of<AppProvider>(context, listen: false).updateTimeSlots(timeSlotsModel, Constants.getAuthToken().toString()).then((value) {
                      if(value.isSuccess){
                        MyMessage.showSuccessMessage(value.message, context);
                        setState(() {
                          startTime = "Start Time";
                          endTime = "End Time";
                        });
                        Navigator.of(context).pop();
                      }else{
                        MyMessage.showFailedMessage(value.message, context);
                      }
                    });
                  }
                },
              ),
            ),
            TextButton(
              child: Text('Cancel', style: AppAssets.latoBlack_failureColor_15,),
              onPressed: () {
                setState(() {
                  startTime = "Start Time";
                  endTime = "End Time";
                });
                Navigator.of(context).pop();
              },
            ),
          ] : null
        );
      },
    );
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
            Container(
              margin: const EdgeInsets.only(top: 60),
              child: appProvider.progress ?
              const Center(child: SizedBox(height: 80, child: ProgressBarWidget(),)) :
              appProvider.timeSlotList.isEmpty ?
              const NoDataFound() :
              ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: appProvider.timeSlotList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      height: 70,
                      width: double.infinity,
                      child: Column(children: [
                        Expanded(
                          child: Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Container(
                              width: 70,
                              height: double.infinity,
                              padding: const EdgeInsets.all(16),
                              child: const Icon(Icons.timer, color: AppAssets.textLightColor),
                            ),
                            Expanded(
                              child: Container(
                                height: double.infinity,
                                padding: const EdgeInsets.only(right: 16),
                                child: Align(alignment: Alignment.centerLeft, child: Text(appProvider.timeSlotList[index].timeslot, style: AppAssets.latoRegular_textDarkColor_16, maxLines: 2, overflow: TextOverflow.ellipsis,)),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                final splitted = appProvider.timeSlotList[index].timeslot.split('-');
                                setState(() {
                                  startTime = splitted[0];
                                  endTime = splitted[1];
                                });
                                _addSlotsDialog(appProvider.timeSlotList[index]);
                              },
                              child: Container(
                                width: 30,
                                height: double.infinity,
                                padding: const EdgeInsets.all(5),
                                margin: const EdgeInsets.only(right: 10),
                                child: SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: SvgPicture.asset(AppAssets.editIcon, color: AppAssets.textLightColor,)),
                              ),
                            ),
                          ],),
                        ),
                        Container(height: 1, width: double.infinity, color: AppAssets.textLightColor,),
                      ],),
                    );
                  }),
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
                Expanded(child: Container(padding: const EdgeInsets.only(left: 20, right: 20), child: Center(child: Text("Time Slots", style: AppAssets.latoBold_textDarkColor_20)))),
                GestureDetector(
                    onTap: () {
                      _addSlotsDialog(TimeSlotsModel.getInstance());
                    },
                    child: Container(padding: const EdgeInsets.all(10), height: 50, width: 50, child: SvgPicture.asset(AppAssets.addIcon, color: AppAssets.iconsTintDarkGreyColor,))),
              ],),
            ),
          ]),
        ),),
      ),
    );
  }
}
