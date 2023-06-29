import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:taph/component/search.dart';
import 'package:taph/screen/personal_info_screen.dart';
import 'package:taph/common/constant_theme.dart';

import '../component/bottom_bar_view.dart';
import '../component/product_detail_view.dart';
import '../domain/tabIcon_data.dart';
import '../repository/product_repository.dart';
import 'home_screen.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({Key? key}) : super(key: key);

  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> with TickerProviderStateMixin {
  AnimationController? animationController;

  List<TabIconData> tabIconsList = TabIconData.tabIconsList;

  Widget tabBody = Container(
    color: ConstantTheme.background,
  );

  Widget appbar = const SizedBox();

  @override
  void initState() {
    for (var tab in tabIconsList) {
      tab.isSelected = false;
    }
    tabIconsList[0].isSelected = true;

    animationController = AnimationController(duration: const Duration(milliseconds: 600), vsync: this);
    tabBody = const HomeScreen();
    appbar = const Search();
    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ConstantTheme.background,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ConstantTheme.background,
          elevation: 0,
          title: appbar,
        ),
        backgroundColor: Colors.transparent,
        body: Container(
          padding: const EdgeInsets.only(top: 10),
          child: Stack(
            children: <Widget>[
              tabBody,
              bottomBar(),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> getData() async {
    return true;
  }

  Widget bottomBar() {
    return Column(
      children: <Widget>[
        const Expanded(
          child: SizedBox(),
        ),
        BottomBarView(
          tabIconsList: tabIconsList,
          addClick: () {
            scanBarcodeNormal().then((value) {
              if (value != "") {
                getProductByCode(value).then((p) {
                  if (p != null) {
                    Navigator.push<dynamic>(
                      context,
                      MaterialPageRoute<dynamic>(
                        builder: (BuildContext context) => ProductDetailView(
                          product: p,
                        ),
                      ),
                    );
                  }
                });
              }
            });
          },
          changeIndex: (int index) {
            if (index == 0) {
              animationController?.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody = const HomeScreen();
                  appbar = const Search();
                });
              });
            } else if (index == 1) {
              animationController?.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody = const HomeScreen();
                  appbar = const Text('Đấu giá hiện tại');
                });
              });
            } else if (index == 2) {
              animationController?.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody = const HomeScreen();
                  appbar = const Text('Bạn đang bán');
                });
              });
            } else if (index == 3) {
              animationController?.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody = const PersonalInfoScreen();
                  appbar = const Text('Thông tin cá nhân');
                });
              });
            }
          },
        ),
      ],
    );
  }

  Future<String> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = "";
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return "";

    return barcodeScanRes;
  }
}
