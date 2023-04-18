import 'package:flutter/material.dart';

import '../screens/catalog_screen.dart';
import '../screens/info_screen.dart';
import '../screens/map_screen.dart';
import '../screens/profil_screen.dart';

import '../style/main_style.dart';

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
    const ProfilScreen(),
    const CatalogScreen(),
    const InfoScreen(),
  ];
  @override
  Widget build(BuildContext context) {
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
                  icon: index == 1
                      ? Image.asset(profileActive)
                      : Image.asset(profile),
                  onPressed: () {
                    setState(() {
                      index = 1;
                    });
                  }),
              const Spacer(flex: 4),
              IconButton(
                  icon: index == 2
                      ? Image.asset(spravochnikActive)
                      : Image.asset(spravochnik),
                  onPressed: () {
                    setState(() {
                      index = 2;
                    });
                  }),
              const Spacer(flex: 2),
              IconButton(
                  icon:
                      index == 3 ? Image.asset(infoActive) : Image.asset(info),
                  onPressed: () {
                    setState(() {
                      index = 3;
                    });
                  }),
              const Spacer(flex: 1),
            ],
          ),
        ),
        floatingActionButton: SizedBox(
          width: 70,
          height: 70,
          child: FloatingActionButton(
              elevation: 2,
              child: Image.asset(
                image_103,
              ),
              onPressed: () {}),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
