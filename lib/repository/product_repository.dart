
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../entity/product.dart';

final db = FirebaseFirestore.instance.collection('product');

Future<void> addProduct(Product product) async {
  await db.add(product.toJson());
}

Future<void> updateProduct(Product product) async {
  await db.doc(product.id).update(product.toJson());
}

Future<List<Product>> getAllProduct(String sort, int size, QuerySnapshot _querySnapshot) async {
  var email = FirebaseAuth.instance.currentUser?.email;
  List<Product> product = [];
  await db
      .where("created_by", isEqualTo: email)
      .orderBy(sort, descending: true)
      .limit(size)
      .get()
      .then((QuerySnapshot querySnapshot) {
        _querySnapshot = querySnapshot;
    for (var doc in querySnapshot.docs) {
      product.add(Product.fromSnapshot(doc));
    }
  });
  return product;
}

Future<List<Product>> getFeaturedProduct() async {
  List<Product> product = [];
  await db.where("is_featured", isEqualTo: true).get()
      .then((QuerySnapshot querySnapshot) {
    for (var doc in querySnapshot.docs) {
      product.add(Product.fromSnapshot(doc));
    }
  });
  return product;
}

Future<Product?> getProductByCode(String code) async {
  Product? product;
  await db.where("code", isEqualTo: code).get()
      .then((QuerySnapshot querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          product = Product.fromSnapshot(querySnapshot.docs.first);
        }
  });
  return product;
}