// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../chatgpt_screen.dart';
import 'package:provider/provider.dart';

import '../../providers/main_provider.dart';
import '../../providers/translation_provider.dart';
import '../../style/constant.dart';
import 'info_detail.dart';

class InfoScreen extends StatelessWidget {
  InfoScreen({super.key});
  static const routeName = 'info';
  final phoneNumber = Uri.parse('tel:103');
  final smsNumber = Uri.parse('sms:103');

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    // final width = MediaQuery.of(context).size.width;
    final list = Provider.of<MainProvider>(context).uderjeniya;
    final listUz = Provider.of<MainProviderUz>(context).uderjeniya;
    // Language Provider
    final language = Provider.of<Translate>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            language.isRussian ? 'Учереждения' : 'Filiallar',
            style: appBarStyle,
          ),
        ),
        body: ListView(
          children: [
            SizedBox(
              width: double.infinity,
              height: height * 0.15,
              child: Image.asset('assets/doctors_get_in_ambulance.jpg', fit: BoxFit.fitWidth),
            ),
            const Divider(),
            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) => ListTile(
                onTap: () {
                  context.goNamed(InfoDetail.routeName);
                },
                title: Text(
                  language.isRussian ? list[index] : listUz[index],
                  style: listTilesStyle,
                ),
                subtitle: Text(
                  language.isRussian ? 'Самаркандской области' : 'Samarqand viloyati',
                  style: listTilesSubtitleStyle,
                ),
              ),
              separatorBuilder: (context, index) => const Divider(),
              itemCount: language.isRussian ? list.length : listUz.length,
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            context.goNamed(Chat.routeName);
          },
          backgroundColor: Colors.red,
          child: const Icon(Icons.help_outline, color: Colors.white),
        ),
      ),
    );
  }
}
