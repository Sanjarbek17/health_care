import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../providers/translation_provider.dart';
import '../screens/catalog/catalog_screen.dart';
import '../screens/constants.dart';
import '../screens/info/info_screen.dart';
import '../screens/map_screen.dart';
import '../screens/profile/profil_screen.dart';
import '../style/my_flutter_app_icons.dart';

class WidgetSpeedDial extends StatelessWidget {
  final Uri smsNumber;
  final double width;
  final Translate language;
  final void Function() onTap;

  const WidgetSpeedDial({super.key, required this.smsNumber, required this.width, required this.language, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 60,
      child: SpeedDial(
        icon: CustomIcons.fast2,
        activeIcon: Icons.close,
        iconTheme: const IconThemeData(color: Colors.red, size: 56),
        visible: true,
        closeManually: false,
        childrenButtonSize: Size(width * 0.9, 85),
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        onOpen: () {},
        onClose: () {},
        tooltip: '103',
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
              if (await canLaunchUrl(Uri.parse('tel:103'))) {
                await launchUrl(Uri.parse('tel:103'));
              } else {
                throw 'Could not launch ${Uri.parse('tel:103')}';
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
            onTap: onTap,
          ),
        ],
      ),
    );
  }
}

class BottomBar extends StatelessWidget {
  final String first;
  final String second;
  final String third;
  final String fourth;
  const BottomBar({
    super.key,
    required this.first,
    required this.second,
    required this.third,
    required this.fourth,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
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
              icon: Image.asset(first),
              onPressed: () {
                context.goNamed(HomeScreen.routeName);
              }),
          const Spacer(flex: 2),
          IconButton(
            icon: Image.asset(second),
            onPressed: () {
              context.goNamed(CatalogScreen.routeName);
            },
          ),
          const Spacer(flex: 4),
          IconButton(
            icon: Image.asset(third),
            onPressed: () {
              context.goNamed(InfoScreen.routeName);
            },
          ),
          const Spacer(flex: 2),
          IconButton(
            icon: Image.asset(fourth),
            onPressed: () {
              context.goNamed(ProfilScreen.routeName);
            },
          ),
          const Spacer(flex: 1),
        ],
      ),
    );
  }
}
