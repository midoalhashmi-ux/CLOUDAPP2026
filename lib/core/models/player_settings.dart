class PlayerSettings {
  final String deepLinkScheme;
  final String storeUrl;

  const PlayerSettings({
    required this.deepLinkScheme,
    required this.storeUrl,
  });

  factory PlayerSettings.fromMap(Map<String, dynamic>? map) {
    return PlayerSettings(
      deepLinkScheme: map?['deepLinkScheme'] ?? 'sportsplayer',
      storeUrl: map?['storeUrl'] ?? '',
    );
  }
}
