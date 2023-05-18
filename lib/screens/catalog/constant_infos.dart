import 'package:flutter/foundation.dart';

class InfoProvider with ChangeNotifier {
  String catalogAppBarTitle = 'Справочник';
  List<String> aricleInfos = [
    """Рана - это повреждение тканей, которое может быть вызвано различными факторами, такими как травма, операция, ожог, резкая температура и другие воздействия на организм. Рана может иметь различный характер, например, быть поверхностной или глубокой, открытой или закрытой.

Для того чтобы правильно ухаживать за раной и быстрее ее заживить, необходимо соблюдать некоторые правила:

Необходимо дезинфицировать рану, используя антисептические средства, такие как перекись водорода или йод.

Рану необходимо закрыть бинтом или специальным пластырем, чтобы предотвратить заражение.

Необходимо регулярно менять повязку и обрабатывать рану.

Важно следить за состоянием раны и обратиться за медицинской помощью, если заметны признаки инфекции, например, покраснение, опухоль, выделение гноя.

Если рана слишком глубокая или большая, то может потребоваться хирургическое вмешательство.

Раны можно разделить на несколько типов в зависимости от их характеристик, например:

Разрезы (порезы) - это раны, образованные при помощи острого предмета, например, ножа.

Ушибы - это повреждение тканей, вызванное сильным ударом.

Ссадины - это поверхностные раны, образованные при трении кожи о твердую поверхность.

Ожоги - это повреждение тканей, вызванное высокой температурой.

Химические ожоги - это повреждение тканей, вызванное воздействием химических веществ.

При любых ранениях важно следовать правилам гигиены, дезинфицировать рану и получить необходимую медицинскую помощь.""",
    """
Когда мы говорим о смешивании или блендинге, мы обычно имеем в виду процесс смешивания двух или более веществ или материалов для создания нового продукта или материала с желаемыми свойствами.

В контексте питания, смешивание различных ингредиентов может использоваться для создания новых вкусов или текстур в блюдах и напитках. Например, блендер может использоваться для смешивания фруктов и овощей для приготовления смузи или коктейлей.

В производстве, смешивание может использоваться для создания новых материалов с желаемыми свойствами, таких как прочность, гибкость или цвет. Например, смешивание различных типов пластиков может привести к созданию нового материала, который сочетает в себе лучшие свойства каждого из них.

Существуют различные методы смешивания, включая механическое перемешивание, смешивание под давлением, перемешивание с помощью вихрей и другие. Выбор метода зависит от типа материалов, которые необходимо смешать, а также от желаемых свойств конечного продукта.
""",
    """Травма или повреждение - это физическое повреждение тканей организма, которое может быть вызвано различными причинами, такими как несчастный случай, спортивные травмы, аварии и другие.

Существует множество различных типов травм и повреждений, включая раны, ушибы, вывихи, переломы, растяжения и другие. Симптомы травм могут варьироваться в зависимости от типа травмы и серьезности повреждения, но могут включать боли, отек, кровотечения, синяки и нарушения функций органов.

Лечение травм может включать в себя различные методы, в зависимости от типа и серьезности травмы. Это может включать обезболивающие препараты, физическую терапию, хирургические вмешательства и другие методы.

В некоторых случаях может потребоваться срочная медицинская помощь, особенно если травма является серьезной или жизнеугрожающей.
""",
    """Ожог - это повреждение кожи или других тканей организма, которое вызывается непосредственным контактом с горячими жидкостями, паром, огнем, солнечными лучами или другими источниками тепла.

Существует несколько классификаций ожогов, включая классификацию по глубине поражения кожи. Поверхностные ожоги, также известные как 1-ой степени, обычно вызывают покраснение и отек кожи, а также некоторое жжение или боль. Более серьезные ожоги могут вызывать образование пузырей и открытых ран, а также более интенсивную боль.

Лечение ожогов может включать охлаждение пораженной области, применение антибиотиков и обезболивающих препаратов, а также хирургическое вмешательство, если это необходимо. При лечении ожогов также может использоваться специальное покрытие, которое помогает защитить пораженную область и ускорить ее заживление.

При лечении ожогов важно соблюдать правила гигиены и предотвращать возможные осложнения, такие как инфекции и шок. В случае серьезных или жизнеугрожающих ожогов, необходима немедленная медицинская помощь""",
    """Опасные условия - это ситуации, которые могут представлять угрозу для жизни и здоровья человека. Они могут быть вызваны различными причинами, такими как природные катастрофы, техногенные катастрофы, инфекции, террористические акты и другие.

Некоторые из опасных условий, которые могут представлять угрозу для жизни и здоровья, включают наводнения, землетрясения, тайфуны, пожары, выбросы химических веществ, эпидемии и пандемии инфекционных болезней, террористические акты и другие.

В случае опасных условий важно соблюдать рекомендации и инструкции, которые могут помочь минимизировать риск для здоровья и безопасности. Это может включать эвакуацию, поиск укрытия, использование защитного оборудования и другие меры безопасности.

В случае опасных условий, особенно если они являются серьезными или жизнеугрожающими, важно получить немедленную медицинскую помощь или вызвать экстренные службы.""",
    """Обморок - это временная потеря сознания и контроля над мышечными функциями, которая может быть вызвана различными факторами, такими как низкое кровяное давление, недостаток кислорода, стресс, недостаток питания, а также другие факторы.

Симптомы обморока могут включать потерю сознания, бледность, потливость, головокружение, чувство тошноты, затруднение дыхания и другие. Обычно обморок не представляет серьезной угрозы для здоровья, но может быть признаком более серьезного заболевания, особенно если он происходит регулярно.

Для предотвращения обморока важно соблюдать здоровый образ жизни, в том числе правильное питание, регулярную физическую активность и достаточный отдых. Также рекомендуется избегать стрессовых ситуаций и перегревания.

Если обморок произошел, важно положить человека на плоскую поверхность, поднять ему ноги, чтобы улучшить кровообращение в мозге, и обеспечить свежий воздух. В случае длительного обморока или других серьезных симптомов, таких как сильная боль в груди или затруднение дыхания, необходимо немедленно обратиться за медицинской помощью.""",
    """Отравление - это состояние, которое возникает при употреблении или контакте с токсичными веществами, которые могут нанести вред здоровью человека. Отравление может быть вызвано различными веществами, такими как химические вещества, лекарства, яды растительного и животного происхождения, алкоголь и другие.

Симптомы отравления могут включать тошноту, рвоту, головную боль, головокружение, озноб, повышенную температуру тела, изменение цвета кожи и другие. В некоторых случаях отравление может быть жизнеугрожающим и требовать немедленной медицинской помощи.

Для предотвращения отравления важно соблюдать правила безопасности при использовании химических веществ, лекарств, алкоголя и других веществ. Не следует употреблять продукты, которые имеют неизвестное происхождение или подозрительный вкус или запах.

В случае отравления необходимо немедленно вызвать экстренную медицинскую помощь и обеспечить первую помощь, такую как промывание желудка и введение противоядия, если оно необходимо. Не следует пытаться лечить отравление самостоятельно, так как это может нанести еще больший вред здоровью.""",
    """Кардиопульмональная реанимация (КПР) - это комплекс мероприятий, направленных на поддержание жизни и восстановление сердечно-сосудистой и дыхательной функций при остановке сердца и дыхания. КПР может быть необходима в случае сердечной недостаточности, инфаркта миокарда, удушья, утопления и других состояний, когда нарушается кровообращение и поступление кислорода к органам и тканям.

Основными методами КПР являются искусственная вентиляция легких (ИВЛ) и непрямой массаж сердца (НМС). При проведении КПР важно правильно определить наличие сознания и дыхания у пострадавшего, провести сердечно-легочную реанимацию и вызвать экстренную медицинскую помощь.

При ИВЛ необходимо очистить верхние дыхательные пути от возможных препятствий, наклонить голову пострадавшего назад и выполнить вдох воздуха через рот. При НМС необходимо положить пострадавшего на твердую поверхность и выполнить ритмические нажатия на грудную клетку, чтобы обеспечить кровообращение.

КПР является очень важной процедурой в случае остановки сердца и дыхания, и может спасти жизнь пострадавшего. Однако, проведение КПР требует определенных знаний и навыков, поэтому рекомендуется пройти специальный курс обучения КПР для правильного проведения этой процедуры.""",
  ];
}

class InfoProviderUz with ChangeNotifier {
  String catalogAppBarTitle = 'Katalog';
  List<String> aricleInfos = [
    """Yara - shikastlanish, jarrohlik, kuyishlar, haddan tashqari harorat va tanaga boshqa ta'sirlar kabi turli omillar tufayli yuzaga kelishi mumkin bo'lgan to'qimalarning shikastlanishi. Yara boshqa xarakterga ega bo'lishi mumkin, masalan, yuzaki yoki chuqur, ochiq yoki yopiq bo'lishi mumkin.

Yarani to'g'ri parvarish qilish va uni tezroq davolash uchun siz ba'zi qoidalarga amal qilishingiz kerak:

Vodorod periks yoki yod kabi antiseptiklar yordamida yarani dezinfeksiya qilish kerak.

INFEKTSION oldini olish uchun yara bandaj yoki maxsus gips bilan qoplangan bo'lishi kerak.

Muntazam ravishda bandajni o'zgartirish va jarohatni davolash kerak.

Qizarish, shishish yoki yiringlash kabi infektsiya belgilari mavjud bo'lsa, yaraning holatini kuzatish va shifokorga murojaat qilish muhimdir.

Agar yara juda chuqur yoki katta bo'lsa, jarrohlik talab qilinishi mumkin.

Yaralarni xususiyatlariga ko'ra bir necha turlarga bo'lish mumkin, masalan:

Kesish (kesish) - pichoq kabi o'tkir narsa bilan hosil qilingan yaralar.

Ko'karishlar - kuchli zarba natijasida kelib chiqqan to'qimalarning shikastlanishi.

Abraziyalar terini qattiq yuzaga ishqalash natijasida hosil bo'lgan yuzaki yaralardir.

Kuyishlar - yuqori harorat ta'sirida to'qimalarning shikastlanishi.

Kimyoviy kuyish - bu kimyoviy moddalar ta'sirida to'qimalarning shikastlanishi.

Har qanday shikastlanish uchun gigiena qoidalariga rioya qilish, yarani dezinfeksiya qilish va kerakli tibbiy yordam olish muhimdir.""",
    """Aralashtirish yoki aralashtirish haqida gapirganda, biz odatda kerakli xususiyatlarga ega yangi mahsulot yoki materialni yaratish uchun ikki yoki undan ortiq moddalar yoki materiallarni aralashtirish jarayonini nazarda tutamiz.

Oziqlanish kontekstida turli ingredientlarni aralashtirish oziq-ovqat va ichimliklarda yangi lazzatlar yoki to'qimalarni yaratish uchun ishlatilishi mumkin. Misol uchun, blender meva va sabzavotlarni smetana yoki kokteyl tayyorlash uchun aralashtirish uchun ishlatilishi mumkin.

Ishlab chiqarishda aralashtirish kuch, moslashuvchanlik yoki rang kabi kerakli xususiyatlarga ega yangi materiallarni yaratish uchun ishlatilishi mumkin. Misol uchun, har xil turdagi plastmassalarni aralashtirish natijasida har birining eng yaxshi xususiyatlarini birlashtirgan yangi material paydo bo'lishi mumkin.

Mexanik aralashtirish, bosimli aralashtirish, vorteks aralashtirish va boshqalarni o'z ichiga olgan turli xil aralashtirish usullari mavjud. Usulni tanlash aralashtirilgan materiallarning turiga, shuningdek, yakuniy mahsulotning kerakli xususiyatlariga bog'liq.""",
    """Jarohat yoki shikastlanish - bu turli sabablarga ko'ra yuzaga kelishi mumkin bo'lgan tana to'qimalariga jismoniy shikastlanish, masalan, baxtsiz hodisa, sport jarohati, baxtsiz hodisalar va boshqalar.

Yaralar, ko'karishlar, dislokatsiyalar, sinishlar, burmalar va boshqalarni o'z ichiga olgan turli xil jarohatlar va jarohatlar mavjud. Shikastlanish belgilari shikastlanish turiga va shikastlanishning og'irligiga qarab farq qilishi mumkin, ammo og'riq, shishish, qon ketish, ko'karishlar va organlarning disfunktsiyasini o'z ichiga olishi mumkin.

Shikastlanishni davolash jarohatning turi va og'irligiga qarab turli usullarni o'z ichiga olishi mumkin. Bu og'riq qoldiruvchi vositalar, fizika terapiyasi, jarrohlik va boshqa usullarni o'z ichiga olishi mumkin.

Ba'zi hollarda, ayniqsa jarohat jiddiy yoki hayot uchun xavfli bo'lsa, shoshilinch tibbiy yordam talab qilinishi mumkin.""",
    """Kuyish - terining yoki tananing boshqa to'qimalarining issiq suyuqliklar, bug ', olov, quyosh nuri yoki boshqa issiqlik manbalari bilan bevosita aloqa qilish natijasida yuzaga keladigan shikastlanishi.

Kuyishning bir nechta tasnifi mavjud, ular orasida terining shikastlanishi chuqurligi bo'yicha tasniflash mavjud. Yuzaki kuyishlar, 1-darajali kuyishlar deb ham ataladi, odatda terining qizarishi va shishishi, shuningdek, biroz yonish yoki og'riq paydo bo'lishiga olib keladi. Kuchliroq kuyishlar qabariq va ochiq yaralarga, shuningdek, kuchli og'riqlarga olib kelishi mumkin.

Kuyishni davolash zararlangan hududni sovutish, antibiotiklar va og'riq qoldiruvchi vositalarni, agar kerak bo'lsa, jarrohlik amaliyotini o'z ichiga olishi mumkin. Kuyishni davolashda zararlangan hududni himoya qilish va shifo jarayonini tezlashtirish uchun maxsus qoplama ham qo'llanilishi mumkin.

Kuyishni davolashda gigiena qoidalariga rioya qilish va infektsiyalar va shok kabi mumkin bo'lgan asoratlarni oldini olish kerak. Jiddiy yoki hayot uchun xavfli kuyishlar bo'lsa, darhol tibbiy yordamga murojaat qiling""",
    """Xavfli sharoitlar - bu inson hayoti va sog'lig'iga tahdid solishi mumkin bo'lgan holatlar. Ular turli sabablarga ko'ra yuzaga kelishi mumkin, masalan, tabiiy ofatlar, texnogen ofatlar, infektsiyalar, terroristik hujumlar va boshqalar.

Hayot va sog'liq uchun xavf tug'dirishi mumkin bo'lgan xavfli sharoitlar qatoriga toshqinlar, zilzilalar, tayfunlar, yong'inlar, kimyoviy moddalarning tarqalishi, yuqumli kasalliklar epidemiyasi va pandemiyasi, terroristik hujumlar va boshqalar kiradi.

Xavfli sharoitlar yuzaga kelganda, sog'liq va xavfsizlik xavfini kamaytirishga yordam beradigan tavsiyalar va ko'rsatmalarga rioya qilish muhimdir. Bunga evakuatsiya qilish, boshpana topish, himoya vositalaridan foydalanish va boshqa xavfsizlik choralari kiradi.

Xavfli sharoitlarda, ayniqsa ular jiddiy yoki hayot uchun xavfli bo'lsa, darhol tibbiy yordam olish yoki tez yordam chaqirish muhimdir.""",
    """Hushdan ketish - bu vaqtinchalik ongni yo'qotish va mushaklarning funktsiyalarini nazorat qilish, bu turli omillar, masalan, past qon bosimi, kislorod etishmasligi, stress, ovqatlanishning etishmasligi va boshqa omillar tufayli yuzaga kelishi mumkin.

Hushdan ketish belgilari ongni yo'qotish, rangparlik, terlash, bosh aylanishi, ko'ngil aynishi, nafas olish qiyinlishuvi va boshqalarni o'z ichiga olishi mumkin. Odatda, hushidan ketish salomatlik uchun jiddiy tahdid emas, lekin u jiddiyroq kasallik belgisi bo'lishi mumkin, ayniqsa, bu muntazam ravishda sodir bo'lsa.

Hushidan ketishning oldini olish uchun sog'lom turmush tarzini saqlash, jumladan, to'g'ri ovqatlanish, muntazam jismoniy faollik va etarli dam olish muhimdir. Bundan tashqari, stressli vaziyatlardan va qizib ketishdan qochish tavsiya etiladi.

Agar hushidan ketish sodir bo'lsa, odamni tekis yuzaga yotqizish, miyaga qon aylanishini yaxshilash uchun oyoqlarini ko'tarish va toza havo bilan ta'minlash muhimdir. Uzoq vaqt davomida hushidan ketish yoki boshqa jiddiy alomatlar, masalan, kuchli ko'krak og'rig'i yoki nafas olish qiyinlishuvi bo'lsa, darhol shifokorga murojaat qiling.""",
    """ Zaharlanish - inson salomatligiga zarar etkazuvchi zaharli moddalardan foydalanganda yoki ular bilan aloqa qilganda yuzaga keladigan holat. Zaharlanish turli xil moddalar, masalan, kimyoviy moddalar, dori vositalari, o'simlik va hayvonot manbalari zaharlari, spirtli ichimliklar va boshqalar bilan sodir bo'lishi mumkin. .

Zaharlanish belgilari orasida ko'ngil aynishi, qusish, bosh og'rig'i, bosh aylanishi, titroq, isitma, terining rangi o'zgarishi va boshqalar bo'lishi mumkin. Ba'zi hollarda zaharlanish hayot uchun xavfli bo'lishi mumkin va darhol tibbiy yordam talab qiladi.

Zaharlanishning oldini olish uchun kimyoviy moddalar, giyohvand moddalar, spirtli ichimliklar va boshqa moddalardan foydalanishda xavfsizlik qoidalariga rioya qilish muhimdir. Kelib chiqishi noma'lum yoki shubhali ta'mi yoki hidi bo'lgan ovqatlarni iste'mol qilmaslik kerak.

Zaharlanish holatida shoshilinch tibbiy yordamni darhol chaqirish va birinchi yordam ko'rsatish kerak, masalan, oshqozonni yuvish va kerak bo'lganda antivenomni yuborish. Zaharlanishni o'zingiz davolashga urinmasligingiz kerak, chunki bu sog'likka yanada ko'proq zarar etkazishi mumkin.""",
    """Kardiopulmoner reanimatsiya (CPR) - yurak va nafas olish to'xtatilganda hayotni saqlab qolish va yurak-qon tomir va nafas olish funktsiyalarini tiklashga qaratilgan chora-tadbirlar majmui. CRP yurak etishmovchiligi, miyokard infarkti, bo'g'ilish, cho'kish va qon aylanishi va organlar va to'qimalarni kislorod bilan ta'minlashning boshqa holatlarida zarur bo'lishi mumkin.

CPRning asosiy usullari o'pkaning sun'iy ventilyatsiyasi (ALV) va bilvosita yurak massaji (NMS). CRCni o'tkazishda jabrlanuvchida ong va nafas olish mavjudligini to'g'ri aniqlash, kardiopulmoner reanimatsiya qilish va shoshilinch tibbiy yordamni chaqirish muhimdir.

Mexanik ventilyatsiya paytida yuqori nafas yo'llarini mumkin bo'lgan to'siqlardan tozalash, jabrlanuvchining boshini orqaga burish va og'iz orqali havoni yutish kerak. NMS bilan qurbonni qattiq yuzaga yotqizish va qon aylanishini ta'minlash uchun ko'krak qafasining ritmik siqilishlarini bajarish kerak.

CPR yurak tutilishi va nafas olish holatlarida juda muhim protsedura bo'lib, jabrlanuvchining hayotini saqlab qolishi mumkin. Biroq, CRCni amalga oshirish ma'lum bilim va ko'nikmalarni talab qiladi, shuning uchun ushbu protsedurani to'g'ri amalga oshirish uchun maxsus CRC o'quv kursidan o'tish tavsiya etiladi.""",
  ];
}
