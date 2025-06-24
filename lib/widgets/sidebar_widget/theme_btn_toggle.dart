import 'package:flutter/material.dart';

class ThemeBtnToggle extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onToggle;

  const ThemeBtnToggle({
    super.key,
    required this.isDarkMode,
    required this.onToggle,
  });

  @override
  State<ThemeBtnToggle> createState() => _ThemeBtnToggleState();
}

class _ThemeBtnToggleState extends State<ThemeBtnToggle> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(widget.isDarkMode ? Icons.nightlight_round : Icons.wb_sunny),
        const SizedBox(width: 8),
        const Text('Themes'),
        const Spacer(),
        Switch(
          value: widget.isDarkMode,
          onChanged: (value) {
            widget.onToggle(value);
          },
        ),
      ],
    );
  }
}
