import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taph/common/common_widget.dart';
import 'package:taph/common/constant_theme.dart';
import 'package:taph/common/storage.dart';
import 'package:taph/service/auth_service.dart';

import '../common/default.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  User? user = FirebaseAuth.instance.currentUser;
  TextEditingController oldPass = TextEditingController();
  TextEditingController newPass = TextEditingController();
  TextEditingController verifyPass = TextEditingController();
  var _isLoading = false;
  String? error;
  bool success = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ConstantTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: ConstantTheme.background,
            title: const Text(
              'Đổi mật khẩu',
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
                      const SizedBox(height: 200,),
                      textField("Mật khẩu cũ", oldPass, isPassword: true, validator: validateNotBlank, enable: !_isLoading),
                      textField("Mật khẩu mới", newPass, isPassword: true, validator: validateNotBlank, enable: !_isLoading),
                      textField("Nhập lại mật khẩu", verifyPass, isPassword: true, validator: validateNotBlank, enable: !_isLoading),
                      const SizedBox(height: 4,),
                      error != null ? Text(error!,
                          style: const TextStyle(color: ConstantTheme.nearlyRed, fontSize: 11))
                          : const SizedBox(),
                      success ? const Text('Cập nhật mật khẩu thành công',
                          style: TextStyle(color: ConstantTheme.nearlyBlue, fontSize: 11))
                          : const SizedBox(),
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
                        await login(user!.email!, oldPass.text).then((value) async {
                          if (value == null) {
                            if (newPass.text == verifyPass.text) {
                              await user?.updatePassword(newPass.text);
                              error = null;
                              success = true;
                            } else {
                              error = 'Xác nhận mật khẩu không đúng';
                              success = false;
                            }
                          } else {
                            error = 'Mật khẩu cũ không đúng';
                            success = false;
                          }
                        });
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

  String? validateNotBlank(value) {
    if (value == null || value.isEmpty) {
      return 'Dữ liệu không được để trống';
    }
    return null;
  }
}
