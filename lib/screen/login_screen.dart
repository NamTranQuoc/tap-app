
import 'package:flutter/material.dart';
import 'package:taph/common/constant_theme.dart';

import '../common/common_widget.dart';
import '../main.dart';
import '../service/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? error;
  bool success = false;
  bool isLoadingLogin = false;
  bool isLoadingSignUp = false;

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
            body: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("NFO", style: TextStyle(color: ConstantTheme.nearlyBlue, fontSize: 80, fontWeight: FontWeight.bold),),
                    const SizedBox(height: 40,),
                    textField("email", email, autovalidateMode: AutovalidateMode.disabled, validator: (value) {
                      const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
                          r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
                          r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
                          r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
                          r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
                          r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
                          r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
                      final regex = RegExp(pattern);

                      if (!value!.isNotEmpty) {
                        return 'Email không được để trống';
                      }
                      if (!regex.hasMatch(value)) {
                        return 'Email không đúng';
                      }
                      return null;
                    }, enable: !isLoadingLogin || !isLoadingSignUp),
                    const SizedBox(height: 10,),
                    textField("Mật khẩu", password, isPassword: true, validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Mật khẩu không được để trống';
                      }
                      return null;
                    }, enable: !isLoadingLogin || !isLoadingSignUp),
                    const SizedBox(height: 5,),
                    (error != null) ? Text(error!,
                        style: const TextStyle(color: ConstantTheme.nearlyRed, fontSize: 11))
                        : (success) ? const Text("Kiểm tra và xác nhận tài khoản trong email",
                        style: TextStyle(color: ConstantTheme.nearlyBlue, fontSize: 11))
                        : const SizedBox(),
                    const SizedBox(height: 40,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(onPressed: (isLoadingLogin || isLoadingSignUp) ? null : () async {
                          setState(() => isLoadingLogin = true);
                          if (_formKey.currentState!.validate()) {
                            await login(email.text, password.text).then((value) {
                              if (value == null) {
                                Navigator.push<dynamic>(
                                  context,
                                  MaterialPageRoute<dynamic>(
                                      builder: (BuildContext context) =>
                                      const MyApp(),
                                      fullscreenDialog: true),
                                );
                              } else {
                                error = value;
                              }
                            });
                          }
                          setState(() => isLoadingLogin = false);
                        },
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)
                            )),
                            backgroundColor: MaterialStateProperty.all(ConstantTheme.nearlyBlue),
                            padding: MaterialStateProperty.all(const EdgeInsets.only(left: 32, right: 32, top: 12, bottom: 12)),
                          ),
                          icon: isLoadingLogin
                              ? Container(
                            width: 24,
                            height: 24,
                            padding: const EdgeInsets.all(2.0),
                            child: const CircularProgressIndicator(
                              color: ConstantTheme.c6,
                              strokeWidth: 3,
                            ),
                          )
                              : const SizedBox(),
                          label: const Text("Đăng nhập", style: TextStyle(fontSize: 18, ),),),
                        const SizedBox(width: 10,),
                        ElevatedButton.icon(onPressed: (isLoadingLogin || isLoadingSignUp) ? null : () async {
                          setState(() => isLoadingSignUp = true);
                          if (_formKey.currentState!.validate()) {
                            await createAuth(email.text, password.text).then((value) {
                              if (value == null) {
                                success = true;
                                error = value;
                              } else {
                                success = false;
                                error = value;
                              }
                            });
                          }
                          setState(() => isLoadingSignUp = false);
                        },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(ConstantTheme.background),
                              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  side: const BorderSide(width: 1, color: ConstantTheme.nearlyBlue)
                              )),
                              padding: MaterialStateProperty.all(const EdgeInsets.only(left: 32, right: 32, top: 12, bottom: 12)),
                            ),
                            icon: isLoadingSignUp ? Container(
                              width: 24,
                              height: 24,
                              padding: const EdgeInsets.all(2.0),
                              child: const CircularProgressIndicator(
                                color: ConstantTheme.nearlyBlue,
                                strokeWidth: 3,
                              ),
                            )
                                : const SizedBox(),
                            label: const Text("Đăng ký", style: TextStyle(fontSize: 18, color: ConstantTheme.nearlyBlue),))
                      ],
                    ),
                    const SizedBox(height: 100,)
                  ],
                )
            )
        )
    );
  }
}
