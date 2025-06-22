import 'package:flutter/material.dart';
import 'package:easy_pdf/widgets/sidebar_widget/theme_btn_toggle.dart';

class CustomSidebar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onMenuTap;
  final bool isDarkMode;
  final ValueChanged<bool> onThemeToggle;

  const CustomSidebar({
    super.key,
    required this.currentIndex,
    required this.onMenuTap,
    required this.isDarkMode,
    required this.onThemeToggle,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: 250,
      height: double.infinity,
      decoration: BoxDecoration(
        color: colors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            offset: const Offset(2, 0),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Menu',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          _buildNavItem(
            context: context,
            icon: Icons.dashboard,
            title: 'Dashboard',
            index: 0,
          ),
          _buildNavItem(
            context: context,
            icon: Icons.camera_alt,
            title: 'Camera',
            index: 1,
          ),
          const Divider(),
          _buildCustomContentItem(
            child: ThemeBtnToggle(
              isDarkMode: isDarkMode,
              onToggle: onThemeToggle,
            ),
          ),
          const Divider(),
          _buildMenuItem(
            context: context,
            icon: Icons.help,
            title: const Text('Help'),
            onTap: () {
              // Handle help
            },
          ),
          const Spacer(),
          _buildMenuItem(
            context: context,
            icon: Icons.logout,
            title: const Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
            iconColor: Colors.red,
            onTap: () {
              // Handle logout
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required int index,
  }) {
    final colors = Theme.of(context).colorScheme;
    final bool isSelected = currentIndex == index;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: isSelected ? colors.primary : null,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? colors.surface : colors.onSurface,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? colors.surface : colors.onSurface,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        onTap: () => onMenuTap(index),
      ),
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required Widget title,
    Color? iconColor,
    required VoidCallback onTap,
  }) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: ListTile(
        leading: Icon(
          icon,
          color: iconColor ?? colors.onSurface,
        ),
        title: title,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        onTap: onTap,
      ),
    );
  }

  Widget _buildCustomContentItem({
    required Widget child,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: child,
    );
  }
}
