import 'package:flutter/material.dart';

class PdfListWidget extends StatefulWidget {
  const PdfListWidget({super.key});

  @override
  State<PdfListWidget> createState() => _PdfListWidgetState();
}

class _PdfListWidgetState extends State<PdfListWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('disini halaman pdf list'),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
    );
  }
}
