import 'dart:io';

import 'package:flutter/material.dart';

class DriverLocationProvider with ChangeNotifier {
  double _latitude = 39.6548;
  double _longitude = 66.9597;

  bool _isLocationEnabled = true;

  double get latitude => _latitude;
  double get longitude => _longitude;

  bool get isLocationEnabled => _isLocationEnabled;

  void setLocationEnabled(bool enabled) {
    _isLocationEnabled = enabled;
    notifyListeners();
  }

  void setLatitude(double latitude, double longitude) {
    _latitude = latitude;
    _longitude = longitude;
    notifyListeners();
  }
}

class MainProvider with ChangeNotifier {
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController birthController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  File? imageFile;
  List<String> names = [
    'Рана',
    'Кровоточения',
    'Травмы и переломы',
    'Первая помощь: ожоги',
    'Опасные состояния',
    'Потерия сознания',
    'Отправления',
  ];
  String woundArticle = 'Кожная рана возникает в результате нарушения целостности эпидермального слоя. Любое повреждение ткани с нарушением анатомической целостности с функциональной потерей можно охарактеризовать как рану. Заживление ран в основном означает заживление кожи. Заживление ран начинается сразу после повреждения эпидермального слоя и может занять годы. Этот динамический процесс включает высокоорганизованные клеточные, гуморальные и молекулярные механизмы. Заживление ран имеет 3 перекрывающихся фазы: воспаление, пролиферацию и ремоделирование.  Любое нарушение приводит к аномальному заживлению раны';
  List<String> articles = [
    'При кровотеченияҳ',
    'При перломах',
    'При ожогах',
    'При обморожениях',
    'При обмороках',
    'При отравлениях',
    'Массаж сердца',
  ];

  List<String> uderjeniya = [
    'Телефоны скорой медицинской помощи',
    'Больницы и клиники',
    'Телефоны медицинских учреждений в районах',
  ];

  List<String> tumanlar = [
    "Kattaqo'rg'on ShTB",
    "Pastdarg'om TTB",
    "Ishtixon TTB",
    "JomboyTTB",
    "Bulung'ur TTB",
    "Nurobod TTB",
    "Payariq TTB",
    "Urgut TTB",
    "Qo'shrabod TTB",
    "Narpay TTB",
    "Oqdaryo TTB",
    "Kattaqo'rg'on TTB",
    "Paxtachi TTB",
    "Samarqand TTB ",
    "Tayloq TTB",
  ];
  List<String> raqamlar = [
    "(0366)-455-21-36",
    "(0366)-465-12-99",
    "(0366)-629-11-03",
    "(0366)-475-11-90",
    "(0366)-442-24-58",
    "(0366)-240-22-03",
    "(0366)-425-12-99",
    "(0366)-483-43-54",
    "(0366)-646-15-99",
    "(0366)-220-63-02",
    "(0366)-492-58-12",
    "(0366)-414-12-99",
    "(0366)-403-12-99",
    "(0366)-616-23-03",
    "(0366)-666-57-03",
  ];
  List<String> regions = [
    'Андижанская область',
    'Бухарская область',
    'Джизакская область',
    'Кашкадарьинская область',
    'Навоийская область',
    'Наманганская область',
    'Самаркандская область',
    'Сурхандарьинская область',
    'Сырдарьинская область',
    'Ташкентская область',
    'Ферганская область',
    'Хорезмская область',
  ];
  String? selectedValue;
}

class MainProviderUz with ChangeNotifier {
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController birthController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  File? imageFile;
  List<String> names = [
    'Yara',
    'Qon ketishi',
    'Jarohatlar va sinishlar',
    'Birinchi yordam: kuyishlar',
    'Xavfli davlatlar',
    'Hushni yo\'qotish',
    'Zaharlanish',
  ];
  String woundArticle = """Teri yarasi epidermis qatlamining yaxlitligini buzish natijasida paydo bo'ladi. Funktsional yo'qotish bilan anatomik yaxlitlikning buzilishi bilan har qanday to'qimalar shikastlanishi yara sifatida tavsiflanishi mumkin. Yarani davolash asosan terining davolanishini anglatadi. Yarani davolash epidermis qatlami shikastlangandan so'ng darhol boshlanadi va bir necha yil davom etishi mumkin. Ushbu dinamik jarayon yuqori darajada tashkil etilgan hujayra, gumoral va molekulyar mexanizmlarni o'z ichiga oladi. Yaraning bitishi bir-biriga o'xshash 3 bosqichdan iborat: yallig'lanish, ko'payish va qayta qurish. Har qanday buzilish yaraning g'ayritabiiy davolanishiga olib keladi'""";

  List<String> articles = [
    'Yaralanganda',
    'Qon ketganda',
    'Singanlar uchun',
    'При ожогах',
    'Kuyishlar uchun',
    'Hushidan ketish bilan',
    'Zaharlanish holatida',
  ];
  List<String> uderjeniya = [
    'Favqulodda telefonlar',
    'Kasalxonalar va klinikalar',
    'Hududlardagi tibbiyot muassasalarining telefon raqamlari',
  ];

  List<String> tumanlar = [
    "Kattaqo'rg'on ShTB",
    "Pastdarg'om TTB",
    "Ishtixon TTB",
    "JomboyTTB",
    "Bulung'ur TTB",
    "Nurobod TTB",
    "Payariq TTB",
    "Urgut TTB",
    "Qo'shrabod TTB",
    "Narpay TTB",
    "Oqdaryo TTB",
    "Kattaqo'rg'on TTB",
    "Paxtachi TTB",
    "Samarqand TTB ",
    "Tayloq TTB",
  ];
  List<String> raqamlar = [
    "(0366)-455-21-36",
    "(0366)-465-12-99",
    "(0366)-629-11-03",
    "(0366)-475-11-90",
    "(0366)-442-24-58",
    "(0366)-240-22-03",
    "(0366)-425-12-99",
    "(0366)-483-43-54",
    "(0366)-646-15-99",
    "(0366)-220-63-02",
    "(0366)-492-58-12",
    "(0366)-414-12-99",
    "(0366)-403-12-99",
    "(0366)-616-23-03",
    "(0366)-666-57-03",
  ];
  List<String> regions = [
    'Andijon viloyati',
    'Buxoro viloyati',
    'Jizzax viloyati',
    'Qashqadaryo viloyati',
    'Navoiy viloyati',
    'Namangan viloyati',
    'Samarqand viloyati',
    'Surxondaryo viloyati',
    'Sirdaryo viloyati',
    'Toshkent viloyati',
    'Farg\'ona viloyati',
    'Xorazm viloyati',
  ];
  String? selectedValue;
}

class MapProvider with ChangeNotifier {
  // create a private variable to store the value of the isRun
  bool _isRun = false;
  int number = -1;

  // create a getter to return the value of the isRun
  bool get isRun => _isRun;

  // create a setter to set the value of the isRun
  void addOne() {
    number++;
    _isRun = number == 0;
    if (isRun) {
      notifyListeners();
    }
  }

  void makeItZero() {
    number = -1;
    _isRun = number == 0;
  }
}
