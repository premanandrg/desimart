import 'package:desimart/main_page.dart';
import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';

import '../app_config.dart';
import '../orders/orders_page.dart';

class OrderPlacedPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return OrderPlacedPageState();
  }
}

class OrderPlacedPageState extends State<OrderPlacedPage> {
  @override
  void initState() {
    //Todo getAppRating();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const MainPage()),
            (Route<dynamic> route) => false);
        return false;
      },
      child: Scaffold(
        body: Center(
          child: Stack(
            children: <Widget>[
              Lottie.asset(
                'assets/animations/colorful.json',
                repeat: true,
                height: MediaQuery.of(context).size.height,
                fit: BoxFit.fill,
              ),
              Column(
                children: <Widget>[
                  Lottie.asset(
                    'assets/animations/orderPlaced.json',
                    repeat: false,
                    fit: BoxFit.fill,
                  ),
                  const Text(
                    'Your Order Placed Successfully',
                    style: TextStyle(
                        color: appColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 16),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => const OrdersPage(
                                isTab: false,
                              )));
                    },
                    child: const Text(
                      'Go to My Orders',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(appColor),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ],
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: SizedBox(
            height: AppBar().preferredSize.height * 0.8,
            child: MaterialButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const MainPage()),
                    (Route<dynamic> route) => false);
              },
              child: const Text(
                'Continue Shopping',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
              color: appColor,
            ),
          ),
        ),
      ),
    );
  }
}
