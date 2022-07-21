import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

//User
var usersRef = FirebaseFirestore.instance.collection('Users');
var myCartRef = FirebaseFirestore.instance
    .collection('Users')
    .doc(FirebaseAuth.instance.currentUser!.uid)
    .collection('Cart');

var myAddressRef = FirebaseFirestore.instance
    .collection('Users')
    .doc(FirebaseAuth.instance.currentUser!.uid)
    .collection('Address');

//Products
var productsRef = FirebaseFirestore.instance.collection('Products');

//Services
var servicesRef = FirebaseFirestore.instance.collection('Services');

//Orders
var ordersRef = FirebaseFirestore.instance.collection('Orders');

//chat
var customerChatRef = FirebaseFirestore.instance.collection('Chat');
var customerRecentChatRef = FirebaseFirestore.instance.collection('Chat');

const String accountWhiteUrl =
    'https://firebasestorage.googleapis.com/v0/b/go-gramin-57a15.appspot.com/o/appData%2Faccount.png?alt=media&token=9eea2930-32a7-442e-8523-4abb8b28441f';

const String appLogoUrl =
    'https://firebasestorage.googleapis.com/v0/b/go-gramin-57a15.appspot.com/o/appData%2Faccount.png?alt=media&token=9eea2930-32a7-442e-8523-4abb8b28441f';
