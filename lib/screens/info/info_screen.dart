// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../widgets/widgets.dart';
import '../constants.dart';
import '/screens/map_screen.dart';
import '../../providers/main_provider.dart';
import '../../providers/translation_provider.dart';
import '../../style/constant.dart';
import 'info_detail.dart';

class InfoScreen extends StatelessWidget {
  InfoScreen({super.key});
  static const routeName = 'info';
  final phoneNumber = Uri.parse('tel:103');
  final smsNumber = Uri.parse('sms:103');

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final list = Provider.of<MainProvider>(context).uderjeniya;
    final listUz = Provider.of<MainProviderUz>(context).uderjeniya;
    // Language Provider
    final language = Provider.of<Translate>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            language.isRussian ? 'Учереждения' : 'Filiallar',
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
                onTap: () {
                  context.goNamed(InfoDetail.routeName);
                },
                title: Text(
                  language.isRussian ? list[index] : listUz[index],
                  style: listTilesStyle,
                ),
                subtitle: Text(
                  language.isRussian ? 'Самаркандской области' : 'Samarqand viloyati',
                  style: listTilesSubtitleStyle,
                ),
              ),
              separatorBuilder: (context, index) => const Divider(),
              itemCount: language.isRussian ? list.length : listUz.length,
            )
          ],
        ),
        bottomNavigationBar: const BottomBar(first: ambulance, second: spravochnik, third: infoActive, fourth: profile),
        floatingActionButton: WidgetSpeedDial(
          language: language,
          width: width,
          smsNumber: smsNumber,
          onTap: () {
            // get mapprovider
            final mapProvider = Provider.of<MapProvider>(context, listen: false);
            // change toggle value
            if (!mapProvider.isRun) {
              mapProvider.addOne();
            }

            context.goNamed(
              HomeScreen.routeName,
              extra: mapProvider.isRun,
            );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
