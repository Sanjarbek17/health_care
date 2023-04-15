import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: Image.asset('assets/logo1034.png'),
          title: const Text(
            '103',
          ),
        ),
        body: const Center(
          child: Text('103'),
        ),
        bottomNavigationBar: BottomNavigationBar(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: [
            BottomNavigationBarItem(
                icon: SizedBox(
                    width: 20,
                    height: 20,
                    child: Image.asset('assets/maps_grey.png')),
                activeIcon: SizedBox(
                  width: 20,
                  height: 20,
                  child: Image.asset('assets/maps_red.png'),
                ),
                label: 'map'),
            BottomNavigationBarItem(
                icon: SizedBox(
                    width: 20,
                    height: 20,
                    child: Image.asset('assets/profil_grey.png')),
                activeIcon: SizedBox(
                    width: 20,
                    height: 20,
                    child: Image.asset('assets/profil_red.png')),
                label: 'profil'),
          ],
        ),
      ),
    );
  }
}
