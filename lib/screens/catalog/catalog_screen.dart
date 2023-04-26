import 'package:flutter/material.dart';
import 'package:health_care/providers/main_provider.dart';
import 'package:health_care/screens/catalog/articles.dart';
import 'package:health_care/screens/constants.dart';
import 'package:health_care/style/constant.dart';
import 'package:provider/provider.dart';

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final list = Provider.of<MainProvider>(context, listen: false).names;
    return Scaffold(
      appBar: AppBar(
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
                children: const [
                  Text(
                    'Первая помощь',
                    style: TextStyle(fontSize: 35, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '11 статей',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) => ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Articles()));
              },
              title: Text(
                list[index],
                style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
              ),
              subtitle: const Text('1 статья'),
            ),
            separatorBuilder: (context, index) => const Divider(),
            itemCount: list.length,
          ),
        ],
      ),
    );
  }
}
