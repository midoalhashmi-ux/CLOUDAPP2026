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
    'FA Cup': 'كأس الاتحاد الإنجليزي',
    'English League Cup': 'كأس الرابطة الإنجليزية',
    'Spanish La Liga': 'الدوري الإسباني',
    'Copa Del Rey': 'كأس ملك إسبانيا',
    'Italian Serie A': 'الدوري الإيطالي',
    'Coppa Italia': 'كأس إيطاليا',
    'German Bundesliga': 'الدوري الألماني',
    'DFB Pokal': 'كأس ألمانيا',
    'French Ligue 1': 'الدوري الفرنسي',
    'Coupe de France': 'كأس فرنسا',
    'UEFA Champions League': 'دوري أبطال أوروبا',
    'UEFA Europa League': 'الدوري الأوروبي',
    'UEFA Europa Conference League': 'دوري المؤتمر الأوروبي',
    'UEFA Nations League': 'دوري الأمم الأوروبية',
    'FIFA World Cup': 'كأس العالم',
    'FIFA Club World Cup': 'كأس العالم للأندية',
    'World Cup Qualification UEFA': 'تصفيات كأس العالم الأوروبية',
    'World Cup Qualification CAF': 'تصفيات كأس العالم الأفريقية',
    'World Cup Qualification AFC': 'تصفيات كأس العالم الآسيوية',
    'Africa Cup of Nations': 'كأس الأمم الأفريقية',
    'AFC Asian Cup': 'كأس آسيا',
    'Dutch Eredivisie': 'الدوري الهولندي',
    'Portuguese Primeira Liga': 'الدوري البرتغالي',
    'Turkish Super Lig': 'الدوري التركي',
  };

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
