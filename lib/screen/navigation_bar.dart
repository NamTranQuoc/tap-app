import 'package:flutter/material.dart';
import 'package:taph/common/constant_theme.dart';
import 'package:taph/screen/personal_info_screen.dart';

import '../component/drawer_user_controller.dart';
import '../component/home_drawer.dart';
import 'change_password_screen.dart';
import 'navigation.dart';

class NavigationBarScreen extends StatefulWidget {
  const NavigationBarScreen({Key? key}) : super(key: key);

  @override
  _NavigationBarScreenState createState() => _NavigationBarScreenState();
}

class _NavigationBarScreenState extends State<NavigationBarScreen> {
  Widget? screenView;
  DrawerIndex? drawerIndex;

  @override
  void initState() {
    drawerIndex = DrawerIndex.HOME;
    screenView = const NavigationScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ConstantTheme.nearlyWhite,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          backgroundColor: ConstantTheme.nearlyWhite,
          body: DrawerUserController(
            screenIndex: drawerIndex,
            drawerWidth: MediaQuery.of(context).size.width * 0.75,
            onDrawerCall: (DrawerIndex drawerIndexdata) {
              changeIndex(drawerIndexdata);
              //callback from drawer for replace screen as user need with passing DrawerIndex(Enum index)
            },
            screenView: screenView,
            //we replace screen view as we need on navigate starting screens like MyHomePage, HelpScreen, FeedbackScreen, etc...
          ),
        ),
      ),
    );
  }

  void changeIndex(DrawerIndex drawerIndexdata) {
    if (drawerIndex != drawerIndexdata) {
      drawerIndex = drawerIndexdata;
      switch (drawerIndex) {
        case DrawerIndex.HOME:
          setState(() {
            screenView = const NavigationScreen();
          });
          break;
        case DrawerIndex.INFO_PERSON:
          setState(() {
            screenView = const PersonalInfoScreen();
          });
          break;
        case DrawerIndex.CHANGE_PASSWORD:
          setState(() {
            screenView = const ChangePasswordScreen();
          });
          break;
        default:
          break;
      }
    }
  }
}
