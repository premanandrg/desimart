import 'package:desimart/app_config.dart';
import 'package:flutter/material.dart';

class CommunityPage extends StatelessWidget {
  const CommunityPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('$appName community')),
    );
  }
}
