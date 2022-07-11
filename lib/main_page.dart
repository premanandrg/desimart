import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desimart/FIREBASE/firebase_config.dart';
import 'package:desimart/cart/cart_page.dart';
import 'package:desimart/community/community_page.dart';
import 'package:desimart/components/EmptyWidget.dart';
import 'package:desimart/homePage/home_page.dart';
import 'package:desimart/orders/orders_page.dart';
import 'package:desimart/profile/profile_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key, this.initPage}) : super(key: key);

  final int? initPage;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Widget> pages = [
    const HomePage(),
    const CommunityPage(),
    const OrdersPage(
      isTab: true,
    ),
    const CartPage(),
  ];
  int currentIndex = 0;

  @override
  void initState() {
    if (widget.initPage == null) {
      currentIndex = 0;
    } else {
      currentIndex = widget.initPage!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          currentIndex: currentIndex,
          items: [
            const BottomNavigationBarItem(
              label: 'Home',
              icon: Icon(Icons.home_outlined),
            ),
            const BottomNavigationBarItem(
              label: 'Community',
              icon: Icon(Icons.people_alt_outlined),
            ),
            const BottomNavigationBarItem(
              label: 'Tracking',
              icon: Icon(Icons.near_me_outlined),
            ),
            BottomNavigationBarItem(
                label: 'Cart',
                icon: StreamBuilder(
                    stream: myCartRef.snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                            snapshot) {
                      if (!snapshot.hasError &&
                          snapshot.data!.docs.isNotEmpty) {
                        return Badge(
                            toAnimate: false,
                            badgeColor: Colors.red,
                            borderRadius: BorderRadius.circular(8),
                            badgeContent: Text(
                                (snapshot.data!.docs.length).toString(),
                                style: const TextStyle(color: Colors.white)),
                            child: const Icon(CupertinoIcons.shopping_cart));
                      }

                      return const Icon(CupertinoIcons.shopping_cart);
                    })),
          ]),
    );
  }
}
