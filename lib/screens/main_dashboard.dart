// MainDashboard.dart
import 'package:flutter/material.dart';
import 'package:easy_pdf/screens/dashboard_content.dart';
import 'package:easy_pdf/widgets/custom_bottom_navbar.dart';
import 'package:easy_pdf/widgets/custom_app_bar.dart';
import 'package:easy_pdf/screens/camera.dart';

class MainDashboard extends StatefulWidget {
  const MainDashboard({super.key});

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  int _currentIndex = 0;
  final List<Widget> _pages = const [DashboardContent(), Camera()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      backgroundColor: Colors.white,
      body: _pages[_currentIndex],
      bottomNavigationBar: CustomNavbar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
