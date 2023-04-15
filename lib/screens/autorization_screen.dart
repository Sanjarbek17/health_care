import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class AutorizationScreen extends StatelessWidget {
  const AutorizationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.arrow_back_ios_new),
                ),
                Text('Авторизация'),
              ],
            ),
            Text(
                'Введите ноиер телефона, который вы использавали при регистрации в мобильном приложении ”iAmbulance”')
          ],
        ),
        floatingActionButton: FilledButton(
          child: Text('Продолжить'),
          onPressed: () {},
        ));
  }
}
