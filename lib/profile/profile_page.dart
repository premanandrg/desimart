import 'package:cached_network_image/cached_network_image.dart';
import 'package:desimart/about/about_page.dart';
import 'package:desimart/address/address_page.dart';
import 'package:desimart/app_config.dart';
import 'package:desimart/customerCare/customer_support_page.dart';
import 'package:desimart/login/login_page.dart';
import 'package:desimart/main_page.dart';
import 'package:desimart/refer/refer_page.dart';
import 'package:desimart/short_codes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../orders/orders_page.dart';
import 'components/account_list_tile.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: Column(children: [
        const SizedBox(
          height: 10,
        ),
        FirebaseAuth.instance.currentUser != null
            ? CircleAvatar(
                radius: 60,
                backgroundImage: CachedNetworkImageProvider(
                    FirebaseAuth.instance.currentUser!.photoURL.toString()),
              )
            : const Icon(
                Icons.account_circle,
                size: 120,
                color: appColor,
              ),
        const SizedBox(
          height: 10,
        ),
        FirebaseAuth.instance.currentUser != null
            ? Text(
                FirebaseAuth.instance.currentUser!.displayName.toString(),
                style: GoogleFonts.roboto(fontSize: 20),
              )
            : Text(
                appName,
                style: GoogleFonts.roboto(fontSize: 20),
              ),
        AccountListTile(
          title: 'My Orders',
          icon: Icons.local_shipping_outlined,
          onClick: () {
            pushPage(
                context,
                const OrdersPage(
                  isTab: false,
                ));
          },
        ),
        AccountListTile(
          title: 'My Addresses',
          icon: Icons.location_on_outlined,
          onClick: () {
            pushPage(context, const AddressPage());
          },
        ),
        AccountListTile(
          title: 'Customer Care',
          icon: Icons.support_agent_outlined,
          onClick: () {
            pushPage(
                context,
                const CustomerSupportPage(
                  isTab: false,
                ));
          },
        ),
        AccountListTile(
          title: 'My Reviews',
          icon: Icons.star_outline,
          onClick: () {
            pushPage(context, const CustomerSupportPage(isTab: false));
          },
        ),
        AccountListTile(
          title: 'Refer',
          icon: Icons.adaptive.share,
          onClick: () {
            pushPage(context, const ReferPage());
          },
        ),
        AccountListTile(
          title: 'About',
          icon: Icons.info_outline,
          onClick: () {
            pushPage(context, const AboutPage());
          },
        ),
        FirebaseAuth.instance.currentUser != null
            ? AccountListTile(
                title: 'Logout',
                icon: Icons.logout_outlined,
                onClick: () {
                  logoutFromApp(context, const MainPage()).then((value) {
                    showMessage(context, 'Logout successfully');
                  });
                },
              )
            : AccountListTile(
                title: 'Login',
                icon: Icons.logout_outlined,
                onClick: () {
                  pushPage(context, const LoginPage(nextPage: MainPage()));
                },
              ),
      ]),
    );
  }
}
