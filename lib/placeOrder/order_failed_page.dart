import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../app_config.dart';

import '../payment/payment_page.dart';

class OrderFailedPage extends StatefulWidget {
  final int totalOrderAmount;
  const OrderFailedPage({Key? key, required this.totalOrderAmount})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return OrderFailedPagesState();
  }
}

class OrderFailedPagesState extends State<OrderFailedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Icon(
              CupertinoIcons.multiply_circle_fill,
              color: Colors.red,
              size: 100,
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Order Failed!',
              style: TextStyle(
                  color: Colors.red, fontWeight: FontWeight.w500, fontSize: 16),
            ),
            const SizedBox(
              height: 5,
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => PaymentPage(
                          orderAmount: widget.totalOrderAmount,
                        )));
              },
              child: const Text(
                'Retry Payment',
                style: TextStyle(color: Colors.white),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(appColor),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
