import 'dart:io';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _loadPdfFiles();
  }

  Future<void> _loadPdfFiles() async {
    setState(() {
      isLoading = true;
    });

    try {
      final easyPdfDir = Directory('/storage/emulated/0/easy-pdf');
      if (!await easyPdfDir.exists()) {
        await easyPdfDir.create(recursive: true);
      }

      final files = await _scanDirectoryRecursive(easyPdfDir, 1, 5);

      setState(() {
        pdfFiles = files;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal memuat file PDF: $e')));
    }
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
            const SizedBox(height: 12),
            Row(
              children: [
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Cari PDF...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      isDense: true,
                      contentPadding: const EdgeInsets.all(8),
                    ),
                    onChanged: (query) {
                      setState(() {
                        pdfFiles =
                            pdfFiles.where((file) {
                              final name =
                                  file.path.split('/').last.toLowerCase();
                              return name.contains(query.toLowerCase());
                            }).toList();
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Expanded(
              child: RefreshIndicator(
                onRefresh: _loadPdfFiles,
                child: PdfListWidget(
                  pdfFiles: pdfFiles,
                  isLoading: isLoading,
                  onRefresh:
                      _loadPdfFiles,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
