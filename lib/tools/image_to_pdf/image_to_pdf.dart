import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageToPdf extends StatefulWidget {
  const ImageToPdf({super.key});

  @override
  State<ImageToPdf> createState() => _ImageToPdfState();
}

class _ImageToPdfState extends State<ImageToPdf> {
  File? _selectedImage;
  bool _isConverting = false;

  Future<void> _requestStoragePermission() async {
    if (await Permission.manageExternalStorage.isGranted) return;

    var status = await Permission.manageExternalStorage.request();
    if (!status.isGranted) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Izin akses penyimpanan diperlukan")),
      );
    }
  }

  Future<void> _pickImage() async {
    await _requestStoragePermission();

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (!mounted) return;

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        if (file.path != null) {
          setState(() {
            _selectedImage = File(file.path!);
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Error: Path file tidak valid")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Tidak ada gambar dipilih")),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error memilih file: $e")));
    }
  }

  Future<void> _convertToPdf() async {
    if (_selectedImage == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Pilih gambar dulu!")));
      return;
    }

    setState(() {
      _isConverting = true;
    });

    try {
      final pdf = pw.Document();
      final imageBytes = await _selectedImage!.readAsBytes();
      final image = pw.MemoryImage(imageBytes);

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Center(child: pw.Image(image, fit: pw.BoxFit.contain));
          },
        ),
      );

      final dir = Directory('/storage/emulated/0/easy-pdf/image-to-pdf');
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }

      final fileName =
          'image-to-pdf_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final filePath = '${dir.path}/$fileName';
      final file = File(filePath);
      final pdfBytes = await pdf.save();
      await file.writeAsBytes(pdfBytes);

      if (!mounted) return;
      showDialog(
        context: context,
        builder: (ctx) {
          final colors = Theme.of(ctx).colorScheme;
          return AlertDialog(
            backgroundColor: colors.surface,
            title: Text(
              "PDF Berhasil Dibuat",
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
                    style: TextStyle(
                      fontSize: 12,
                      color: colors.surface,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Ukuran: ${(pdfBytes.length / 1024).toStringAsFixed(1)} KB",
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
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      if (mounted) {
        setState(() {
          _isConverting = false;
        });
      }
    }
  }

  void _clearImage() {
    setState(() {
      _selectedImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text("JPG to PDF Tool"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          if (_selectedImage != null)
            IconButton(
              icon: const Icon(Icons.clear_all),
              onPressed: _clearImage,
              tooltip: 'Hapus gambar',
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
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Row(
                children: [
                  const Icon(Icons.image, color: Colors.blue, size: 50),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'JPG to PDF Converter',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Konversi gambar JPG ke file PDF dengan mudah dan cepat.',
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
                onPressed: _isConverting ? null : _pickImage,
                icon: const Icon(Icons.add),
                label: const Text("Pilih Gambar"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
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
                  _selectedImage != null
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
                                    'Gambar yang dipilih',
                                    style: TextStyle(
                                      color: colors.onSurface,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    '${(_selectedImage!.lengthSync() / 1024).toStringAsFixed(1)} KB',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: colors.onSurface,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  children: [
                                    Container(
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
                                            Icons.image,
                                            color: Colors.blue,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              _selectedImage!.path
                                                  .split('/')
                                                  .last,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: colors.onSurface,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: _clearImage,
                                            child: const Icon(
                                              Icons.close,
                                              color: Colors.red,
                                              size: 20,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.file(
                                          _selectedImage!,
                                          fit: BoxFit.contain,
                                          width: double.infinity,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
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
                                "Belum ada gambar dipilih",
                                style: TextStyle(color: Colors.grey),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Klik tombol di atas untuk memilih gambar",
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
                    (_isConverting || _selectedImage == null)
                        ? null
                        : _convertToPdf,
                icon:
                    _isConverting
                        ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                        : const Icon(Icons.picture_as_pdf, size: 20),
                label: Text(_isConverting ? "Memproses..." : "Konversi ke PDF"),
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
