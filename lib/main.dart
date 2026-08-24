import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'theme/app_theme.dart';
import 'theme/dynamic_theme_service.dart';
import 'core/services/content_service.dart';
import 'core/services/feature_flags_service.dart';

// ملاحظة: يجب توليد firebase_options.dart تلقائياً عبر أمر
// flutterfire configure
// ثم استيراده هنا واستبدال DefaultFirebaseOptions.currentPlatform أدناه.
// import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const SportsApp());
}

class SportsApp extends StatelessWidget {
  const SportsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DynamicThemeSettings>(
      stream: DynamicThemeService.watchTheme(),
      builder: (context, snapshot) {
        final theme = snapshot.hasData
            ? snapshot.data!.toThemeData()
            : AppTheme.fallback;

        return MaterialApp(
          title: 'تطبيق البث الرياضي',
          debugShowCheckedModeBanner: false,
          theme: theme,
          locale: const Locale('ar'),
          home: const HomeScreen(),
        );
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الرئيسية')),
      body: StreamBuilder(
        stream: ContentService.watchCategories(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final categories = snapshot.data!;
          if (categories.isEmpty) {
            return const Center(child: Text('لا توجد أقسام بعد'));
          }
          return ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return ListTile(
                title: Text(category.title),
                onTap: () {
                  // TODO: الانتقال إلى شاشة قنوات القسم
                },
              );
            },
          );
        },
      ),
    );
  }
}
