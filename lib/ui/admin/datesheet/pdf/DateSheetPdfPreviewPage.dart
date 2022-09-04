import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:university_management_system/models/teacher_model.dart';
import 'package:university_management_system/models/workload_assignment_model.dart';
import '../../../../assets/app_assets.dart';
import '../../../../models/datesheet_model.dart';
import '../../../../models/rooms_model.dart';
import '../../../../models/timeslots_model.dart';
import '../../../../models/user_model.dart';
import '../../../../models/workload_model.dart';
import 'DateSheetPdfExport.dart';

class DateSheetPdfPreviewPage extends StatelessWidget {
  List<DatesheetModel> dateSheetList;
  DateSheetPdfPreviewPage({required this.dateSheetList, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: AppAssets.backgroundColor,
          child: Stack(
            children: [
              Image.asset(AppAssets.appDoodle, width: double.infinity, height: double.infinity, fit: BoxFit.cover, color: AppAssets.textLightColor.withOpacity(0.15),),
              PdfPreview(
                canChangeOrientation: true,
                canDebug: false,
                padding: const EdgeInsets.only(top: 100),
                build: (context) => makeDateSheetPdf(dateSheetList),
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
                  Expanded(child: Container(padding: const EdgeInsets.only(left: 20, right: 20), child: Center(child: Text("Time Table PDF", style: AppAssets.latoBold_textDarkColor_20)))),
                  Container(padding: const EdgeInsets.all(10), height: 50, width: 50,),
                ],),
              ),
            ],
          ),
        ),
      ),
    );
  }
}