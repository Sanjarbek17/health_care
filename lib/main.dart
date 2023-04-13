import 'package:flutter/material.dart';

import './style/main_style.dart';

import './screens/main_screen.dart';
import './screens/playlist.dart';
import './screens/playing.dart';

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
    return MaterialApp(
      theme: theme,
      initialRoute: '/',
      routes: {
        '/': (context) => const MainPage(),
        '/playlist': (context) => const PlaylistPage(),
        '/playing': (context) => const PlayingPage(),
      },
    );
  }
}
