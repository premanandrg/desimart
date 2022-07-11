import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desimart/payment/payment_page.dart';
import 'package:desimart/placeOrder/order_data.dart';
import 'package:flutter/material.dart';

import '../app_config.dart';
import '../product/product_details_page.dart';
import '../short_codes.dart';

class OrderSummaryPage extends StatefulWidget {
  const OrderSummaryPage({Key? key}) : super(key: key);

  @override
  State<OrderSummaryPage> createState() => _OrderSummaryPageState();
}

class _OrderSummaryPageState extends State<OrderSummaryPage> {
  int price = 0;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: const Text('Order Summary')),
      body: ListView.builder(
        itemCount: cartProductsSnaps.length,
        itemBuilder: (BuildContext context, int index) {
          DocumentSnapshot productSnap = cartProductsSnaps[index];
          return GestureDetector(
            onTap: () {
              pushPage(context,
                  ProductDetailsPage(productId: cartProductsSnaps[index].id));
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
                                  color: appColor.shade800, fontSize: 10),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 5),
                          decoration: BoxDecoration(
                              color: appColor,
                              borderRadius: BorderRadius.circular(20)),
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
                                    color: Colors.white, fontSize: 10),
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              productSnap['name'],
                              style: Theme.of(context).textTheme.headline6,
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
                                  '₹' + productSnap['price'].toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 20),
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
                                    (productSnap['mrp'] -
                                                (productSnap['mrp'] *
                                                    productSnap['price'] /
                                                    100))
                                            .ceil()
                                            .toString() +
                                        '%',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 15,
                                        color: Colors.white),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                //TODO
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
      ),
      bottomNavigationBar: BottomAppBar(
          child: Row(
        children: [
          InkWell(
            onTap: () async {},
            child: SizedBox(
              height: AppBar().preferredSize.height,
              width: size.width / 2,
              child: Center(child: Builder(builder: (context) {
                for (int i = 0; i < cartProductsSnaps.length; i++) {
                  price += cartProductsSnaps[i]['price'] as int;
                }
                return Text(
                  '₹ $price',
                  style: Theme.of(context)
                      .textTheme
                      .button!
                      .copyWith(color: appColor),
                );
              })),
            ),
          ),
          InkWell(
            onTap: () {
              pushPage(context, PaymentPage(orderAmount: price));
            },
            child: Container(
              color: appColor,
              height: AppBar().preferredSize.height,
              width: size.width / 2,
              child: Center(
                  child: Text(
                'Pay',
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
