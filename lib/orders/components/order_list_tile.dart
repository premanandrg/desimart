import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../app_config.dart';

import '../../components/EmptyWidget.dart';
import '../order_details_page.dart';
import 'order_constants.dart';

class OrderListTile extends StatelessWidget {
  const OrderListTile({Key? key, required this.orderSnap}) : super(key: key);
  final DocumentSnapshot orderSnap;

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> orderMap = orderSnap.data() as Map<String, dynamic>;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (BuildContext context) => OrderDetailsPage(
              orderId: orderSnap.id,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Card(
          elevation: 0.5,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 20, 5),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    orderMap.containsKey('isReplacement')
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
                        : const EmptyWidget(),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    orderMap.containsKey('wentWrong')
                        ? Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(0)),
                            child: Text(
                              orderMap['wentWrong']['text'],
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text(
                          '   ORDER ID - #',
                          style: TextStyle(color: Colors.black45, fontSize: 12),
                        ),
                        SelectableText(
                          orderSnap['order_id'].toString(),
                          style: const TextStyle(
                              color: Colors.black45, fontSize: 12),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.history,
                          size: 12,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          DateFormat('dd-MM-y')
                              .format(orderSnap['timeStamp'].toDate()),
                          style: GoogleFonts.lato(fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
                const Divider(),
                orderMap.containsKey('products')
                    ? ListView.separated(
                        itemCount: orderSnap['products'].length,
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int indexX) {
                          return Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: CachedNetworkImage(
                                  imageUrl: orderSnap['products'][indexX]
                                      ['image'],
                                  height: 80,
                                  width: 80,
                                  memCacheHeight: 200,
                                ),
                              ),
                              Expanded(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                          orderSnap['products'][indexX]['name'],
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.lato(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          )),
                                      const SizedBox(height: 5),
                                      AutoSizeText(
                                          orderSnap['products'][indexX]
                                                  ['subtitle']
                                              .toString(),
                                          maxLines: 2,
                                          minFontSize: 7,
                                          maxFontSize: 12,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.lato(
                                              color: Colors.black45)),
                                      const SizedBox(
                                        height: 5,
                                      ),
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
                                      const SizedBox(height: 10),
                                    ]),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Text(
                                      'Qty : ' +
                                          orderSnap['products'][indexX]
                                                  ['quantity']
                                              .toString(),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const Divider();
                        },
                      )
                    : Row(
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
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                  Text(orderSnap['subtile'].toString(),
                                      style: GoogleFonts.lato(
                                          color: Colors.black45)),
                                  const SizedBox(height: 5),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        '₹   ' + orderSnap['price'].toString(),
                                        style: GoogleFonts.lato(),
                                      ),
                                      Text(
                                        ' x ' +
                                            orderSnap['quantity'].toString(),
                                        style: GoogleFonts.lato(),
                                      ),
                                      Text(
                                        ' = ₹   ' +
                                            (orderSnap['price'] *
                                                    orderSnap['quantity'])
                                                .toString(),
                                        style: GoogleFonts.lato(),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                ]),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Qty : ' + orderSnap['quantity'].toString()),
                            ],
                          ),
                        ],
                      ),
                orderMap.containsKey('products')
                    ? const SizedBox(height: 5)
                    : const EmptyWidget(),
                const SizedBox(width: 50, child: Divider()),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          Navigator.of(context).push(CupertinoPageRoute(
                              builder: (BuildContext context) =>
                                  OrderDetailsPage(
                                    orderId: orderSnap.id,
                                  )));
                        },
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(),
                          ),
                          child: const Text(
                            'Details',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      // Flexible(
                      //   flex: 1,
                      //   child: AutoSizeText(
                      //     orderSnap['etd'],
                      //     overflow: TextOverflow.ellipsis,
                      //     maxLines: 1,
                      //     maxFontSize: 14,
                      //   ),
                      // ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.fiber_manual_record_rounded,
                              color: red.contains(orderSnap['status'])
                                  ? Colors.red
                                  : yellow.contains(orderSnap['status'])
                                      ? Colors.yellow
                                      : Colors.green,
                            ),
                            Flexible(
                              child: orderSnap['status'] != null
                                  ? AutoSizeText(
                                      // orderStatus[orderSnap['status_code']],
                                      orderStatusStrings
                                              .containsKey(orderSnap['status'])
                                          ? orderStatusStrings[
                                              orderSnap['status']]
                                          : orderSnap['status'],

                                      maxLines: 1,
                                      maxFontSize: 20,
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  : const Text(''),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
