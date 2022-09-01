import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:university_management_system/ui/admin/students/add_students.dart';
import 'package:university_management_system/ui/admin/students/student_complete_profile.dart';
import 'package:university_management_system/widgets/no_data.dart';
import 'package:university_management_system/widgets/primary_button.dart';
import 'package:university_management_system/widgets/primary_search_field.dart';
import 'package:university_management_system/widgets/primary_text_field.dart';
import '../../../assets/app_assets.dart';
import '../../../models/class_model.dart';
import '../../../models/dpt_model.dart';
import '../../../models/student_model.dart';
import '../../../models/user_model.dart';
import '../../../providers/app_provider.dart';
import '../../../utilities/constants.dart';
import '../../../widgets/progress_bar.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ViewStudents extends StatefulWidget {
  const ViewStudents({Key? key}) : super(key: key);

  @override
  State<ViewStudents> createState() => _ViewStudentsState();
}

class _ViewStudentsState extends State<ViewStudents> {

  var searchController = TextEditingController();

  List<DepartmentModel> departmentList = [];
  DepartmentModel dptSelectedValue = DepartmentModel(departmentId: 0, departmentName: "Select Department", departmentType: "Demo");
  var departmentItems;

  List<ClassModel> classList = [];
  ClassModel classSelectedValue = ClassModel(classId: 0, className: "Select Class", classSemester: "", classType: "", departmentModel: DepartmentModel.getInstance());
  var classItems;

  List<StudentModel> searchList = [];
  String authToken = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Constants.getAuthToken().then((value) {
      authToken = value;
    });

    getStudents();
    getDepartments(false);
    getClasses(false);
  }

  void getStudents() async {
    Provider.of<AppProvider>(context, listen: false).fetchAllStudents("student", authToken);
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

  void getClasses(bool specific) async {
    if(!specific) {
      classList.clear();
      Provider.of<AppProvider>(context, listen: false).fetchAllClasses(
          Constants.getAuthToken().toString()).then((value) {
        setState(() {
          if (value.isSuccess) {
            classList = Provider.of<AppProvider>(context, listen: false).classList;
            classList.add(classSelectedValue);
            classList.sort((a, b) => a.classId.compareTo(b.classId));

            classItems = classList.map((item) {
              return DropdownMenuItem<ClassModel>(
                child: Text("${item.className} ${item.classSemester} ${item
                    .classType}"),
                value: item,
              );
            }).toList();

            // if list is empty, create a dummy item
            if (classItems.isEmpty) {
              classItems = [
                DropdownMenuItem(
                  child: Text(classSelectedValue.className),
                  value: classSelectedValue,
                )
              ];
            } else {
              classSelectedValue = classList[0];
            }
          }
        });
      });
    }
    else{
      setState(() {
        classSelectedValue = classList[0];

        List<ClassModel> searchedList = [];
        classList.forEach((element) {
          if(dptSelectedValue.departmentId == element.departmentModel.departmentId){
            searchedList.add(element);
          }
        });

        classItems = searchedList.map((item) {
          return DropdownMenuItem<ClassModel>(
            child: Text("${item.className} ${item.classSemester} ${item
                .classType}"),
            value: item,
          );
        }).toList();

        // if list is empty, create a dummy item
        if (classItems.isEmpty) {
          classItems = [
            DropdownMenuItem(
              child: Text(classSelectedValue.className),
              value: classSelectedValue,
            )
          ];
        } else {
          classSelectedValue = searchedList[0];
        }
      });
    }
  }

  filter(ClassModel value){
    setState(() {
      classSelectedValue = value;
    });
    onFilterChanged("${value.className} ${value.classSemester} ${value.classType}", dptSelectedValue.departmentName);
    Navigator.of(context).pop();
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
                  visible: dptSelectedValue.departmentId != 0 && classSelectedValue.classId != 0,
                  child: Container(padding: const EdgeInsets.only(top: 20, left: 20, bottom: 20), color: Colors.white, width: double.infinity, child: Row(children: [
                    Expanded(
                      child: Column(children: [
                        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text("Department:  " ,style: AppAssets.latoBold_textDarkColor_16,),
                          Expanded(child: Text(dptSelectedValue.departmentName ,style: AppAssets.latoRegular_textDarkColor_16,)),
                        ],),
                        const SizedBox(height: 10,),
                        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text("Class:  " ,style: AppAssets.latoBold_textDarkColor_16,),
                          Expanded(child: Text("${classSelectedValue.className} ${classSelectedValue.classSemester} ${classSelectedValue.classType}" ,style: AppAssets.latoRegular_textDarkColor_16,)),
                        ],),
                      ],),
                    ),
                    const SizedBox(height: 10,),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                         getDepartments(true);
                         getClasses(true);
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
                        onChange: onTextChanged
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
                                      getClasses(true);
                                    });
                                  },
                                  items: departmentItems,
                                ),
                              ),
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
                                child: DropdownButton<ClassModel>(
                                  value: classSelectedValue,
                                  icon: const Icon(Icons.arrow_drop_down),
                                  underline: Container(
                                    height: 0,
                                    color: Colors.transparent,
                                  ),
                                  isExpanded: true,
                                  onChanged: (value) {
                                    filter(value!);
                                  },
                                  items: classItems,
                                ),
                              ),
                              const SizedBox(height: 20,),
                              /*PrimaryButton(
                                width: double.infinity,
                                height: 50,
                                buttonMargin: const EdgeInsets.only(top: 20, bottom: 30),
                                buttonPadding: const EdgeInsets.all(12),
                                buttonText: "Search Student",
                                buttonTextStyle: AppAssets.latoBold_whiteColor_16,
                                shadowColor: AppAssets.shadowColor,
                                buttonRadius: BorderRadius.circular(30),
                                onPress: () {

                                },
                              ),*/
                            ],),);
                          });
                        });
                    }, child: Container(alignment: Alignment.center, height: 50, width: 50, child: Icon(Icons.filter_list_alt, color: dptSelectedValue.departmentId != 0 && classSelectedValue.classId != 0 ? AppAssets.primaryColor : AppAssets.textDarkColor,),))),
                  ],),
                ),
                Expanded(
                  child: appProvider.studentProgress ?
                  const Center(child: SizedBox(height: 80, child: ProgressBarWidget(),)) :
                  appProvider.studentList.isEmpty ?
                  const NoDataFound() :
                  searchList.isEmpty ?
                  ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: appProvider.studentList.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => StudentCompleteProfile(studentModel: appProvider.studentList[index],),));
                          },
                          child: Container(
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
                                        child: SvgPicture.asset(appProvider.studentList[index].userModel.userGender == "female" ? AppAssets.femaleAvatar : AppAssets.maleAvatar, fit: BoxFit.fill, color: AppAssets.textDarkColor,)),
                                  ),
                                  const SizedBox(width: 6,),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.only(right: 16),
                                          child: Align(alignment: Alignment.centerLeft, child: Text(appProvider.studentList[index].userModel.userRollNo, style: AppAssets.latoBold_textDarkColor_14, maxLines: 1, overflow: TextOverflow.ellipsis,)),
                                        ),
                                        const SizedBox(height: 4,),
                                        Container(
                                          padding: const EdgeInsets.only(right: 16),
                                          child: Align(alignment: Alignment.centerLeft, child: Text(appProvider.studentList[index].userModel.userName, style: AppAssets.latoRegular_textDarkColor_16, maxLines: 2, overflow: TextOverflow.ellipsis,)),
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
                      }) :
                  ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: searchList.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => StudentCompleteProfile(studentModel: searchList[index],),));
                          },
                          child: Container(
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
                                        child: SvgPicture.asset(searchList[index].userModel.userGender == "female" ? AppAssets.femaleAvatar : AppAssets.maleAvatar, fit: BoxFit.fill, color: AppAssets.textDarkColor,)),
                                  ),
                                  const SizedBox(width: 6,),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.only(right: 16),
                                          child: Align(alignment: Alignment.centerLeft, child: Text(searchList[index].userModel.userRollNo, style: AppAssets.latoBold_textDarkColor_14, maxLines: 1, overflow: TextOverflow.ellipsis,)),
                                        ),
                                        const SizedBox(height: 4,),
                                        Container(
                                          padding: const EdgeInsets.only(right: 16),
                                          child: Align(alignment: Alignment.centerLeft, child: Text(searchList[index].userModel.userName, style: AppAssets.latoRegular_textDarkColor_16, maxLines: 2, overflow: TextOverflow.ellipsis,)),
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
                GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddStudents(studentModel: StudentModel.getInstance(), departmentList: departmentList, classList: classList,)));
                    },
                    child: Container(padding: const EdgeInsets.all(10), height: 50, width: 50, child: Visibility(visible: !appProvider.progress,child: SvgPicture.asset(AppAssets.addIcon, color: AppAssets.iconsTintDarkGreyColor,)))),
              ],),
            ),
          ]),
        ),)
      ),
    );
  }

  onTextChanged(String text) async {
    setState(() {searchList.clear();});
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    if(text.toLowerCase().isEmpty){
      setState(() {searchList.clear();});
    }

    Provider.of<AppProvider>(context, listen: false).studentList.forEach((data) {
      if (data.userModel.userName.toLowerCase().contains(text.toLowerCase()) || data.userModel.userRollNo.toLowerCase().contains(text.toLowerCase())) {
        setState(() {searchList.add(data);});
      }
    });
  }

  onFilterChanged(String textClass, String textDepartment) async {
    setState(() {searchList.clear();});
    if (textClass.isEmpty || textDepartment.isEmpty) {
      setState(() {});
      return;
    }

    if(textClass.toLowerCase().isEmpty || textDepartment.toLowerCase().isEmpty){
      setState(() {searchList.clear();});
    }

    Provider.of<AppProvider>(context, listen: false).studentList.forEach((data) {
      print("______: ${data.departmentModel.departmentName}");
      if (data.departmentModel.departmentName.toLowerCase().contains(textDepartment.toLowerCase()) && "${data.classModel.className} ${data.classModel.classSemester} ${data.classModel.classType}".toLowerCase().contains(textClass.toLowerCase())) {
        setState(() {searchList.add(data);});
      }
    });
  }
}
