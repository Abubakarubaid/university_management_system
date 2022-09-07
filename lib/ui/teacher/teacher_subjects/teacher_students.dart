import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:university_management_system/ui/admin/students/add_students.dart';
import 'package:university_management_system/ui/admin/students/student_complete_profile.dart';
import 'package:university_management_system/widgets/no_data.dart';
import 'package:university_management_system/widgets/primary_button.dart';
import 'package:university_management_system/widgets/primary_search_field.dart';
import 'package:university_management_system/widgets/primary_text_field.dart';
import '../../../assets/app_assets.dart';
import '../../../models/class_model.dart';
import '../../../models/teacher_workload_model.dart';
import '../../../models/user_model.dart';
import '../../../widgets/progress_bar.dart';

class TeacherStudents extends StatefulWidget {
  TeacherWorkloadModel teacherWorkloadModel;
  TeacherStudents({required this.teacherWorkloadModel, Key? key}) : super(key: key);

  @override
  State<TeacherStudents> createState() => _TeacherStudentsState();
}

class _TeacherStudentsState extends State<TeacherStudents> {

  var searchController = TextEditingController();

  List<UserModel> searchList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: AppAssets.backgroundColor,
          child: Stack(children: [
            Container(
              margin: const EdgeInsets.only(top: 60),
              child: Column(children: [
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: PrimarySearchFiled(
                      controller: searchController,
                      hint: "Search here",
                      keyboardType: TextInputType.text,
                      onChange: onTextChanged
                  ),
                ),
                Expanded(
                  child: widget.teacherWorkloadModel.studentList.isEmpty ?
                  const NoDataFound() :
                  searchList.isEmpty ?
                  ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: widget.teacherWorkloadModel.studentList.length,
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
                                  padding: const EdgeInsets.all(12),
                                  child: Container(
                                    clipBehavior: Clip.antiAlias,
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                          //border: Border.all(color: AppAssets.textLightColor, width: 1),
                                          borderRadius: BorderRadius.circular(35)
                                      ),
                                      child: SvgPicture.asset(widget.teacherWorkloadModel.studentList[index].userGender == "female" ? AppAssets.femaleAvatar : AppAssets.maleAvatar, fit: BoxFit.fill, color: AppAssets.textDarkColor,)),
                                ),
                                const SizedBox(width: 6,),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.only(right: 16),
                                        child: Align(alignment: Alignment.centerLeft, child: Text(widget.teacherWorkloadModel.studentList[index].userRollNo == "null" ? "" : widget.teacherWorkloadModel.studentList[index].userRollNo, style: AppAssets.latoBold_textDarkColor_14, maxLines: 1, overflow: TextOverflow.ellipsis,)),
                                      ),
                                      const SizedBox(height: 4,),
                                      Container(
                                        padding: const EdgeInsets.only(right: 16),
                                        child: Align(alignment: Alignment.centerLeft, child: Text(widget.teacherWorkloadModel.studentList[index].userName == "null" ? "" : widget.teacherWorkloadModel.studentList[index].userName, style: AppAssets.latoRegular_textDarkColor_16, maxLines: 2, overflow: TextOverflow.ellipsis,)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],),
                            ),
                            Container(height: 1, width: double.infinity, color: AppAssets.textLightColor,),
                          ],),
                        );
                      }) :
                  ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: searchList.length,
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
                                  padding: const EdgeInsets.all(12),
                                  child: Container(
                                      clipBehavior: Clip.antiAlias,
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        //border: Border.all(color: AppAssets.textLightColor, width: 1),
                                          borderRadius: BorderRadius.circular(35)
                                      ),
                                      child: SvgPicture.asset(searchList[index].userGender == "female" ? AppAssets.femaleAvatar : AppAssets.maleAvatar, fit: BoxFit.fill, color: AppAssets.textDarkColor,)),
                                ),
                                const SizedBox(width: 6,),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.only(right: 16),
                                        child: Align(alignment: Alignment.centerLeft, child: Text(searchList[index].userRollNo == "null" ? "" : searchList[index].userRollNo, style: AppAssets.latoBold_textDarkColor_14, maxLines: 1, overflow: TextOverflow.ellipsis,)),
                                      ),
                                      const SizedBox(height: 4,),
                                      Container(
                                        padding: const EdgeInsets.only(right: 16),
                                        child: Align(alignment: Alignment.centerLeft, child: Text(searchList[index].userName == "null" ? "" : searchList[index].userName, style: AppAssets.latoRegular_textDarkColor_16, maxLines: 2, overflow: TextOverflow.ellipsis,)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],),
                            ),
                            Container(height: 1, width: double.infinity, color: AppAssets.textLightColor,),
                          ],),
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
                Expanded(child: Container(padding: const EdgeInsets.only(left: 20, right: 20), child: Center(child: Text("Students", style: AppAssets.latoBold_textDarkColor_20)))),
                Container(alignment: Alignment.centerRight,padding: const EdgeInsets.only(top: 10, left: 10, bottom: 10, right: 10), height: 50, width: 50, child: Text("${widget.teacherWorkloadModel.studentList.length}", style: AppAssets.latoBold_textDarkColor_20,),),
              ],),
            ),
          ]),
        ),
      ),
    );
  }

  onTextChanged(String text) async {
    print("______: ${text}");
    setState(() {searchList.clear();});
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    if(text.toLowerCase().isEmpty){
      setState(() {searchList.clear();});
    }

    widget.teacherWorkloadModel.studentList.forEach((data) {
      if (data.userName.toLowerCase().contains(text.toLowerCase()) ||
          data.userRollNo.toLowerCase().contains(text.toLowerCase())) {
        setState(() {searchList.add(data);});
      }
    });
  }
}
