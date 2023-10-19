import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:taph/entity/product.dart';
import 'package:taph/screen/product/product_view.dart';

import '../../common/constant_theme.dart';

class ListProductView extends StatefulWidget {
  const ListProductView({Key? key}) : super(key: key);

  @override
  _ListProductViewState createState() => _ListProductViewState();
}

class _ListProductViewState extends State<ListProductView>
    with TickerProviderStateMixin {
  final db = FirebaseFirestore.instance.collection('product');
  AnimationController? animationController;
  bool firstLoading = true;
  bool hasMore = true;
  int size = 4;
  late DocumentSnapshot lastDocument;
  List<Product> products = [];
  int total = 0;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);

    asyncTasks() async {
      await db.count().get().then((value) {
        total = value.count;
        getProducts();
      });
    }

    asyncTasks();
  }

  getProducts() async {
    setState(() => isLoading = true);
    if (!hasMore) {
      print('No More Products');
      return;
    }
    if (firstLoading) {
      await db
          .orderBy('created_date', descending: true)
          .limit(size)
          .get()
          .then(handleAfterFetchComplete);
      firstLoading = false;
    } else {
      await db
          .orderBy('created_date', descending: true)
          .limit(size)
          .startAfterDocument(lastDocument)
          .get()
          .then(handleAfterFetchComplete);
    }
    setState(() => isLoading = false);
  }

  handleAfterFetchComplete(QuerySnapshot querySnapshot) {
    if (querySnapshot.docs.isNotEmpty) {
      lastDocument = querySnapshot.docs.last;
      for (var doc in querySnapshot.docs) {
        products.add(Product.fromSnapshot(doc));
      }
    }

    if (products.length >= total) {
      hasMore = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height - 200;
    return Container(
        height: height,
        padding: const EdgeInsets.only(top: 8, bottom: 100, left: 16, right: 16),
        child: ListView(
          children: [
            GridView.count(
              childAspectRatio: 0.8,
              crossAxisCount: 2,
              mainAxisSpacing: 16.0,
              crossAxisSpacing: 16.0,
              padding: const EdgeInsets.all(4),
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              children: products.map((e) {
                final Animation<double> animation =
                Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                        parent: animationController!,
                        curve: Interval((1 / products.length) * 1, 1.0,
                            curve: Curves.fastOutSlowIn)));
                animationController?.forward();
                return ProductView(
                  product: e,
                  animation: animation,
                  animationController: animationController,
                  callback: getProducts,
                );
              }).toList(),
            ),
            buttonLoadingMore(),
          ],
        )
    );
  }

  Widget buttonLoadingMore() {
    if (hasMore) {
      return TextButton(
          onPressed: () {
            if (!isLoading) {
              getProducts();
            }
          },
          child: (!isLoading) ? const Text("Xem thêm",
            style: TextStyle(color: ConstantTheme.nearlyBlue),)
              : const CircularProgressIndicator(
            color: ConstantTheme.nearlyBlue,
            strokeWidth: 3,
          )
      );
    }
    return const SizedBox();
  }
}
