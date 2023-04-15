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
        body: SafeArea(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                color: Colors.red,
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50)),
                              child: const Icon(Icons.phone_rounded,
                                  color: Colors.red, size: 30),
                            ),
                            Text(
                              appBarTitle,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ],
                        ),
                        // small title text
                        Text(
                          appBarLeadingText,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // change to map widget
              const Center(child: Text('103')),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          height: 60,
          shape: const CircularNotchedRectangle(),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            // we're gonna change this  to active and inactive images
            children: [
              const Spacer(flex: 1),
              IconButton(icon: Image.asset(ambulance), onPressed: () {}),
              const Spacer(flex: 2),
              IconButton(icon: Image.asset(profile), onPressed: () {}),
              const Spacer(flex: 4),
              IconButton(icon: Image.asset(spravochnik), onPressed: () {}),
              const Spacer(flex: 2),
              IconButton(icon: Image.asset(info), onPressed: () {}),
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
