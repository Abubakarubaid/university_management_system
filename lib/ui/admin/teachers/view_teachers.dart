import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:university_management_system/models/teacher_model.dart';
import 'package:university_management_system/ui/admin/students/add_students.dart';
import 'package:university_management_system/ui/admin/students/student_complete_profile.dart';
import 'package:university_management_system/ui/admin/teachers/fetch_teacher_workloads.dart';
import 'package:university_management_system/ui/admin/teachers/teacher_complete_profile.dart';
import 'package:university_management_system/utilities/base/my_message.dart';
import 'package:university_management_system/widgets/no_data.dart';
import 'package:university_management_system/widgets/primary_button.dart';
import 'package:university_management_system/widgets/primary_search_field.dart';
import 'package:university_management_system/widgets/primary_text_field.dart';
import '../../../assets/app_assets.dart';
import '../../../models/dpt_model.dart';
import '../../../models/user_model.dart';
import '../../../providers/app_provider.dart';
import '../../../utilities/constants.dart';
import '../../../widgets/progress_bar.dart';

class ViewTeachers extends StatefulWidget {
  const ViewTeachers({Key? key}) : super(key: key);

  @override
  State<ViewTeachers> createState() => _ViewTeachersState();
}

class _ViewTeachersState extends State<ViewTeachers> {

  var searchController = TextEditingController();
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

    getTeachers();
    getDepartments(false);
  }

  void getTeachers() async {
    Provider.of<AppProvider>(context, listen: false).fetchAllTeachers(true, "teacher", authToken);
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

  Future<void> _approveDialog(TeacherModel model) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
            backgroundColor: AppAssets.backgroundColor,
            title: Center(child: Text('Approve Teacher', style: AppAssets.latoBlack_textDarkColor_20,)),
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
                  Provider.of<AppProvider>(context, listen: false).approveTeacher(model.userModel.userId, "active", authToken).then((value) {
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
        child: Consumer<AppProvider> (builder: (context, appProvider, child) => Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: AppAssets.backgroundColor,
          child: Stack(children: [
            Container(
              margin: const EdgeInsets.only(top: 60),
              child: Column(children: [
                Visibility(
                  visible: dptSelectedValue.departmentId != 0,
                  child: Container(padding: const EdgeInsets.only(top: 20, left: 20, bottom: 20), color: Colors.white, width: double.infinity, child: Row(children: [
                    Expanded(
                      child: Column(children: [
                        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text("Department:  " ,style: AppAssets.latoBold_textDarkColor_16,),
                          Expanded(child: Text(dptSelectedValue.departmentName ,style: AppAssets.latoRegular_textDarkColor_16,)),
                        ],),
                      ],),
                    ),
                    const SizedBox(height: 10,),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          getDepartments(true);
                        });
                      },
                      child: SizedBox(
                        width: 50,
                        child: Icon(Icons.playlist_remove_outlined, color: Colors.red,),
                      ),
                    ),
                  ],),),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: Stack(children: [
                    PrimarySearchFiled(
                        controller: searchController,
                        hint: "Search here",
                        keyboardType: TextInputType.text,
                        onChange: (text) {}
                    ),
                    Align(alignment: Alignment.centerRight, child: GestureDetector(onTap: () {
                      showMaterialModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return StatefulBuilder(builder: (context, setState) {
                              return Container(margin: const EdgeInsets.all(20), child: Column(mainAxisSize: MainAxisSize.min, children: [
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
                                const SizedBox(height: 20,),
                                PrimaryButton(
                                  width: double.infinity,
                                  height: 50,
                                  buttonMargin: const EdgeInsets.only(top: 20, bottom: 30),
                                  buttonPadding: const EdgeInsets.all(12),
                                  buttonText: "Search Teacher",
                                  buttonTextStyle: AppAssets.latoBold_whiteColor_16,
                                  shadowColor: AppAssets.shadowColor,
                                  buttonRadius: BorderRadius.circular(30),
                                  onPress: () {

                                  },
                                ),
                              ],),);
                            });
                          });
                    }, child: Container(alignment: Alignment.center, height: 50, width: 50, child: Icon(Icons.filter_list_alt, color: dptSelectedValue.departmentId != 0 ? AppAssets.primaryColor : AppAssets.textDarkColor,),))),
                  ],),
                ),
                Expanded(
                  child: appProvider.studentProgress ?
                  const Center(child: SizedBox(height: 80, child: ProgressBarWidget(),)) :
                  appProvider.teacherList.isEmpty ?
                  const NoDataFound() :
                  ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: appProvider.teacherList.length,
                      itemBuilder: (context, index) {
                        //print("_______________: User_ID: ${appProvider.teacherList[index].userModel.userId} - Workloads: ${appProvider.teacherList[index].workloadList.length}");
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => TeacherCompleteProfile(teacherModel: appProvider.teacherList[index],),));
                          },
                          child: SizedBox(
                            height: 70,
                            width: double.infinity,
                            child: Column(children: [
                              Expanded(
                                child: Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Container(
                                    width: 70,
                                    height: double.infinity,
                                    padding: const EdgeInsets.all(12),
                                    child: Container(
                                        clipBehavior: Clip.antiAlias,
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          //border: Border.all(color: AppAssets.textLightColor, width: 1),
                                            borderRadius: BorderRadius.circular(35)
                                        ),
                                        child: SvgPicture.asset(appProvider.teacherList[index].userModel.userGender == "female" ? AppAssets.femaleAvatar : AppAssets.maleAvatar, fit: BoxFit.fill, color: AppAssets.textDarkColor,)),
                                  ),
                                  const SizedBox(width: 6,),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.only(right: 16),
                                          child: Align(alignment: Alignment.centerLeft, child: Text(appProvider.teacherList[index].userModel.userName, style: AppAssets.latoBold_textDarkColor_16, maxLines: 1, overflow: TextOverflow.ellipsis,)),
                                        ),
                                        const SizedBox(height: 4,),
                                        Container(
                                          padding: const EdgeInsets.only(right: 16),
                                          child: Align(alignment: Alignment.centerLeft, child: Text(appProvider.teacherList[index].departmentModel.departmentName, style: AppAssets.latoRegular_textDarkColor_14, maxLines: 2, overflow: TextOverflow.ellipsis,)),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                    visible: appProvider.teacherList[index].userModel.userStatus == "in_active",
                                    child: GestureDetector(
                                      onTap: () {
                                        _approveDialog(appProvider.teacherList[index]);
                                      },
                                      child: Container(
                                        width: 30,
                                        height: double.infinity,
                                        padding: const EdgeInsets.all(3),
                                        margin: const EdgeInsets.only(right: 10),
                                        child: SizedBox(
                                            width: 50,
                                            height: 50,
                                            child: SvgPicture.asset(AppAssets.approveIcon, color: AppAssets.successColor,)),
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: appProvider.teacherList[index].userModel.userStatus == "active",
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => FetchTeacherWorkload(teacherModel: appProvider.teacherList[index],),));
                                      },
                                      child: Container(
                                        width: 30,
                                        height: double.infinity,
                                        padding: const EdgeInsets.all(3),
                                        margin: const EdgeInsets.only(right: 10),
                                        child: SizedBox(
                                            width: 50,
                                            height: 50,
                                            child: Icon(Icons.arrow_forward_ios, color: AppAssets.textLightColor,)),
                                      ),
                                    ),
                                  ),
                                ],),
                              ),
                              Container(height: 1, width: double.infinity, color: AppAssets.textLightColor,),
                            ],),
                          ),
                        );
                      }),
                ),
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
                Expanded(child: Container(padding: const EdgeInsets.only(left: 20, right: 20), child: Center(child: Text("Teachers", style: AppAssets.latoBold_textDarkColor_20)))),
                GestureDetector(
                    onTap: () {
                      //Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddStudents(editStatus: false, selectedUser: UserModel.getInstance(), departmentList: [], classList: [],)));
                    },
                    child: Container(padding: const EdgeInsets.all(10), height: 50, width: 50,)),
              ],),
            ),
          ]),
        ),),
      ),
    );
  }
}
