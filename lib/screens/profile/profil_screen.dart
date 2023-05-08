// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_print, must_be_immutable

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker_android/image_picker_android.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';

import '/screens/catalog/catalog_screen.dart';
import '/screens/map_screen.dart';
import '/screens/profile/editing_profile.dart';
import '../../providers/main_provider.dart';
import '../../providers/translation_provider.dart';
import '../../style/my_flutter_app_icons.dart';
import '../constants.dart';
import '../info/info_screen.dart';

class ProfilScreen extends StatefulWidget with ChangeNotifier {
  File? image;
  ProfilScreen({super.key, this.image});
  static const routeName = 'profile';

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  final phoneNumber = Uri.parse('tel:103');
  final smsNumber = Uri.parse('sms:103');

  @override
  Widget build(BuildContext context) {
    String name = Provider.of<MainProvider>(context, listen: false).nameController.text;
    String surname = Provider.of<MainProvider>(context, listen: false).surnameController.text;
    String birth = Provider.of<MainProvider>(context, listen: false).birthController.text;
    String number = Provider.of<MainProvider>(context, listen: false).numberController.text;
    // ···
    final ImagePickerPlatform imagePickerImplementation = ImagePickerPlatform.instance;
    if (imagePickerImplementation is ImagePickerAndroid) {
      imagePickerImplementation.useAndroidPhotoPicker = true;
    }
    final width = MediaQuery.of(context).size.width;
    // Language Provider
    final language = Provider.of<Translate>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        title: Text(
          language.isRussian ? 'Информация о пользователе' : 'Foydalanuvchi ma\'lumotlari',
          style: TextStyle(
            fontFamily: 'Material Icons',
            fontSize: 23,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                Provider.of<Translate>(context, listen: false).toggleLanguage();
              });
            },
            icon: Text(Provider.of<Translate>(context, listen: false).isRussian ? 'Uz' : 'Ru'),
          )
        ],
      ),
      body: ListView(
        children: [
          Container(
            height: width * 0.3,
            color: Colors.red,
            child: Center(
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: widget.image != null
                        ? CircleAvatar(
                            radius: 40,
                            backgroundImage: FileImage(widget.image!),
                            // child: Image.file(_image!),
                          )
                        : CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.grey[400],
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                            ),
                          ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10, bottom: 5),
                        child: Text(
                          name != '' ? name : 'Name',
                          style: TextStyle(
                            fontSize: 21,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          surname != '' ? surname : 'Surname',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[100],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(birth != '' ? birth : 'Birth year'),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(number != '' ? number : 'Number'),
            ),
          ),

          // Padding(
          //   padding: const EdgeInsets.all(18.0),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       Text(
          //         'Сотрудник 103',
          //         style: TextStyle(
          //           fontSize: 19,
          //           fontWeight: FontWeight.w500,
          //           color: Colors.grey[800],
          //         ),
          //       ),
          //       Switch.adaptive(
          //         value: _switched,
          //         onChanged: (value) {
          //           setState(() {
          //             _switched = value;
          //           });
          //         },
          //       )
          //     ],
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(
                language.isRussian ? (Provider.of<MainProvider>(context, listen: false).selectedValue ?? 'Регион не выбран') : (Provider.of<MainProvider>(context, listen: false).selectedValue ?? 'Viloyat tanlanmagan'),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              top: 40,
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                maximumSize: Size(width - 20, 50),
                minimumSize: Size(width - 20, 45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {
                context.goNamed(EditingProfile.routeName, extra: widget.image);
              },
              child: Text(language.isRussian ? 'Изменить профиль' : 'Profilni tahrirlash'),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        height: 60,
        elevation: 20,
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          // we're gonna change this  to active and inactive images
          children: [
            const Spacer(flex: 1),
            IconButton(
              icon: Image.asset(ambulance),
              onPressed: () {
                context.goNamed(HomeScreen.routeName);
              },
            ),
            const Spacer(flex: 2),
            IconButton(
              icon: Image.asset(spravochnik),
              onPressed: () {
                context.goNamed(CatalogScreen.routeName);
              },
            ),
            const Spacer(flex: 4),
            IconButton(
              icon: Image.asset(info),
              onPressed: () {
                context.goNamed(InfoScreen.routeName);
              },
            ),
            const Spacer(flex: 2),
            IconButton(
              icon: Image.asset(profileActive),
              onPressed: () {},
            ),
            const Spacer(flex: 1),
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        width: 70,
        height: 70,
        child: SpeedDial(
          icon: MyFlutterApp.logo1034,
          activeIcon: Icons.close,
          iconTheme: const IconThemeData(color: Colors.red, size: 56),
          visible: true,
          closeManually: false,
          childrenButtonSize: Size(width * 0.9, 85),
          curve: Curves.bounceIn,
          overlayColor: Colors.black,
          overlayOpacity: 0.5,
          onOpen: () => print('OPENING DIAL'),
          onClose: () => print('DIAL CLOSED'),
          tooltip: '102',
          heroTag: 'speed-dial-hero-tag',
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 8.0,
          shape: const CircleBorder(),
          children: [
            SpeedDialChild(
              child: ListTile(
                textColor: Colors.white,
                iconColor: Colors.white,
                leading: Icon(Icons.sms),
                title: Text(language.isRussian ? mainButtonThirdText : mainButtonThirdTextUz),
                subtitle: Text(
                  language.isRussian ? mainButtonThirdSubtitleText : mainButtonThirdSubtitleTextUz,
                  style: TextStyle(fontSize: 10),
                ),
              ),
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
              onTap: () async {
                if (await canLaunchUrl(smsNumber)) {
                  await launchUrl(smsNumber);
                } else {
                  throw 'Could not launch $smsNumber';
                }
              },
            ),
            SpeedDialChild(
              child: ListTile(
                textColor: Colors.white,
                iconColor: Colors.white,
                leading: Icon(Icons.phone_iphone_rounded),
                title: Text(language.isRussian ? mainButtonSecondText : mainButtonSecondTextUz),
                subtitle: Text(
                  language.isRussian ? mainButtonSecondSubtitleText : mainButtonSecondSubtitleTextUz,
                  style: TextStyle(fontSize: 10),
                ),
              ),
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
              onTap: () async {
                if (await canLaunchUrl(Uri.parse('tel:+998940086601'))) {
                  await launchUrl(Uri.parse('tel:+998940086601'));
                } else {
                  throw 'Could not launch ${Uri.parse('tel:+998940086601')}';
                }
              },
            ),
            SpeedDialChild(
              child: ListTile(
                textColor: Colors.white,
                iconColor: Colors.white,
                leading: Icon(Icons.place_outlined),
                title: Text(language.isRussian ? mainButtonFirstText : mainButtonFirstSubtitleTextUz),
                subtitle: Text(
                  language.isRussian ? mainButtonFirstSubtitleText : mainButtonFirstSubtitleTextUz,
                  style: TextStyle(fontSize: 10),
                ),
              ),
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
              onTap: () {
                // get mapprovider
                final mapProvider = Provider.of<MapProvider>(context, listen: false);
                // change toggle value
                if (!mapProvider.isRun) {
                  mapProvider.addOne();
                }

                context.goNamed(
                  HomeScreen.routeName,
                  extra: mapProvider.isRun,
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
