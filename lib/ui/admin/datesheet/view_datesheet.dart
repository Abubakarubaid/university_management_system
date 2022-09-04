import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:university_management_system/models/datesheet_upload_model.dart';
import 'package:university_management_system/utilities/ip_configurations.dart';
import 'package:university_management_system/utilities/shared_preference_manager.dart';
import '../../../assets/app_assets.dart';
import '../../../models/dpt_model.dart';
import '../../../providers/app_provider.dart';
import '../../../utilities/PdfPicker.dart';
import '../../../utilities/base/my_message.dart';
import '../../../utilities/constants.dart';
import '../../../widgets/no_data.dart';
import '../../../widgets/primary_button.dart';
import 'package:file_picker/file_picker.dart';

import '../../../widgets/progress_bar.dart';

class ViewDateSheet extends StatefulWidget {
  DepartmentModel departmentModel;
  ViewDateSheet({required this.departmentModel, Key? key}) : super(key: key);

  @override
  State<ViewDateSheet> createState() => _ViewDateSheetState();
}

class _ViewDateSheetState extends State<ViewDateSheet> {

  String authToken = "";
  String pdfText="Choose (PDF)";

  @override
  void initState() {
    super.initState();

    Constants.getAuthToken().then((value) {
      authToken = value;
    });

    getDateSheet();
  }

  getPdfData() async{
    PlatformFile? file = await PdfPicker.getInstance().getPdfFile();
    if(file != null){
      setState(() {
        pdfText = file.path!;

        if(pdfText != "Choose (PDF)"){
          DateSheetUploadModel model = DateSheetUploadModel.getInstance();
          var now = DateTime.now();
          var formatter = DateFormat('MMMM dd, yyyy');
          String formattedDate = formatter.format(now);
          model.dateSheetDate = formattedDate;
          model.dateSheetStatus = "Active";
          model.dateSheetFile = pdfText;
          model.departmentModel = widget.departmentModel;

          Provider.of<AppProvider>(context, listen: false).addDateSheetPdf(model, authToken).then((value) {
            if(value.isSuccess){
              MyMessage.showSuccessMessage(value.message, context);
              setState(() {
                pdfText="Choose (PDF)";
              });
            }else{
              MyMessage.showFailedMessage(value.message, context);
              setState(() {
                pdfText="Choose (PDF)";
              });
            }
          });

        }else{
          MyMessage.showFailedMessage("Please Choose Pdf File to upload", context);
          setState(() {
            pdfText="Choose (PDF)";
          });
        }
      });
    }else{
      MyMessage.showFailedMessage("Operation Cancelled", context);
      setState(() {
        pdfText="Choose (PDF)";
      });
    }
  }

  getDateSheet() async {
    Provider.of<AppProvider>(context, listen: false).fetchDateSheetPdf(widget.departmentModel.departmentId.toString(), authToken);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<AppProvider>(builder: (context, appProvider, child) {
          //print("_______________: ${IPConfigurations.serverImagePath}${appProvider.dateSheetUploadModel.dateSheetFile}");
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: AppAssets.backgroundColor,
            child: Stack(children: [
              Opacity(opacity: 0.05, child: Center(child: Image.asset(AppAssets.dateSheetColored,))),
              Container(
                height: double.infinity,
                margin: const EdgeInsets.only(top: 80, left: 20, right: 20, bottom: 20),
                child: Column(
                  children: [
                    Expanded(
                      child: appProvider.progress ?
                      const Center(child: SizedBox(height: 80, child: ProgressBarWidget(),)) :
                      appProvider.dateSheetUploadModel.dateSheetId == 0 ?
                      const NoDataFound() :
                      const PDF(fitPolicy: FitPolicy.BOTH,fitEachPage: true, pageFling: true,).fromUrl(
                        "${IPConfigurations.serverImagePath}${appProvider.dateSheetUploadModel.dateSheetFile}",
                        placeholder: (double progress) => Center(child: Text('$progress %')),
                        errorWidget: (dynamic error) => Center(child: Text(error.toString())),
                      ),
                    ),
                    Visibility(visible: appProvider.uploadProgress, child: const SizedBox(height:80, child: ProgressBarWidget())),
                    Visibility(
                      visible: !appProvider.uploadProgress,
                      child: PrimaryButton(
                        width: double.infinity,
                        height: 50,
                        buttonMargin: const EdgeInsets.only(top: 20),
                        buttonPadding: const EdgeInsets.all(12),
                        buttonText: "Upload new Date Sheet",
                        buttonTextStyle: AppAssets.latoBold_whiteColor_16,
                        shadowColor: AppAssets.shadowColor,
                        buttonRadius: BorderRadius.circular(30),
                        onPress: () async {
                          if(widget.departmentModel.departmentId == 0){
                            MyMessage.showFailedMessage("Please Select Department first", context);
                          }else {
                            getPdfData();
                          }
                        },
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
                  Expanded(child: Container(padding: const EdgeInsets.only(left: 20, right: 20), child: Center(child: Text("Date Sheet", style: AppAssets.latoBold_textDarkColor_20)))),
                  Container(padding: const EdgeInsets.all(10), height: 50, width: 50),
                ],),
              ),
            ]),
          );
        }),
      ),
    );
  }
}
