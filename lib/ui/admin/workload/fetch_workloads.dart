import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:university_management_system/models/workload_assignment_model.dart';
import 'package:university_management_system/models/workload_model.dart';
import 'package:university_management_system/ui/admin/workload/pdf/PdfPreviewPage.dart';
import 'package:university_management_system/utilities/base/my_message.dart';
import '../../../assets/app_assets.dart';
import '../../../models/dpt_model.dart';
import '../../../models/teacher_model.dart';
import '../../../models/user_model.dart';
import '../../../providers/app_provider.dart';
import '../../../utilities/constants.dart';
import '../../../widgets/no_data.dart';
import '../../../widgets/primary_search_field.dart';
import '../../../widgets/progress_bar.dart';
import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;

class FetchWorkloads extends StatefulWidget {
  DepartmentModel departmentModel;
  FetchWorkloads({required this.departmentModel, Key? key}) : super(key: key);

  @override
  State<FetchWorkloads> createState() => _FetchWorkloadsState();
}

class _FetchWorkloadsState extends State<FetchWorkloads> {

  var searchController = TextEditingController();

  List<TeacherModel> teacherList = [];
  TeacherModel teacherSelectedValue = TeacherModel(userModel: UserModel.getInstance(), departmentModel: DepartmentModel.getInstance(), workloadList: []);
  var teacherItems;

  String authToken = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Constants.getAuthToken().then((value) {
      authToken = value;
    });

    getWorkloads();
    getTeachers();
  }

  getTeachers() async {
    Provider.of<AppProvider>(context, listen: false).fetchAllTeachers(false, "teacher", authToken).then((value) {
      if(value.isSuccess){
        getWorkloads();
      }
    });
  }

  getWorkloads() async {
    Provider.of<AppProvider>(context, listen: false).fetchAllWorkload(widget.departmentModel, authToken);
  }

  Future<void> _deleteDialog(WorkloadAssignmentModel model) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
            backgroundColor: AppAssets.backgroundColor,
            title: Center(child: Text('Delete Workload', style: AppAssets.latoBlack_textDarkColor_20,)),
            content: StatefulBuilder(
                builder: (context, setState) => Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Container(width: double.infinity, height: 2, color: AppAssets.textLightColor.withOpacity(0.3),),
                  const SizedBox(height: 20,),
                  Center(child: Text('Are you sure?', style: AppAssets.latoRegular_textDarkColor_16,)),
                  Visibility(visible: Provider.of<AppProvider>(context, listen: true).dialogProgress, child: const SizedBox(height: 80,child: ProgressBarWidget())),
                ],)
            ),
            actions: true ? <Widget>[
              TextButton(
                child: Text('Yes', style: AppAssets.latoBlack_primaryColor_16,),
                onPressed: () {
                  Provider.of<AppProvider>(context, listen: false).deleteWorkload(model, authToken).then((value) {
                    if(value.isSuccess){
                      Navigator.of(context).pop();
                      MyMessage.showSuccessMessage(value.message, context);
                    }else{
                      MyMessage.showFailedMessage(value.message, context);
                    }
                  });
                },
              ),
              TextButton(
                child: Text('No', style: AppAssets.latoBlack_failureColor_15,),
                onPressed: () {
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
            Opacity(opacity: 0.05, child: Center(child: Image.asset(AppAssets.workloadIcon,))),
            Container(
              height: double.infinity,
              margin: const EdgeInsets.only(top: 60, left: 20, right: 20),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: PrimarySearchFiled(
                        controller: searchController,
                        hint: "Search here",
                        keyboardType: TextInputType.text,
                        onChange: (text) {}
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
                          Container(
                            clipBehavior: Clip.antiAlias,
                            margin: index == appProvider.workloadList.length-1 ? const EdgeInsets.only(top: 20, bottom: 30) : const EdgeInsets.only(top: 20),
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
                                          Expanded(child: Text(appProvider.workloadList[index].departmentModel.departmentName, style: AppAssets.latoRegular_textDarkColor_14, maxLines: 2, overflow: TextOverflow.ellipsis,)),
                                          const SizedBox(width: 6,),
                                          GestureDetector(
                                            onTap: () {
                                              _deleteDialog(appProvider.workloadList[index]);
                                            },
                                            child: Container(
                                              width: 30,
                                              height: double.infinity,
                                              padding: const EdgeInsets.all(5),
                                              child: SizedBox(
                                                  width: 30,
                                                  height: 30,
                                                  child: Icon(Icons.delete, color: AppAssets.failureColor.withOpacity(0.7),)),
                                            ),
                                          ),
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
                ],
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
                Expanded(child: Container(padding: const EdgeInsets.only(left: 20, right: 20), child: Center(child: Text("All Workload", style: AppAssets.latoBold_textDarkColor_20)))),
                GestureDetector(
                    onTap: () async {
                      print("Workload Length: ${appProvider.workloadList.length}, Teacher Length: ${appProvider.teacherList.length}");
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => PdfPreviewPage(workloadList: appProvider.workloadList, teachersList: appProvider.teacherList,)));
                    },
                    child: Container(padding: const EdgeInsets.all(10), height: 50, width: 50, child: Icon(Icons.picture_as_pdf, color: Colors.blue,))),
              ],),
            ),
          ]),
        ),),
      ),
    );
  }
}
