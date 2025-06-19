import 'package:flutter/material.dart';
import 'package:easy_pdf/widgets/dashboard_widget/premium_banner.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 221, 25, 11),
      ),
      child: Row(
        children: [
          // Toggle Sidebar
          Icon(Icons.menu, size: 35),
          Spacer(),

          // Premium banner
          PremiumBanner(),

          const SizedBox(width: 12),

          // *Profile
          Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/my_image.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.person, size: 30, color: Colors.grey);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(90);
}
