import 'package:desimart/main_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../login/login_page.dart';
import '../../short_codes.dart';
import '../profile_page.dart';

class AccountListTile extends StatelessWidget {
  const AccountListTile({
    Key? key,
    required this.title,
    required this.icon,
    required this.onClick,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final Function onClick;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: () {
          if (FirebaseAuth.instance.currentUser == null) {
            pushPage(context, const LoginPage(nextPage: MainPage()));
            return;
          }
          onClick();
        },
        title: Text(title),
        leading: Icon(icon),
        trailing: const Icon(Icons.chevron_right));
  }
}
