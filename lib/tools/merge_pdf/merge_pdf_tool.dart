import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class MergePdfTool extends StatefulWidget {
  const MergePdfTool({super.key});

  @override
  State<MergePdfTool> createState() => _MergePdfToolState();
}

class _MergePdfToolState extends State<MergePdfTool> {
  List<File> _selectedPdfs = [];
  bool _isMerging = false;

  Future<void> _pickPdfs() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: true,
      );

      if (!mounted) return;

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _selectedPdfs =
              result.files
                  .where((file) => file.path != null)
                  .map((file) => File(file.path!))
                  .toList();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Tidak ada file PDF dipilih")),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error memilih file: $e")));
    }
  }

  Future<void> _mergePdfs() async {
    if (_selectedPdfs.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Pilih file PDF dulu!")));
      return;
    }

    setState(() {
      _isMerging = true;
    });

    try {
      PdfDocument mergedDocument = PdfDocument();

      for (var file in _selectedPdfs) {
        final bytes = await file.readAsBytes();
        final PdfDocument doc = PdfDocument(inputBytes: bytes);

        for (int i = 0; i < doc.pages.count; i++) {
          mergedDocument.pages.add().graphics.drawPdfTemplate(
            doc.pages[i].createTemplate(),
            const Offset(0, 0),
          );
        }

        doc.dispose();
      }

      final dir = Directory('/storage/emulated/0/easy-pdf/merge-pdf');
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }

      final fileName = 'merge_pdf_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final filePath = '${dir.path}/$fileName';
      final fileOut = File(filePath);
      final bytesOut = mergedDocument.saveSync();
      await fileOut.writeAsBytes(bytesOut);
      mergedDocument.dispose();

      if (!mounted) return;
      showDialog(
        context: context,
        builder: (ctx) {
          final colors = Theme.of(ctx).colorScheme; // ✅ Panggil colors di sini

          return AlertDialog(
            backgroundColor: colors.surface,
            title: Text(
              "PDF Berhasil Digabung",
              style: TextStyle(color: colors.onSurface),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "File berhasil disimpan di:",
                  style: TextStyle(color: colors.onSurface),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colors.onSurface,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    filePath,
                    style: TextStyle(fontSize: 12, color: colors.surface),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Ukuran: ${(bytesOut.length / 1024).toStringAsFixed(1)} KB",
                  style: TextStyle(color: colors.onSurface),
                ),
                Text(
                  "Jumlah file digabung: ${_selectedPdfs.length}",
                  style: TextStyle(color: colors.onSurface),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text("OK", style: TextStyle(color: colors.primary)),
              ),
            ],
          );
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal gabung PDF: $e")));
    } finally {
      if (mounted) {
        setState(() {
          _isMerging = false;
        });
      }
    }
  }

  void _removeFile(int index) {
    setState(() {
      _selectedPdfs.removeAt(index);
    });
  }

  void _clearAllFiles() {
    setState(() {
      _selectedPdfs.clear();
    });
  }

  void _reorderFiles(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex--;
      final file = _selectedPdfs.removeAt(oldIndex);
      _selectedPdfs.insert(newIndex, file);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Merge PDF Tool"),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        actions: [
          if (_selectedPdfs.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear_all),
              onPressed: _clearAllFiles,
              tooltip: 'Hapus semua file',
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.purple[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.purple[200]!),
              ),
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/svg/table_merge_cells_icon.svg',
                    width: 50,
                    height: 50,
                    colorFilter: const ColorFilter.mode(
                      Colors.purple,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PDF Merger Tool',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Gabungkan beberapa file PDF menjadi satu file PDF. Urutkan file sesuai keinginan.',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isMerging ? null : _pickPdfs,
                icon: const Icon(Icons.add),
                label: const Text("Pilih File PDF"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child:
                  _selectedPdfs.isNotEmpty
                      ? Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              color: colors.surface,
                              child: Row(
                                children: [
                                  Text(
                                    'File yang dipilih (${_selectedPdfs.length})',
                                    style: TextStyle(
                                      color: colors.onSurface,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    'Tekan & tahan untuk mengatur urutan',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: colors.onSurface,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: ReorderableListView.builder(
                                padding: const EdgeInsets.all(8),
                                itemCount: _selectedPdfs.length,
                                onReorder: _reorderFiles,
                                itemBuilder: (context, index) {
                                  final file = _selectedPdfs[index];
                                  final fileSize = file.lengthSync();
                                  return Container(
                                    key: ValueKey(file.path),
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 2,
                                    ),
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: colors.surface,
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        color: Colors.grey[200]!,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.picture_as_pdf,
                                          color: Colors.red,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          '${index + 1}.',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            file.path.split('/').last,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          '${(fileSize / 1024).toStringAsFixed(1)} KB',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: colors.onSurface,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        GestureDetector(
                                          onTap: () => _removeFile(index),
                                          child: const Icon(
                                            Icons.close,
                                            color: Colors.red,
                                            size: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                      : Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.cloud_upload_outlined,
                                color: Colors.grey,
                                size: 64,
                              ),
                              SizedBox(height: 16),
                              Text(
                                "Belum ada file PDF dipilih",
                                style: TextStyle(color: Colors.grey),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Klik tombol di atas untuk memilih file PDF",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed:
                    (_isMerging || _selectedPdfs.isEmpty) ? null : _mergePdfs,
                icon:
                    _isMerging
                        ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                        : const Icon(Icons.merge_type, size: 20),
                label: Text(_isMerging ? "Memproses..." : "Gabungkan PDF"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(221, 25, 11, 1.0),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
