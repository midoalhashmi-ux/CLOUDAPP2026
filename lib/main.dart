import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const _AndroidDiagnosticApp());
}

class _AndroidDiagnosticApp extends StatelessWidget {
  const _AndroidDiagnosticApp();

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color(0xFF0B1120),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.verified, color: Color(0xFF38BDF8), size: 56),
              SizedBox(height: 18),
              Text('اختبار تشغيل أندرويد', style: TextStyle(color: Colors.white, fontSize: 24)),
              SizedBox(height: 8),
              Text('إذا ظهرت هذه الشاشة فأساس التطبيق يعمل.', style: TextStyle(color: Colors.white70)),
            ],
          ),
        ),
      ),
    );
  }
}
