// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../widgets/widgets.dart';
import '/providers/main_provider.dart';
import '/screens/catalog/articles.dart';
import '/screens/catalog/constant_infos.dart';
import '/screens/constants.dart';
import '/screens/map_screen.dart';
import '/style/constant.dart';
import '../../providers/translation_provider.dart';

class CatalogScreen extends StatelessWidget {
  CatalogScreen({super.key});
  static const routeName = 'catalog';
  final phoneNumber = Uri.parse('tel:103');
  final smsNumber = Uri.parse('sms:103');
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    // Names list Providers
    final list = Provider.of<MainProvider>(context, listen: false).names;
    final listUz = Provider.of<MainProviderUz>(context, listen: false).names;
    // Constatns Providers
    final constants = Provider.of<InfoProvider>(context, listen: false);
    final constantsUz = Provider.of<InfoProviderUz>(context, listen: false);
    // Language Provider
    final language = Provider.of<Translate>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          // toolbarHeight: ,
          centerTitle: true,
          title: Text(
            language.isRussian ? constants.catalogAppBarTitle : constantsUz.catalogAppBarTitle,
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
              itemBuilder: (context, index) => ListTile(
                onTap: () {
                  context.goNamed(
                    Articles.routeName,
                    extra: {
                      'name': (language.isRussian ? list : listUz)[index],
                      'index': index,
                    },
                  );
                },
                title: Text(
                  (language.isRussian ? list : listUz)[index],
                  style: listTilesStyle,
                ),
                subtitle: Text(
                  language.isRussian ? '1 статья' : '1 ta maqola',
                  style: listTilesSubtitleStyle,
                ),
              ),
              separatorBuilder: (context, index) => const Divider(),
              itemCount: (language.isRussian ? list : listUz).length,
            ),
          ],
        ),
        bottomNavigationBar: const BottomBar(first: ambulance, second: spravochnikActive, third: info, fourth: profile),
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
