import 'dart:io';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:path/path.dart' as p;

class OpenPdfViewer extends StatelessWidget {
  final String path;

  const OpenPdfViewer({super.key, required this.path});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final fileName = p.basename(path);

    return Scaffold(
      appBar: AppBar(title: Text(fileName), backgroundColor: colors.primary),
      body: SfPdfViewer.file(File(path)),
    );
  }
}
