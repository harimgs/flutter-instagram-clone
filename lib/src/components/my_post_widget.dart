import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clone_instagram/src/model/post.dart';

class MyPostWidget extends StatelessWidget {
  final Post post;
  const MyPostWidget({Key? key, required this.post}) : super(key: key);

  Widget _image() {
    return CachedNetworkImage(
      imageUrl: post.thumbnail!,
      fit: BoxFit.cover,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _image(),
    );
  }
}
