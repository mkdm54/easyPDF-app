import 'package:flutter/material.dart';

class ButtonTools extends StatelessWidget {
  final Widget icon;
  final String label;
  final VoidCallback? onpressed;

  const ButtonTools({
    super.key,
    required this.icon,
    required this.label,
    this.onpressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min, // supaya ukurannya pas
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.5),
                spreadRadius: 1,
                blurRadius: 2,
                offset: Offset(2, 2),
              ),
            ],
          ),
          child: Center(child: icon),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Colors.black)),
      ],
    );
  }
}
