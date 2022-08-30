import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:university_management_system/assets/app_assets.dart';

class ProfileImagePick extends StatefulWidget {
  bool addButtonVisibility;
  ProfileImagePick({required this.addButtonVisibility,Key? key}) : super(key: key);
  _ProfileImagePickState pickState = _ProfileImagePickState();
  @override
  _ProfileImagePickState createState() => pickState;

  String getUri(){
    return pickState.getUri();
  }

}

class _ProfileImagePickState extends State<ProfileImagePick> {
  String _defaultImage = AppAssets.placeholder;
  final ImagePicker _picker = ImagePicker();
  late XFile? profileImg = null;

  getImage() async {
    // Pick an image
    profileImg = await _picker.pickImage(source: ImageSource.gallery);
    if (!profileImg!.path.isEmpty) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return getImageView();
  }

  getImageView() {
    if (profileImg != null) {
      print("-------------" + profileImg!.path);
      return MaterialButton(
          onPressed: () {
            getImage();
          },
          child: SizedBox(
            width: 130,
            height: 130,
            child: Stack(
              children: [
                Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                      boxShadow: const [BoxShadow(color: Color(0X10000009),blurRadius: 6, spreadRadius: 1)],
                      borderRadius: BorderRadius.circular(65), color: Colors.white),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(65),
                    child: FittedBox(
                      child: Image.file(
                        File(profileImg!.path),
                        fit: BoxFit.contain,
                      ),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Visibility(
                  visible: widget.addButtonVisibility != null? widget.addButtonVisibility: false,
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Image.asset(AppAssets.addButtonIcon, height: 40,width: 40,),
                  ),
                )
              ],
            ),
          )
      );
    } else {
      return MaterialButton(
          onPressed: () {
            getImage();
          },
          child:SizedBox(
            width: 130,
            height: 130,
            child: Stack(
              children: [
                Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(65), color: Colors.white,boxShadow: const [BoxShadow(color: Color(0X10000009),blurRadius: 6, spreadRadius: 1)]),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(65),
                    child: FittedBox(
                      child: Image.asset(_defaultImage),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Visibility(
                  visible: widget.addButtonVisibility != null ? widget.addButtonVisibility : false,
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Image.asset(AppAssets.addButtonIcon, height: 40,width: 40,),
                  ),
                )
              ],
            ),
          )


      );
    }
  }
  String getUri(){
    if(profileImg!=null){
      return profileImg!.path;
    }else{
      return "";
    }
  }
  @override

  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('_defaultImage', _defaultImage));
  }
}
