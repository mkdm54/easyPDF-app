import 'package:flutter/material.dart';
import 'package:easy_pdf/widgets/dashboard_widget/premium_banner.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onMenuPressed;

  const CustomAppBar({super.key, this.onMenuPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(color: Color.fromARGB(255, 221, 25, 11)),
      child: Row(
        children: [

          // Toggle Sidebar
          GestureDetector(
            onTap: onMenuPressed,
            child: const Icon(Icons.menu, size: 35, color: Colors.white),
          ),

          const Spacer(),

          const PremiumBanner(),

          const SizedBox(width: 12),

          Container(
            width: 35,
            height: 35,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/my_image.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.person, size: 30, color: Colors.grey);
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
