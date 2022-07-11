import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../FIREBASE/firebase_config.dart';
import 'components/order_list_tile.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key? key, required this.isTab}) : super(key: key);

  final bool isTab;

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      body: FutureBuilder(
        future: ordersRef
            .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong!'));
          } else if (snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No addresses found!'));
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              return OrderListTile(orderSnap: snapshot.data!.docs[index]);
            },
          );
        },
      ),
    );
  }
}
