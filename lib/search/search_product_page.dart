import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desimart/FIREBASE/firebase_config.dart';
import 'package:desimart/app_config.dart';
import 'package:desimart/product/product_details_page.dart';
import 'package:desimart/short_codes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:speech_to_text/speech_to_text.dart';

class SearchProductPage extends StatefulWidget {
  const SearchProductPage({Key? key, required this.isMic}) : super(key: key);
  final bool isMic;
  @override
  State<SearchProductPage> createState() => _SearchProductPageState();
}

class _SearchProductPageState extends State<SearchProductPage> {
  final TextEditingController searchController = TextEditingController();
  var searchquery = productsRef.get();
  bool isOn = false;
  double confidence = 1.0;
  SpeechToText stt = SpeechToText();

  void listen() async {
    if (!isOn) {
      isOn = await stt.initialize(
          onStatus: ((status) => {print(status)}),
          onError: (data) {
            print(data);
          });
    }
    if (isOn) {
      setState(() {
        isOn = true;
        showMessage(context, 'Listening...');
        stt.listen(onResult: (val) {
          searchController.text = val.recognizedWords;
          setState(() {
            searchquery = productsRef
                .where('keywords',
                    arrayContainsAny: searchController.text.split(' '))
                .get();
          });

          searchController.selection = TextSelection.fromPosition(
              TextPosition(offset: searchController.text.length));
        });
      });
    } else {
      setState(() {
        isOn = true;
        stt.stop();
      });
    }
  }

  @override
  void initState() {
    if (widget.isMic) {
      listen();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: appColor,
          title: TextField(
            controller: searchController,
            autofocus: true,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Search...',
              suffix: GestureDetector(
                onLongPress: () {
                  listen();
                },
                onLongPressUp: () {
                  setState(() {
                    isOn = false;
                  });
                  stt.stop();
                },
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    CupertinoIcons.mic,
                    color: isOn ? Colors.green.shade900 : Colors.green.shade300,
                  ),
                ),
              ),
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
