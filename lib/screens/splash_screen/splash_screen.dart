import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:easy_pdf/screens/main_dashboard.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.asset(
        'assets/video/pdf-14046375-11316369.mp4',
      )
      ..initialize().then((_) {
        setState(() {});
        _controller.play();

        // Pindah ke dashboard saat video selesai
        _controller.addListener(() {
          if (_controller.value.position >= _controller.value.duration) {
            if (mounted) _navigateToDashboard();
          }
        });
      });
  }

  void _navigateToDashboard() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const MainDashboard(),
        transitionDuration: const Duration(milliseconds: 600),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:
          _controller.value.isInitialized
              ? Center(
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
              )
              : const Scaffold(
                backgroundColor: Colors.white,
              ), // ← tidak menampilkan apa pun saat belum siap
    );
  }
}
