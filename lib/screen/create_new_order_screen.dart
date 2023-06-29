import 'dart:io';

import 'package:flutter/material.dart';
import 'package:taph/common/constant_theme.dart';

class CreateNewOrderScreen extends StatefulWidget {
  const CreateNewOrderScreen({Key? key}) : super(key: key);

  @override
  _CreateNewOrderScreenState createState() => _CreateNewOrderScreenState();
}

class _CreateNewOrderScreenState extends State<CreateNewOrderScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: ConstantTheme.background,
        child: Text("Tạo đơn hàng mới")
    );
  }
}
