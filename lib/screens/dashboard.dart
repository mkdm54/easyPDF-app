// dashboard.dart
import 'package:flutter/material.dart';
import 'package:easy_pdf/screens/pdf_list.dart';
import 'package:easy_pdf/widgets/custom_bottom_navbar.dart';
import 'package:easy_pdf/screens/tools_menu_page.dart';
import 'package:easy_pdf/widgets/custom_app_bar.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _currentIndex = 0;
  final List<Widget> _pages = const [PdfListWidget(), ToolsMenuPage()];
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
