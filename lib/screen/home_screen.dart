import 'package:flutter/material.dart';
import 'package:taph/common/constant_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
  @override
  Widget build(BuildContext context) {
    return Container(
      color: ConstantTheme.background,
      child: Text("HOME")
    );
  }
}
