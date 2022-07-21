import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desimart/FIREBASE/firebase_config.dart';
import 'package:desimart/app_config.dart';
import 'package:desimart/login/login_page.dart';
import 'package:desimart/mediaPlayer/image_viewer.dart';
import 'package:desimart/short_codes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../placeOrder/order_data.dart';
import '../placeOrder/order_summary_page.dart';

class ProductDetailsPage extends StatefulWidget {
  const ProductDetailsPage({Key? key, required this.productId})
      : super(key: key);

  final String productId;

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  PageController pageController = PageController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder(
      future: productsRef.doc(widget.productId).get(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData &&
            !snapshot.hasError) {
          DocumentSnapshot productSnap = snapshot.data;

          return Scaffold(
            appBar: AppBar(title: const Text('Details')),
            body: SingleChildScrollView(
              child: Column(children: [
                SizedBox(
                  height: size.height * 0.4,
                  child: PageView.builder(
                    controller: pageController,
                    itemCount: productSnap['images'].length,
                    itemBuilder: (BuildContext context, int index) {
                      return Hero(
                        tag: productSnap['images'][index],
                        child: GestureDetector(
                          onTap: () {
                            pushPage(
                                context,
                                ImageViewer(
                                    imageUrl: productSnap['images'][index]));
                          },
                          child: CachedNetworkImage(
                              imageUrl: productSnap['images'][index]),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SmoothPageIndicator(
                  controller: pageController,
                  count: productSnap['images'].length,
                  effect: const SlideEffect(
                      activeDotColor: Colors.black38,
                      strokeWidth: 0,
                      dotHeight: 6,
                      dotWidth: 6,
                      dotColor: Colors.black12),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        productSnap['name'],
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      Text(
                        productSnap['subtitle'],
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text(
                            '₹ ' + productSnap['price'].toString(),
                            style: const TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 20),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            '₹' + productSnap['mrp'].toString(),
                            style: const TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 18,
                                decoration: TextDecoration.lineThrough),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 3),
                            decoration: BoxDecoration(
                                color: appColor,
                                borderRadius: BorderRadius.circular(5)),
                            child: Text(
                              (((productSnap['mrp'] - productSnap['price']) /
                                              productSnap['mrp']) *
                                          100)
                                      .ceil()
                                      .toString() +
                                  '%',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 15,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ListTile(
                        title: Text('Vendor name'),
                        leading: CircleAvatar(),
                        subtitle: Text('Hubli'),
                        trailing: Icon(Icons.chevron_right),
                      ),
                      FutureBuilder(
                        future: productsRef.get(),
                        builder: (BuildContext context,
                            AsyncSnapshot<dynamic> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return const Center(
                                child: Text('Something went wrong!'));
                          } else if (snapshot.data!.docs.isEmpty) {
                            return const Center(
                                child: Text('No products found!'));
                          }
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (BuildContext context, int index) {
                              DocumentSnapshot productSnap =
                                  snapshot.data!.docs[index];
                              return ListTile(
                                onTap: () {
                                  pushPage(
                                      context,
                                      ProductDetailsPage(
                                          productId: productSnap.id));
                                },
                                leading: CachedNetworkImage(
                                  imageUrl: productSnap['image'],
                                  width: 60,
                                ),
                                title: Text(productSnap['name']),
                                subtitle: Text(productSnap['subtitle']),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                )
              ]),
            ),
            bottomNavigationBar: BottomAppBar(
                child: Row(
              children: [
                InkWell(
                  onTap: () async {
                    addToCart(context, productSnap.id);
                  },
                  child: SizedBox(
                    height: AppBar().preferredSize.height,
                    width: size.width / 2,
                    child: Center(
                        child: Text(
                      'ADD TO CART',
                      style: Theme.of(context)
                          .textTheme
                          .button!
                          .copyWith(color: appColor),
                    )),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    cartProductsSnaps.clear();

                    cartProductsSnaps.add(productSnap);

                    pushPage(context, const OrderSummaryPage());
                  },
                  child: Container(
                    color: appColor,
                    height: AppBar().preferredSize.height,
                    width: size.width / 2,
                    child: Center(
                        child: Text(
                      'BUY NOW',
                      style: Theme.of(context)
                          .textTheme
                          .button!
                          .copyWith(color: Colors.white),
                    )),
                  ),
                ),
              ],
            )),
          );
        }
        return Scaffold(
          appBar: AppBar(title: const Text('Details')),
          body: const Center(child: CircularProgressIndicator()),
          bottomNavigationBar: BottomAppBar(
              child: Row(
            children: [
              InkWell(
                onTap: () async {},
                child: SizedBox(
                  height: AppBar().preferredSize.height,
                  width: size.width / 2,
                  child: Center(
                      child: Text(
                    'ADD TO CART',
                    style: Theme.of(context)
                        .textTheme
                        .button!
                        .copyWith(color: appColor),
                  )),
                ),
              ),
              InkWell(
                onTap: () async {},
                child: Container(
                  color: appColor,
                  height: AppBar().preferredSize.height,
                  width: size.width / 2,
                  child: Center(
                      child: Text(
                    'BUY NOW',
                    style: Theme.of(context)
                        .textTheme
                        .button!
                        .copyWith(color: Colors.white),
                  )),
                ),
              ),
            ],
          )),
        );
      },
    );
  }
}
