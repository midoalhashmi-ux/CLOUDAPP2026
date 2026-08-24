import 'package:flutter/material.dart';
import '../../core/models/category_model.dart';
import '../../core/models/channel_model.dart';
import '../../core/services/content_service.dart';
import '../watch/watch_screen.dart';

class ChannelsScreen extends StatelessWidget {
  final CategoryModel category;
  const ChannelsScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(category.title)),
      body: StreamBuilder<List<ChannelModel>>(
        stream: ContentService.watchChannelsForCategory(category.id),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final channels = snapshot.data!;
          if (channels.isEmpty) {
            return const Center(child: Text('لا توجد قنوات بعد في هذا القسم'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: channels.length,
            itemBuilder: (context, index) =>
                _ChannelCard(channel: channels[index]),
          );
        },
      ),
    );
  }
}

class _ChannelCard extends StatelessWidget {
  final ChannelModel channel;
  const _ChannelCard({required this.channel});

  Color _statusColor(BuildContext context) {
    switch (channel.status) {
      case 'live':
        return Colors.redAccent;
      case 'upcoming':
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }

  String _statusLabel() {
    switch (channel.status) {
      case 'live':
        return 'مباشر الآن';
      case 'upcoming':
        return 'قريباً';
      default:
        return 'انتهى';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => WatchScreen(channel: channel),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: channel.logoUrl != null && channel.logoUrl!.isNotEmpty
                    ? Image.network(
                        channel.logoUrl!,
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _fallbackLogo(theme),
                      )
                    : _fallbackLogo(theme),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(channel.title,
                        style: theme.textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(channel.subtitle,
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: Colors.grey)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _statusColor(context).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _statusLabel(),
                        style: TextStyle(
                          color: _statusColor(context),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.play_circle_fill, size: 34),
            ],
          ),
        ),
      ),
    );
  }

  Widget _fallbackLogo(ThemeData theme) {
    return Container(
      width: 64,
      height: 64,
      color: theme.colorScheme.primary.withOpacity(0.15),
      child: Icon(Icons.sports_soccer, color: theme.colorScheme.primary),
    );
  }
}
