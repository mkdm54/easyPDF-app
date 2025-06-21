import 'package:flutter/material.dart';
import 'package:easy_pdf/screens/dashboard_content.dart';
import 'package:easy_pdf/screens/camera.dart';
import 'package:easy_pdf/widgets/custom_app_bar.dart';
import 'package:easy_pdf/widgets/custom_sidebar.dart';
import 'package:easy_pdf/widgets/custom_bottom_navbar.dart';

class MainDashboard extends StatefulWidget {
  const MainDashboard({super.key});

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  int _currentIndex = 0;
  bool isSidebarVisible = false;

  void toggleSidebar() {
    setState(() {
      isSidebarVisible = !isSidebarVisible;
    });
  }

  void onMenuTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  final List<Widget> _pages = const [DashboardContent(), Camera()];

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
            left: isSidebarVisible ? 0 : -MediaQuery.of(context).size.width,
            top: 0,
            bottom: 0,
            right: isSidebarVisible ? 0 : MediaQuery.of(context).size.width,
            child: Row(
              children: [
                Container(
                  width: 250,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        offset: const Offset(2, 0),
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: CustomSidebar(
                    currentIndex: _currentIndex,
                    onMenuTap: onMenuTap,
                  ),
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
