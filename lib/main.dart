import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'core/services/content_service.dart';
import 'features/channels/channels_screen.dart';
import 'firebase_options.dart';
import 'theme/app_theme.dart';
import 'theme/dynamic_theme_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const _BootApp());
}

class _BootApp extends StatefulWidget {
  const _BootApp();
  @override
  State<_BootApp> createState() => _BootAppState();
}

class _BootAppState extends State<_BootApp> {
  String? _error;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
      if (mounted) setState(() => _ready = true);
    } catch (error) {
      if (mounted) setState(() => _error = error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) return _ErrorApp(error: _error!);
    if (!_ready) return const _LoadingApp();
    return const SportsApp();
  }
}

class _LoadingApp extends StatelessWidget {
  const _LoadingApp();
  @override
  Widget build(BuildContext context) => const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Color(0xFF0B1120),
          body: Center(child: CircularProgressIndicator(color: Color(0xFF38BDF8))),
        ),
      );
}

class _ErrorApp extends StatelessWidget {
  final String error;
  const _ErrorApp({required this.error});
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: const Color(0xFF0B1120),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text('تعذر بدء خدمة المحتوى.\n\n$error',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white)),
            ),
          ),
        ),
      );
}

class SportsApp extends StatelessWidget {
  const SportsApp({super.key});
  @override
  Widget build(BuildContext context) => StreamBuilder<DynamicThemeSettings>(
        stream: DynamicThemeService.watchTheme(),
        builder: (context, snapshot) => MaterialApp(
          title: 'البث الرياضي',
          debugShowCheckedModeBanner: false,
          theme: snapshot.data?.toThemeData() ?? AppTheme.fallback,
          locale: const Locale('ar'),
          home: const HomeScreen(),
        ),
      );
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('البث الرياضي')),
        body: StreamBuilder(
          stream: ContentService.watchRootCategories(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('تعذر تحميل الأقسام. تحقق من اتصال الإنترنت وقواعد Firebase.'));
            }
            if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
            final categories = snapshot.data!;
            if (categories.isEmpty) return const Center(child: Text('لا توجد أقسام بعد'));
            return GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 1.1,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return Card(
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => ChannelsScreen(category: category),
                    )),
                    child: Stack(fit: StackFit.expand, children: [
                      if (category.iconUrl?.isNotEmpty == true)
                        Image.network(category.iconUrl!, fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _fallback(context))
                      else
                        _fallback(context),
                      Positioned(
                        left: 0, right: 0, bottom: 0,
                        child: Container(
                          color: Colors.black54,
                          padding: const EdgeInsets.all(10),
                          child: Text(category.title,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ]),
                  ),
                );
              },
            );
          },
        ),
      );

  Widget _fallback(BuildContext context) => Container(
        color: Theme.of(context).colorScheme.primary.withOpacity(.18),
        child: Icon(Icons.sports_soccer, size: 42, color: Theme.of(context).colorScheme.primary),
      );
}
