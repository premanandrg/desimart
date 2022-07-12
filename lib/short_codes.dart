import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'FIREBASE/firebase_config.dart';
import 'login/login_page.dart';
import 'product/product_details_page.dart';

import 'package:flutter_tts/flutter_tts.dart' as speecher;

void pushPage(BuildContext context, Widget page) {
  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
    return page;
  }));
}

void pushReplacePage(BuildContext context, Widget page) {
  Navigator.of(context)
      .pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
    return page;
  }));
}

Future<void> logoutFromApp(BuildContext context, var page) async {
  await FirebaseAuth.instance.signOut();
  await GoogleSignIn().signOut();
  Navigator.pushAndRemoveUntil(context,
      MaterialPageRoute(builder: (BuildContext context) {
    return page;
  }), (route) => false);
}

void showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

Future<void> addToCart(BuildContext context, String productId) async {
  //add to cart
  if (FirebaseAuth.instance.currentUser == null) {
    showMessage(context, 'Please login to add product to cart');
    pushPage(
        context, LoginPage(nextPage: ProductDetailsPage(productId: productId)));
    return;
  }

  await myCartRef.doc(productId).get().then((value) async {
    if (value.exists) {
      showMessage(context, 'Product is already in your cart');
      return;
    }
    await myCartRef.doc(productId).set({
      'productId': productId,
      'timestamp': Timestamp.now(),
      'quantity': 1,
    }).then((value) {
      showMessage(context, 'Product added to cart');
    });
  });
}

Future<void> speech(String string) async {
  speecher.FlutterTts tts = speecher.FlutterTts();
  await tts.speak(string.toString());
}
