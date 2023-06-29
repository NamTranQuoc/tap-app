import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taph/common/storage.dart';

class MyImagePicker extends StatefulWidget {
  @override
  _MyImagePicker createState() => _MyImagePicker();
}
class _MyImagePicker extends State<MyImagePicker> {
  /// Variables
  List<File> imageFiles = [];
  final ImagePicker _picker = ImagePicker();

  /// Widget
  @override
  Widget build(BuildContext context) {
    return Container(
        child: imageFiles.isEmpty
            ? Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                color: Colors.greenAccent,
                onPressed: () {
                  _getFromGallery();
                },
                child: Text("PICK FROM GALLERY"),
              ),
              Container(
                height: 40.0,
              ),
              RaisedButton(
                color: Colors.lightGreenAccent,
                onPressed: () {
                  // getDownloadUrl("images/mountains.png").then((value) {
                  //   print(value);
                  // });
                },
                child: Text("PICK FROM CAMERA"),
              )
            ],
          ),
        ): Container(
          child: ListView(
            children: imageFiles.map((e) {
              return Image.file(
                e,
                fit: BoxFit.cover,
              );
            }).toList(),
          ),
        )
    );
  }

  /// Get from gallery
  _getFromGallery() async {
    _picker.pickMultiImage().then((value) {
      print(value.length);
      if (!value.isEmpty) {
        for (var element in value) {
          imageFiles.add(File(element.path));
          // uploadImage(File(element.path));
        }

        setState(() {});
      }
    }).onError((error, stackTrace) {});
  }

  // /// Get from Camera
  // _getFromCamera() async {
  //   PickedFile? pickedFile = await ImagePicker().getImage(
  //     source: ImageSource.camera,
  //     maxWidth: 1800,
  //     maxHeight: 1800,
  //   );
  //   if (pickedFile != null) {
  //     setState(() {
  //       imageFile = File(pickedFile.path);
  //     });
  //   }
  // }
}