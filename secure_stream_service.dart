import 'package:cloud_functions/cloud_functions.dart';

class SecureStreamService {
  static Future<String?> getTemporaryStreamUrl(String channelId) async {
    try {
      final callable =
          FirebaseFunctions.instance.httpsCallable('getStreamUrl');
      final result = await callable.call({'channelId': channelId});
      return result.data['url'] as String?;
    } catch (e) {
      return null;
    }
  }
}
