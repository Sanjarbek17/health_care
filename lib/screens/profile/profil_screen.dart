// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_print, must_be_immutable

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:go_router/go_router.dart';
import 'package:health_care/screens/catalog/catalog_screen.dart';
import 'package:health_care/screens/map_screen.dart';
import 'package:health_care/screens/profile/editing_profile.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker_android/image_picker_android.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import '../../providers/main_provider.dart';
import '../../style/my_flutter_app_icons.dart';
import '../constants.dart';
import '../info/info_screen.dart';

class ProfilScreen extends StatefulWidget {
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
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        title: const Text(
          'Информация о пользователе',
          style: TextStyle(
            fontFamily: 'Material Icons',
            fontSize: 23,
            fontWeight: FontWeight.w500,
          ),
        ),
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
              title: Text(Provider.of<MainProvider>(context, listen: false).selectedValue ?? 'No region selected'),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(left: 15, right: 15),
          //   child: DropdownButton2(
          //     isExpanded: true,
          //     hint: Text(
          //       'Выберите регион',
          //       style: TextStyle(
          //         // fontSize: 14,
          //         color: Theme.of(context).hintColor,
          //       ),
          //     ),
          //     items: items
          //         .map(
          //           (item) => DropdownMenuItem<String>(
          //             value: item,
          //             child: Text(
          //               item,
          //               style: const TextStyle(
          //                 fontSize: 14,
          //               ),
          //             ),
          //           ),
          //         )
          //         .toList(),
          //     value: Provider.of<MainProvider>(context, listen: false).selectedValue,
          //     onChanged: (value) {
          //       setState(() {
          //         Provider.of<MainProvider>(context, listen: false).selectedValue = value as String;
          //       });
          //     },
          //     buttonStyleData: const ButtonStyleData(
          //       height: 50,
          //       // width: 10,
          //     ),
          //     menuItemStyleData: const MenuItemStyleData(
          //       height: 50,
          //     ),
          //   ),
          // ),
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
              child: Text('Изменить профиль'),
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
          childrenButtonSize: Size(width * 0.9, 70),
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
              child: const ListTile(
                textColor: Colors.white,
                iconColor: Colors.white,
                leading: Icon(Icons.sms),
                title: Text(mainButtonThirdText),
                subtitle: Text(mainButtonThirdSubtitleText, style: TextStyle(fontSize: 10)),
              ),
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
              onTap: () async {
                if (await canLaunchUrl(smsNumber)) {
                  await launchUrl(smsNumber);
                } else {
                  throw 'Could not launch $smsNumber';
                }
              },
            ),
            SpeedDialChild(
              child: const ListTile(
                textColor: Colors.white,
                iconColor: Colors.white,
                leading: Icon(Icons.phone_iphone_rounded),
                title: Text(mainButtonSecondText),
                subtitle: Text(
                  mainButtonSecondSubtitleText,
                  style: TextStyle(fontSize: 10),
                ),
              ),
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
              onTap: () async {
                if (await canLaunchUrl(Uri.parse('tel:+998940086601'))) {
                  await launchUrl(Uri.parse('tel:+998940086601'));
                } else {
                  throw 'Could not launch ${Uri.parse('tel:+998940086601')}';
                }
              },
            ),
            SpeedDialChild(
              child: const ListTile(
                textColor: Colors.white,
                iconColor: Colors.white,
                leading: Icon(Icons.place_outlined),
                title: Text(mainButtonFirstText),
                subtitle: Text(mainButtonFirstSubtitleText, style: TextStyle(fontSize: 10)),
              ),
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
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
