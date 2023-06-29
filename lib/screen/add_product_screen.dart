import 'dart:io';

import 'package:flutter/material.dart';
import 'package:taph/common/constant_theme.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: ConstantTheme.background,
        child: Text("Thêm sản phẩm")
    );
  }
}
