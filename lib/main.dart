import 'package:flutter/material.dart';
import 'package:health_care/providers/main_provider.dart';
import 'package:health_care/screens/catalog/articles.dart';
import 'package:provider/provider.dart';

import './style/main_style.dart';

import 'screens/home_screen.dart';

void main() {
  runApp(const MainRoute());
}

class MainRoute extends StatefulWidget {
  const MainRoute({super.key});
  @override
  State<MainRoute> createState() => _MainRouteState();
}

class _MainRouteState extends State<MainRoute> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MainProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme,
        initialRoute: '/',
        routes: {
          '/': (context) => const HomeScreen(),
        },
      ),
    );
  }
}
