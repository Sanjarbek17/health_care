import 'package:flutter/material.dart';

class MainProvider with ChangeNotifier {
  List<String> names = [
    'Рана',
    'Кровоточения',
    'Травмы и переломы',
    'Первая помощь: ожоги',
    'Опасные состояния',
    'Потерия сознания',
    'Отправления',
  ];
  String woundArticle =
      'Кожная рана возникает в результате нарушения целостности эпидермального слоя. Любое повреждение ткани с нарушением анатомической целостности с функциональной потерей можно охарактеризовать как рану. Заживление ран в основном означает заживление кожи. Заживление ран начинается сразу после повреждения эпидермального слоя и может занять годы. Этот динамический процесс включает высокоорганизованные клеточные, гуморальные и молекулярные механизмы. Заживление ран имеет 3 перекрывающихся фазы: воспаление, пролиферацию и ремоделирование.  Любое нарушение приводит к аномальному заживлению раны';
  List<String> articles = [
    'При кровотеченияҳ',
    'При перломах',
    'При ожогах',
    'При обморожениях',
    'При обмороках',
    'При отравлениях',
    'Массаж сердца',
  ];
}
