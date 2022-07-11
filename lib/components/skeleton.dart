import 'package:flutter/material.dart';

class Skeleton extends StatelessWidget {
  const Skeleton({Key? key, this.heigth, this.width}) : super(key: key);
  final double? heigth;
  final double? width;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: heigth,
      width: width,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.04),
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}
