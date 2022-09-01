import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:university_management_system/models/workload_model.dart';
import 'package:university_management_system/ui/admin/timetable/pdf/TimeTablePdfPreviewPage.dart';
import 'package:university_management_system/ui/admin/workload/pdf/PdfPreviewPage.dart';
import '../../../assets/app_assets.dart';
import '../../../models/dpt_model.dart';
import '../../../models/rooms_model.dart';
import '../../../models/teacher_model.dart';
import '../../../models/timeslots_model.dart';
import '../../../models/user_model.dart';
import '../../../providers/app_provider.dart';
import '../../../utilities/constants.dart';
import '../../../widgets/no_data.dart';
import '../../../widgets/primary_search_field.dart';
import '../../../widgets/progress_bar.dart';
import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;

class TeacherTimeTablePage extends StatefulWidget {
  const TeacherTimeTablePage({Key? key}) : super(key: key);

  @override
  State<TeacherTimeTablePage> createState() => _TeacherTimeTablePageState();
}

class _TeacherTimeTablePageState extends State<TeacherTimeTablePage> {

  String authToken = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Constants.getAuthToken().then((value) {
      authToken = value;
    });

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
            Opacity(opacity: 0.1, child: Center(child: Image.asset(AppAssets.timetable_new,))),
            Container(
              height: double.infinity,
              margin: const EdgeInsets.only(top: 60, left: 20, right: 20),
              child: Column(
                children: [
                  Expanded(
                    child: appProvider.progress ?
                    const Center(child: SizedBox(height: 80, child: ProgressBarWidget(),)) :
                    appProvider.workloadList.isEmpty ?
                    const NoDataFound() :
                    Container(),
                  ),
                ],
              ),
            ),
          ]),
        ),),
      ),
    );
  }
}
