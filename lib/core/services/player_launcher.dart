import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/player_settings.dart';

/// تطبيق المحتوى لا يملك رابط البث. يرسل معرف القناة فقط إلى المشغل الخارجي.
class PlayerLauncher {
  static Future<void> openChannel(BuildContext context, String channelId) async {
    PlayerSettings settings;
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('settings')
          .doc('player')
          .get();
      settings = PlayerSettings.fromMap(snapshot.data());
    } catch (_) {
      settings = PlayerSettings.fromMap(null);
    }

    final scheme = settings.deepLinkScheme.trim().replaceAll('://', '');
    final playerUri = Uri.parse('$scheme://play?channelId=$channelId');
    try {
      final opened = await launchUrl(
        playerUri,
        mode: LaunchMode.externalApplication,
      );
      if (opened) return;
    } catch (_) {
      // إذا لم يكن المشغل مثبتاً نعرض خيار تثبيته بدلاً من إظهار خطأ تقني.
    }

    if (!context.mounted) return;
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('تطبيق المشغل مطلوب'),
        content: const Text(
          'لم يتم العثور على تطبيق المشغل. ثبّته أولاً ثم ارجع وافتح القناة.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: settings.storeUrl.isEmpty
                ? null
                : () async {
                    await launchUrl(
                      Uri.parse(settings.storeUrl),
                      mode: LaunchMode.externalApplication,
                    );
                  },
            child: const Text('تحميل المشغل'),
          ),
        ],
      ),
    );
  }
}
