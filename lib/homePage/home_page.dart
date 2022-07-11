import 'package:desimart/app_config.dart';
import 'package:desimart/chat/customer_support_page.dart';
import 'package:desimart/search/search_product_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../short_codes.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(appName),
        actions: [
          IconButton(
              onPressed: () {
                pushPage(context, const SearchProductPage());
              },
              icon: const Icon(CupertinoIcons.search))
        ],
      ),
      floatingActionButton: FloatingActionButton(
          mini: true,
          backgroundColor: Colors.white,
          onPressed: () {
            pushPage(context, const CustomerSupportPage(isTab: false));
          },
          child: const Icon(
            Icons.support_agent_outlined,
            color: appColor,
          )),
    );
  }
}
