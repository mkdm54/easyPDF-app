import 'package:flutter/material.dart';
// import 'package:easy_pdf/screens/splash_screen/splash_screen.dart';
import 'package:easy_pdf/screens/dashboard.dart';
import 'package:easy_pdf/theme/app_theme.dart';
import 'package:flutter/services.dart';

void main() {
    WidgetsFlutterBinding.ensureInitialized();

  // menghilangkan status bar, bisa muncul ketika swipe & hilang otomatis
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'easy PDF',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: const Dashboard(),
    );
  }
}
