import 'package:flutter/material.dart';

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
                  icon: const Icon(Icons.arrow_back_ios_new),
                ),
                const Text('Авторизация'),
              ],
            ),
            const Text('Введите ноиер телефона, который вы использавали при регистрации в мобильном приложении ”iAmbulance”')
          ],
        ),
        floatingActionButton: FilledButton(
          child: const Text('Продолжить'),
          onPressed: () {},
        ));
  }
}
