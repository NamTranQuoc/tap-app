
import 'package:barcode/barcode.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:taph/common/constant_theme.dart';
import 'package:select_form_field/select_form_field.dart';

Widget textField(String label,
    TextEditingController controller,
    {TextInputType type = TextInputType.text,
    int maxLine = 1, enable = true, validator, isPassword = false,
      autovalidateMode = AutovalidateMode.onUserInteraction}) {
  return Container(
      margin: const EdgeInsets.only(right: 25, left: 25, top: 10),
      padding: const EdgeInsets.only(left: 10, right: 10),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          border: Border.all(color: Colors.blueAccent)
      ),
      child: TextFormField(
        autovalidateMode: autovalidateMode,
        controller: controller,
        keyboardType: type,
        maxLines: maxLine,
        enabled: enable,
        validator: validator,
        obscureText: isPassword,
        style: const TextStyle(
          fontFamily: 'WorkSans',
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: ConstantTheme.nearlyBlue,
        ),
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
          helperStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: ConstantTheme.c4,
          ),
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            letterSpacing: 0.2,
            color: ConstantTheme.c4,
          ),
        ),
        onEditingComplete: () {},
      ));
}

Widget selectField(String label,
    TextEditingController controller,
    List<Map<String, dynamic>> item) {
  return Container(
      margin: const EdgeInsets.only(right: 25, left: 25, top: 10),
      padding: const EdgeInsets.only(left: 10, right: 10),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          border: Border.all(color: Colors.blueAccent)
      ),
      child: SelectFormField(
        type: SelectFormFieldType.dialog,
        enableSearch: true,
        items: item,
        controller: controller,
        style: const TextStyle(
          fontFamily: 'WorkSans',
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: ConstantTheme.nearlyBlue,
        ),
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
          helperStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: ConstantTheme.c4,
          ),
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            letterSpacing: 0.2,
            color: ConstantTheme.c4,
          ),
        ),
        onEditingComplete: () {},
      ));
}

Widget multiSelectField(String label,
    List items, List? selected, Function setState, {validator}) {
  return Container(
      margin: const EdgeInsets.only(right: 25, left: 25, top: 10),
      padding: const EdgeInsets.only(left: 4, right: 4),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          border: Border.all(color: Colors.blueAccent)
      ),
      child: MultiSelectFormField(
        border: InputBorder.none,
        validator: validator,
        chipBackGroundColor: Colors.red,
        autovalidate: AutovalidateMode.onUserInteraction,
        chipLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        dialogTextStyle: const TextStyle(fontWeight: FontWeight.bold),
        checkBoxActiveColor: Colors.red,
        checkBoxCheckColor: Colors.green,
        fillColor: Colors.transparent,
        title: Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        dataSource: [{'id': '4w6wlYTvTgAGTxpPFUEV', 'name': 'Bàn Phím'}, {'id': '6g5lCrl3LOtUTKvpBWhZ', 'name': 'Tai Nghe'}, {'id': 'ExAptA5q6pKEabDJJhqV', 'name': 'Linh Kiện'}, {'id': 'HIsYSexweaLhwdfgOvIM', 'name': 'Chuột'}, {'id': 'SGcC8tzbWzXIvG2OKg1M', 'name': 'Điện Thoại'}, {'id': 'YTpnLtwWHmkQCCZE2GdJ', 'name': 'Màn Hình'}, {'id': 'yTpga6HcNpQErcCleUA0', 'name': 'Laptop'}],
        textField: 'name',
        valueField: 'id',
        okButtonLabel: 'Chọn',
        cancelButtonLabel: 'Huỷ',
        hintWidget: const Text('Chọn một hoặc nhiều ngành hàng'),
        initialValue: selected,
        onSaved: (value) {
          if (value == null) return;
          setState(value);
        },
      ));
}

Widget buildBarcode(String barcode) {
  /// Create the Barcode
  final svg = Barcode.code128().toSvg(
    barcode,
    width: 300,
    height: 100,
  );
  return SvgPicture.string(svg);
}