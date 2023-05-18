// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/main_provider.dart';
import '../../providers/translation_provider.dart';
import '../../style/constant.dart';

class InfoDetail extends StatelessWidget {
  const InfoDetail({super.key});
  static const routeName = 'info-detail';

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final tuman = Provider.of<MainProvider>(context).tumanlar;
    final tumanUz = Provider.of<MainProviderUz>(context).tumanlar;
    final numbers = Provider.of<MainProvider>(context).raqamlar;
    final numbersUz = Provider.of<MainProviderUz>(context).raqamlar;
    // Language Provider
    final language = Provider.of<Translate>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          centerTitle: true,
          title: Text(
            language.isRussian ? 'Самаркандские районы' : 'Samarqand viloyati',
            style: appBarStyle,
          ),
        ),
        body: ListView(
          children: [
            SizedBox(
              width: double.infinity,
              height: height * 0.15,
              child: Image.asset(
                'assets/doctors_get_in_ambulance.jpg',
                fit: BoxFit.fitWidth,
              ),
            ),
            const Divider(),
            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) => ListTile(
                title: Text(
                  language.isRussian ? tuman[index] : tumanUz[index],
                  style: listTilesStyle,
                ),
                subtitle: Text(
                  language.isRussian ? numbers[index] : numbersUz[index],
                  style: listTilesSubtitleStyle,
                ),
              ),
              separatorBuilder: (context, index) => const Divider(),
              itemCount: language.isRussian ? tuman.length : tumanUz.length,
            )
          ],
        ),
      ),
    );
  }
}
