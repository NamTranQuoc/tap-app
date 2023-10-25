import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:taph/common/constant_theme.dart';
import 'package:taph/screen/product/add_product_screen.dart';
import 'package:taph/screen/product/list_product_view.dart';

import '../common/common_widget.dart';

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 8.0, left: 18, right: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Sản Phẩm',
                    textAlign: TextAlign.left,
                    style: ConstantTheme.ts1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: () {
                            scanBarcodeNormal().then((value) {
                              if (value != "" && value != "-1") {
                                Navigator.push<bool>(
                                  context,
                                  MaterialPageRoute<bool>(
                                      builder: (BuildContext context) =>
                                          AddProductScreen(code: value, barcode: buildBarcode(value)),
                                      fullscreenDialog: true),
                                ).then((value) {
                                  print(value);
                                  if (value != null && value) {
                                    keyListProductScreen.currentState?.reloadProduct();
                                  }
                                });
                              }});
                          },
                          child: const Text("Scan",
                            style: TextStyle(color: ConstantTheme.nearlyBlue),)
                      ),
                      TextButton(
                          onPressed: () {
                            var barcode = DateTime.now().millisecondsSinceEpoch.toString();
                            print(barcode);
                            Navigator.push<dynamic>(
                              context,
                              MaterialPageRoute<dynamic>(
                                  builder: (BuildContext context) =>
                                      AddProductScreen(code: barcode, barcode: buildBarcode(barcode),),
                                  fullscreenDialog: true),
                            ).then((value) {
                              if (value != null && value) {
                                keyListProductScreen.currentState?.reloadProduct();
                              }
                            });
                          },
                          child: const Text("Gen",
                            style: TextStyle(color: ConstantTheme.nearlyBlue),)
                      )
                    ],
                  )
                ],
              )
            ),
            ListProductView(key: keyListProductScreen,),
          ],
        )
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
