import 'package:flutter/material.dart';

class ContentContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;

  const ContentContainer({
    super.key,
    required this.child,
    this.padding,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: padding ?? const EdgeInsets.all(12),
      height: double.infinity,
      decoration: BoxDecoration(color: colors.surface),
      child: child,
    );
  }
}
