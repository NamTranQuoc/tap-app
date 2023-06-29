
import 'package:flutter/widgets.dart';

class ProductType {
  String name;
  int price;
  int quantity;

  ProductType({
    this.name = '',
    this.price = 0,
    this.quantity = 0
  });

  ProductType.fromJson(Map<String, Object?> json)
      : this(
    name: json['name'] as String,
    price: json['price'] as int,
    quantity: json['quantity'] as int
  );

  Map<String, Object?> toJson() {
    return {
      'name': name,
      'price': price,
      'quantity': quantity
    };
  }

  ProductType.fromController(ProductTypeController data)
      : this(
      name: data.name.text,
      price: int.parse(data.price.text),
      quantity: int.parse(data.quantity.text)
  );
}

class ProductTypeController {
  TextEditingController name = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController quantity = TextEditingController();

  ProductTypeController();
}