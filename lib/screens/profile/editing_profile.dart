// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:health_care/screens/profile/profil_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_android/image_picker_android.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../providers/main_provider.dart';
import '../../style/constant.dart';

class EditingProfile extends StatefulWidget {
  File? image;
  EditingProfile({super.key, this.image});
  static const routeName = 'edit';

  @override
  State<EditingProfile> createState() => _EditingProfileState();
}

class _EditingProfileState extends State<EditingProfile> {
  bool _switched = false;

  final phoneNumber = Uri.parse('tel:103');
  final smsNumber = Uri.parse('sms:103');

  File? _image;

  Future<bool> _getImage(ImageSource source) async {
    bool isPicked = false;
    Map<Permission, PermissionStatus> status = await [
      Permission.storage,
    ].request();
    if (!status[Permission.storage]!.isDenied) {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: source);

      if (pickedFile != null) {
        final directory = await getApplicationDocumentsDirectory();
        final name = basename(pickedFile.path);
        final image = File('${directory.path}/$name');
        final savedFile = await image.writeAsBytes(await pickedFile.readAsBytes());

        setState(() {
          _image = savedFile;
          isPicked = true;
        });
      }
    } else {
      Permission.storage.request();
    }
    return isPicked;
  }

  @override
  Widget build(BuildContext context) {
    final ImagePickerPlatform imagePickerImplementation = ImagePickerPlatform.instance;
    if (imagePickerImplementation is ImagePickerAndroid) {
      imagePickerImplementation.useAndroidPhotoPicker = true;
    }
    final items = Provider.of<MainProvider>(context).regions;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Изменить профиль',
          style: TextStyle(
            fontFamily: 'Material Icons',
            fontSize: 23,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: InkWell(
                  hoverColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Column(
                            children: [
                              TextButton(
                                onPressed: () {
                                  _getImage(ImageSource.camera).then((value) => value ? Navigator.of(context).pop() : null);
                                },
                                child: const Text(
                                  'Take photo',
                                  style: dialogStyle,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  _getImage(ImageSource.gallery).then((value) => value ? Navigator.of(context).pop() : null);
                                },
                                child: const Text(
                                  'Choose from library',
                                  style: dialogStyle,
                                ),
                              ),
                              _image != null || widget.image != null
                                  ? TextButton(
                                      onPressed: () {
                                        setState(() {
                                          if (widget.image != null) {
                                            widget.image = null;
                                          } else {
                                            _image = null;
                                          }
                                        });
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text(
                                        'Remove photo',
                                        style: dialogStyle,
                                      ),
                                    )
                                  : TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text(
                                        'Cencel',
                                        style: dialogStyle,
                                      ),
                                    ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: _image != null
                      ? CircleAvatar(
                          radius: 35,
                          backgroundImage: FileImage(_image!),
                          // child: Image.file(_image!),
                        )
                      : widget.image != null
                          ? CircleAvatar(
                              radius: 35,
                              backgroundImage: FileImage(widget.image!),
                              // child: Image.file(_image!),
                            )
                          : const CircleAvatar(
                              radius: 35,
                              backgroundColor: Color(0xFFAFB1A0),
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                              ),
                            ),
                  // CircleAvatar(
                  //   backgroundImage: ,
                  //   backgroundColor: Color(0xFFAFB1A0),
                  //   radius: 35,
                  // ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18, right: 18, top: 10),
            child: TextField(
              controller: Provider.of<MainProvider>(context, listen: false).nameController,
              decoration: const InputDecoration(
                labelText: 'Имя',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18, right: 18, top: 10),
            child: TextField(
              controller: Provider.of<MainProvider>(context, listen: false).surnameController,
              decoration: const InputDecoration(
                labelText: 'Отчество',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18, right: 18, top: 10),
            child: TextField(
              controller: Provider.of<MainProvider>(context, listen: false).birthController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Год рождения',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18, right: 18, top: 10),
            child: TextField(
              controller: Provider.of<MainProvider>(context, listen: false).numberController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Номер телефона',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Сотрудник 103',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[800],
                  ),
                ),
                Switch.adaptive(
                  value: _switched,
                  onChanged: (value) {
                    setState(() {
                      _switched = value;
                    });
                  },
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: DropdownButton2(
              isExpanded: true,
              hint: Text(
                'Выберите регион',
                style: TextStyle(
                  // fontSize: 14,
                  color: Theme.of(context).hintColor,
                ),
              ),
              items: items
                  .map(
                    (item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                  )
                  .toList(),
              value: Provider.of<MainProvider>(context, listen: false).selectedValue,
              onChanged: (value) {
                setState(() {
                  Provider.of<MainProvider>(context, listen: false).selectedValue = value as String;
                });
              },
              buttonStyleData: const ButtonStyleData(
                height: 50,
                // width: 10,
              ),
              menuItemStyleData: const MenuItemStyleData(
                height: 50,
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
                context.goNamed(ProfilScreen.routeName, extra: _image);
              },
              child: const Text('Сохранить изменения'),
            ),
          ),
        ],
      ),
    );
  }
}
