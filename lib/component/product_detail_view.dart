
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:taph/screen/product/edit_product_screen.dart';

import '../common/constant_theme.dart';
import '../common/parse.dart';
import '../common/storage.dart';
import '../entity/product.dart';
import '../entity/product_type.dart';

class ProductDetailView extends StatefulWidget {
  const ProductDetailView({Key? key, this.product}) : super(key: key);

  final Product? product;

  @override
  _ProductDetailView createState() => _ProductDetailView();
}

class _ProductDetailView extends State<ProductDetailView>
    with TickerProviderStateMixin {
  final double infoHeight = 364.0;
  AnimationController? animationController;
  Animation<double>? animation;
  double opacity1 = 0.0;
  double opacity2 = 0.0;
  double opacity3 = 0.0;
  late ProductType typeSelect;
  int nos = 1;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animationController!,
        curve: const Interval(0, 1.0, curve: Curves.fastOutSlowIn)));
    setData();
    super.initState();
  }

  Future<void> setData() async {
    animationController?.forward();
    setState(() {
      opacity1 = 1.0;
    });
    setState(() {
      opacity2 = 1.0;
    });
    setState(() {
      opacity3 = 1.0;
    });
    typeSelect = widget.product!.types.first;
  }

  List<Widget> listType() {
    List<Widget> result = [];
    for (var element in widget.product!.types) {
      result.add(getTimeBoxUI(element));
    }
    return result;
  }

  void minusNos() {
    if (nos > 1) {
      setState(() {
        nos = nos - 1;
      });
    }
  }

  void addNos() {
    if (nos < typeSelect.quantity) {
      setState(() {
        nos = nos + 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double tempHeight = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).size.width / 1.2) +
        24.0;
    return Container(
      color: ConstantTheme.nearlyWhite,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                AspectRatio(
                    aspectRatio: 1.2,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8)),
                      child: CarouselSlider(
                        options: CarouselOptions(height: 400.0),
                        items: widget.product!.images.map((i) {
                          return Image.network(
                              getDownloadUrl(i),
                            fit: BoxFit.fitWidth,
                          );
                        }).toList(),
                      )
                    )),
              ],
            ),
            Positioned(
              top: (MediaQuery.of(context).size.width / 1.2) - 24.0,
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: ConstantTheme.nearlyWhite,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(32.0),
                      topRight: Radius.circular(32.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: ConstantTheme.grey.withOpacity(0.2),
                        offset: const Offset(1.1, 1.1),
                        blurRadius: 10.0),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: SingleChildScrollView(
                    child: Container(
                      constraints: BoxConstraints(
                          minHeight: infoHeight,
                          maxHeight: tempHeight > infoHeight
                              ? tempHeight
                              : infoHeight),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 32.0, left: 18, right: 16),
                            child: Text(
                              widget.product!.name,
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 22,
                                letterSpacing: 0.27,
                                color: ConstantTheme.darkerText,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 16, right: 16, bottom: 8, top: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  formatMoney(typeSelect.price),
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 22,
                                    letterSpacing: 0.27,
                                    color: ConstantTheme.nearlyBlue,
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    InkWell(
                                      onTap: minusNos,
                                      child: const Icon(
                                      Icons.remove_circle_outlined,
                                      color: ConstantTheme.nearlyBlue,
                                      size: 30,
                                    )),
                                    const SizedBox(width: 10,),
                                    Text(
                                      nos.toString(),
                                    style: const TextStyle(fontSize: 18),),
                                    const SizedBox(width: 10,),
                                    InkWell(
                                        onTap: addNos,
                                        child: const Icon(
                                          Icons.add_circle,
                                          color: ConstantTheme.nearlyBlue,
                                          size: 30,
                                        )
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 500),
                            opacity: opacity1,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                children: listType(),
                              ),
                            ),
                          ),
                          Expanded(
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 500),
                              opacity: opacity2,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 16, right: 16, top: 8, bottom: 8),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Text(
                                    widget.product!.description,
                                    textAlign: TextAlign.justify,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w200,
                                      fontSize: 14,
                                      letterSpacing: 0.27,
                                      color: ConstantTheme.grey,
                                    ),
                                    maxLines: 100,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 500),
                            opacity: opacity3,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 16, bottom: 16, right: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: ConstantTheme.nearlyBlue,
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(16.0),
                                        ),
                                        boxShadow: <BoxShadow>[
                                          BoxShadow(
                                              color: ConstantTheme
                                                  .nearlyBlue
                                                  .withOpacity(0.5),
                                              offset: const Offset(1.1, 1.1),
                                              blurRadius: 10.0),
                                        ],
                                      ),
                                      child: const Center(
                                        child: Text(
                                          'Thêm vào giỏ hàng',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18,
                                            letterSpacing: 0.0,
                                            color: ConstantTheme
                                                .nearlyWhite,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).padding.bottom,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: (MediaQuery.of(context).size.width / 1.2) - 24.0 - 35,
              right: 35,
              child: ScaleTransition(
                alignment: Alignment.center,
                scale: CurvedAnimation(
                    parent: animationController!, curve: Curves.fastOutSlowIn),
                child: Card(
                  color: ConstantTheme.nearlyBlue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0)),
                  elevation: 10.0,
                  child: SizedBox(
                    width: 60,
                    height: 60,
                    child: Center(
                      child: InkWell(
                        child: const Icon(
                          Icons.edit,
                          color: ConstantTheme.nearlyWhite,
                          size: 30,
                        ),
                        onTap: () {
                          Navigator.push<bool>(
                            context,
                            MaterialPageRoute<bool>(
                              builder: (BuildContext context) => EditProductScreen(
                                product: widget.product!,
                              ),
                            ),
                          ).then((value) {
                            if (value != null && value) {
                              setState(() => {});
                            }
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: Card(
                color: ConstantTheme.nearlyWhite,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0)),
                elevation: 10.0,
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: InkWell(
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      color: ConstantTheme.nearlyBlack,
                      size: 30,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }

  Widget getTimeBoxUI(ProductType productType) {
    bool isS = productType == typeSelect;
    return InkWell(
        splashColor: Colors.white24,
        borderRadius: const BorderRadius.all(Radius.circular(24.0)),
        onTap: () {
          setState(() {
            typeSelect = productType;
            nos = nos > typeSelect.quantity ? typeSelect.quantity : nos;
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: isS
                  ? ConstantTheme.nearlyBlue
                  : ConstantTheme.nearlyWhite,
              borderRadius: const BorderRadius.all(Radius.circular(16.0)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: ConstantTheme.grey.withOpacity(0.2),
                    offset: const Offset(1.1, 1.1),
                    blurRadius: 8.0),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 18.0, right: 18.0, top: 12.0, bottom: 12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    productType.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 14,
                        letterSpacing: 0.27,
                        color: isS
                            ? ConstantTheme.nearlyWhite
                            : ConstantTheme.grey),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
