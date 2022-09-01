import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:university_management_system/models/class_model.dart';
import 'package:university_management_system/providers/app_provider.dart';
import 'package:university_management_system/widgets/primary_text_field.dart';
import '../../../assets/app_assets.dart';
import '../../../models/dpt_model.dart';
import '../../../utilities/base/my_message.dart';
import '../../../utilities/constants.dart';
import '../../../widgets/no_data.dart';
import '../../../widgets/primary_dropdown_field.dart';
import '../../../widgets/progress_bar.dart';

class ViewClasses extends StatefulWidget {
  const ViewClasses({Key? key}) : super(key: key);

  @override
  State<ViewClasses> createState() => _ViewClassesState();
}

class _ViewClassesState extends State<ViewClasses> {

  var classNameController = TextEditingController();

  var itemsSemester = [
    "Select Semester",
    "1st",
    "2nd",
    "3rd",
    "4th",
    "5th",
    "6th",
    "7th",
    "8th",
    "9th",
    "10th",
  ];
  String semesterSelectedValue = "Select Semester";

  var itemsType = [
    "Select Type",
    "Morning",
    "Evening",
  ];
  String typeSelectedValue = "Select Type";

  List<DepartmentModel> departmentList = [];
  DepartmentModel dptSelectedValue = DepartmentModel(departmentId: 0, departmentName: "Select Department", departmentType: "Demo");
  var items;

  @override
  void initState() {
    super.initState();

    Provider.of<AppProvider>(context, listen: false).dialogProgressReset();

    getClasses();
    getDepartments();
  }

  void getClasses() async {
    Provider.of<AppProvider>(context, listen: false).fetchAllClasses(Constants.getAuthToken().toString());
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

  Future<void> _addClassDialog(ClassModel classModel) async {

    dptSelectedValue = departmentList[0];

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppAssets.backgroundColor,
          title: Center(child: Text(classNameController.text.isEmpty ? 'Add new Class' : 'Edit Class', style: AppAssets.latoBlack_textDarkColor_20,)),
          content: StatefulBuilder(
            builder: (context, setState) => SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                Visibility(visible: classNameController.text.isNotEmpty,child: Container(margin: EdgeInsets.only(top: 20), child: Text(classModel.departmentModel.departmentName))),
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
                PrimaryTextFiled(
                    controller: classNameController,
                    hint: "Class Name",
                    keyboardType: TextInputType.text,
                    onChange: (text) {
                      print("-------------:${text}" );
                    }
                ),
                const SizedBox(height: 20,),
                PrimaryDropDownFiled(
                    hint: "Select Semester",
                    selectedValue: semesterSelectedValue,
                    items: itemsSemester,
                    onChange: (text) {
                      setState(() {
                        semesterSelectedValue = text.toString();
                      });
                    }
                ),
                const SizedBox(height: 20,),
                PrimaryDropDownFiled(
                    hint: "Select Type",
                    selectedValue: typeSelectedValue,
                    items: itemsType,
                    onChange: (text) {
                      setState(() {
                        typeSelectedValue = text.toString();
                      });
                    }
                ),
                Visibility(visible: Provider.of<AppProvider>(context, listen: true).dialogProgress, child: SizedBox(height: 80,child: ProgressBarWidget())),
              ],),
            )
          ),
          actions: true ? <Widget>[
            Visibility(
              visible: classNameController.text.isEmpty,
              child: TextButton(
                child: Text('Add', style: AppAssets.latoBlack_primaryColor_16,),
                onPressed: () {
                  if(classNameController.text.isEmpty){
                    MyMessage.showFailedMessage("Class name is missing", context);
                  }else if(semesterSelectedValue == "Select Semester"){
                    MyMessage.showFailedMessage("Class semester is missing", context);
                  }else if(typeSelectedValue == "Select Type"){
                    MyMessage.showFailedMessage("Class type is missing", context);
                  }else if(dptSelectedValue.departmentName == "Select Department"){
                    MyMessage.showFailedMessage("Please Select Department", context);
                  }else{
                    classModel.className = classNameController.text;
                    classModel.classSemester = semesterSelectedValue;
                    classModel.classType = typeSelectedValue;
                    classModel.departmentModel = dptSelectedValue;
                    Provider.of<AppProvider>(context, listen: false).addClass(classModel, Constants.getAuthToken().toString()).then((value) {
                      if(value.isSuccess){
                        MyMessage.showSuccessMessage(value.message, context);
                        setState(() {
                          classNameController.text = "";
                          typeSelectedValue = "Select Type";
                          semesterSelectedValue = "Select Semester";
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
              visible: classNameController.text.isNotEmpty,
              child: TextButton(
                child: Text('Update', style: AppAssets.latoBlack_primaryColor_16,),
                onPressed: () {
                  if(classNameController.text.isEmpty){
                    MyMessage.showFailedMessage("Class name is missing", context);
                  }else if(semesterSelectedValue == "Select Semester"){
                    MyMessage.showFailedMessage("Class semester is missing", context);
                  }else if(typeSelectedValue == "Select Type"){
                    MyMessage.showFailedMessage("Class type is missing", context);
                  }else{
                    if(dptSelectedValue.departmentName != "Select Department"){
                      classModel.departmentModel = dptSelectedValue;
                    }

                    classModel.className = classNameController.text;
                    classModel.classSemester = semesterSelectedValue;
                    classModel.classType = typeSelectedValue;

                    Provider.of<AppProvider>(context, listen: false).updateClass(classModel, Constants.getAuthToken().toString()).then((value) {
                      if(value.isSuccess){
                        MyMessage.showSuccessMessage(value.message, context);
                        setState(() {
                          classNameController.text = "";
                          typeSelectedValue = "Select Type";
                          semesterSelectedValue = "Select Semester";
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
                  classNameController.text = "";
                  semesterSelectedValue = "Select Semester";
                  typeSelectedValue = "Select Type";
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
              appProvider.classList.isEmpty ?
              const NoDataFound() :
              ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: appProvider.classList.length,
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
                              child: Image.asset(AppAssets.folderIcon, color: AppAssets.textLightColor,),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(right: 16),
                                    child: Align(alignment: Alignment.centerLeft, child: Text("${appProvider.classList[index].className} ${appProvider.classList[index].classSemester}", style: AppAssets.latoBold_textDarkColor_14, maxLines: 1, overflow: TextOverflow.ellipsis,)),
                                  ),
                                  const SizedBox(height: 4,),
                                  Container(
                                    padding: const EdgeInsets.only(right: 16),
                                    child: Align(alignment: Alignment.centerLeft, child: Text(appProvider.classList[index].classType, style: AppAssets.latoRegular_textDarkColor_16, maxLines: 2, overflow: TextOverflow.ellipsis,)),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  classNameController.text = appProvider.classList[index].className;
                                  semesterSelectedValue = appProvider.classList[index].classSemester;
                                  typeSelectedValue = appProvider.classList[index].classType;
                                });

                                _addClassDialog(appProvider.classList[index]);
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
                Expanded(child: Container(padding: const EdgeInsets.only(left: 20, right: 20), child: Center(child: Text("Classes", style: AppAssets.latoBold_textDarkColor_20)))),
                GestureDetector(
                    onTap: () {
                      _addClassDialog(ClassModel.getInstance());
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
