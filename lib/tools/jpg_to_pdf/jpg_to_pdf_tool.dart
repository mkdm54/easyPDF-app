import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';

class JpgToPdfTool extends StatefulWidget {
  const JpgToPdfTool({super.key});

  @override
  State<JpgToPdfTool> createState() => _JpgToPdfToolState();
}

class _JpgToPdfToolState extends State<JpgToPdfTool> {
  File? _selectedImage;
  bool _isConverting = false;

  Future<void> _pickImage() async {
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

      Directory? dir = await getExternalStorageDirectory();
      dir ??= await getApplicationDocumentsDirectory();

      final fileName =
          'jpg_to_pdf_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final filePath = '${dir.path}/$fileName';
      final file = File(filePath);
      await file.writeAsBytes(await pdf.save());

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("PDF berhasil disimpan di: $filePath"),
          duration: const Duration(seconds: 5),
        ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("JPG to PDF Tool"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.image, color: Colors.blue, size: 100),
                  const SizedBox(width: 8),
                  const Flexible(
                    child: Text(
                      'Konversi gambar JPG ke file PDF dengan mudah dan cepat.',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _isConverting ? null : _pickImage,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 24,
                ),
                decoration: BoxDecoration(
                  color: _isConverting ? Colors.grey : Colors.blue,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withValues(alpha: 0.5),
                      blurRadius: 4,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    "Pilih Gambar",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _selectedImage != null
                ? Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      _selectedImage!,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.contain,
                    ),
                  ),
                )
                : Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      "Belum ada gambar dipilih",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: _isConverting ? null : _convertToPdf,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 24,
                ),
                decoration: BoxDecoration(
                  color: _isConverting ? Colors.grey : Colors.green,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: (_isConverting ? Colors.grey : Colors.green)
                          .withValues(alpha: 0.5),
                      blurRadius: 4,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
                child: Center(
                  child:
                      _isConverting
                          ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                          : const Text(
                            "Konversi ke PDF",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
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
