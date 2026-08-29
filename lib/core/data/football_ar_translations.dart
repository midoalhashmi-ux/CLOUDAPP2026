/// قاموس ترجمة أسماء الدوريات والفرق الإنجليزية (كما ترد من مصدر البيانات)
/// إلى العربية. أي اسم غير موجود هنا يُعرض كما ورد من المصدر (إنجليزي)
/// بدل ما يختفي أو يظهر فارغاً.
///
/// ملاحظة: هذا القاموس محلي (يُشحن مع التطبيق). لاحقاً يمكن تحويله لقراءة
/// إضافات من Firestore (settings/football_translations) بنفس أسلوب باقي
/// الإعدادات، حتى تضيف/تعدّل ترجمات من لوحة التحكم بدون تحديث التطبيق —
/// [FootballTranslations.applyRemoteOverrides] جاهزة لهذا الغرض.
class FootballTranslations {
  FootballTranslations._();

  static final Map<String, String> _leagues = {
    'Saudi Professional League': 'الدوري السعودي للمحترفين',
    'Saudi Pro League': 'الدوري السعودي للمحترفين',
    'Saudi King Cup': 'كأس الملك السعودي',
    'Egyptian Premier League': 'الدوري المصري الممتاز',
    'UAE Arabian Gulf League': 'دوري الخليج العربي الإماراتي',
    'UAE Pro League': 'دوري المحترفين الإماراتي',
    'Qatar Stars League': 'دوري نجوم قطر',
    'Iraqi Premier League': 'الدوري العراقي الممتاز',
    'Kuwaiti Premier League': 'الدوري الكويتي الممتاز',
    'Moroccan Botola Pro': 'البطولة المغربية المحترفة',
    'Tunisian Ligue 1': 'الرابطة التونسية المحترفة الأولى',
    'Algerian Ligue Professionnelle 1': 'الرابطة الجزائرية المحترفة الأولى',
    'CAF Champions League': 'دوري أبطال أفريقيا',
    'AFC Champions League': 'دوري أبطال آسيا',
    'AFC Champions League Elite': 'دوري أبطال آسيا للنخبة',
    'English Premier League': 'الدوري الإنجليزي الممتاز',
    'Spanish La Liga': 'الدوري الإسباني',
    'Italian Serie A': 'الدوري الإيطالي',
    'German Bundesliga': 'الدوري الألماني',
    'French Ligue 1': 'الدوري الفرنسي',
    'UEFA Champions League': 'دوري أبطال أوروبا',
    'UEFA Europa League': 'الدوري الأوروبي',
    'UEFA Europa Conference League': 'دوري المؤتمر الأوروبي',
    'FIFA World Cup': 'كأس العالم',
    'FIFA Club World Cup': 'كأس العالم للأندية',
    'World Cup Qualification CAF': 'تصفيات كأس العالم الأفريقية',
    'World Cup Qualification AFC': 'تصفيات كأس العالم الآسيوية',
    'Africa Cup of Nations': 'كأس الأمم الأفريقية',
    'AFC Asian Cup': 'كأس آسيا',

    // أسماء API-Football القصيرة (بدون بادئة اسم الدولة) — API-Football
    // يرجع "Premier League" وليس "English Premier League" مثلاً، فبدون
    // هذه الأسطر كانت أشهر 5 دوريات أوروبية تُستبعد بالكامل من شاشة
    // النتائج لعدم تطابق النص حرفياً مع القاموس القديم (المبني على
    // تسمية TheSportsDB السابقة).
    'Premier League': 'الدوري الإنجليزي الممتاز',
    'La Liga': 'الدوري الإسباني',
    'Serie A': 'الدوري الإيطالي',
    'Bundesliga': 'الدوري الألماني',
    'Ligue 1': 'الدوري الفرنسي',
    'World Cup': 'كأس العالم',
    'World Cup - Qualification Africa': 'تصفيات كأس العالم الأفريقية',
    'World Cup - Qualification Asia': 'تصفيات كأس العالم الآسيوية',
    'Club World Cup': 'كأس العالم للأندية',
    'CAF Confederation Cup': 'كأس الكونفدرالية الأفريقية',

    // ملاحظة: عمداً ما أضفنا كؤوس محلية (FA Cup, Copa Del Rey, Coppa
    // Italia, DFB Pokal, Coupe de France, English League Cup) ولا دوريات
    // أخرى (هولندي/برتغالي/تركي/أرجنتيني/برازيلي/أمريكي...) ولا كأس أمم
    // أوروبا (Nations League) ولا الأولمبياد — لأن هذي كانت تُدخل فرق
    // درجة ثانية/ثالثة غير مطلوبة، حسب طلب حصر النتائج على الدرجة الأولى
    // من الدوريات الخمس الكبرى + الدوريات العربية والأفريقية فقط.
  };

  /// الدوريات المدعومة فقط (عربية + عالمية معروفة) — أي دوري غير موجود هنا
  /// يُستبعد بالكامل من شاشة النتائج بدل عرضه بالإنجليزية، لأن غالب الدوريات
  /// الصغيرة/المحلية غير المعروفة عالمياً (دوريات درجة ثانية وثالثة مثلاً)
  /// ليست ضمن اهتمام المستخدم أصلاً.
  static bool isSupportedLeague(String en) => _leagues.containsKey(en.trim());

  static final Map<String, String> _teams = {
    // السعودية
    'Al Hilal': 'الهلال', 'Al-Hilal': 'الهلال',
    'Al Nassr': 'النصر', 'Al-Nassr': 'النصر',
    'Al Ittihad': 'الاتحاد', 'Al-Ittihad': 'الاتحاد',
    'Al Ahli': 'الأهلي', 'Al-Ahli': 'الأهلي',
    'Al Shabab': 'الشباب', 'Al-Shabab': 'الشباب',
    'Al Taawoun': 'التعاون', 'Al-Taawoun': 'التعاون',
    'Al Fateh': 'الفتح', 'Al-Fateh': 'الفتح',
    'Al Ettifaq': 'الاتفاق', 'Al-Ettifaq': 'الاتفاق',
    'Al Fayha': 'الفيحاء', 'Al-Fayha': 'الفيحاء',
    'Damac': 'ضمك',
    'Al Riyadh': 'الرياض', 'Al-Riyadh': 'الرياض',
    'Al Khaleej': 'الخليج', 'Al-Khaleej': 'الخليج',
    'Al Okhdood': 'الأخدود',
    'Al Wehda': 'الوحدة', 'Al-Wehda': 'الوحدة',
    'Al Raed': 'الرائد', 'Al-Raed': 'الرائد',
    'Al Qadsiah': 'القادسية', 'Al-Qadsiah': 'القادسية',
    // منتخبات
    'Saudi Arabia': 'السعودية',
    'Egypt': 'مصر',
    'Morocco': 'المغرب',
    'Tunisia': 'تونس',
    'Algeria': 'الجزائر',
    'Qatar': 'قطر',
    'United Arab Emirates': 'الإمارات',
    'Iraq': 'العراق',
    'Jordan': 'الأردن',
    'Kuwait': 'الكويت',
    'Bahrain': 'البحرين',
    'Oman': 'عمان',
    'Lebanon': 'لبنان',
    'Palestine': 'فلسطين',
    'Syria': 'سوريا',
    'Brazil': 'البرازيل',
    'Argentina': 'الأرجنتين',
    'France': 'فرنسا',
    'Germany': 'ألمانيا',
    'Spain': 'إسبانيا',
    'England': 'إنجلترا',
    'Italy': 'إيطاليا',
    'Portugal': 'البرتغال',
    'Netherlands': 'هولندا',
    'Belgium': 'بلجيكا',
    'Croatia': 'كرواتيا',
    'Uruguay': 'الأوروغواي',
    // أندية عالمية كبرى
    'Real Madrid': 'ريال مدريد',
    'Barcelona': 'برشلونة',
    'Atletico Madrid': 'أتلتيكو مدريد',
    'Manchester United': 'مانشستر يونايتد',
    'Manchester City': 'مانشستر سيتي',
    'Liverpool': 'ليفربول',
    'Chelsea': 'تشيلسي',
    'Arsenal': 'آرسنال',
    'Tottenham': 'توتنهام',
    'Tottenham Hotspur': 'توتنهام',
    'Bayern Munich': 'بايرن ميونخ',
    'Borussia Dortmund': 'بوروسيا دورتموند',
    'Paris Saint-Germain': 'باريس سان جيرمان',
    'Juventus': 'يوفنتوس',
    'AC Milan': 'ميلان',
    'Inter Milan': 'إنتر ميلان',
    'Napoli': 'نابولي',
    'AS Roma': 'روما',
    // أرجنتين
    'River Plate': 'ريفر بليت',
    'Boca Juniors': 'بوكا جونيورز',
    'Racing Club': 'راسينغ كلوب',
    'Independiente': 'إندبندينتي',
    'San Lorenzo': 'سان لورينزو',
    // البرازيل
    'Flamengo': 'فلامنغو',
    'Palmeiras': 'بالميراس',
    'Corinthians': 'كورينثيانز',
    'Sao Paulo': 'ساو باولو',
    'Fluminense': 'فلومينينسي',
    // أمريكا (MLS)
    'LA Galaxy': 'إل إيه غالاكسي',
    'Inter Miami': 'إنتر ميامي',
    'LAFC': 'لوس أنجلوس إف سي',
    'Seattle Sounders': 'سياتل ساوندرز',

    // الدوري الإنجليزي (بقية الفرق)
    'Newcastle United': 'نيوكاسل يونايتد', 'Newcastle': 'نيوكاسل يونايتد',
    'Aston Villa': 'أستون فيلا',
    'Nottingham Forest': 'نوتنغهام فورست',
    'Brighton & Hove Albion': 'برايتون', 'Brighton and Hove Albion': 'برايتون', 'Brighton': 'برايتون',
    'Bournemouth': 'بورنموث', 'AFC Bournemouth': 'بورنموث',
    'Brentford': 'برينتفورد',
    'Fulham': 'فولهام',
    'Crystal Palace': 'كريستال بالاس',
    'Everton': 'إيفرتون',
    'Leeds United': 'ليدز يونايتد', 'Leeds': 'ليدز يونايتد',
    'Sunderland': 'سندرلاند',
    'Coventry City': 'كوفنتري سيتي',
    'Ipswich Town': 'إبسويتش تاون',
    'Hull City': 'هال سيتي',

    // الدوري الإسباني (بقية الفرق)
    'Athletic Bilbao': 'أتلتيك بيلباو', 'Athletic Club': 'أتلتيك بيلباو',
    'Villarreal': 'فياريال',
    'Real Betis': 'ريال بيتيس',
    'Real Sociedad': 'ريال سوسيداد',
    'Sevilla': 'إشبيلية',
    'Valencia': 'فالنسيا',
    'Celta Vigo': 'سلتا فيغو',
    'Rayo Vallecano': 'رايو فاليكانو',
    'Osasuna': 'أوساسونا',
    'Getafe': 'خيتافي',
    'Espanyol': 'إسبانيول',
    'Alaves': 'ألافيس', 'Deportivo Alaves': 'ألافيس',
    'Levante': 'ليفانتي',
    'Elche': 'إلتشي',
    'Racing Santander': 'راسينغ سانتاندير', 'Racing de Santander': 'راسينغ سانتاندير',
    'Deportivo La Coruna': 'ديبورتيفو لاكورونيا', 'Deportivo La Coruña': 'ديبورتيفو لاكورونيا',
    'Las Palmas': 'لاس بالماس', 'UD Las Palmas': 'لاس بالماس',

    // الدوري الإيطالي (بقية الفرق)
    'Lazio': 'لاتسيو',
    'Atalanta': 'أتالانتا',
    'Fiorentina': 'فيورنتينا',
    'Bologna': 'بولونيا',
    'Torino': 'تورينو',
    'Udinese': 'أودينيزي',
    'Genoa': 'جنوى',
    'Cagliari': 'كالياري',
    'Parma': 'بارما',
    'Como': 'كومو',
    'Verona': 'فيرونا', 'Hellas Verona': 'فيرونا',
    'Lecce': 'ليتشي',
    'Cremonese': 'كريمونيزي',
    'Pisa': 'بيزا',
    'Sassuolo': 'ساسولو',

    // الدوري الألماني (بقية الفرق)
    'RB Leipzig': 'آر بي لايبزيغ',
    'Bayer Leverkusen': 'باير ليفركوزن',
    'Eintracht Frankfurt': 'آينتراخت فرانكفورت',
    'VfB Stuttgart': 'شتوتغارت', 'Stuttgart': 'شتوتغارت',
    'Borussia Monchengladbach': 'بوروسيا مونشنغلادباخ', "Borussia M'gladbach": 'بوروسيا مونشنغلادباخ',
    'Werder Bremen': 'فيردر بريمن',
    'SC Freiburg': 'فرايبورغ', 'Freiburg': 'فرايبورغ',
    'Mainz 05': 'ماينز', 'Mainz': 'ماينز',
    'Union Berlin': 'يونيون برلين',
    'Augsburg': 'أوغسبورغ',
    'Hoffenheim': 'هوفنهايم', 'TSG Hoffenheim': 'هوفنهايم',
    'FC Koln': 'كولن', 'Cologne': 'كولن',
    'Schalke 04': 'شالكه',
    'SV Elversberg': 'إلفرسبيرغ',
    'SC Paderborn': 'بادربورن', 'Paderborn': 'بادربورن',

    // الدوري الفرنسي (بقية الفرق)
    'Marseille': 'مارسيليا', 'Olympique Marseille': 'مارسيليا',
    'Monaco': 'موناكو', 'AS Monaco': 'موناكو',
    'Lyon': 'ليون', 'Olympique Lyonnais': 'ليون',
    'Lille': 'ليل',
    'Nice': 'نيس',
    'Rennes': 'رين',
    'Lens': 'لانس',
    'Strasbourg': 'ستراسبورغ',
    'Toulouse': 'تولوز',
    'Reims': 'ريمس',
    'Auxerre': 'أوكسير',
    'Angers': 'أنجيه',
    'Le Havre': 'لوهافر',
    'Brest': 'بريست',
    'Troyes': 'تروا',
    'Le Mans': 'لومان',
    'Paris FC': 'باريس إف سي',
  };

  static String league(String en) => _leagues[en.trim()] ?? en;

  static String team(String en) => _teams[en.trim()] ?? en;

  /// يدمج ترجمات إضافية (مثلاً قادمة من Firestore) فوق القاموس المحلي —
  /// تُستخدم لاحقاً لو رُبط هذا الملف بمصدر أونلاين قابل للتعديل من لوحة
  /// التحكم بدون تحديث التطبيق.
  static void applyRemoteOverrides({
    Map<String, String>? leagues,
    Map<String, String>? teams,
  }) {
    if (leagues != null) _leagues.addAll(leagues);
    if (teams != null) _teams.addAll(teams);
  }
}
