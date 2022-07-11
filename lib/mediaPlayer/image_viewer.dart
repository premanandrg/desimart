import 'package:cached_network_image/cached_network_image.dart';
import 'package:desimart/app_config.dart';
import 'package:flutter/material.dart';

class ImageViewer extends StatelessWidget {
  const ImageViewer({Key? key, required this.imageUrl}) : super(key: key);
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        foregroundColor: appColor,
      ),
      body: Hero(
          tag: imageUrl,
          child: Center(child: CachedNetworkImage(imageUrl: imageUrl))),
    );
  }
}
