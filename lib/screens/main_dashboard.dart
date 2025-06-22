import 'package:flutter/material.dart';
import 'package:easy_pdf/screens/dashboard_content.dart';
import 'package:easy_pdf/screens/camera.dart';
import 'package:easy_pdf/widgets/custom_app_bar.dart';
import 'package:easy_pdf/widgets/custom_sidebar.dart';
import 'package:easy_pdf/widgets/custom_bottom_navbar.dart';

class MainDashboard extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeToggle;

  const MainDashboard({
    super.key,
    required this.isDarkMode,
    required this.onThemeToggle,
  });

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  int _currentIndex = 0;
  bool isSidebarVisible = false;

  final List<Widget> _pages = const [DashboardContent(), Camera()];

  void toggleSidebar() {
    setState(() {
      isSidebarVisible = !isSidebarVisible;
    });
  }

  void onMenuTap(int index) {
    setState(() {
      _currentIndex = index;
      isSidebarVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(onMenuPressed: toggleSidebar),
      body: Stack(
        children: [
          _pages[_currentIndex],
          if (isSidebarVisible)
            GestureDetector(
              onTap: toggleSidebar,
              child: Container(color: Colors.black.withValues(alpha: 0.5)),
            ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            left: isSidebarVisible ? 0 : -250,
            top: 0,
            bottom: 0,
            right: 0,
            child: Row(
              children: [
                CustomSidebar(
                  currentIndex: _currentIndex,
                  onMenuTap: onMenuTap,
                  isDarkMode: widget.isDarkMode,
                  onThemeToggle: widget.onThemeToggle,
                ),
                Expanded(child: Container()),
              ],
            ),
          ),
        ],
      ),
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
