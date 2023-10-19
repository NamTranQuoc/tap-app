
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:taph/entity/product_type.dart';

class Product {
  String id;
  String name;
  String code;
  List<String> images;
  List<ProductType> types;
  String description;
  DateTime createdDate;
  bool stocking;
  String createdBy;

  Product({
    this.id = '',
    this.name = '',
    required this.code,
    required this.images,
    required this.types,
    this.description = '',
    required this.createdDate,
    this.stocking = true,
    required this.createdBy
  });

  Product.fromSnapshot(QueryDocumentSnapshot doc)
      : this(
      id: doc.id,
      name: doc['name']! as String,
      code: doc['code']! as String,
      images: (doc['images'] as List).cast<String>(),
      types: ((doc['types'] as List).cast<Map<String, Object?>>())
          .map((e) => ProductType.fromJson(e)).toList(),
      description: doc['description'] as String,
      createdDate: (doc['created_date'] as Timestamp).toDate(),
      createdBy: doc['created_by'] as String
  );

  List<ProductType> toTypes(List<Map<String, Object>> data) {
    List<ProductType> pt = [];
    for (var element in data) {
      pt.add(ProductType.fromJson(element));
    }
    return pt;
  }

  Map<String, Object?> toJson() {
    var email = FirebaseAuth.instance.currentUser?.email;
    return {
      'name': name,
      'code': code,
      'images': images,
      'types': types.map((e) => e.toJson()).toList(),
      'description': description,
      'created_date': createdDate,
      'created_by': email
    };
  }
}