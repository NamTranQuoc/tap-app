import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taph/common/common_widget.dart';
import 'package:taph/common/constant_theme.dart';
import 'package:taph/common/storage.dart';

import '../common/default.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({Key? key}) : super(key: key);

  @override
  _PersonalInfoScreenState createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  User? user = FirebaseAuth.instance.currentUser;
  TextEditingController name = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  var _isLoading = false;
  File? file;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    name.text = user!.displayName ?? '';
    phoneNumber.text = user!.phoneNumber ?? '';
  }

  @override
  Widget build(BuildContext context) {
    double width = (MediaQuery.of(context).size.width / 3) - 30;
    return Container(
      color: ConstantTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: ConstantTheme.background,
            title: const Text(
              'Thông tin các nhân',
              style: ConstantTheme.ts1,
            )
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      buildImage(width),
                      textField("Tên", name),
                      // textField("Số điện thoại", phoneNumber, type: TextInputType.number),
                    ],
                  ),
                ),
              ),
            ),
            const Divider(
              height: 1,
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, bottom: 16, top: 8),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: ConstantTheme.nearlyBlue,
                  borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.6),
                      blurRadius: 8,
                      offset: const Offset(4, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: OutlinedButton.icon(
                    onPressed: _isLoading ? null : () async {
                      setState(() => _isLoading = true);
                      if (_formKey.currentState!.validate()) {
                        await user?.updateDisplayName(name.text);
                        if (file != null) {
                          await uploadImage(file!, location: user!.photoURL).then((value) async {
                            await user?.updatePhotoURL(value);
                          });
                        }
                      }
                      setState(() {
                        _isLoading = false;
                      });
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0)
                      )),
                      backgroundColor: MaterialStateProperty.all(ConstantTheme.nearlyBlue),
                      side: MaterialStateProperty.all(const BorderSide(width: 5.0, color: ConstantTheme.nearlyBlue)),
                    ),
                    icon: _isLoading
                        ? Container(
                      width: 24,
                      height: 24,
                      padding: const EdgeInsets.all(2.0),
                      child: const CircularProgressIndicator(
                        color: ConstantTheme.c6,
                        strokeWidth: 3,
                      ),
                    )
                        : const Icon(Icons.add, color: ConstantTheme.c6,),
                    label: const Text('Cập nhật', style: TextStyle(color: ConstantTheme.c6),),
                  ),
                ),
              ),
            )
          ],
        )
      ),
    );
  }

  _getFromGallery() async {
    _picker.pickImage(source: ImageSource.gallery).then((value) {
      if (value != null) {
        file = File(value.path);
        setState(() {});
      }
    }).onError((error, stackTrace) {
      print("error" + error.toString());
    });
  }

  Widget buildImage(double width) {
    return InkWell(
      onTap: _getFromGallery,
      child: Container(
          width: width,
          height: width,
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              border: Border.all(color: Colors.blueAccent)
          ),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: AspectRatio(
                aspectRatio: 1.0,
                child: (file != null) ? Image.file(file!)
                    : Image.network(getDownloadUrl(user!.photoURL ?? Default.noImagePath)),
              ))),
    );
  }
}
