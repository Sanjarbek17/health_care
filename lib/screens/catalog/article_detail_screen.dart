// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import '../../style/constant.dart';

class ArticleDetailScreen extends StatelessWidget {
  String name;
  int indx;
  ArticleDetailScreen({
    super.key,
    required this.name,
    required this.indx,
  });
  static const routeName = 'article-detail';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        title: Text(
          name,
          style: appBarStyle,
        ),
      ),
    );
  }
}
