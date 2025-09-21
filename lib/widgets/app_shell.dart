import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../screens/catalog/catalog_screen.dart';
import '../screens/info/info_screen.dart';
import '../screens/map_screen.dart';
import '../screens/profile/profil_screen.dart';
import '../screens/constants.dart';
import '../providers/translation_provider.dart';
import '../models/patient_model.dart';
import '../widgets/emergency_type_selector.dart';
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
      resizeToAvoidBottomInset: false,
      body: widget.child,
      bottomNavigationBar: BottomAppBar(
        height: 80,
        elevation: 20,
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            const Spacer(flex: 1),
            GestureDetector(
              onTap: () => _onItemTapped(0),
              child: Container(
                width: 35,
                height: 35,
                child: Image.asset(_selectedIndex == 0 ? ambulanceActive : ambulance, fit: BoxFit.contain),
              ),
            ),
            const Spacer(flex: 2),
            GestureDetector(
              onTap: () => _onItemTapped(1),
              child: Container(
                width: 35,
                height: 35,
                child: Image.asset(_selectedIndex == 1 ? spravochnikActive : spravochnik, fit: BoxFit.contain),
              ),
            ),
            const Spacer(flex: 4),
            GestureDetector(
              onTap: () => _onItemTapped(2),
              child: Container(
                width: 35,
                height: 35,
                child: Image.asset(_selectedIndex == 2 ? infoActive : info, fit: BoxFit.contain),
              ),
            ),
            const Spacer(flex: 2),
            GestureDetector(
              onTap: () => _onItemTapped(3),
              child: Container(
                width: 35,
                height: 35,
                child: Image.asset(_selectedIndex == 3 ? profileActive : profile, fit: BoxFit.contain),
              ),
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
          try {
            // Show emergency type selector
            await showEmergencyTypeSelector(
              context,
              onEmergencyTypeSelected: (type) {
                // This will be handled by the PatientProvider
                print('Emergency type selected: ${type.displayName}');
              },
            );
          } catch (e) {
            print('Error in emergency request: $e');
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('❌ Error showing emergency options. Please try again.'),
                  duration: Duration(seconds: 3),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
