import 'package:flutter/material.dart';

import '../constants.dart';

class Articles extends StatelessWidget {
  // int index;
  // Articles({super.key, required this.index});
  static const routeName = 'articles';

  @override
  Widget build(BuildContext context) {
    final index = ModalRoute.of(context)!.settings.arguments;

    return ListView(
      children: [
        Container(
          height: MediaQuery.of(context).size.height / 6,
          decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fitWidth, image: AssetImage(spravochnikBackground)),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'Первая помощь',
                  style: TextStyle(
                      fontSize: 35,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  '11 статей',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
