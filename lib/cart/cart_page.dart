import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desimart/FIREBASE/firebase_config.dart';
import 'package:desimart/address/select_address_page.dart';
import 'package:desimart/components/skeleton.dart';
import 'package:desimart/login/login_page.dart';
import 'package:desimart/main_page.dart';
import 'package:desimart/placeOrder/order_data.dart';
import 'package:desimart/placeOrder/order_summary_page.dart';
import 'package:desimart/short_codes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../app_config.dart';
import '../product/product_details_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: const Text('My Cart')),
      body: FirebaseAuth.instance.currentUser == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.shopping_cart_outlined,
                    size: 70,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text('Please login to add items to your cart'),
                  OutlinedButton(
                    onPressed: () {
                      if (FirebaseAuth.instance.currentUser == null) {
                        pushPage(
                            context, const LoginPage(nextPage: MainPage()));
                      }
                    },
                    child: const Text('Login'),
                  ),
                ],
              ),
            )
          : FutureBuilder(
              future: myCartRef.orderBy('timestamp').get(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Something went wrong!'));
                } else if (snapshot.data!.docs.isEmpty) {
                  return Center(
                      child: Column(
                    children: [
                      LottieBuilder.asset('assets/animations/emptyCart.json'),
                      const Text('No products found!'),
                    ],
                  ));
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return FutureBuilder(
                      future:
                          productsRef.doc(snapshot.data!.docs[index].id).get(),
                      builder:
                          (BuildContext context, AsyncSnapshot<dynamic> snap) {
                        if (snap.connectionState == ConnectionState.waiting) {
                          return const ShimmerCartItem();
                        } else if (snap.hasError) {
                          return const Center(
                              child: Text('Something went wrong!'));
                        }

                        DocumentSnapshot productSnap = snap.data;

                        return GestureDetector(
                          onTap: () {
                            pushPage(context,
                                ProductDetailsPage(productId: productSnap.id));
                          },
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.home,
                                            size: 13,
                                            color: appColor.shade800,
                                          ),
                                          Text(
                                            ' Nisarga Home Products',
                                            style: TextStyle(
                                                color: appColor.shade800,
                                                fontSize: 10),
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 5),
                                        decoration: BoxDecoration(
                                            color: appColor,
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: Row(
                                          children: const [
                                            Icon(
                                              Icons.location_on,
                                              size: 13,
                                              color: Colors.white,
                                            ),
                                            Text(
                                              ' Hubli',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      CachedNetworkImage(
                                        imageUrl: productSnap['image'],
                                        width: 100,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            productSnap['name'],
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6,
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(productSnap['subtitle']),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                '₹' +
                                                    productSnap['price']
                                                        .toString(),
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 20),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                '₹' +
                                                    productSnap['mrp']
                                                        .toString(),
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w300,
                                                    fontSize: 18,
                                                    decoration: TextDecoration
                                                        .lineThrough),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5,
                                                        vertical: 3),
                                                decoration: BoxDecoration(
                                                    color: appColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                child: Text(
                                                  (productSnap['mrp'] -
                                                              (productSnap[
                                                                      'mrp'] *
                                                                  productSnap[
                                                                      'price'] /
                                                                  100))
                                                          .ceil()
                                                          .toString() +
                                                      '%',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      fontSize: 15,
                                                      color: Colors.white),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 40,
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(2),
                                                decoration: BoxDecoration(
                                                    color:
                                                        defaultBackgroundColor,
                                                    boxShadow: const [
                                                      BoxShadow(
                                                        offset: Offset(
                                                          0.0,
                                                          3.0,
                                                        ),
                                                        color: Colors.black38,
                                                        blurRadius: 10.0,
                                                        spreadRadius: 0.5,
                                                      ), //BoxShadow
                                                      BoxShadow(
                                                        color: Colors.white,
                                                        offset:
                                                            Offset(0.0, 0.0),
                                                        blurRadius: 0.0,
                                                        spreadRadius: 0.0,
                                                      ), //BoxShadow
                                                    ],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    GestureDetector(
                                                        onTap: () async {
                                                          if (snapshot.data!
                                                                          .docs[
                                                                      index][
                                                                  'quantity'] ==
                                                              1) {
                                                            await myCartRef
                                                                .doc(productSnap
                                                                    .id)
                                                                .delete()
                                                                .then((value) {
                                                              showMessage(
                                                                  context,
                                                                  'Product removed from your cart');
                                                              setState(() {});
                                                            });
                                                            return;
                                                          }
                                                          await myCartRef
                                                              .doc(productSnap
                                                                  .id)
                                                              .set(
                                                                  {
                                                                'quantity':
                                                                    FieldValue
                                                                        .increment(
                                                                            -1)
                                                              },
                                                                  SetOptions(
                                                                      merge:
                                                                          true)).then(
                                                                  (value) {
                                                            setState(() {});
                                                          });
                                                        },
                                                        child: Icon(
                                                          Icons.remove,
                                                          size: 20,
                                                          color:
                                                              appColor.shade900,
                                                        )),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
                                                      child: Text(
                                                        snapshot
                                                            .data!
                                                            .docs[index]
                                                                ['quantity']
                                                            .toString(),
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                        onTap: () async {
                                                          await myCartRef
                                                              .doc(productSnap
                                                                  .id)
                                                              .set(
                                                                  {
                                                                'quantity':
                                                                    FieldValue
                                                                        .increment(
                                                                            1)
                                                              },
                                                                  SetOptions(
                                                                      merge:
                                                                          true)).then(
                                                                  (value) {
                                                            setState(() {});
                                                          });
                                                        },
                                                        child: Icon(
                                                          Icons.add,
                                                          size: 20,
                                                          color:
                                                              appColor.shade900,
                                                        )),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
      bottomNavigationBar: BottomAppBar(
          child: Row(
        children: [
          InkWell(
            onTap: () async {},
            child: SizedBox(
              height: AppBar().preferredSize.height * 0.8,
              width: size.width / 2,
              child: Center(
                  child: Text(
                ' ',
                style: Theme.of(context)
                    .textTheme
                    .button!
                    .copyWith(color: appColor),
              )),
            ),
          ),
          InkWell(
            onTap: () async {
              if (FirebaseAuth.instance.currentUser == null) {
                pushPage(context, const LoginPage(nextPage: CartPage()));
                return;
              }
              setState(() {
                isLoading = true;
              });
              cartProductsSnaps.clear();

              await myCartRef.get().then((value) async {
                for (int i = 0; i < value.docs.length; i++) {
                  await productsRef.doc(value.docs[i].id).get().then((product) {
                    cartProductsSnaps.add(product);
                  });
                }
              });

              setState(() {
                isLoading = false;
              });
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (BuildContext context) {
                return const SelectAddressPage();
              })).then((value) {
                if (value != null) {
                  selectedAddressSnap = value;
                  pushPage(context, const OrderSummaryPage());
                }
              });
            },
            child: Container(
              color: appColor,
              height: AppBar().preferredSize.height * 0.8,
              width: size.width / 2,
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                      color: Colors.white,
                    ))
                  : Center(
                      child: Text(
                      'Checkout',
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
}

class ShimmerCartItem extends StatelessWidget {
  const ShimmerCartItem({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Skeleton(),
                const Spacer(),
                Skeleton(),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Skeleton(
                  width: 60,
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Skeleton(),
                    const SizedBox(
                      height: 5,
                    ),
                    Skeleton(
                      width: 60,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Skeleton(
                          width: 60,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Skeleton(
                          width: 60,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Skeleton(
                          width: 60,
                        ),
                        const SizedBox(
                          width: 40,
                        ),
                        Skeleton(),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
