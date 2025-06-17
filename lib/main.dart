import 'package:flutter/material.dart';
import 'package:easy_pdf/screens/dashboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'easy PDF',
      debugShowCheckedModeBanner: false,
      home: const Dashboard(),
    );
  }
}
