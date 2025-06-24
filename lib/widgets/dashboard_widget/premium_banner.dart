import 'package:flutter/material.dart';

class PremiumBanner extends StatefulWidget {
  final double? height;
  final EdgeInsets? padding;
  final String text;
  final IconData icon;
  final VoidCallback? onTap;
  final Duration animationDuration;

  const PremiumBanner({
    super.key,
    this.height = 35,
    this.padding = const EdgeInsets.symmetric(horizontal: 10),
    this.text = 'Premium',
    this.icon = Icons.diamond,
    this.onTap,
    this.animationDuration = const Duration(seconds: 3),
  });

  @override
  State<PremiumBanner> createState() => _PremiumBannerState();
}

class _PremiumBannerState extends State<PremiumBanner>
    with SingleTickerProviderStateMixin {
  
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _animation = Tween<double>(
      begin: -1.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return GestureDetector(
          onTap: widget.onTap,
          child: Container(
            padding: widget.padding,
            height: widget.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(_animation.value - 0.5, -1),
                end: Alignment(_animation.value + 0.5, 1),
                colors: const [
                  Color(0xFF42A5F5),
                  Color(0xFF7E57C2),
                  Color(0xFFE91E63),
                  Color(0xFF42A5F5),
                ],
                stops: const [0.0, 0.3, 0.7, 1.0],
              ),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  widget.icon,
                  color: Colors.white,
                  size: 20,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}