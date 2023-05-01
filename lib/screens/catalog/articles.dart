// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:health_care/providers/main_provider.dart';
import 'package:health_care/screens/catalog/article_detail_screen.dart';
import 'package:provider/provider.dart';

import '../../style/constant.dart';
import '../constants.dart';

class Articles extends StatelessWidget {
  String name;
  int index;
  Articles({super.key, required this.index, required this.name});
  static const routeName = '/articles';

  @override
  Widget build(BuildContext context) {
    final articles = Provider.of<MainProvider>(context).articles;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        title: const Text(
          'Справочник',
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
                  const Text(
                    'Первая помощь',
                    style: TextStyle(fontSize: 35, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    '11 статей',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, i) => ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ArticleDetailScreen(
                        indx: index,
                        name: name,
                      ),
                    ));
              },
              title: Text(
                articles[index],
                style: listTilesStyle,
              ),
            ),
            separatorBuilder: (context, index) => Divider(),
            itemCount: 1,
          )
        ],
      ),
    );
  }
}
