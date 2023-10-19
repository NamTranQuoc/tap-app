import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taph/common/constant_theme.dart';

import '../../common/common_widget.dart';
import '../../common/storage.dart';
import '../../entity/product.dart';
import '../../entity/product_type.dart';
import '../../repository/product_repository.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({Key? key, required this.code, required this.barcode}) : super(key: key);

  final String code;
  final Widget barcode;

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  var _isLoading = false;
  bool _errorImage = false;
  final ImagePicker _picker = ImagePicker();
  List<File> imageFiles = [];
  List<ProductTypeController> types = [ProductTypeController()];
  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController codeText = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    codeText.text = widget.code;
  }

  @override
  Widget build(BuildContext context) {
    double widthImage = (MediaQuery.of(context).size.width / 3) - 30;
    return Container(
        color: ConstantTheme.background,
        child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Column(
              children: [
                getAppBarUI(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          const SizedBox(height: 8,),
                          widget.barcode,
                          const Padding(
                            padding: EdgeInsets.only(top: 8.0, left: 16, right: 16),
                            child: Text(
                              'Hình ảnh',
                              textAlign: TextAlign.left,
                              style: ConstantTheme.ts2,
                            ),
                          ),
                          listImage(widthImage),
                          const Divider(
                            thickness: 2,
                            endIndent: 32,
                            indent: 32,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 8.0, left: 16, right: 16),
                            child: Text(
                              'Thông tin chung',
                              textAlign: TextAlign.left,
                              style: ConstantTheme.ts2,
                            ),
                          ),
                          textField("Mã sản phẩm", codeText, type: TextInputType.text, enable: false, validator: validateNotBlank),
                          textField("Tên sản phẩm", name, type: TextInputType.text, enable: !_isLoading, validator: validateNotBlank),
                          textField("Mô tả", description, type: TextInputType.multiline, maxLine: 4, enable: !_isLoading),
                          const SizedBox(height: 10,),
                          const Divider(
                            thickness: 2,
                            endIndent: 32,
                            indent: 32,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 8.0, left: 16, right: 16),
                            child: Text(
                              'Loại Sản phẩm',
                              textAlign: TextAlign.left,
                              style: ConstantTheme.ts2,
                            ),
                          ),
                          listType(widthImage)
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
                        onPressed: _isLoading ? null : () {
                          setState(() => _isLoading = true);
                          if (_formKey.currentState!.validate() && imageFiles.isNotEmpty) {
                            uploadImages().then((value) {
                              var email = FirebaseAuth.instance.currentUser?.email;
                              Product product1 = Product(images: value,
                                  types: types.map((e) {
                                    return ProductType.fromController(e);
                                  }).toList(),
                                  createdDate: DateTime.now(),
                                  createdBy: email!,
                                  name: name.text,
                                  description: description.text,
                                  code: codeText.text);
                              addProduct(product1).then((value) {
                                Navigator.pop(context, true);
                              });
                            });
                          } else {
                            if (imageFiles.isEmpty) {
                              _errorImage = true;
                            }
                            setState(() {
                              _isLoading = false;
                            });
                          }
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
                        label: const Text('Lưu sản phẩm', style: TextStyle(color: ConstantTheme.c6),),
                      ),
                    ),
                  ),
                )
              ],
            )
        )
    );
  }

  String? validateNotBlank(value) {
    if (value == null || value.isEmpty) {
      return 'Dữ liệu không được để trống';
    }
    return null;
  }

  Future<List<String>> uploadImages() async {
    List<String> list = [];
    for (var element in imageFiles) {
      await uploadImage(element).then((value) {
        list.add(value);
      });
    }
    return list;
  }

  Widget listImage(double width) {
    if (imageFiles.isEmpty) {
      return buttonSelectImage();
    }
    return Column(
      children: buildImage(width),
    );
  }

  _getFromGallery() async {
    if (_errorImage) {
      setState(() => _errorImage = false);
    }
    _picker.pickMultiImage().then((value) {
      imageFiles.clear();
      if (value.isNotEmpty) {
        for (var element in value) {
          imageFiles.add(File(element.path));
        }
        setState(() {});
      }
    }).onError((error, stackTrace) {
      print("error" + error.toString());
    });
  }

  _getFromCamera() async {
    if (_errorImage) {
      setState(() => _errorImage = false);
    }
    _picker.pickImage(source: ImageSource.camera).then((value) {
      if (value != null) {
        imageFiles.add(File(value.path));
        setState(() {});
      }
    }).onError((error, stackTrace) {
      print("error" + error.toString());
    });
  }

  List<Widget> buildImage(double width) {
    List<Widget> widgets = [];
    List<Widget> items = [];
    for (var element in imageFiles) {
      items.add(Container(
          width: width,
          height: width,
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              border: Border.all(color: Colors.blueAccent)
          ),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: AspectRatio(
                aspectRatio: 1.0,
                child: Image.file(element),
              ))),
      );
      if (items.length == 3) {
        widgets.add(Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: items,
        ));
        items = [];
      }
    }if (items.length != 3) {
      widgets.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items,
      ));
      items = [];
    }
    widgets.add(buttonSelectImage());
    return widgets;
  }

  Widget buttonSelectImage() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
                onPressed: () {
                  if (!_isLoading) {
                    _getFromGallery();
                  }
                },
                child: const Text("Chọn",
                  style: TextStyle(color: ConstantTheme.nearlyBlue),)
            ),
            OutlinedButton(
                onPressed: () {
                  if (!_isLoading) {
                    _getFromCamera();
                  }
                },
                child: const Text("Chụp",
                  style: TextStyle(color: ConstantTheme.nearlyBlue),)
            )
          ],
        ),
        validatorImage()
      ],
    );
  }

  Widget validatorImage() {
    if (_errorImage) {
      return const Text("Chọn ít nhất một hình ảnh",
          style: TextStyle(color: ConstantTheme.nearlyRed, fontSize: 11));
    } else {
      return const SizedBox();
    }
  }

  Widget getAppBarUI() {
    return Container(
      decoration: BoxDecoration(
        color: ConstantTheme.background,
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              offset: const Offset(0, 2),
              blurRadius: 4.0),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top, left: 8, right: 8),
        child: Row(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(32.0),
                  ),
                  onTap: () {
                    Navigator.pop(context, false);
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.close),
                  ),
                ),
              ),
            ),
            const Expanded(
              child: Center(
                child: Text(
                  'Thêm sản phẩm',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
            )
          ],
        ),
      ),
    );
  }

  Widget listType(double width) {
    if (types.isEmpty) {
      return widgetAddAndRemoveType();
    }
    List<Widget> list = types.map((e) {
      return widgetType(e);
    }).toList();
    list.add(widgetAddAndRemoveType());
    return Column(
      children: list,
    );
  }

  Widget widgetAddAndRemoveType() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton(
          onPressed: () {
            if (!_isLoading) {
              _addType();
            }
          },
          child: const Text("Thêm",
              style: TextStyle(color: ConstantTheme.nearlyBlue)),
        ),
        const SizedBox(width: 10,),
        (types.length > 1) ? TextButton(
          onPressed: () {
            if (!_isLoading) {
              _removeType();
            }
          },
          child: const Text("Xoá",
              style: TextStyle(color: ConstantTheme.nearlyRed)),
        ) : const SizedBox()
      ],
    );
  }

  Widget widgetType(ProductTypeController productType) {
    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
      padding: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
          border: Border.all(color: ConstantTheme.c3),
          borderRadius: BorderRadius.circular(8)
      ),
      child: Column(
        children: [
          textField("Tên loại", productType.name, type: TextInputType.text, enable: !_isLoading, validator: validateNotBlank),
          textField("Giá", productType.price, type: TextInputType.number, enable: !_isLoading, validator: validateNotBlank),
          textField("Số lượng", productType.quantity, type: TextInputType.number, enable: !_isLoading, validator: validateNotBlank),
        ],
      ),
    );
  }

  _addType() {
    setState(() {
      types.add(ProductTypeController());
    });
  }

  _removeType() {
    setState(() {
      types.removeLast();
    });
  }
}
