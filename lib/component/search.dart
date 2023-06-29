import 'package:flutter/material.dart';
import 'package:taph/common/constant_theme.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  _Search createState() => _Search();
}

class _Search extends State<Search> {

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 32 ),
      child: TextFormField(
        style: const TextStyle(
          fontFamily: 'WorkSans',
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: ConstantTheme.c3,
        ),
        keyboardType: TextInputType.text,
        decoration: const InputDecoration(
          fillColor: ConstantTheme.nearlyWhite,
          filled: true,
          suffixIcon: Icon(Icons.search, color: ConstantTheme.c3),
          hintText: 'Tìm kiếm sản phẩm',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide.none
          ),
          helperStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: ConstantTheme.c4,
          ),
          labelStyle: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            letterSpacing: 0.2,
            color: ConstantTheme.c4,
          ),
        ),
        onEditingComplete: () {
          FocusScope.of(context).unfocus();
        },
      ),
    );
  }
}
