import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'catalog/catalog_screen.dart';
import '../screens/info_screen.dart';
import '../screens/map_screen.dart';
import '../screens/profil_screen.dart';

import '../style/main_style.dart';
import '../style/my_flutter_app_icons.dart';

import 'constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;
  List<Widget> screens = [
    const MapScreen(),
    ProfilScreen(),
    const CatalogScreen(),
    const InfoScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return MaterialApp(
      theme: theme,
      home: Scaffold(
        body: screens[index],
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
                  icon: index == 0
                      ? Image.asset(ambulanceActive)
                      : Image.asset(ambulance),
                  onPressed: () {
                    setState(() {
                      index = 0;
                    });
                  }),
              const Spacer(flex: 2),
              IconButton(
                  icon: index == 2
                      ? Image.asset(spravochnikActive)
                      : Image.asset(spravochnik),
                  onPressed: () {
                    setState(() {
                      index = 2;
                    });
                  }),
              const Spacer(flex: 4),
              IconButton(
                  icon:
                      index == 3 ? Image.asset(infoActive) : Image.asset(info),
                  onPressed: () {
                    setState(() {
                      index = 3;
                    });
                  }),
              const Spacer(flex: 2),
              IconButton(
                  icon: index == 1
                      ? Image.asset(profileActive)
                      : Image.asset(profile),
                  onPressed: () {
                    setState(() {
                      index = 1;
                    });
                  }),
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
            iconTheme: IconThemeData(color: Colors.red),
            // this is ignored if animatedIcon is non null
            // child: Icon(Icons.add),
            visible: true,
            // If true user is forced to close dial manually
            // by tapping main button and overlay is not rendered.
            // childPadding: EdgeInsets.all(30),
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
                  subtitle: Text(mainButtonThirdSubtitleText,
                      style: TextStyle(fontSize: 10)),
                ),
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2)),
                onTap: () => print('FIRST CHILD'),
              ),
              SpeedDialChild(
                child: const ListTile(
                  textColor: Colors.white,
                  iconColor: Colors.white,
                  leading: Icon(Icons.phone_iphone_rounded),
                  title: Text(mainButtonSecondText),
                  subtitle: Text(mainButtonSecondSubtitleText,
                      style: TextStyle(fontSize: 10)),
                ),
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2)),
                onTap: () => print('FIRST CHILD'),
              ),
              SpeedDialChild(
                child: const ListTile(
                  textColor: Colors.white,
                  iconColor: Colors.white,
                  leading: Icon(Icons.place_outlined),
                  title: Text(mainButtonFirstText),
                  subtitle: Text(mainButtonFirstSubtitleText,
                      style: TextStyle(fontSize: 10)),
                ),
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2)),
                onTap: () => print('FIRST CHILD'),
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
