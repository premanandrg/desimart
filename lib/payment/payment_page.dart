import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../FIREBASE/firebase_config.dart';
import '../app_config.dart';
import '../placeOrder/order_data.dart';
import '../placeOrder/order_failed_page.dart';
import '../placeOrder/order_placed_page.dart';
import '../short_codes.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({Key? key, required this.orderAmount}) : super(key: key);

  final int orderAmount;

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  static const platform = MethodChannel("razorpay_flutter");

  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    openCheckout();
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout() async {
    var options = {
      'key': 'rzp_live_S3cVVxoZ4jU4ju',
      'amount': 1 * 100,
      'name': appName,
      'description': appName + ' Products',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {
        'contact': selectedAddressSnap!['phoneNumber'],
        'email': FirebaseAuth.instance.currentUser!.email
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    print('Success Response: $response');

    List orderProductsList = [];

    for (var i = 0; i < cartProductsSnaps.length; i++) {
      Map<String, dynamic> orderItem =
          cartProductsSnaps[i].data() as Map<String, dynamic>;
      orderItem.addAll({
        'productId': cartProductsSnaps[i].id,
        'vendorId': cartProductsSnaps[i]['vendorId'],
        'quantity': 1,
      });
      orderProductsList.add(orderItem);
    }
    Map<String, dynamic> orderData = {
      'orderId': DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        DateTime.now().hour,
        DateTime.now().minute,
        DateTime.now().second,
      ).toString(),
      //TODO quanity
      'quantity': 1,

      'order_id': DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        DateTime.now().hour,
        DateTime.now().minute,
        DateTime.now().second,
      ).toString(),
      'paymentId': response.paymentId,
      'timeStamp': Timestamp.now(),
      'userId': FirebaseAuth.instance.currentUser!.uid,
      'name': selectedAddressSnap!['name'],
      'address': selectedAddressSnap!.data(),
      'orderAmount': widget.orderAmount,
      'status': 'Order Placed',
      'products': orderProductsList,
      //TODO delivery charges
      'delivery_charges': 40,
    };
    await ordersRef.add(orderData).then((value) {
      pushReplacePage(context, OrderPlacedPage());
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print('Error Response: $response');
    pushReplacePage(
        context,
        OrderFailedPage(
          totalOrderAmount: widget.orderAmount,
        ));
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print('External SDK Response: $response');
    /* Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName!,
        toastLength: Toast.LENGTH_SHORT); */
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
      ),
      body: const Center(child: CircularProgressIndicator()),
    );
  }
}
