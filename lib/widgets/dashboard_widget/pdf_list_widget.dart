import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PdfListWidget extends StatelessWidget {
  final List<File> pdfFiles;
  final bool isLoading;
  final VoidCallback onRefresh;

  const PdfListWidget({
    super.key,
    required this.pdfFiles,
    required this.isLoading,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (pdfFiles.isEmpty) {
      return SingleChildScrollView(
        child: Center(
          // <-- ini memastikan isinya di tengah horizontal
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off,
                  size: 80,
                  color: colors.primary.withValues(alpha: 0.6),
                ),
                const SizedBox(height: 16),
                Text(
                  "Tidak ada PDF yang ditemukan",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: colors.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 5),
                Text(
                  "Silakan tambahkan file PDF untuk ditampilkan di sini.",
                  style: TextStyle(
                    fontSize: 14,
                    color: colors.onSurfaceVariant.withValues(alpha: 0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: pdfFiles.length,
      itemBuilder: (context, index) {
        final file = pdfFiles[index];
        final fileName = file.path.split('/').last;
        final filePath = file.path;

        return FutureBuilder<DateTime>(
          future: file.lastModified(),
          builder: (context, snapshot) {
            String dateStr = 'Loading date...';
            if (snapshot.hasData) {
              final date = snapshot.data!;
              dateStr = DateFormat('dd MMM yyyy HH:mm').format(date);
            }

            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => Scaffold(
                            appBar: AppBar(title: Text(fileName)),
                            body: SfPdfViewer.file(file),
                          ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/svg/app_icon.svg',
                        width: 40,
                        height: 40,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              fileName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              filePath,
                              style: TextStyle(
                                fontSize: 12,
                                color: colors.onSurfaceVariant,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Modified: $dateStr',
                              style: const TextStyle(
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
