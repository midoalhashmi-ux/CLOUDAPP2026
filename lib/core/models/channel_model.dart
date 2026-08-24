class ChannelModel {
  final String id;
  final String categoryId;
  final String title;
  final String subtitle;
  final String status;
  final DateTime? startTime;
  final String? logoUrl;
  final String? playerChannelKey;

  ChannelModel({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.subtitle,
    required this.status,
    this.startTime,
    this.logoUrl,
    this.playerChannelKey,
  });

  factory ChannelModel.fromMap(String id, Map<String, dynamic> map) {
    return ChannelModel(
      id: id,
      categoryId: map['categoryId'] ?? '',
      title: map['title'] ?? '',
      subtitle: map['subtitle'] ?? '',
      status: map['status'] ?? 'upcoming',
      startTime: map['startTime'] != null
          ? DateTime.tryParse(map['startTime'])
          : null,
      logoUrl: map['logoUrl'],
      playerChannelKey: map['playerChannelKey'],
    );
  }
}
