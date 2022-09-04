import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:university_management_system/models/subject_model.dart';
import 'package:university_management_system/ui/admin/datesheet/view_datesheet.dart';
import 'package:university_management_system/ui/teacher/teacher_attendance/fetch_attendance.dart';
import 'package:university_management_system/ui/teacher/teacher_subjects/teacher_classes.dart';
import 'package:university_management_system/widgets/no_data.dart';
import 'package:university_management_system/widgets/primary_button.dart';
import 'package:university_management_system/widgets/primary_text_field.dart';
import '../../../assets/app_assets.dart';
import '../../../models/class_model.dart';
import '../../../models/datesheet_model.dart';
import '../../../models/dpt_model.dart';
import '../../../models/rooms_model.dart';
import '../../../models/teacher_model_credithours.dart';
import '../../../models/user_model.dart';
import '../../../providers/app_provider.dart';
import '../../../utilities/base/my_message.dart';
import '../../../utilities/constants.dart';
import '../../../widgets/primary_dropdown_field.dart';
import '../../../widgets/progress_bar.dart';
import 'fetch_datesheets.dart';

class DatesheetAssignment extends StatefulWidget {
  const DatesheetAssignment({Key? key}) : super(key: key);

  @override
  State<DatesheetAssignment> createState() => _DatesheetAssignmentState();
}

class _DatesheetAssignmentState extends State<DatesheetAssignment> {

  String startTime = "Start Time";
  String endTime = "End Time";
  String selectedDate = "Select Date";

  List<DepartmentModel> departmentList = [];
  DepartmentModel dptSelectedValue = DepartmentModel(departmentId: 0, departmentName: "Select Department", departmentType: "Demo");
  var departmentItems;

  List<ClassModel> classList = [];
  ClassModel classSelectedValue = ClassModel(classId: 0, className: "Select Class", classSemester: "", classType: "", departmentModel: DepartmentModel.getInstance());
  var classItems;

  List<SubjectModel> subjectList = [];
  SubjectModel subjectSelectedValue = SubjectModel(subjectId: 0, subjectCode: "", subjectName: "Select Subject", creditHours: 0, departmentModel: DepartmentModel.getInstance());
  var subjectItems;

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

    getDepartments(false);
    getClasses(false);
    getSubjects(false);
    getRooms(false);
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
        getSubjects(true);
        getClasses(true);
        getRooms(true);
      });
    }

  }

  void getClasses(bool specific) async {
    if(!specific) {
      classList.clear();
      Provider.of<AppProvider>(context, listen: false).fetchAllClasses(
          Constants.getAuthToken().toString()).then((value) {
        setState(() {
          if (value.isSuccess) {
            classList = Provider.of<AppProvider>(context, listen: false).classList;
            classList.add(classSelectedValue);
            classList.sort((a, b) => a.classId.compareTo(b.classId));

            classItems = classList.map((item) {
              return DropdownMenuItem<ClassModel>(
                child: Text("${item.className} ${item.classSemester} ${item
                    .classType}"),
                value: item,
              );
            }).toList();

            // if list is empty, create a dummy item
            if (classItems.isEmpty) {
              classItems = [
                DropdownMenuItem(
                  child: Text(classSelectedValue.className),
                  value: classSelectedValue,
                )
              ];
            } else {
              classSelectedValue = classList[0];
            }
          }
        });
      });
    }
    else{
      setState(() {
        classSelectedValue = classList[0];

        List<ClassModel> searchedList = [];
        classList.forEach((element) {
          if(dptSelectedValue.departmentId == element.departmentModel.departmentId){
            searchedList.add(element);
          }
        });

        classItems = searchedList.map((item) {
          return DropdownMenuItem<ClassModel>(
            child: Text("${item.className} ${item.classSemester} ${item
                .classType}"),
            value: item,
          );
        }).toList();

        // if list is empty, create a dummy item
        if (classItems.isEmpty) {
          classItems = [
            DropdownMenuItem(
              child: Text(classSelectedValue.className),
              value: classSelectedValue,
            )
          ];
        } else {
          classSelectedValue = searchedList[0];
        }
      });
    }
  }

  void getSubjects(bool specific) async {
    if(!specific) {
      subjectList.clear();
      Provider.of<AppProvider>(context, listen: false).fetchAllSubjects(
          Constants.getAuthToken().toString()).then((value) {
        setState(() {
          if (value.isSuccess) {
            subjectList = Provider.of<AppProvider>(context, listen: false).subjectList;
            subjectList.add(subjectSelectedValue);
            subjectList.sort((a, b) => a.subjectId.compareTo(b.subjectId));

            subjectItems = subjectList.map((item) {
              return DropdownMenuItem<SubjectModel>(
                child: Text("${item.subjectName}"),
                value: item,
              );
            }).toList();

            // if list is empty, create a dummy item
            if (subjectItems.isEmpty) {
              subjectItems = [
                DropdownMenuItem(
                  child: Text(subjectSelectedValue.subjectName),
                  value: subjectSelectedValue,
                )
              ];
            } else {
              subjectSelectedValue = subjectList[0];
            }
          }
        });
      });
    }
    else{
      setState(() {
        subjectSelectedValue = subjectList[0];

        List<SubjectModel> searchedList = [];
        subjectList.forEach((element) {
          if(dptSelectedValue.departmentId == element.departmentModel.departmentId){
            searchedList.add(element);
          }
        });

        subjectItems = searchedList.map((item) {
          return DropdownMenuItem<SubjectModel>(
            child: Text("${item.subjectName}"),
            value: item,
          );
        }).toList();

        // if list is empty, create a dummy item
        if (subjectItems.isEmpty) {
          subjectItems = [
            DropdownMenuItem(
              child: Text(subjectSelectedValue.subjectName),
              value: subjectSelectedValue,
            )
          ];
        } else {
          subjectSelectedValue = searchedList[0];
        }
      });
    }
  }

  void getRooms(bool specific) async {
    if(!specific) {
      roomList.clear();
      Provider.of<AppProvider>(context, listen: false).fetchAllRooms(
          Constants.getAuthToken().toString()).then((value) {
        setState(() {
          if (value.isSuccess) {
            roomList = Provider.of<AppProvider>(context, listen: false).roomList;
            roomList.add(roomSelectedValue);
            roomList.sort((a, b) => a.roomId.compareTo(b.roomId));

            roomItems = roomList.map((item) {
              return DropdownMenuItem<RoomsModel>(
                child: Text("${item.roomName}"),
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
            } else {
              roomSelectedValue = roomList[0];
            }
          }
        });
      });
    }
    else{
      setState(() {
        roomSelectedValue = roomList[0];

        List<RoomsModel> searchedList = [];
        roomList.forEach((element) {
          if(dptSelectedValue.departmentId == element.departmentModel.departmentId){
            searchedList.add(element);
          }
        });

        roomItems = searchedList.map((item) {
          return DropdownMenuItem<RoomsModel>(
            child: Text("${item.roomName}"),
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
        } else {
          roomSelectedValue = searchedList[0];
        }
      });
    }
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
            Opacity(opacity: 0.05, child: Center(child: Image.asset(AppAssets.dateSheetColored,))),
            Container(
              height: double.infinity,
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(children: [
                  const SizedBox(height: 80,),
                  Image.asset(AppAssets.dateSheetColored, width: 100, height: 100,),
                  const SizedBox(height: 30,),
                  Text("Please Select Department, Class, Subject, Room & DateTime for Datesheet", textAlign: TextAlign.center, style: AppAssets.latoBold_textDarkColor_20,),
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
                          getClasses(true);
                          getSubjects(true);
                          getRooms(true);
                        });
                      },
                      items: departmentItems,
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
                    child: DropdownButton<ClassModel>(
                      value: classSelectedValue,
                      icon: const Icon(Icons.arrow_drop_down),
                      underline: Container(
                        height: 0,
                        color: Colors.transparent,
                      ),
                      isExpanded: true,
                      onChanged: (value) {
                        setState(() {
                          classSelectedValue = value!;
                        });
                      },
                      items: classItems,
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
                    child: DropdownButton<SubjectModel>(
                      value: subjectSelectedValue,
                      icon: const Icon(Icons.arrow_drop_down),
                      underline: Container(
                        height: 0,
                        color: Colors.transparent,
                      ),
                      isExpanded: true,
                      onChanged: (value) {
                        setState(() {
                          subjectSelectedValue = value!;
                        });
                      },
                      items: subjectItems,
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
                  Row(children: [
                    Expanded(
                      child: GestureDetector(
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
                    ),
                    const SizedBox(width: 12,),
                    Expanded(
                      child: GestureDetector(
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
                    ),
                  ],),
                  const SizedBox(height: 20,),
                  GestureDetector(
                    onTap: () {
                      DatePicker.showDatePicker(
                          context,
                          showTitleActions: true,
                          minTime: DateTime(1900, 1, 1),
                          maxTime: DateTime(2050, 1, 1),
                          theme: const DatePickerTheme(
                            headerColor: AppAssets.primaryColor,
                            backgroundColor: AppAssets.backgroundColor,
                            itemStyle: TextStyle(color: AppAssets.textDarkColor, fontWeight: FontWeight.bold, fontSize: 18),
                            doneStyle: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          onConfirm: (date) {
                            final DateFormat formatter = DateFormat('EEEE, MMM dd, yyyy');
                            setState(() {
                              selectedDate = formatter.format(date);
                            });
                          },
                          currentTime: DateTime.now(), locale: LocaleType.en
                      );
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
                        Icon(Icons.date_range, color: AppAssets.textLightColor),
                        SizedBox(width: 12,),
                        Expanded(child: Text(selectedDate, maxLines: 1, overflow: TextOverflow.ellipsis,)),
                      ],),
                    ),
                  ),
                  const SizedBox(height: 30,),
                  Visibility(
                    visible: !appProvider.progress,
                    child: PrimaryButton(
                      width: double.infinity,
                      height: 50,
                      buttonMargin: const EdgeInsets.only(top: 20, bottom: 10),
                      buttonPadding: const EdgeInsets.all(12),
                      buttonText: "Add into Datesheet",
                      buttonTextStyle: AppAssets.latoBold_whiteColor_16,
                      shadowColor: AppAssets.shadowColor,
                      buttonRadius: BorderRadius.circular(30),
                      onPress: () {
                        if(dptSelectedValue.departmentId == 0){
                          MyMessage.showFailedMessage("Please choose Department", context);
                        }else if(classSelectedValue.classId == 0){
                          MyMessage.showFailedMessage("Please choose Class", context);
                        }else if(subjectSelectedValue.subjectId == 0){
                          MyMessage.showFailedMessage("Please choose Subject", context);
                        }else if(roomSelectedValue.roomId == 0){
                          MyMessage.showFailedMessage("Please choose Room", context);
                        }else if(startTime == "Start Time"){
                          MyMessage.showFailedMessage("Please choose Start Time", context);
                        }else if(endTime == "End Time"){
                          MyMessage.showFailedMessage("Please choose End Time", context);
                        }else if(selectedDate == "Select Date"){
                          MyMessage.showFailedMessage("Please choose Date", context);
                        }else {
                          DatesheetModel model = DatesheetModel.getInstance();
                          model.departmentModel = dptSelectedValue;
                          model.classModel = classSelectedValue;
                          model.subjectModel = subjectSelectedValue;
                          model.roomsModel = roomSelectedValue;
                          model.sheetStatus = "Active";
                          model.sheetStartTime = startTime;
                          model.sheetEndTime = endTime;
                          model.sheetDate = selectedDate;

                          Provider.of<AppProvider>(context, listen: false).addDateSheet(model, authToken).then((value) {
                            if(value.isSuccess){
                              setState(() {
                                model = DatesheetModel.getInstance();
                                startTime = "Start Time";
                                endTime = "End Time";
                                selectedDate = "Select Date";
                                getDepartments(true);
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
                  Text("OR"),
                  Visibility(
                    visible: !appProvider.progress,
                    child: PrimaryButton(
                      width: double.infinity,
                      height: 50,
                      buttonMargin: const EdgeInsets.only(top: 10, bottom: 10),
                      buttonPadding: const EdgeInsets.all(12),
                      buttonText: "Generate Datesheets",
                      buttonTextStyle: AppAssets.latoBold_whiteColor_16,
                      shadowColor: AppAssets.shadowColor,
                      buttonRadius: BorderRadius.circular(30),
                      onPress: () {
                        if(dptSelectedValue.departmentId == 0){
                          MyMessage.showFailedMessage("Please Select Department first", context);
                        }else {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => FetchDatesheets(departmentModel: dptSelectedValue,)));
                        }
                      },
                    ),
                  ),
                  Text("OR"),
                  Visibility(
                    visible: !appProvider.progress,
                    child: PrimaryButton(
                      width: double.infinity,
                      height: 50,
                      buttonMargin: const EdgeInsets.only(top: 10, bottom: 30),
                      buttonPadding: const EdgeInsets.all(12),
                      buttonText: "View/Upload Date Sheet",
                      buttonTextStyle: AppAssets.latoBold_whiteColor_16,
                      shadowColor: AppAssets.shadowColor,
                      buttonRadius: BorderRadius.circular(30),
                      onPress: () {
                        if(dptSelectedValue.departmentId == 0){
                          MyMessage.showFailedMessage("Please Select Department first", context);
                        }else {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => ViewDateSheet(departmentModel: dptSelectedValue,)));
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
                Expanded(child: Container(padding: const EdgeInsets.only(left: 20, right: 20), child: Center(child: Text("Date Sheet", style: AppAssets.latoBold_textDarkColor_20)))),
                Container(padding: const EdgeInsets.all(10), height: 50, width: 50,),
              ],),
            ),
          ]),
        ),),
      ),
    );
  }
}
