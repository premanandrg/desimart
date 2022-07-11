import 'dart:async';

import 'package:desimart/app_config.dart';
import 'package:desimart/main_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../short_codes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(const Duration(seconds: 2), () {
      pushReplacePage(
          context,
          const MainPage(
            initPage: 0,
          ));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            //TODO add gradient
            ),
        child: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
              const Icon(
                CupertinoIcons.shopping_cart,
                size: 50,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                appName,
                style: Theme.of(context).textTheme.bodyLarge,
              )
            ])),
      ),
    );
  }
}
