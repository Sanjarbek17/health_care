// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:go_router/go_router.dart';
import 'package:health_care/screens/map_screen.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../providers/main_provider.dart';
import '../style/constant.dart';
import '../style/my_flutter_app_icons.dart';
import 'catalog/catalog_screen.dart';
import 'constants.dart';
import 'profile/profil_screen.dart';

class InfoScreen extends StatelessWidget {
  InfoScreen({super.key});
  static const routeName = 'info';
  final phoneNumber = Uri.parse('tel:+998940086601');
  final smsNumber = Uri.parse('sms:103');

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final list = Provider.of<MainProvider>(context).uderjeniya;
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
            SizedBox(
              width: double.infinity,
              height: height * 0.15,
              child: Image.asset(
                'assets/doctors_get_in_ambulance.jpg',
                fit: BoxFit.fitWidth,
              ),
            ),
            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) => ListTile(
                title: Text(
                  list[index],
                  style: listTilesStyle,
                ),
                subtitle: const Text(
                  'Самаркандской области',
                  style: listTilesSubtitleStyle,
                ),
              ),
              separatorBuilder: (context, index) => const Divider(),
              itemCount: list.length,
            )
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
                icon: Image.asset(spravochnik),
                onPressed: () {
                  context.goNamed(CatalogScreen.routeName);
                },
              ),
              const Spacer(flex: 4),
              IconButton(
                icon: Image.asset(infoActive),
                onPressed: () {},
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
            iconTheme: const IconThemeData(color: Colors.red),
            visible: true,
            closeManually: false,
            childrenButtonSize: Size(width * 0.9, 70),
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
                child: const ListTile(
                  textColor: Colors.white,
                  iconColor: Colors.white,
                  leading: Icon(Icons.sms),
                  title: Text(mainButtonThirdText),
                  subtitle: Text(mainButtonThirdSubtitleText, style: TextStyle(fontSize: 10)),
                ),
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                onTap: () async {
                  if (await canLaunchUrl(smsNumber)) {
                    await launchUrl(smsNumber);
                  } else {
                    throw 'Could not launch $smsNumber';
                  }
                },
              ),
              SpeedDialChild(
                child: const ListTile(
                  textColor: Colors.white,
                  iconColor: Colors.white,
                  leading: Icon(Icons.phone_iphone_rounded),
                  title: Text(mainButtonSecondText),
                  subtitle: Text(
                    mainButtonSecondSubtitleText,
                    style: TextStyle(fontSize: 10),
                  ),
                ),
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                onTap: () async {
                  if (await canLaunchUrl(Uri.parse('tel:+998940086601'))) {
                    await launchUrl(Uri.parse('tel:+998940086601'));
                  } else {
                    throw 'Could not launch ${Uri.parse('tel:+998940086601')}';
                  }
                },
              ),
              SpeedDialChild(
                child: const ListTile(
                  textColor: Colors.white,
                  iconColor: Colors.white,
                  leading: Icon(Icons.place_outlined),
                  title: Text(mainButtonFirstText),
                  subtitle: Text(mainButtonFirstSubtitleText, style: TextStyle(fontSize: 10)),
                ),
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
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
