import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desimart/FIREBASE/firebase_config.dart';
import 'package:desimart/app_config.dart';
import 'package:desimart/product/product_details_page.dart';
import 'package:desimart/short_codes.dart';
import 'package:flutter/material.dart';

class SearchProductPage extends StatefulWidget {
  const SearchProductPage({Key? key}) : super(key: key);

  @override
  State<SearchProductPage> createState() => _SearchProductPageState();
}

class _SearchProductPageState extends State<SearchProductPage> {
  final TextEditingController searchController = TextEditingController();
  var searchquery = productsRef.get();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: appColor,
          title: TextField(
            controller: searchController,
            autofocus: true,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'Search...',
            ),
            onChanged: (value) {
              setState(() {
                searchquery = productsRef
                    .where('keywords', arrayContainsAny: value.split(' '))
                    .get();
              });
            },
          )),
      body: FutureBuilder(
        future: searchquery,
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong!'));
          } else if (snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No products found!'));
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              DocumentSnapshot productSnap = snapshot.data!.docs[index];
              return ListTile(
                onTap: () {
                  pushPage(
                      context, ProductDetailsPage(productId: productSnap.id));
                },
                leading: CachedNetworkImage(
                  imageUrl: productSnap['image'],
                  width: 60,
                ),
                title: Text(productSnap['name']),
                subtitle: Text(productSnap['subtitle']),
              );
            },
          );
        },
      ),
    );
  }
}
