import 'package:flutter/material.dart';
import '../../core/data/football_ar_translations.dart';
import '../../core/models/match_model.dart';
import '../../core/services/matches_service.dart';

/// شاشة "النتائج": جدول مباريات كرة القدم (العربية والعالمية) ليوم واحد،
/// مع إمكانية التنقل بين الأيام عبر سهمين. لا حاجة لأي إعداد إضافي —
/// المصدر مجاني بالكامل.
class MatchesScreen extends StatefulWidget {
  const MatchesScreen({super.key});

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  // إزاحة الأيام عن اليوم الحالي: 0 = اليوم، 1 = غداً، -1 = أمس ...
  int _dayOffset = 0;
  late Future<List<MatchModel>> _future;

  static const _weekdaysAr = [
    'الاثنين',
    'الثلاثاء',
    'الأربعاء',
    'الخميس',
    'الجمعة',
    'السبت',
    'الأحد',
  ];

  @override
  void initState() {
    super.initState();
    _future = MatchesService.fetchMatches(_selectedDate);
  }

  DateTime get _selectedDate {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day).add(Duration(days: _dayOffset));
  }

  void _changeDay(int delta) {
    setState(() {
      _dayOffset += delta;
      _future = MatchesService.fetchMatches(_selectedDate);
    });
  }

  Future<void> _refresh() async {
    setState(() => _future = MatchesService.fetchMatches(_selectedDate));
    await _future;
  }

  String get _dayLabel {
    if (_dayOffset == 0) return 'اليوم';
    if (_dayOffset == 1) return 'غداً';
    if (_dayOffset == -1) return 'أمس';
    final date = _selectedDate;
    return '${_weekdaysAr[date.weekday - 1]} ${date.day}/${date.month}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildDaySwitcher(context),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _refresh,
            child: FutureBuilder<List<MatchModel>>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return _buildMessage(
                    context,
                    icon: Icons.wifi_off,
                    text: 'تعذر جلب المباريات. تحقق من اتصال الإنترنت وحاول مرة أخرى.',
                  );
                }
                final matches = snapshot.data ?? [];
                if (matches.isEmpty) {
                  return _buildMessage(
                    context,
                    icon: Icons.sports_soccer,
                    text: 'لا توجد مباريات مسجّلة في هذا اليوم.',
                  );
                }
                return _buildMatchesList(context, matches);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDaySwitcher(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            tooltip: 'اليوم السابق',
            icon: const Icon(Icons.chevron_right),
            onPressed: () => _changeDay(-1),
          ),
          Text(
            _dayLabel,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          IconButton(
            tooltip: 'اليوم التالي',
            icon: const Icon(Icons.chevron_left),
            onPressed: () => _changeDay(1),
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(BuildContext context,
      {required IconData icon, required String text}) {
    return ListView(
      // ListView حتى يبقى RefreshIndicator (سحب للتحديث) شغّالاً حتى في
      // حالة الخطأ أو القائمة الفارغة.
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.18),
        Icon(icon, size: 48, color: Colors.white38),
        const SizedBox(height: 12),
        Text(text, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }

  Widget _buildMatchesList(BuildContext context, List<MatchModel> matches) {
    final grouped = <String, List<MatchModel>>{};
    for (final match in matches) {
      grouped.putIfAbsent(match.leagueNameEn, () => []).add(match);
    }

    final leagues = grouped.keys.toList();

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 24),
      itemCount: leagues.length,
      itemBuilder: (context, index) {
        final leagueEn = leagues[index];
        final leagueMatches = grouped[leagueEn]!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 16, 14, 6),
              child: Row(
                children: [
                  if (leagueMatches.first.leagueLogo != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Image.network(
                        leagueMatches.first.leagueLogo!,
                        width: 22,
                        height: 22,
                        errorBuilder: (_, __, ___) => const SizedBox(width: 22),
                      ),
                    ),
                  Expanded(
                    child: Text(
                      FootballTranslations.league(leagueEn),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white70),
                    ),
                  ),
                ],
              ),
            ),
            ...leagueMatches.map((match) => _MatchTile(match: match)),
          ],
        );
      },
    );
  }
}

class _MatchTile extends StatelessWidget {
  final MatchModel match;
  const _MatchTile({required this.match});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        child: Row(
          children: [
            Expanded(child: _teamColumn(match.homeTeamEn, match.homeLogo)),
            SizedBox(width: 76, child: _centerInfo(context, primary)),
            Expanded(child: _teamColumn(match.awayTeamEn, match.awayLogo)),
          ],
        ),
      ),
    );
  }

  Widget _teamColumn(String nameEn, String? logo) {
    return Column(
      children: [
        if (logo != null)
          Image.network(logo, width: 34, height: 34,
              errorBuilder: (_, __, ___) => const Icon(Icons.shield_outlined, size: 34))
        else
          const Icon(Icons.shield_outlined, size: 34),
        const SizedBox(height: 6),
        Text(
          FootballTranslations.team(nameEn),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 12.5),
        ),
      ],
    );
  }

  Widget _centerInfo(BuildContext context, Color primary) {
    switch (match.status) {
      case MatchStatus.live:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${match.homeScore ?? 0} - ${match.awayScore ?? 0}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: primary)),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                  color: Colors.redAccent, borderRadius: BorderRadius.circular(4)),
              child: const Text('مباشر', style: TextStyle(color: Colors.white, fontSize: 10)),
            ),
          ],
        );
      case MatchStatus.finished:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${match.homeScore ?? 0} - ${match.awayScore ?? 0}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 4),
            const Text('انتهت', style: TextStyle(color: Colors.white54, fontSize: 11)),
          ],
        );
      case MatchStatus.postponed:
        return const Text('مؤجلة',
            textAlign: TextAlign.center, style: TextStyle(color: Colors.orangeAccent, fontSize: 12));
      case MatchStatus.upcoming:
        final h = match.kickoff.hour.toString().padLeft(2, '0');
        final m = match.kickoff.minute.toString().padLeft(2, '0');
        return Text('$h:$m',
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14));
    }
  }
}
