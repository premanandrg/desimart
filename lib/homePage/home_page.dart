import 'package:cached_network_image/cached_network_image.dart';
import 'package:desimart/app_config.dart';
import 'package:desimart/chat/customer_support_page.dart';
import 'package:desimart/notification/notification_page.dart';
import 'package:desimart/profile/profile_page.dart';
import 'package:desimart/search/search_product_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../login/login_page.dart';
import '../main_page.dart';
import '../short_codes.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      // backgroundColor: Colors.yellow,
      body: Column(children: [
        AppBar(
          backgroundColor: Colors.white,
          foregroundColor: appColor,
          title: const Text(appName),
          elevation: 0,
          actions: [
            IconButton(
              onPressed: () {
                pushPage(context, const ProfilePage());
              },
              icon: FirebaseAuth.instance.currentUser == null
                  ? const Icon(Icons.account_circle)
                  : CircleAvatar(
                      backgroundImage: FirebaseAuth.instance.currentUser == null
                          ? null
                          : CachedNetworkImageProvider(FirebaseAuth
                              .instance.currentUser!.photoURL
                              .toString()),
                    ),
            ),
            IconButton(
                onPressed: () {
                  pushPage(context, const NotificationPage());
                },
                icon: const Icon(Icons.notifications_on)),
          ],
        ),
        const SizedBox(
          height: 25,
        ),
        GestureDetector(
          onTap: () {
            pushPage(context, const SearchProductPage());
          },
          child: Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            height: 54,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(blurRadius: 40, color: appColor.withOpacity(0.26)),
                ]),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Search',
                    style: TextStyle(
                      color: appColor.withOpacity(0.5),
                    ),
                  ),
                ),
                const Icon(
                  CupertinoIcons.search,
                ),
              ],
            ),
          ),
        ),
        // ListView.builder(
        //   scrollDirection: Axis.horizontal,
        //   shrinkWrap: true,
        //   itemBuilder: (BuildContext context, int index) {
        //     return Chip(label: Text('All'));
        //   },
        // ),
      ]),
      floatingActionButton: FloatingActionButton(
          mini: true,
          backgroundColor: Colors.white,
          onPressed: () {
            if (FirebaseAuth.instance.currentUser == null) {
              pushPage(context, const LoginPage(nextPage: MainPage()));
              return;
            }
            pushPage(context, const CustomerSupportPage(isTab: false));
          },
          child: const Icon(
            Icons.support_agent_outlined,
            color: appColor,
          )),
    );
  }
}
