// widgets/custom_sidebar.dart
import 'package:flutter/material.dart';

class CustomSidebar extends StatelessWidget {
  final bool isVisible;
  final int currentIndex;
  final Function(int) onMenuTap;

  const CustomSidebar({
    super.key,
    required this.isVisible,
    required this.currentIndex,
    required this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: isVisible ? 250 : 0,
      height: double.infinity,
      color: colors.surface,
      child:
          isVisible
              ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Menu',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildMenuItem(
                      context: context,
                      icon: Icons.dashboard,
                      title: 'Dashboard',
                      index: 0,
                    ),
                    _buildMenuItem(
                      context: context,
                      icon: Icons.camera_alt,
                      title: 'Camera',
                      index: 1,
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.sunny),
                      title: Row(
                        children: [
                          const Text('Theme'),
                          const SizedBox(width: 8),
                          Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'New',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      contentPadding: EdgeInsets.zero,
                      onTap: () {
                        // Handle tap
                      },
                    ),

                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.help),
                      title: const Text('Help'),
                      contentPadding: EdgeInsets.zero,
                      onTap: () {
                        // Handle help
                      },
                    ),

                    // Tombol Logout
                    // const Spacer(),
                    // ListTile(
                    //   leading: const Icon(Icons.logout, color: Colors.red),
                    //   title: const Text(
                    //     'Logout',
                    //     style: TextStyle(color: Colors.red),
                    //   ),
                    //   contentPadding: EdgeInsets.zero,
                    // ),
                  ],
                ),
              )
              : null,
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required int index,
  }) {
    bool isSelected = currentIndex == index;
    final colors = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: isSelected ? colors.surface : null,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? colors.primary : colors.onSurface,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? colors.primary : colors.onSurface,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        onTap: () => onMenuTap(index),
      ),
    );
  }
}
