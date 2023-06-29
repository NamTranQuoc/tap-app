import 'package:intl/intl.dart';

int stringToTimeStamp(String s) {
  return DateFormat("dd-MM-yyyy").parse(s).millisecondsSinceEpoch;
}

String timestampToString(int timestamp, {String? format}) {
  return DateFormat(format ?? "dd-MM-yyyy HH:mm")
      .format(DateTime.fromMillisecondsSinceEpoch(timestamp));
}

String timestampToDate(int timestamp) {
  return DateFormat("dd-MM-yyyy")
      .format(DateTime.fromMillisecondsSinceEpoch(timestamp));
}

String formatMoney(int money) {
  var formatter = NumberFormat('###,###,###,###,###');
  return '${formatter.format(money)}đ';
}

String formatNameProduct(String name) {
  if (name.length > 24) {
    return '${name.substring(0, 24)}...';
  }
  return name;
}
