import 'package:flutter/material.dart';
// import 'package:easy_pdf/screens/splash_screen/splash_screen.dart';
import 'package:easy_pdf/screens/main_dashboard.dart';
import 'package:easy_pdf/theme/app_theme.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // menghilangkan status bar, bisa muncul ketika swipe & hilang otomatis
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _setThemeMode(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'easy PDF',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      debugShowCheckedModeBanner: false,
      home: MainDashboard(
        isDarkMode: _themeMode == ThemeMode.dark,
        onThemeToggle: (isDark) => _setThemeMode(isDark),
      ),
    );
  }
}
