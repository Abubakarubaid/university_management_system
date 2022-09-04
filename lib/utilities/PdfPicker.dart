import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class PdfPicker{
  PdfPicker.getInstance(){}

  Future<PlatformFile?> getPdfFile() async{
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      // File file = File(result.files.single.path!);
      PlatformFile file = result.files.first;
      print(file.name);
      print(file.bytes);
      print(file.size);
      print(file.extension);
      print(file.path);
      return file;
    } else {
      print("User Canceled");
      return null;
      // User canceled the picker
    }
  }
}