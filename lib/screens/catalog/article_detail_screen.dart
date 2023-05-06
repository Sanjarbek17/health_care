// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:health_care/screens/catalog/constant_infos.dart';
import 'package:provider/provider.dart';

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
    final detailList = Provider.of<InfoProvider>(context, listen: false).aricleInfos;
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
      body: ListView(
        children: [
          const Divider(),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10, left: 10),
            child: Text(name, style: const TextStyle(fontSize: 30)),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(detailList[indx]),
          ),
        ],
      ),
    );
  }
}
