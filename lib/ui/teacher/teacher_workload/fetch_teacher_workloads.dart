import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:university_management_system/models/workload_model.dart';
import '../../../assets/app_assets.dart';
import '../../../models/single_teacher_model.dart';
import '../../../widgets/no_data.dart';
import '../../../widgets/primary_search_field.dart';
import '../../../widgets/progress_bar.dart';

class TeacherWorkload extends StatefulWidget {
  SingleTeacherModel teacherModel;
  TeacherWorkload({required this. teacherModel, Key? key}) : super(key: key);

  @override
  State<TeacherWorkload> createState() => _TeacherWorkloadState();
}

class _TeacherWorkloadState extends State<TeacherWorkload> {

  @override
  void initState() {
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
            Opacity(opacity: 0.05, child: Center(child: Image.asset(AppAssets.workloadIcon,))),
            Container(
              height: double.infinity,
              margin: const EdgeInsets.only(top: 60, left: 20, right: 20),
              child: Column(
                children: [
                  Expanded(
                    child: widget.teacherModel.workloadList.isEmpty ? const NoDataFound() :
                    ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: widget.teacherModel.workloadList.length,
                      itemBuilder: (context, index) =>
                          Container(
                            clipBehavior: Clip.antiAlias,
                            margin: index == widget.teacherModel.workloadList.length-1 ? const EdgeInsets.only(top: 20, bottom: 30) : const EdgeInsets.only(top: 20),
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
                              message: widget.teacherModel.workloadList[index].workDemanded == "Demanded" ? "Demanded" : "Free",
                              color: widget.teacherModel.workloadList[index].workDemanded == "Demanded" ? Colors.red : Colors.green,
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
                                        Expanded(child: Text("${widget.teacherModel.workloadList[index].classModel.className} ${widget.teacherModel.workloadList[index].classModel.classSemester} ${widget.teacherModel.workloadList[index].classModel.classType}", style: AppAssets.latoBold_textDarkColor_16, maxLines: 1, overflow: TextOverflow.ellipsis,)),
                                      ],),
                                      const SizedBox(height: 8,),
                                      Row(children: [
                                        const SizedBox(width: 6,),
                                        Text("Subject Code: ", style: AppAssets.latoBold_textDarkColor_14, maxLines: 1, overflow: TextOverflow.ellipsis,),
                                        const SizedBox(width: 8,),
                                        Expanded(child: Text(widget.teacherModel.workloadList[index].subjectModel.subjectCode, style: AppAssets.latoRegular_textDarkColor_14, maxLines: 1, overflow: TextOverflow.ellipsis,)),
                                      ],),
                                      const SizedBox(height: 8,),
                                      Row(crossAxisAlignment: CrossAxisAlignment.start,children: [
                                        const SizedBox(width: 6,),
                                        Text("Subject Name: ", style: AppAssets.latoBold_textDarkColor_14, maxLines: 1, overflow: TextOverflow.ellipsis,),
                                        const SizedBox(width: 8,),
                                        Expanded(child: Text(widget.teacherModel.workloadList[index].subjectModel.subjectName, style: AppAssets.latoRegular_textDarkColor_14, maxLines: 2, overflow: TextOverflow.ellipsis,)),
                                      ],),
                                      const SizedBox(height: 8,),
                                      Row(children: [
                                        const SizedBox(width: 6,),
                                        Text("Teacher: ", style: AppAssets.latoBold_textDarkColor_14, maxLines: 1, overflow: TextOverflow.ellipsis,),
                                        const SizedBox(width: 8,),
                                        Expanded(child: Text(widget.teacherModel.userModel.userName, style: AppAssets.latoRegular_textDarkColor_14, maxLines: 1, overflow: TextOverflow.ellipsis,)),
                                      ],),
                                      const SizedBox(height: 8,),
                                      Expanded(
                                        child: Row(crossAxisAlignment: CrossAxisAlignment.start,children: [
                                          const Icon(Icons.subject, color: AppAssets.textLightColor,),
                                          const SizedBox(width: 8,),
                                          Expanded(child: Text(widget.teacherModel.workloadList[index].departmentModel.departmentId == widget.teacherModel.workloadList[index].subDepartmentModel.departmentId ? "${widget.teacherModel.workloadList[index].subDepartmentModel.departmentName} (own)" : "${widget.teacherModel.workloadList[index].subDepartmentModel.departmentName} (other)", style: AppAssets.latoRegular_textDarkColor_14, maxLines: 2, overflow: TextOverflow.ellipsis,)),
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
                Container(padding: const EdgeInsets.all(10), height: 50, width: 50,),
              ],),
            ),
          ]),
        ),
      ),
    );
  }
}
