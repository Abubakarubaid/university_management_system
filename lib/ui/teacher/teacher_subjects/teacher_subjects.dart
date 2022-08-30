import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:university_management_system/models/subject_model.dart';
import 'package:university_management_system/ui/teacher/teacher_subjects/teacher_classes.dart';
import 'package:university_management_system/widgets/no_data.dart';
import 'package:university_management_system/widgets/primary_button.dart';
import 'package:university_management_system/widgets/primary_text_field.dart';
import '../../../assets/app_assets.dart';
import '../../../models/single_teacher_model.dart';
import '../../../widgets/progress_bar.dart';

class TeacherSubjects extends StatefulWidget {
  SingleTeacherModel teacherModel;
  TeacherSubjects({required this.teacherModel, Key? key}) : super(key: key);

  @override
  State<TeacherSubjects> createState() => _TeacherSubjectsState();
}

class _TeacherSubjectsState extends State<TeacherSubjects> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

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
              child: widget.teacherModel.workloadList.isEmpty ? const NoDataFound() :
              ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: widget.teacherModel.workloadList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => TeacherClasses(teacherModel: widget.teacherModel, subjectModel: widget.teacherModel.workloadList[index].subjectModel,)));
                      },
                      child: Container(
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
                                      child: Align(alignment: Alignment.centerLeft, child: Text(widget.teacherModel.workloadList[index].subjectModel.subjectCode, style: AppAssets.latoBold_textDarkColor_14, maxLines: 1, overflow: TextOverflow.ellipsis,)),
                                    ),
                                    const SizedBox(height: 4,),
                                    Container(
                                      padding: const EdgeInsets.only(right: 16),
                                      child: Align(alignment: Alignment.centerLeft, child: Text(widget.teacherModel.workloadList[index].subjectModel.subjectName, style: AppAssets.latoRegular_textDarkColor_16, maxLines: 2, overflow: TextOverflow.ellipsis,)),
                                    ),
                                    const SizedBox(height: 4,),
                                    Container(
                                      padding: const EdgeInsets.only(right: 16),
                                      child: Row(
                                        children: [
                                          Align(alignment: Alignment.centerLeft, child: Text("Credit Hours: ", style: AppAssets.latoBold_textDarkColor_14, maxLines: 1, overflow: TextOverflow.ellipsis,)),
                                          Align(alignment: Alignment.centerLeft, child: Text(widget.teacherModel.workloadList[index].subjectModel.creditHours.toString(), style: AppAssets.latoRegular_textDarkColor_16, maxLines: 1, overflow: TextOverflow.ellipsis,)),
                                        ],
                                      ),
                                    ),
                                  ],
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
                Container(padding: const EdgeInsets.all(10), height: 50, width: 50, ),
              ],),
            ),
          ]),
        ),
      ),
    );
  }
}
