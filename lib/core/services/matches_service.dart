import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/match_model.dart';

/// يجلب جدول مباريات كرة القدم ليوم محدد من TheSportsDB — مصدر مجاني
/// تماماً لا يحتاج تسجيل ولا مفتاح API خاص (يستخدم مفتاح الاختبار
/// العام "3" الموثّق رسمياً من الخدمة نفسها للاستخدام غير التجاري).
///
/// نطلب كل مباريات كرة القدم حول العالم في يوم واحد بطلب واحد فقط
/// (eventsday.php?s=Soccer)، ثم نعرضها/نرتّبها في الواجهة — بدل تعداد
/// كل دوري بطلب منفصل، حتى لا نستهلك الحد المسموح من الطلبات بسرعة.
class MatchesService {
  MatchesService._();

  static const _baseUrl = 'https://www.thesportsdb.com/api/v1/json/3';

  static Future<List<MatchModel>> fetchMatches(DateTime date) async {
    final dateStr =
        '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

    final uri = Uri.parse('$_baseUrl/eventsday.php?d=$dateStr&s=Soccer');
    final response = await http.get(uri).timeout(const Duration(seconds: 12));

    if (response.statusCode != 200) {
      throw Exception('تعذر جلب المباريات (${response.statusCode})');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final events = body['events'] as List<dynamic>?;
    if (events == null || events.isEmpty) return [];

    final matches = events
        .whereType<Map<String, dynamic>>()
        .map(MatchModel.fromTheSportsDb)
        .toList();

    matches.sort((a, b) => a.kickoff.compareTo(b.kickoff));
    return matches;
  }
}
