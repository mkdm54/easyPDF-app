// MainDashboard.dart
import 'package:flutter/material.dart';
import 'package:easy_pdf/screens/dashboard_content.dart';
import 'package:easy_pdf/widgets/custom_bottom_navbar.dart';
import 'package:easy_pdf/widgets/custom_app_bar.dart';
import 'package:easy_pdf/widgets/custom_sidebar.dart';
import 'package:easy_pdf/screens/camera.dart';

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

  // void onLogoutTap() {
  //   // Handle logout tap
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text('Logout'),
  //         content: const Text('Are you sure you want to logout?'),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.of(context).pop(),
  //             child: const Text('Cancel'),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //               // nanti asksi  logout
  //             },
  //             child: const Text('Logout'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  final List<Widget> _pages = const [DashboardContent(), Camera()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(onMenuPressed: toggleSidebar),
      backgroundColor: Colors.white,
      body: Row(
        children: [
          CustomSidebar(
            isVisible: isSidebarVisible,
            currentIndex: _currentIndex,
            onMenuTap: onMenuTap,
          ),

          // Main content
          Expanded(child: _pages[_currentIndex]),
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
