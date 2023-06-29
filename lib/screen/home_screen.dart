import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:taph/common/constant_theme.dart';
import 'package:taph/screen/create_new_order_screen.dart';
import 'package:taph/screen/product/add_product_screen.dart';
import 'package:taph/screen/product/list_product_view.dart';

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
          mainAxisAlignment: MainAxisAlignment.center,
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
                  TextButton(
                      onPressed: () {
                        scanBarcodeNormal().then((value) {
                          if (value != "") {
                            Navigator.push<dynamic>(
                              context,
                              MaterialPageRoute<dynamic>(
                                  builder: (BuildContext context) =>
                                  AddProductScreen(code: value,),
                                  fullscreenDialog: true),
                            );
                          }});
                      },
                      child: const Text("Thêm",
                        style: TextStyle(color: ConstantTheme.nearlyBlue),)
                  )
                ],
              )
            ),
            ListProductView(
              callBack: () {},
            ),
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
