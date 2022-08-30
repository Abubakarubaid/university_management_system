import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:university_management_system/models/dpt_model.dart';
import 'package:university_management_system/models/subject_model.dart';
import 'package:university_management_system/widgets/no_data.dart';
import 'package:university_management_system/widgets/primary_button.dart';
import 'package:university_management_system/widgets/primary_text_field.dart';
import '../../../assets/app_assets.dart';
import '../../../providers/app_provider.dart';
import '../../../utilities/base/my_message.dart';
import '../../../utilities/constants.dart';
import '../../../widgets/progress_bar.dart';

class ViewSubjects extends StatefulWidget {
  const ViewSubjects({Key? key}) : super(key: key);

  @override
  State<ViewSubjects> createState() => _ViewSubjectsState();
}

class _ViewSubjectsState extends State<ViewSubjects> {

  var subCodeController = TextEditingController();
  var subTitleController = TextEditingController();
  var subCreditController = TextEditingController();

  List<DepartmentModel> departmentList = [];
  DepartmentModel dptSelectedValue = DepartmentModel(departmentId: 0, departmentName: "Select Department", departmentType: "Demo");
  var items;

  @override
  void initState() {
    super.initState();

    Provider.of<AppProvider>(context, listen: false).dialogProgressReset();

    getSubjects();
    getDepartments();
  }

  void getSubjects() async {
    Provider.of<AppProvider>(context, listen: false).fetchAllSubjects(Constants.getAuthToken().toString());
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

  Future<void> _addSubjectDialog(SubjectModel subjectModel) async {

    dptSelectedValue = departmentList[0];

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppAssets.backgroundColor,
          title: Center(child: Text(subCodeController.text.isEmpty ? 'Add new Subject' : 'Edit Subject', style: AppAssets.latoBlack_textDarkColor_20,)),
          content: StatefulBuilder(
            builder: (context, setState) => SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                Visibility(visible: subCodeController.text.isNotEmpty,child: Container(margin: EdgeInsets.only(top: 20), child: Text(subjectModel.departmentModel.departmentName))),
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
                    controller: subCodeController,
                    hint: "Course Code",
                    keyboardType: TextInputType.text,
                    onChange: (text) {
                      print("-------------:${text}" );
                    }
                ),
                const SizedBox(height: 20,),
                PrimaryTextFiled(
                    controller: subTitleController,
                    hint: "Subject Title",
                    keyboardType: TextInputType.text,
                    onChange: (text) {
                      print("-------------:${text}" );
                    }
                ),
                const SizedBox(height: 20,),
                PrimaryTextFiled(
                    controller: subCreditController,
                    hint: "Credit Hours",
                    keyboardType: TextInputType.number,
                    onChange: (text) {
                      print("-------------:${text}" );
                    }
                ),
                Visibility(visible: Provider.of<AppProvider>(context, listen: true).dialogProgress, child: const SizedBox(height: 80,child: ProgressBarWidget())),
              ],),
            )
          ),
          actions: true ? <Widget>[
            Visibility(
              visible: subCodeController.text.isEmpty,
              child: TextButton(
                child: Text('Add', style: AppAssets.latoBlack_primaryColor_16,),
                onPressed: () {
                  if(subCodeController.text.isEmpty){
                    MyMessage.showFailedMessage("Subject code is missing", context);
                  }else if(subTitleController.text.isEmpty){
                    MyMessage.showFailedMessage("Subject title is missing", context);
                  }else if(subCreditController.text.isEmpty){
                    MyMessage.showFailedMessage("Subject credit hours is missing", context);
                  }else if(dptSelectedValue.departmentName == "Select Department"){
                    MyMessage.showFailedMessage("Please Select Department", context);
                  }else{
                    subjectModel.subjectName = subTitleController.text;
                    subjectModel.subjectCode = subCodeController.text;
                    subjectModel.creditHours = int.parse(subCreditController.text);
                    subjectModel.departmentModel = dptSelectedValue;
                    Provider.of<AppProvider>(context, listen: false).addSubject(subjectModel, Constants.getAuthToken().toString()).then((value) {
                      if(value.isSuccess){
                        MyMessage.showSuccessMessage(value.message, context);
                        setState(() {
                          subTitleController.text = "";
                          subCodeController.text = "";
                          subCreditController.text = "";
                          subCreditController.text = "";
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
              visible: subCodeController.text.isNotEmpty,
              child: TextButton(
                child: Text('Update', style: AppAssets.latoBlack_primaryColor_16,),
                onPressed: () {
                  if(subCodeController.text.isEmpty){
                    MyMessage.showFailedMessage("Subject code is missing", context);
                  }else if(subTitleController.text.isEmpty){
                    MyMessage.showFailedMessage("Subject title is missing", context);
                  }else if(subCreditController.text.isEmpty){
                    MyMessage.showFailedMessage("Subject credit hours is missing", context);
                  }else{
                    if(dptSelectedValue.departmentName != "Select Department"){
                      subjectModel.departmentModel = dptSelectedValue;
                    }

                    subjectModel.subjectName = subTitleController.text;
                    subjectModel.subjectCode = subCodeController.text;
                    subjectModel.creditHours = int.parse(subCreditController.text);

                    Provider.of<AppProvider>(context, listen: false).updateSubject(subjectModel, Constants.getAuthToken().toString()).then((value) {
                      if(value.isSuccess){
                        MyMessage.showSuccessMessage(value.message, context);
                        setState(() {
                          subTitleController.text = "";
                          subCodeController.text = "";
                          subCreditController.text = "";
                          subCreditController.text = "";
                          dptSelectedValue = departmentList[0];
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
                  subCodeController.text = "";
                  subTitleController.text = "";
                  subCreditController.text = "";
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
              appProvider.subjectList.isEmpty ?
              const NoDataFound() :
              ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: appProvider.subjectList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      height: 96,
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
                                    child: Align(alignment: Alignment.centerLeft, child: Text(appProvider.subjectList[index].subjectCode, style: AppAssets.latoBold_textDarkColor_14, maxLines: 1, overflow: TextOverflow.ellipsis,)),
                                  ),
                                  const SizedBox(height: 4,),
                                  Container(
                                    padding: const EdgeInsets.only(right: 16),
                                    child: Align(alignment: Alignment.centerLeft, child: Text(appProvider.subjectList[index].subjectName, style: AppAssets.latoRegular_textDarkColor_16, maxLines: 2, overflow: TextOverflow.ellipsis,)),
                                  ),
                                  const SizedBox(height: 4,),
                                  Container(
                                    padding: const EdgeInsets.only(right: 16),
                                    child: Row(
                                      children: [
                                        Align(alignment: Alignment.centerLeft, child: Text("Credit Hours: ", style: AppAssets.latoBold_textDarkColor_14, maxLines: 1, overflow: TextOverflow.ellipsis,)),
                                        Align(alignment: Alignment.centerLeft, child: Text(appProvider.subjectList[index].creditHours.toString(), style: AppAssets.latoRegular_textDarkColor_16, maxLines: 1, overflow: TextOverflow.ellipsis,)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  subTitleController.text = appProvider.subjectList[index].subjectName;
                                  subCodeController.text = appProvider.subjectList[index].subjectCode;
                                  subCreditController.text = appProvider.subjectList[index].creditHours.toString();
                                  //dptSelectedValue = appProvider.subjectList[index].departmentModel;
                                });
                                _addSubjectDialog(appProvider.subjectList[index]);
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
                Expanded(child: Container(padding: const EdgeInsets.only(left: 20, right: 20), child: Center(child: Text("Subjects", style: AppAssets.latoBold_textDarkColor_20)))),
                GestureDetector(
                    onTap: () {
                      _addSubjectDialog(SubjectModel.getInstance());
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
