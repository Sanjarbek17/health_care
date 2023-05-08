// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '/providers/main_provider.dart';
import '/screens/catalog/articles.dart';
import '/screens/catalog/constant_infos.dart';
import '/screens/constants.dart';
import '/screens/info/info_screen.dart';
import '/screens/map_screen.dart';
import '/style/constant.dart';
import '../../providers/translation_provider.dart';
import '../../style/my_flutter_app_icons.dart';
import '../profile/profil_screen.dart';

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
        bottomNavigationBar: BottomAppBar(
          height: 60,
          elevation: 20,
          shape: const CircularNotchedRectangle(),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            // we're gonna change this  to active and inactive images
            children: [
              const Spacer(flex: 1),
              IconButton(
                icon: Image.asset(ambulance),
                onPressed: () {
                  context.goNamed(HomeScreen.routeName);
                },
              ),
              const Spacer(flex: 2),
              IconButton(
                icon: Image.asset(spravochnikActive),
                onPressed: () {},
              ),
              const Spacer(flex: 4),
              IconButton(
                icon: Image.asset(info),
                onPressed: () {
                  context.goNamed(InfoScreen.routeName);
                },
              ),
              const Spacer(flex: 2),
              IconButton(
                icon: Image.asset(profile),
                onPressed: () {
                  context.goNamed(ProfilScreen.routeName);
                },
              ),
              const Spacer(flex: 1),
            ],
          ),
        ),
        floatingActionButton: SizedBox(
          width: 70,
          height: 70,
          child: SpeedDial(
            icon: MyFlutterApp.logo1034,
            activeIcon: Icons.close,
            iconTheme: const IconThemeData(color: Colors.red, size: 56),
            visible: true,
            closeManually: false,
            childrenButtonSize: Size(width * 0.9, 85),
            curve: Curves.bounceIn,
            overlayColor: Colors.black,
            overlayOpacity: 0.5,
            onOpen: () => print('OPENING DIAL'),
            onClose: () => print('DIAL CLOSED'),
            tooltip: '102',
            heroTag: 'speed-dial-hero-tag',
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 8.0,
            shape: const CircleBorder(),
            children: [
              SpeedDialChild(
                child: ListTile(
                  textColor: Colors.white,
                  iconColor: Colors.white,
                  leading: const Icon(Icons.sms),
                  title: Text(language.isRussian ? mainButtonThirdText : mainButtonThirdTextUz),
                  subtitle: Text(
                    language.isRussian ? mainButtonThirdSubtitleText : mainButtonThirdSubtitleTextUz,
                    style: const TextStyle(fontSize: 10),
                  ),
                ),
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                onTap: () async {
                  if (await canLaunchUrl(smsNumber)) {
                    await launchUrl(smsNumber);
                  } else {
                    throw 'Could not launch $smsNumber';
                  }
                },
              ),
              SpeedDialChild(
                child: ListTile(
                  textColor: Colors.white,
                  iconColor: Colors.white,
                  leading: const Icon(Icons.phone_iphone_rounded),
                  title: Text(language.isRussian ? mainButtonSecondText : mainButtonSecondTextUz),
                  subtitle: Text(
                    language.isRussian ? mainButtonSecondSubtitleText : mainButtonSecondSubtitleTextUz,
                    style: const TextStyle(fontSize: 10),
                  ),
                ),
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                onTap: () async {
                  if (await canLaunchUrl(Uri.parse('tel:+998940086601'))) {
                    await launchUrl(Uri.parse('tel:+998940086601'));
                  } else {
                    throw 'Could not launch ${Uri.parse('tel:+998940086601')}';
                  }
                },
              ),
              SpeedDialChild(
                child: ListTile(
                  textColor: Colors.white,
                  iconColor: Colors.white,
                  leading: const Icon(Icons.place_outlined),
                  title: Text(language.isRussian ? mainButtonFirstText : mainButtonFirstSubtitleTextUz),
                  subtitle: Text(
                    language.isRussian ? mainButtonFirstSubtitleText : mainButtonFirstSubtitleTextUz,
                    style: const TextStyle(fontSize: 10),
                  ),
                ),
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
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
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
