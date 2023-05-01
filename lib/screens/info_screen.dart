import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/main_provider.dart';
import '../style/constant.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final _list = Provider.of<MainProvider>(context).uderjeniya;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Учереждения',
            style: appBarStyle,
          ),
        ),
        body: ListView(
          children: [
            Container(
              width: double.infinity,
              height: height * 0.15,
              child: Image.asset(
                'assets/doctors_get_in_ambulance.jpg',
                fit: BoxFit.fitWidth,
              ),
            ),
            ListView.separated(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) => ListTile(
                title: Text(
                  _list[index],
                  style: listTilesStyle,
                ),
                subtitle: Text(
                  'Самаркандской области',
                  style: listTilesSubtitleStyle,
                ),
              ),
              separatorBuilder: (context, index) => Divider(),
              itemCount: _list.length,
            )
          ],
        ),
      ),
    );
  }
}
