import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../app_config.dart';

import '../components/EmptyWidget.dart';
import '../firebase/firebase_config.dart';
import '../product/product_details_page.dart';

import 'components/order_constants.dart';

class OrderDetailsPage extends StatelessWidget {
  const OrderDetailsPage({Key? key, required this.orderId}) : super(key: key);

  final String orderId;

  @override
  Widget build(BuildContext context) {
    int starValue = 5;
    Map<String, String> orderStatus = {
      'NEW': 'Order Placed',
      'SHIPPED': 'Shipped',
      'IN TRANSIT-EN-ROUTE': 'On the way',
      'IN TRANSIT': 'On the way',
      'REACHED AT DESTINATION HUB': 'Reached at your nearest Hub',
      'OUT FOR DELIVERY': 'Out for delivery',
      'DELIVERED': 'Delivered',
    };

    return Scaffold(
      appBar: AppBar(title: const Text('Details')),
      body: FutureBuilder(
        future: ordersRef.doc(orderId).get(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong!'));
          }

//Order Details
          Map orderSnap = snapshot.data.data();
          if (orderSnap.containsKey('status')) {
            if (orderSnap['status'] == 'CANCELED') {
              orderStatus.addAll({'CANCELED': 'Cancelled'});
            } else if (orderSnap['status'] == 'RTO DELIVERED') {
              orderStatus.addAll({'RTO DELIVERED': 'Returned'});
            } else if (orderSnap['status'] == 'DAMAGED') {
              orderStatus.addAll({'DAMAGED': 'Damaged'});
            }
          }
          if (orderSnap.containsKey('star')) {
            starValue = orderSnap['star'];
            //  isRatedByStar = true;
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            orderSnap.containsKey('isReplacement')
                                ? Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        color: appColor,
                                        borderRadius: BorderRadius.circular(0)),
                                    child: const Text(
                                      'Replacement Order',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  )
                                : const SizedBox(height: 0, width: 0),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            orderSnap.containsKey('wentWrong')
                                ? Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(0)),
                                    child: Text(
                                      orderSnap['wentWrong']['text'],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  )
                                : const EmptyWidget(),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: <Widget>[
                            const Text(
                              'Order Id - #',
                              style: TextStyle(color: Colors.black45),
                            ),
                            Expanded(
                              child: SelectableText(
                                orderSnap['order_id'].toString(),
                                style: const TextStyle(color: Colors.black45),
                              ),
                            )
                          ],
                        ),
                        const Divider(),
                        orderSnap.containsKey('products')
                            ? ListView.separated(
                                itemCount: orderSnap['products'].length,
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder:
                                    (BuildContext context, int indexX) {
                                  return ListTile(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (BuildContext context) {
                                        return ProductDetailsPage(
                                          productId: orderSnap['products']
                                              [indexX]['productId'],
                                        );
                                      }));
                                    },
                                    contentPadding: const EdgeInsets.all(2),
                                    leading: CachedNetworkImage(
                                      imageUrl: orderSnap['products'][indexX]
                                          ['image'],
                                      height: 80,
                                      width: 80,
                                    ),
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          orderSnap['products'][indexX]['name'],
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.lato(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          orderSnap['products'][indexX]
                                              ['subtitle'],
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.lato(
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black38,
                                              fontSize: 10),
                                        ),
                                        const SizedBox(height: 3),
                                      ],
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              '₹   ' +
                                                  orderSnap['products'][indexX]
                                                          ['price']
                                                      .toString(),
                                              style: GoogleFonts.lato(),
                                            ),
                                            Text(
                                              ' x ' +
                                                  orderSnap['products'][indexX]
                                                          ['quantity']
                                                      .toString(),
                                              style: GoogleFonts.lato(),
                                            ),
                                            Text(
                                              ' = ₹   ' +
                                                  (orderSnap['products'][indexX]
                                                              ['price'] *
                                                          orderSnap['products']
                                                                  [indexX]
                                                              ['quantity'])
                                                      .toString(),
                                              style: GoogleFonts.lato(),
                                            ),
                                          ],
                                        ),
                                        orderSnap['status'] == 'DELIVERED'
                                            ? ProductReviewWidget(
                                                orderSnap: orderSnap,
                                                orderId: orderId,
                                                indexX: indexX,
                                              )
                                            : const EmptyWidget(),
                                      ],
                                    ),
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return const Divider();
                                },
                              )
                            : GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) {
                                    return ProductDetailsPage(
                                      productId: orderSnap['productId'],
                                    );
                                  }));
                                },
                                child: Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: CachedNetworkImage(
                                        imageUrl: orderSnap['image'],
                                        height: 80,
                                        width: 80,
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(orderSnap['name'],
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.lato(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                )),
                                            const SizedBox(height: 5),
                                            Text(
                                                orderSnap['subtitle']
                                                    .toString(),
                                                style: GoogleFonts.lato(
                                                    color: Colors.black45)),
                                            const SizedBox(height: 10),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  '₹   ' +
                                                      orderSnap['price']
                                                          .toString(),
                                                  style: GoogleFonts.lato(),
                                                ),
                                                Text(
                                                  ' x ' +
                                                      orderSnap['quantity']
                                                          .toString(),
                                                  style: GoogleFonts.lato(),
                                                ),
                                                Text(
                                                  ' = ₹   ' +
                                                      (orderSnap['price'] *
                                                              orderSnap[
                                                                  'quantity'])
                                                          .toString(),
                                                  style: GoogleFonts.lato(),
                                                ),
                                              ],
                                            ),
                                          ]),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Qty : ' +
                                            orderSnap['quantity'].toString()),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.history,
                              size: 12,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Ordered on ' +
                                  DateFormat('MMMM d, y  h:mm aa').format(
                                    orderSnap['timeStamp'].toDate(),
                                  ),
                              style: GoogleFonts.lato(fontSize: 12),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          'Address',
                          style: TextStyle(
                              color: appColor, fontWeight: FontWeight.w500),
                        ),
                        const Divider(),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              orderSnap['address']['name'],
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: const TextStyle(fontSize: 17),
                            ),
                            Text(
                              orderSnap['address']['street'] +
                                  ", \n" +
                                  orderSnap['address']['city'] +
                                  ", " +
                                  orderSnap['address']['state'] +
                                  " - " +
                                  orderSnap['address']['pincode'] +
                                  "\n" +
                                  orderSnap['address']['phoneNumber'],
                              style: const TextStyle(height: 1.5),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: const <Widget>[
                            Icon(Icons.support_agent),
                            SizedBox(width: 4),
                            Text(
                              'Customer support',
                              style: TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                        const Divider(),
                        MaterialButton(
                            color: appColor,
                            onPressed: () {
                              //TODO
                              // Navigator.of(context).push(MaterialPageRoute(
                              //     builder: (BuildContext context) {
                              //   return const ChatPage(isTab: false);
                              // }));
                            },
                            child: const Text(
                              'Chat now',
                              style: TextStyle(color: Colors.white),
                            )),
                      ],
                    ),
                  ),
                ),
                isWentWrong(orderSnap)
                    ? Card(
                        child: ListTile(
                            onTap: () async {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Replacement order creating...')));

                              //TODO
                              // await createReplacementOrder(widget.orderId)
                              //     .then((value) {
                              //   Navigator.of(context).pop();
                              // });
                            },
                            title: const Text(
                              'Create replacement Order',
                            ),
                            leading: const Icon(
                              Icons.new_label,
                              color: Colors.yellow,
                            )),
                      )
                    : const EmptyWidget(),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Tacking',
                          style: TextStyle(
                              color: appColor, fontWeight: FontWeight.w500),
                        ),
                        const Divider(),

                        //Tracking View
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            RotatedBox(
                              quarterTurns: 1,
                              child: SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  activeTrackColor:
                                      red.contains(orderSnap['status'])
                                          ? Colors.red
                                          : appColor,
                                  inactiveTrackColor:
                                      red.contains(orderSnap['status'])
                                          ? Colors.red.withOpacity(0.2)
                                          : appColor.withOpacity(0.2),
                                  trackShape:
                                      const RoundedRectSliderTrackShape(),
                                  trackHeight: 2.0,
                                  thumbShape: const RoundSliderThumbShape(
                                      enabledThumbRadius: 6.0),
                                  thumbColor: red.contains(orderSnap['status'])
                                      ? Colors.red
                                      : appColor,
                                  overlayColor:
                                      red.contains(orderSnap['status'])
                                          ? Colors.red.withAlpha(32)
                                          : appColor.withAlpha(32),
                                  overlayShape: const RoundSliderOverlayShape(
                                      overlayRadius: 28.0),
                                  tickMarkShape:
                                      const RoundSliderTickMarkShape(),
                                  activeTickMarkColor:
                                      appColor.withOpacity(0.2),
                                  inactiveTickMarkColor:
                                      appColor.withOpacity(0.1),
                                  valueIndicatorShape:
                                      const PaddleSliderValueIndicatorShape(),
                                  valueIndicatorColor:
                                      red.contains(orderSnap['status'])
                                          ? Colors.red
                                          : appColor,
                                  valueIndicatorTextStyle: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                child: SizedBox(
                                  width:
                                      (orderStatus.values.toSet().length * 36.8)
                                          .toDouble(),
                                  child: Slider(
                                    //TODO
                                    value: orderStatus
                                            .containsKey(orderSnap['status'])
                                        ? Set.of(orderStatus.values)
                                            .toList()
                                            .indexOf(
                                                orderStatus[orderSnap['status']]
                                                    .toString())
                                            .toDouble()
                                        : 0.0,
                                    min: 0,
                                    max: orderStatus.values
                                            .toSet()
                                            .length
                                            .toDouble() -
                                        1,
                                    divisions: Set.of(orderStatus.values)
                                        .toList()
                                        .length,
                                    //TODO
                                    label: orderStatus
                                            .containsKey(orderSnap['status'])
                                        ? orderStatus[orderSnap['status']]
                                        : orderSnap['status'],
                                    onChanged: (value) {},
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: ListView.separated(
                                itemCount:
                                    Set.of(orderStatus.values).toList().length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  if (orderStatus.values
                                          .toSet()
                                          .elementAt(index) ==
                                      orderStatus[orderSnap['status']]) {
                                    return Text(
                                      Set.of(orderStatus.values)
                                          .toList()
                                          .elementAt(index)
                                          .toString(),
                                      style: TextStyle(
                                          color:
                                              red.contains(orderSnap['status'])
                                                  ? Colors.red
                                                  : appColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    );
                                  }
                                  return Text(
                                    Set.of(orderStatus.values)
                                        .toList()
                                        .elementAt(index)
                                        .toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500),
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return const Divider();
                                },
                              ),
                            ),
                          ],
                        ),
                        // Row(
                        //   crossAxisAlignment: CrossAxisAlignment.end,
                        //   mainAxisAlignment: MainAxisAlignment.end,
                        //   children: [
                        //     orderSnap.containsKey('status') &&
                        //             orderSnap.containsKey('awb_code')
                        //         ? orderSnap['status'] != 'CANCELED' &&
                        //                 orderSnap['awb_code']
                        //                     .toString()
                        //                     .isNotEmpty
                        //             ? MaterialButton(
                        //                 onPressed: () {
                        //                   if (orderSnap
                        //                       .containsKey('awb_code')) {
                        //                     if (orderSnap['awb_code']
                        //                         .toString()
                        //                         .isNotEmpty) {
                        //                       try {
                        //                         launch(
                        //                             'https://shiprocket.co/tracking/${orderSnap['awb_code']}');
                        //                       } catch (e) {
                        //                         print(e.toString());
                        //                       }
                        //                     }
                        //                   }
                        //                 },
                        //                 color: Colors.white,
                        //                 child: Row(
                        //                   mainAxisSize: MainAxisSize.min,
                        //                   children: [
                        //                     Text(
                        //                       orderSnap['status'][0]
                        //                               .toString()
                        //                               .toUpperCase() +
                        //                           orderSnap['status']
                        //                               .toString()
                        //                               .substring(1)
                        //                               .toLowerCase(),
                        //                       style: const TextStyle(
                        //                         fontSize: 12,
                        //                       ),
                        //                     ),
                        //                     const Icon(
                        //                       CupertinoIcons.rocket,
                        //                       size: 12,
                        //                     ),
                        //                   ],
                        //                 ),
                        //               )
                        //             : const SizedBox(
                        //                 height: 0,
                        //                 width: 0,
                        //               )
                        //         : const SizedBox(
                        //             height: 0,
                        //             width: 0,
                        //           ),
                        //   ],
                        // )
                      ],
                    ),
                  ),
                ),
                orderSnap.containsKey('isReplacement') &&
                        orderSnap['status'] != 'CANCELED'
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            MaterialButton(
                              onPressed: () async {
                                //Cancel order and transform order amount to wallet
                                showDialog(
                                  context: context,
                                  builder: (BuildContext contextX) {
                                    return AlertDialog(
                                      title: const Text('Cancel Order'),
                                      content: const Text(
                                          'Do you really want to cancel this order?'),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('No')),
                                        TextButton(
                                            onPressed: () async {
                                              Navigator.of(context).pop();

                                              if (orderSnap
                                                  .containsKey('order_id')) {
                                                // if (orderSnap.containsKey(
                                                //     'vendorOrderAmount')) {
                                                //   await cancelOrder(
                                                //           orderSnap[
                                                //               'order_id'])
                                                //       .then(
                                                //           (cancelOrder) async {
                                                //     //TODO check for confirmation
                                                //     if (cancelOrder
                                                //         .containsKey(
                                                //             'message')) {
                                                //       Fluttertoast.showToast(
                                                //           msg: cancelOrder[
                                                //               'message']);
                                                //     }

                                                //     var rewardData = {
                                                //       'timestamp':
                                                //           Timestamp.now(),
                                                //       'orderAmount':
                                                //           orderSnap[
                                                //               'vendorOrderAmount'],
                                                //       'orderId':
                                                //           widget.orderId,
                                                //       'points': orderSnap[
                                                //           'vendorOrderAmount'],
                                                //       'usedPoints': 0,
                                                //       'willExpire': false,
                                                //       'userId': orderSnap[
                                                //           'userId'],
                                                //     };

                                                //   await rewardsRef
                                                //       .add(rewardData);
                                                //   await ordersRef
                                                //       .doc(widget
                                                //           .orderId)
                                                //       .set(
                                                //           {
                                                //         'status':
                                                //             'CANCELED'
                                                //       },
                                                //           SetOptions(
                                                //               merge:
                                                //                   true)).then(
                                                //           (value) async {
                                                //     var paymentData = {
                                                //       'amount': !orderSnap
                                                //               .containsKey(
                                                //                   'isPickUpRequestSent')
                                                //           ? (-(orderSnap[
                                                //               'vendorOrderAmount']))
                                                //           : (-(orderSnap[
                                                //                   'vendorOrderAmount'] +
                                                //               orderSnap[
                                                //                   'vendorShippingCharge'])),
                                                //       'timestamp':
                                                //           Timestamp
                                                //               .now(),
                                                //       'status': 'open',
                                                //       'orderId': widget
                                                //           .orderId,
                                                //       'order_id':
                                                //           orderSnap[
                                                //               'order_id'],
                                                //       'products':
                                                //           orderSnap[
                                                //               'products'],
                                                //       'customerId':
                                                //           orderSnap[
                                                //               'userId'],
                                                //       'vendorId':
                                                //           orderSnap[
                                                //               'vendorId'],
                                                //       'title': orderSnap
                                                //               .containsKey(
                                                //                   'order_id')
                                                //           ? 'Order Cancelled : ' +
                                                //               orderSnap[
                                                //                       'order_id']
                                                //                   .toString()
                                                //           : 'Order Cancelled',
                                                //     };

                                                //     await paymentReportsRef
                                                //         .add(
                                                //             paymentData);
                                                //     Fluttertoast.showToast(
                                                //         msg:
                                                //             'Order Cancelled and Ordere amount will be  credited to your  wallet');
                                                //   });
                                                // });
                                                // }
                                              }
                                              //dissmiss dialog
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Yes')),
                                      ],
                                    );
                                  },
                                );
                              },
                              color: appColor,
                              child: const Text(
                                'Cancel Order',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox(
                        height: 0,
                        width: 0,
                      ),
                orderSnap.containsKey('xOrder')
                    ? Card(
                        child: ListTile(
                          onTap: () {
                            if (orderSnap['xOrder'].containsKey('newOrderId')) {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) {
                                return OrderDetailsPage(
                                  orderId: orderSnap['xOrder']['newOrderId'],
                                );
                              }));
                            }
                          },
                          leading: const SizedBox(
                              height: double.maxFinite,
                              child: Icon(Icons.info_outline)),
                          title: Text(orderSnap['xOrder'].containsKey('text')
                              ? orderSnap['xOrder']['text']
                              : 'Your Action needed'),
                          trailing: const Icon(Icons.chevron_right_rounded),
                          subtitle: orderSnap['xOrder'].containsKey('order_id')
                              ? Text(
                                  'New order Id :  ${orderSnap['xOrder']['order_id']}')
                              : const Text('Replacement order not found'),
                        ),
                      )
                    : const SizedBox(height: 0, width: 0),
                const SizedBox(height: 5),
                const SizedBox(height: 5),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 5, 15, 15),
                    child: Column(
                      children: <Widget>[
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'Price Details',
                          style: TextStyle(
                              color: appColor, fontWeight: FontWeight.w500),
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const Text(
                              'Price',
                              style: TextStyle(fontSize: 15),
                            ),
                            Text('₹ ' + orderSnap['mrp'].toString())
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const Text('Delivery Charges'),
                            Text(
                                '₹ ' + orderSnap['delivery_charges'].toString())
                          ],
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const Text(
                              'Total Price',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            Text(
                              '₹ ' +
                                  ((orderSnap['vendorOrderAmount'])).toString(),
                              style: const TextStyle(
                                  color: appColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 100,
                )
              ],
            ),
          );
        },
      ),
    );
  }

  bool isWentWrong(Map orderSnap) {
    if (orderSnap.containsKey('wentWrong') &&
        !orderSnap.containsKey('xOrder')) {
      return true;
    }
    return false;
  }
}

class ProductReviewWidget extends StatelessWidget {
  const ProductReviewWidget({
    Key? key,
    required this.orderSnap,
    required this.orderId,
    required this.indexX,
  }) : super(key: key);

  final Map orderSnap;
  final String orderId;
  final int indexX;

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      double initialRating = 0.0;

      if (orderSnap.containsKey('review')) {
        if (orderSnap['review']
            .containsKey(orderSnap['products'][indexX]['productId'])) {
          initialRating = orderSnap['review']
                  [orderSnap['products'][indexX]['productId']]['pStar']
              .toDouble();
        }
      }
      return RatingBar.builder(
          glow: false,
          initialRating: initialRating,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: false,
          itemCount: 5,
          itemSize: 20,
          itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: appColor,
              ),
          onRatingUpdate: (value) {
            // Navigator.of(context)
            //     .push(MaterialPageRoute(builder: (BuildContext context) {
            //   return WriteReviewPage(
            //     productId: orderSnap['products'][indexX]['productId'],
            //     orderId: orderId,
            //     initialReview: orderSnap.containsKey('review') &&
            //             orderSnap['review'].containsKey(
            //                 orderSnap['products'][indexX]['productId'])
            //         ? orderSnap['review']
            //             [orderSnap['products'][indexX]['productId']]
            //         : {'pStar': value.toInt(), 'vStar': 0, 'review': ''},
            //   );
            // })).then((value) {
            //   if (value != null) {
            //     orderSnap['review']
            //         [orderSnap['products'][indexX]['productId']] = value;
            //     // orderSnap.addAll(
            //     //     {'review': value});

            //   }
            // });
          });
    });
  }
}
