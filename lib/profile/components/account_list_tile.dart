import 'package:flutter/material.dart';

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
          onClick();
        },
        title: Text(title),
        leading: Icon(icon),
        trailing: Icon(Icons.chevron_right));
  }
}
