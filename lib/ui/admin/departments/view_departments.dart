import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:university_management_system/models/dpt_model.dart';
import 'package:university_management_system/providers/app_provider.dart';
import 'package:university_management_system/utilities/base/my_message.dart';
import 'package:university_management_system/utilities/constants.dart';
import 'package:university_management_system/widgets/no_data.dart';
import 'package:university_management_system/widgets/primary_button.dart';
import 'package:university_management_system/widgets/primary_text_field.dart';
import '../../../assets/app_assets.dart';
import '../../../widgets/primary_dropdown_field.dart';
import '../../../widgets/progress_bar.dart';

class ViewDepartments extends StatefulWidget {
  const ViewDepartments({Key? key}) : super(key: key);

  @override
  State<ViewDepartments> createState() => _ViewDepartmentsState();
}

class _ViewDepartmentsState extends State<ViewDepartments> {

  var dptController = TextEditingController();

  var itemsType = [
    "Select Type",
    "Own",
    "Other",
  ];
  String typeSelectedValue = "Select Type";

  @override
  void initState() {
    super.initState();

    Provider.of<AppProvider>(context, listen: false).dialogProgressReset();

    getDepartments();
  }

  void getDepartments() async {
    Provider.of<AppProvider>(context, listen: false).fetchAllDepartments(Constants.getAuthToken().toString());
  }

  Future<void> _addDepartmentDialog(DepartmentModel departmentModel) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppAssets.backgroundColor,
          title: Center(child: Text(dptController.text.isEmpty ? 'Add new Department' : 'Edit Department', style: AppAssets.latoBlack_textDarkColor_20,)),
          content: StatefulBuilder(
            builder: (context, setState) => Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
              PrimaryTextFiled(
                  controller: dptController,
                  hint: "Department Name",
                  keyboardType: TextInputType.text,
                  onChange: (text) {
                    print("-------------:${text}" );
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
              Visibility(visible: Provider.of<AppProvider>(context, listen: true).dialogProgress, child: const SizedBox(height: 80,child: ProgressBarWidget())),
            ],)
          ),
          actions: true ? <Widget>[
            Visibility(
              visible: dptController.text.isEmpty,
              child: TextButton(
                child: Text('Add', style: AppAssets.latoBlack_primaryColor_16,),
                onPressed: () {
                  if(dptController.text.isEmpty){
                    MyMessage.showFailedMessage("Department name is missing", context);
                  }else if(typeSelectedValue == "Select Type"){
                    MyMessage.showFailedMessage("Department type is missing", context);
                  }else{
                    Provider.of<AppProvider>(context, listen: false).addDepartment(dptController.text, typeSelectedValue, Constants.getAuthToken().toString()).then((value) {
                      if(value.isSuccess){
                        MyMessage.showSuccessMessage(value.message, context);
                        setState(() {
                          dptController.text = "";
                          typeSelectedValue = "Select Type";
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
              visible: dptController.text.isNotEmpty,
              child: TextButton(
                child: Text('Update', style: AppAssets.latoBlack_primaryColor_16,),
                onPressed: () {
                  if(dptController.text.isEmpty){
                    MyMessage.showFailedMessage("Department name is missing", context);
                  }else if(typeSelectedValue == "Select Type"){
                    MyMessage.showFailedMessage("Department type is missing", context);
                  }else{
                    departmentModel.departmentName = dptController.text;
                    departmentModel.departmentType = typeSelectedValue;
                    Provider.of<AppProvider>(context, listen: false).updateDepartment(departmentModel, Constants.getAuthToken().toString()).then((value) {
                      if(value.isSuccess){
                        MyMessage.showSuccessMessage(value.message, context);
                        setState(() {
                          dptController.text = "";
                          typeSelectedValue = "Select Type";
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
                  dptController.text = "";
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
                  appProvider.departmentList.isEmpty ?
                      const NoDataFound() :
                  ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: appProvider.departmentList.length,
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
                                  child: Container(
                                    height: double.infinity,
                                    padding: const EdgeInsets.only(right: 16),
                                    child: Align(alignment: Alignment.centerLeft, child: Text(appProvider.departmentList[index].departmentName, style: AppAssets.latoRegular_textDarkColor_16, maxLines: 2, overflow: TextOverflow.ellipsis,)),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      dptController.text = appProvider.departmentList[index].departmentName;
                                      typeSelectedValue = appProvider.departmentList[index].departmentType;
                                    });
                                    _addDepartmentDialog(appProvider.departmentList[index]);
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
                      })
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
                Expanded(child: Container(padding: const EdgeInsets.only(left: 20, right: 20), child: Center(child: Text("Departments", style: AppAssets.latoBold_textDarkColor_20)))),
                GestureDetector(
                    onTap: () {
                      _addDepartmentDialog(DepartmentModel.getInstance());
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
