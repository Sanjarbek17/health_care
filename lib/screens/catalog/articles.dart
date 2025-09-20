// ignore_for_file: prefer_const_literals_to_create_immutables, must_be_immutable

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../providers/main_provider.dart';
import 'article_detail_screen.dart';
import '../../providers/translation_provider.dart';
import '../../style/constant.dart';
import '../constants.dart';

class Articles extends StatelessWidget {
  String name;
  int index;
  Articles({super.key, required this.index, required this.name});
  static const routeName = 'articles';

  @override
  Widget build(BuildContext context) {
    final articles = Provider.of<MainProvider>(context).articles;
    final articlesUz = Provider.of<MainProviderUz>(context).articles;
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
          language.isRussian ? 'Статьи' : 'Maqolalar',
          style: appBarStyle,
        ),
      ),
      body: ListView(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 6,
            decoration: const BoxDecoration(
              image: DecorationImage(fit: BoxFit.fitWidth, image: AssetImage(spravochnikBackground)),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    language.isRussian ? 'Первая помощь' : 'Birinchi yordam',
                    style: const TextStyle(fontSize: 35, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    language.isRussian ? '11 статей' : '11 ta maqola',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, i) => ListTile(
              onTap: () {
                context.goNamed(ArticleDetailScreen.routeName, extra: {
                  'index': index,
                  "name": name,
                });
              },
              title: Text(
                language.isRussian ? articles[index] : articlesUz[index],
                style: listTilesStyle,
              ),
            ),
            separatorBuilder: (context, index) => const Divider(),
            itemCount: 1,
          )
        ],
      ),
    );
  }
}
