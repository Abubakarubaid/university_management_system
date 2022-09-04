import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:launch_review/launch_review.dart';
import 'package:provider/provider.dart';

import '../assets/app_assets.dart';
import '../providers/auth_provider.dart';
import '../utilities/base/my_message.dart';
import '../utilities/constants.dart';
import '../widgets/progress_bar.dart';
import 'admin/admin_profile.dart';
import 'auth/login_page.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  String appName = "";
  String packageName = "";
  String version = "";
  String buildNumber = "";

  String authToken = "";
  bool progressBar = false;

  void getToken() {
    Constants.getAuthToken().then((value) {
      setState(() {
        authToken = value;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getToken();
    getPackageInfo();
  }

  void getPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    setState(() {
      appName = packageInfo.appName;
      packageName = packageInfo.packageName;
      version = packageInfo.version;
      buildNumber = packageInfo.buildNumber;
    });
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
            Opacity(opacity: 0.08, child: Align(alignment: Alignment.bottomCenter, child: Image.asset(AppAssets.main_app_logo))),
            Column(
              children: [
                SizedBox(height: 80,),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) {
                      return const AdminProfile();
                    }));
                  },
                  child: Card(
                    margin: EdgeInsets.only(top: 10, left: 16, right: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    shadowColor: Color(0xFFD7D7D7),
                    elevation: 3,
                    clipBehavior: Clip.antiAlias,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(left: 16, right: 16),
                      height: 60,
                      child: Row(
                        children: [
                          Icon(Icons.verified_user, color: AppAssets.textLightColor,),
                          SizedBox(width: 16,),
                          Expanded(child: Text("Admin Profile", style: AppAssets.latoBold_textDarkColor_16, maxLines: 1, overflow: TextOverflow.ellipsis,)),
                        ],
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    showDialog<String>(
                      context: context,
                      builder: (context) => StatefulBuilder(builder: (context, setState) =>AlertDialog(
                        title: Text("App Info",textAlign: TextAlign.center, style: AppAssets.latoBold_primaryColor_18,),
                        content: Column(mainAxisSize: MainAxisSize.min,children: [
                          Container(
                            margin: EdgeInsets.only(top: 12),
                            child: Align(alignment: Alignment.centerLeft, child: Text("App Name",textAlign: TextAlign.center, style: AppAssets.latoBold_textDarkColor_16,)),
                          ),
                          Container(
                            height: 40,
                            width: double.infinity,
                            margin: EdgeInsets.only(top: 6),
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                            decoration: BoxDecoration(
                              color: Color(0xFFF5F5F5),
                              borderRadius: new BorderRadius.circular(12.0),
                            ),
                            child: Align(alignment: Alignment.centerLeft, child: Text("${appName}",textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: Color(0xFF333333).withOpacity(0.5),))),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 12),
                            child: Align(alignment: Alignment.centerLeft, child: Text("Version No",textAlign: TextAlign.center, style: AppAssets.latoBold_textDarkColor_16,)),
                          ),
                          Container(
                            height: 40,
                            width: double.infinity,
                            margin: EdgeInsets.only(top: 6),
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                            decoration: BoxDecoration(
                              color: Color(0xFFF5F5F5),
                              borderRadius: new BorderRadius.circular(12.0),
                            ),
                            child: Align(alignment: Alignment.centerLeft, child: Text("${buildNumber}",textAlign: TextAlign.center, style: TextStyle( fontSize: 13, color: Color(0xFF333333).withOpacity(0.5),),)),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 12),
                            child: Align(alignment: Alignment.centerLeft, child: Text("Version Name",textAlign: TextAlign.center, style: AppAssets.latoBold_textDarkColor_16,)),
                          ),
                          Container(
                            height: 40,
                            width: double.infinity,
                            margin: EdgeInsets.only(top: 6),
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                            decoration: BoxDecoration(
                              color: Color(0xFFF5F5F5),
                              borderRadius: new BorderRadius.circular(12.0),
                            ),
                            child: Align(alignment: Alignment.centerLeft, child: Text("${version}",textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: Color(0xFF333333).withOpacity(0.5),),)),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              padding: EdgeInsets.only(left: 20, right: 20),
                              margin: EdgeInsets.only(left: 50, right: 50, bottom: 20, top: 20),
                              height: 46,
                              decoration: new BoxDecoration(
                                color: AppAssets.primaryColor,
                                border: new Border.all(color: Colors.white, width: 2.0),
                                borderRadius: new BorderRadius.circular(12.0),
                              ),
                              child: Center(child: Text("Done", style: AppAssets.latoBold_whiteColor_16, textAlign: TextAlign.center, )),
                            ),
                          ),
                        ],),
                      )),
                    );
                  },
                  child: Card(
                    margin: EdgeInsets.only(top: 10, left: 16, right: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    shadowColor: Color(0xFFD7D7D7),
                    elevation: 3,
                    clipBehavior: Clip.antiAlias,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(left: 16, right: 16),
                      height: 60,
                      child: Row(
                        children: [
                          Icon(Icons.app_registration, color: AppAssets.textLightColor,),
                          SizedBox(width: 16,),
                          Expanded(child: Text("About", style: AppAssets.latoBold_textDarkColor_16, maxLines: 1, overflow: TextOverflow.ellipsis,)),
                        ],
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    showDialog<String>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text("Contact us",textAlign: TextAlign.center, style: AppAssets.latoBold_primaryColor_18,),
                        content: Column(mainAxisSize: MainAxisSize.min,children: [
                          Container(
                            margin: EdgeInsets.only(top: 12),
                            child: Align(alignment: Alignment.centerLeft, child: Text("Phone",textAlign: TextAlign.center, style: AppAssets.latoBold_textDarkColor_16,)),
                          ),
                          Container(
                            height: 40,
                            width: double.infinity,
                            margin: EdgeInsets.only(top: 6),
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                            decoration: BoxDecoration(
                              color: Color(0xFFF5F5F5),
                              borderRadius: new BorderRadius.circular(12.0),
                            ),
                            child: Align(alignment: Alignment.centerLeft, child: Text("+92 321 6045522",textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: Color(0xFF333333).withOpacity(0.5),),)),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 12),
                            child: Align(alignment: Alignment.centerLeft, child: Text("Email",textAlign: TextAlign.center, style: AppAssets.latoBold_textDarkColor_16,)),
                          ),
                          Container(
                            height: 40,
                            width: double.infinity,
                            margin: EdgeInsets.only(top: 6),
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                            decoration: BoxDecoration(
                              color: Color(0xFFF5F5F5),
                              borderRadius: new BorderRadius.circular(12.0),
                            ),
                            child: Align(alignment: Alignment.centerLeft, child: Text("hassaan.ubaid@uoc.edu.pk",textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: Color(0xFF333333).withOpacity(0.5),),)),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 12),
                            child: Align(alignment: Alignment.centerLeft, child: Text("Address",textAlign: TextAlign.center, style: AppAssets.latoBold_textDarkColor_16,)),
                          ),
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(top: 6),
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            decoration: BoxDecoration(
                              color: Color(0xFFF5F5F5),
                              borderRadius: new BorderRadius.circular(12.0),
                            ),
                            child: Align(alignment: Alignment.centerLeft, child: Text("UOC, Chakwal, Pakistan",textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: Color(0xFF333333).withOpacity(0.5),),)),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              padding: EdgeInsets.only(left: 20, right: 20),
                              margin: EdgeInsets.only(left: 50, right: 50, bottom: 20, top: 20),
                              height: 46,
                              decoration: new BoxDecoration(
                                color: AppAssets.primaryColor,
                                border: new Border.all(color: Colors.white, width: 2.0),
                                borderRadius: new BorderRadius.circular(12.0),
                              ),
                              child: Center(child: Text("Done", style: AppAssets.latoBold_whiteColor_16, textAlign: TextAlign.center, )),
                            ),
                          ),
                        ],),
                      ),
                    );
                  },
                  child: Card(
                    margin: EdgeInsets.only(top: 10, left: 16, right: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    shadowColor: Color(0xFFD7D7D7),
                    elevation: 3,
                    clipBehavior: Clip.antiAlias,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(left: 16, right: 16),
                      height: 60,
                      child: Row(
                        children: [
                          Icon(Icons.phone, color: AppAssets.textLightColor),
                          SizedBox(width: 16,),
                          Expanded(child: Text("Contact Us", style: AppAssets.latoBold_textDarkColor_16, maxLines: 1, overflow: TextOverflow.ellipsis,)),
                        ],
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    LaunchReview.launch();
                  },
                  child: Card(
                    margin: EdgeInsets.only(top: 10, left: 16, right: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    shadowColor: Color(0xFFD7D7D7),
                    elevation: 3,
                    clipBehavior: Clip.antiAlias,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(left: 16, right: 16),
                      height: 60,
                      child: Row(
                        children: [
                          Icon(Icons.feedback, color: AppAssets.textLightColor),
                          SizedBox(width: 16,),
                          Expanded(child: Text("Give Feedback", style: AppAssets.latoBold_textDarkColor_16, maxLines: 1, overflow: TextOverflow.ellipsis,)),
                        ],
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: !progressBar,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        progressBar = true;
                      });
                      Provider.of<AuthProvider>(context, listen: false).userLogout(authToken).then((value) async {
                        if(value.isSuccess)  {
                          MyMessage.showSuccessMessage(value.message, context);
                          await Future.delayed(const Duration(milliseconds: 3000),(){});
                          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                              LoginPage()), (Route<dynamic> route) => false);
                        }else{
                          MyMessage.showFailedMessage(value.message, context);
                        }
                        setState(() {
                          progressBar = false;
                        });
                      });
                    },
                    child: Card(
                      margin: EdgeInsets.only(top: 10, left: 16, right: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      shadowColor: Color(0xFFD7D7D7),
                      elevation: 3,
                      clipBehavior: Clip.antiAlias,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.only(left: 16, right: 16),
                        height: 60,
                        child: Row(
                          children: [
                            Icon(Icons.logout, color: AppAssets.textLightColor),
                            SizedBox(width: 16,),
                            Expanded(child: Text("Logout", style: AppAssets.latoBold_textDarkColor_16, maxLines: 1, overflow: TextOverflow.ellipsis,)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(visible: progressBar, child: const SizedBox(height: 80,child: ProgressBarWidget())),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("Developed by", style: TextStyle(color: Colors.black.withOpacity(0.3), fontSize: 12),),
                        Text("Dr. Hafiz Hassan Ubaid", style: TextStyle(color: Colors.black.withOpacity(0.3), fontSize: 14),),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],),
        ),
      ),
    );
  }
}
