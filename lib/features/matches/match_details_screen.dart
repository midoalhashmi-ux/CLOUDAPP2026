import 'package:flutter/material.dart';

import '../../core/data/football_ar_translations.dart';
import '../../core/models/match_model.dart';
import '../../core/models/match_stats_model.dart';
import '../../core/services/match_stats_service.dart';

/// شاشة تفاصيل مباراة واحدة: النتيجة + إحصائيات (استحواذ، تسديدات،
/// ركنيات، بطاقات...) عند توفرها. لا تُستدعى الإحصائيات من الخادم
/// إطلاقاً للمباريات التي لم تبدأ بعد — لا توجد إحصائيات لها أصلاً.
class MatchDetailsScreen extends StatefulWidget {
  final MatchModel match;
  const MatchDetailsScreen({super.key, required this.match});

  @override
  State<MatchDetailsScreen> createState() => _MatchDetailsScreenState();
}

class _MatchDetailsScreenState extends State<MatchDetailsScreen> {
  late Future<MatchStatsResult>? _future;

  @override
  void initState() {
    super.initState();
    final match = widget.match;
    final canHaveStats = match.status == MatchStatus.live ||
        match.status == MatchStatus.finished;

    _future = canHaveStats
        ? MatchStatsService.fetchStats(
            fixtureId: match.id,
            matchFinished: match.status == MatchStatus.finished,
          )
        : null;
  }

  @override
  Widget build(BuildContext context) {
    final match = widget.match;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${FootballTranslations.team(match.homeTeamEn)} ضد ${FootballTranslations.team(match.awayTeamEn)}',
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildScoreHeader(context, match),
          const SizedBox(height: 24),
          _buildStatsSection(context, match),
        ],
      ),
    );
  }

  Widget _buildScoreHeader(BuildContext context, MatchModel match) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        child: Row(
          children: [
            Expanded(child: _teamHeader(match.homeTeamEn, match.homeLogo)),
            SizedBox(
              width: 90,
              child: Column(
                children: [
                  if (match.hasScore)
                    Text(
                      '${match.homeScore} - ${match.awayScore}',
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    )
                  else
                    Text(
                      '${match.kickoff.hour.toString().padLeft(2, '0')}:${match.kickoff.minute.toString().padLeft(2, '0')}',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  const SizedBox(height: 6),
                  Text(_statusLabel(match.status),
                      style: TextStyle(
                          fontSize: 12,
                          color: match.status == MatchStatus.live
                              ? Colors.redAccent
                              : Colors.white54)),
                ],
              ),
            ),
            Expanded(child: _teamHeader(match.awayTeamEn, match.awayLogo)),
          ],
        ),
      ),
    );
  }

  Widget _teamHeader(String nameEn, String? logo) {
    return Column(
      children: [
        if (logo != null)
          Image.network(logo, width: 48, height: 48,
              errorBuilder: (_, __, ___) => const Icon(Icons.shield_outlined, size: 48))
        else
          const Icon(Icons.shield_outlined, size: 48),
        const SizedBox(height: 8),
        Text(FootballTranslations.team(nameEn),
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  String _statusLabel(MatchStatus status) {
    switch (status) {
      case MatchStatus.live:
        return 'مباشر الآن';
      case MatchStatus.finished:
        return 'انتهت المباراة';
      case MatchStatus.postponed:
        return 'مؤجلة';
      case MatchStatus.upcoming:
        return 'لم تبدأ بعد';
    }
  }

  Widget _buildStatsSection(BuildContext context, MatchModel match) {
    if (_future == null) {
      return _buildInfoMessage(
        icon: Icons.hourglass_empty,
        text: 'الإحصائيات تظهر بعد بداية المباراة.',
      );
    }

    return FutureBuilder<MatchStatsResult>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.only(top: 32),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final result = snapshot.data;
        if (result is MatchStatsSuccess) {
          return _buildStatsTable(context, result.stats);
        }
        if (result is MatchStatsUnavailable) {
          return _buildInfoMessage(
              icon: Icons.bar_chart, text: result.message);
        }
        if (result is MatchStatsError) {
          return _buildInfoMessage(
              icon: Icons.wifi_off, text: result.message);
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildInfoMessage({required IconData icon, required String text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          Icon(icon, size: 40, color: Colors.white38),
          const SizedBox(height: 12),
          Text(text, textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _buildStatsTable(BuildContext context, MatchStats stats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: Text('الإحصائيات',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ),
        for (final entry in MatchStats.orderedTypes.entries)
          _statRow(entry.value, stats.home.display(entry.key),
              stats.away.display(entry.key)),
      ],
    );
  }

  Widget _statRow(String labelAr, String homeValue, String awayValue) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(homeValue,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: Text(labelAr,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70, fontSize: 13)),
          ),
          SizedBox(
            width: 60,
            child: Text(awayValue,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
