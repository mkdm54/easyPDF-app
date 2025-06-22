import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:easy_pdf/widgets/content_container.dart';
import 'package:easy_pdf/widgets/dashboard_widget/button_tools_card.dart';
import 'package:easy_pdf/widgets/dashboard_widget/pdf_list_widget.dart';

class DashboardContent extends StatefulWidget {
  const DashboardContent({super.key});

  @override
  State<DashboardContent> createState() => _DashboardContentState();
}

class _DashboardContentState extends State<DashboardContent> {
  List<File> pdfFiles = [];
  bool isLoading = true;
  String debugInfo = '';

  @override
  void initState() {
    super.initState();
    _loadPdfFiles();
  }

  Future<void> _loadPdfFiles() async {
    setState(() {
      isLoading = true;
      debugInfo = 'Loading...';
    });

    List<File> allPdfs = [];
    List<String> searchPaths = [];

    try {
      final appDocDir = await getApplicationDocumentsDirectory();
      searchPaths.add('App Documents: ${appDocDir.path}');
      allPdfs.addAll(await _scanDirectory(appDocDir));

      final appSupportDir = await getApplicationSupportDirectory();
      searchPaths.add('App Support: ${appSupportDir.path}');
      allPdfs.addAll(await _scanDirectory(appSupportDir));

      final externalDir = await getExternalStorageDirectory();
      if (externalDir != null) {
        searchPaths.add('External Storage: ${externalDir.path}');
        allPdfs.addAll(await _scanDirectory(externalDir));
      }

      final tempDir = await getTemporaryDirectory();
      searchPaths.add('Temp: ${tempDir.path}');
      allPdfs.addAll(await _scanDirectory(tempDir));

      final uniquePdfs = <String, File>{};
      for (final pdf in allPdfs) {
        uniquePdfs[pdf.path] = pdf;
      }

      setState(() {
        pdfFiles = uniquePdfs.values.toList();
        isLoading = false;
        debugInfo =
            'Searched paths:\n${searchPaths.join('\n')}\n\nFound ${pdfFiles.length} PDF files';
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        debugInfo = 'Error: $e\n\nSearched paths:\n${searchPaths.join('\n')}';
      });
    }
  }

  Future<List<File>> _scanDirectory(Directory dir) async {
    List<File> pdfs = [];
    try {
      if (!await dir.exists()) return pdfs;
      final files = await dir.list().toList();

      for (final entity in files) {
        if (entity is File && entity.path.toLowerCase().endsWith('.pdf')) {
          pdfs.add(entity);
        } else if (entity is Directory) {
          pdfs.addAll(await _scanDirectoryRecursive(entity, 1, 2));
        }
      }
    } catch (_) {}
    return pdfs;
  }

  Future<List<File>> _scanDirectoryRecursive(
    Directory dir,
    int currentDepth,
    int maxDepth,
  ) async {
    List<File> pdfs = [];
    if (currentDepth > maxDepth) return pdfs;

    try {
      if (!await dir.exists()) return pdfs;
      final files = await dir.list().toList();

      for (final entity in files) {
        if (entity is File && entity.path.toLowerCase().endsWith('.pdf')) {
          pdfs.add(entity);
        } else if (entity is Directory) {
          pdfs.addAll(
            await _scanDirectoryRecursive(entity, currentDepth + 1, maxDepth),
          );
        }
      }
    } catch (_) {}
    return pdfs;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      body: ContentContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Tools',
                  style: TextStyle(fontSize: 20, color: colors.onSurface),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ButtonToolsCard(),
            const SizedBox(height: 20),
            Expanded(
              child: PdfListWidget(
                pdfFiles: pdfFiles,
                debugInfo: debugInfo,
                isLoading: isLoading,
                onRefresh: _loadPdfFiles,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
