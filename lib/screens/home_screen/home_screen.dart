import 'package:flutter/material.dart';
import './home_screen_constant.dart';

import '../../style/main_style.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      home: Scaffold(
        appBar: AppBar(
          leading: Image.asset(image_103),
          title: const Text(
            '103',
          ),
        ),
        body: const Center(child: Text('103')),
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          child: Row(
            // we're gonna change this  to active and inactive images
            children: [
              IconButton(icon: Image.asset(ambulance), onPressed: () {}),
              IconButton(icon: Image.asset(profile), onPressed: () {}),
              const Spacer(),
              IconButton(icon: Image.asset(spravochnik), onPressed: () {}),
              IconButton(icon: Image.asset(info), onPressed: () {}),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
            elevation: 2,
            child: Image.asset(
              image_103,
            ),
            onPressed: () {}),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
