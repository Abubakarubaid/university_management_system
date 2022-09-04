import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../assets/app_assets.dart';
import '../../../models/dpt_model.dart';
import '../../../models/teacher_model.dart';
import '../../../models/user_model.dart';
import '../../../providers/app_provider.dart';
import '../../../utilities/base/my_message.dart';
import '../../../utilities/constants.dart';
import '../../../utilities/ip_configurations.dart';
import '../../../utilities/shared_preference_manager.dart';
import '../../../widgets/no_data.dart';
import '../../../widgets/primary_button.dart';
import '../../../widgets/progress_bar.dart';

class ViewTeacherDateSheet extends StatefulWidget {
  const ViewTeacherDateSheet({Key? key}) : super(key: key);

  @override
  State<ViewTeacherDateSheet> createState() => _ViewTeacherDateSheetState();
}

class _ViewTeacherDateSheetState extends State<ViewTeacherDateSheet> {

  String authToken = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Constants.getAuthToken().then((value) {
      authToken = value;
    });

    getDateSheet();
  }

  getDateSheet() async {
    await SharedPreferenceManager.getInstance().getUser().then((model) {
      Provider.of<AppProvider>(context, listen: false).fetchDateSheetPdf(model.userDepartment, authToken);
    });
    setState(() {});
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
        ),),
      ),
    );
  }
}
