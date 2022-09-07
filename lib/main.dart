import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:university_management_system/providers/app_provider.dart';
import 'package:university_management_system/providers/auth_provider.dart';
import 'package:university_management_system/repositories/app_repo.dart';
import 'package:university_management_system/repositories/auth_repo.dart';
import 'package:university_management_system/ui/admin/admin_dashboard.dart';
import 'package:university_management_system/ui/admin/admin_dashboard_new.dart';
import 'package:university_management_system/ui/admin/dashboard.dart';
import 'package:university_management_system/ui/auth/login_page.dart';
import 'package:university_management_system/ui/teacher/main_teacher_dashboard.dart';
import 'package:university_management_system/ui/teacher/teacher_dashboard.dart';
import 'assets/app_assets.dart';
void main() {

  runApp(
      MultiProvider(providers: [
        ChangeNotifierProvider(create: (_)=> AuthProvider(authRepo: AuthRepo())),
        ChangeNotifierProvider(create: (_)=> AppProvider(appRepo: AppRepo())),
      ],
          child: const MyApp()
      )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LMS by Hafiz Hassan Ubaid',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    _navigateToNextScreen();
  }
  _navigateToNextScreen() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isLoggedIn = prefs.getBool("isLoggedIn");
    String userType = prefs.getString("type").toString();

    print("__________________: ${isLoggedIn} ${userType}");
    await Future.delayed(const Duration(milliseconds: 3000),(){});
    if(isLoggedIn == true && ("admin" == userType)){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Dashboard()));
    }else if(isLoggedIn == true && ("teacher" == userType)){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> MainTeacherDashboard()));
    }else{
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> LoginPage()));
    }
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: AppAssets.backgroundColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 150,
              width: 150,
              child: Image.asset("assets/icons/splash.png",),
            ),
            const SizedBox(height: 10,),
            Text("University Management System",style: AppAssets.latoBlack_primaryColor_10,),
          ],
        ),
      ),
    );

    //return TeacherDashboard();
  }
}
