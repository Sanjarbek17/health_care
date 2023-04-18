import 'package:flutter/material.dart';
import 'package:health_care/screens/constants.dart';
import 'package:health_care/style/constant.dart';

class CatalogScreen extends StatelessWidget {
  CatalogScreen({super.key});
  List<String> names = [
    'Рана',
    'Кровоточения',
    'Травмы и переломы',
    'Первая помощь: ожоги',
    'Опасные состояния',
    'Потерия сознания',
    'Отправления',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Справочник',
          style: appBarStyle,
        ),
      ),
      body: ListView(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 6,
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fitWidth,
                image: AssetImage(spravochnikBackground),
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Первая помощь',
                    style: TextStyle(
                        fontSize: 35,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '11 статей',
                    style: TextStyle(
                        // fontSize: 35,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            itemBuilder: (context, index) => ListTile(
              title: Text(
                names[index],
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
              subtitle: Text('1 статья'),
            ),
            separatorBuilder: (context, index) => Divider(),
            itemCount: names.length,
          ),
        ],
      ),
    );
  }
}
