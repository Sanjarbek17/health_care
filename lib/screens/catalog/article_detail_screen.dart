// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'constant_infos.dart';
import '../../providers/translation_provider.dart';
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
    final detailListUz = Provider.of<InfoProviderUz>(context, listen: false).aricleInfos;
    // Language Provider
    final language = Provider.of<Translate>(context, listen: false);
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
            child: Text(language.isRussian ? detailList[indx] : detailListUz[indx]),
          ),
        ],
      ),
    );
  }
}
