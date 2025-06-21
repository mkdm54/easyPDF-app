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
    final colors = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onpressed,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
                  blurRadius: 4,
                  offset: const Offset(2, 2),
                ),
              ],
            ),
            child: Center(child: icon),
          ),
          const SizedBox(height: 8),
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.visible,
              textAlign: TextAlign.center,
              style: TextStyle(color: colors.onSurface),
            ),
          ),
        ],
      ),
    );
  }
}
