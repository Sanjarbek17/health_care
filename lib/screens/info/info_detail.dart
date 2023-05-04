// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/main_provider.dart';
import '../../style/constant.dart';

class InfoDetail extends StatelessWidget {
  const InfoDetail({super.key});
  static const routeName = 'info-detail';

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final tuman = Provider.of<MainProvider>(context).tumanlar;
    final numbers = Provider.of<MainProvider>(context).raqamlar;
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
          title: const Text(
            'Самаркандские районы',
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
                  tuman[index],
                  style: listTilesStyle,
                ),
                subtitle: Text(
                  numbers[index],
                  style: listTilesSubtitleStyle,
                ),
              ),
              separatorBuilder: (context, index) => const Divider(),
              itemCount: tuman.length,
            )
          ],
        ),
      ),
    );
  }
}
