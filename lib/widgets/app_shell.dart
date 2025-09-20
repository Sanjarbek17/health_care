import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';

import '../screens/catalog/catalog_screen.dart';
import '../screens/info/info_screen.dart';
import '../screens/map_screen.dart';
import '../screens/profile/profil_screen.dart';
import '../screens/constants.dart';
import '../providers/translation_provider.dart';
import '../widgets/functions.dart';
import 'widgets.dart';

class AppShell extends StatefulWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;

  // Map route names to indices
  static const Map<String, int> _routeToIndex = {
    'home-screen': 0,
    'catalog-screen': 1,
    'info-screen': 2,
    'profil-screen': 3,
  };

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        context.goNamed(HomeScreen.routeName);
        break;
      case 1:
        context.goNamed(CatalogScreen.routeName);
        break;
      case 2:
        context.goNamed(InfoScreen.routeName);
        break;
      case 3:
        context.goNamed(ProfilScreen.routeName);
        break;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Update selected index based on current route
    final currentRoute = GoRouterState.of(context).name;
    if (currentRoute != null && _routeToIndex.containsKey(currentRoute)) {
      setState(() {
        _selectedIndex = _routeToIndex[currentRoute]!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final language = Provider.of<Translate>(context, listen: false);
    final double width = MediaQuery.of(context).size.width;
    final smsNumber = Uri.parse('sms:103');

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomAppBar(
        height: 60,
        elevation: 20,
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            const Spacer(flex: 1),
            IconButton(
              icon: Image.asset(_selectedIndex == 0 ? ambulanceActive : ambulance),
              onPressed: () => _onItemTapped(0),
            ),
            const Spacer(flex: 2),
            IconButton(
              icon: Image.asset(_selectedIndex == 1 ? spravochnikActive : spravochnik),
              onPressed: () => _onItemTapped(1),
            ),
            const Spacer(flex: 4),
            IconButton(
              icon: Image.asset(_selectedIndex == 2 ? infoActive : info),
              onPressed: () => _onItemTapped(2),
            ),
            const Spacer(flex: 2),
            IconButton(
              icon: Image.asset(_selectedIndex == 3 ? profileActive : profile),
              onPressed: () => _onItemTapped(3),
            ),
            const Spacer(flex: 1),
          ],
        ),
      ),
      floatingActionButton: WidgetSpeedDial(
        language: language,
        width: width,
        smsNumber: smsNumber,
        onTap: () async {
          Position p = await determinePosition();
          sendMessage({'position': p.toJson()});
          print('send message');
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
