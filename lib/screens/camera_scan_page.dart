// 1. Updated CameraScanPage.dart - sesuai dengan struktur navigation Anda
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:image/image.dart' as img;
import 'package:permission_handler/permission_handler.dart';

class CameraScanPage extends StatefulWidget {
  const CameraScanPage({super.key});

  @override
  State<CameraScanPage> createState() => _CameraScanPageState();
}

class _CameraScanPageState extends State<CameraScanPage> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  final List<String> _capturedImagePaths = [];
  bool _isInitialized = false;
  bool _isProcessing = false;
  int _currentCameraIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    // Request camera permission
    final cameraPermission = await Permission.camera.request();
    if (cameraPermission != PermissionStatus.granted) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Camera permission is required to scan documents'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    try {
      _cameras = await availableCameras();
      if (_cameras!.isNotEmpty) {
        _controller = CameraController(
          _cameras![_currentCameraIndex],
          ResolutionPreset.high,
          enableAudio: false,
        );
        await _controller!.initialize();
        if (mounted) {
          setState(() {
            _isInitialized = true;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to initialize camera: $e')),
        );
      }
    }
  }

  Future<void> _switchCamera() async {
    if (_cameras == null || _cameras!.length <= 1) return;

    setState(() {
      _isProcessing = true;
    });

    await _controller?.dispose();
    _currentCameraIndex = (_currentCameraIndex + 1) % _cameras!.length;

    _controller = CameraController(
      _cameras![_currentCameraIndex],
      ResolutionPreset.high,
      enableAudio: false,
    );

    try {
      await _controller!.initialize();
      setState(() {
        _isProcessing = false;
      });
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error switching camera: $e')));
    }
  }

  Future<void> _capturePhoto() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    try {
      setState(() {
        _isProcessing = true;
      });

      final XFile image = await _controller!.takePicture();

      setState(() {
        _capturedImagePaths.add(image.path);
        _isProcessing = false;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '📸 Photo captured! Total: ${_capturedImagePaths.length} pages',
          ),
          backgroundColor: Colors.green,
          action:
              _capturedImagePaths.isNotEmpty
                  ? SnackBarAction(
                    label: 'Create PDF',
                    textColor: Colors.white,
                    onPressed: _createPDF,
                  )
                  : null,
        ),
      );
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Error capturing photo: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _createPDF() async {
    if (_capturedImagePaths.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('📷 No photos to convert. Take some photos first!'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      final pdf = pw.Document();

      for (int i = 0; i < _capturedImagePaths.length; i++) {
        final imagePath = _capturedImagePaths[i];
        final imageFile = File(imagePath);
        final imageBytes = await imageFile.readAsBytes();

        // Decode and optimize image
        final image = img.decodeImage(imageBytes);
        if (image != null) {
          // Resize if too large to optimize PDF size
          final resizedImage = img.copyResize(
            image,
            width: image.width > 1200 ? 1200 : image.width,
          );
          final optimizedBytes = Uint8List.fromList(
            img.encodeJpg(resizedImage, quality: 85),
          );

          final pdfImage = pw.MemoryImage(optimizedBytes);

          pdf.addPage(
            pw.Page(
              pageFormat: PdfPageFormat.a4,
              margin: const pw.EdgeInsets.all(20),
              build: (pw.Context context) {
                return pw.Column(
                  children: [
                    pw.Expanded(
                      child: pw.Center(
                        child: pw.Image(pdfImage, fit: pw.BoxFit.contain),
                      ),
                    ),
                    pw.SizedBox(height: 10),
                    pw.Text(
                      'Page ${i + 1} of ${_capturedImagePaths.length}',
                      style: pw.TextStyle(
                        fontSize: 10,
                        color: PdfColors.grey600,
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        }
      }

      final dir = Directory('/storage/emulated/0/easy-pdf/scan-pdf');
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }
      final timestamp = DateTime.now();
      final formattedTime =
          '${timestamp.day}-${timestamp.month}-${timestamp.year}_${timestamp.hour}-${timestamp.minute}';
      final pdfPath = '${dir.path}/Scanned_Document_$formattedTime.pdf';

      final file = File(pdfPath);
      await file.writeAsBytes(await pdf.save());

      for (String imagePath in _capturedImagePaths) {
        try {
          await File(imagePath).delete();
        } catch (e) {
          // !
        }
      }

      // Clear captured images
      setState(() {
        _capturedImagePaths.clear();
        _isProcessing = false;
      });

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('✅ PDF created successfully!'),
                Text('📄 ${file.path.split('/').last}'),
              ],
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 4),
            action: SnackBarAction(
              label: 'View Dashboard',
              textColor: Colors.white,
              onPressed: () {
                // Navigate to dashboard (index 0)
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              },
            ),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error creating PDF: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _removeLastPhoto() {
    if (_capturedImagePaths.isNotEmpty) {
      // Delete the file
      try {
        File(_capturedImagePaths.last).delete();
      } catch (e) {
        //!
      }

      setState(() {
        _capturedImagePaths.removeLast();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '🗑️ Last photo removed. Remaining: ${_capturedImagePaths.length}',
          ),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  void _clearAllPhotos() {
    if (_capturedImagePaths.isEmpty) return;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Clear All Photos'),
            content: Text(
              'Are you sure you want to remove all ${_capturedImagePaths.length} photos?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  // Delete all files
                  for (String path in _capturedImagePaths) {
                    try {
                      File(path).delete();
                    } catch (e) {
                      //!
                    }
                  }

                  setState(() {
                    _capturedImagePaths.clear();
                  });

                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('🗑️ All photos cleared'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                },
                child: const Text(
                  'Clear All',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    // Clean up any remaining temp files
    for (String path in _capturedImagePaths) {
      try {
        File(path).delete();
      } catch (e) {
        //!
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    if (!_isInitialized) {
      return Scaffold(
        backgroundColor: colors.surface,
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Initializing Camera...'),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera preview
          Positioned.fill(child: CameraPreview(_controller!)),

          // Document scanning overlay
          Positioned.fill(
            child: Container(
              margin: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.8),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
              ),
            ),
          ),

          // Top overlay with info
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '📄 Document Scanner',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (_cameras != null && _cameras!.length > 1)
                        IconButton(
                          onPressed: _isProcessing ? null : _switchCamera,
                          icon: const Icon(
                            Icons.flip_camera_ios,
                            color: Colors.white,
                          ),
                        ),
                    ],
                  ),
                  if (_capturedImagePaths.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '📸 ${_capturedImagePaths.length} pages captured',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Processing indicator
          if (_isProcessing)
            Container(
              color: Colors.black54,
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 16),
                    Text(
                      'Processing...',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 120,
        color: Colors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Clear all photos
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed:
                      _capturedImagePaths.isNotEmpty && !_isProcessing
                          ? _clearAllPhotos
                          : null,
                  icon: Icon(
                    Icons.clear_all,
                    color:
                        _capturedImagePaths.isNotEmpty
                            ? Colors.red
                            : Colors.grey,
                    size: 28,
                  ),
                ),
                Text(
                  'Clear All',
                  style: TextStyle(
                    color:
                        _capturedImagePaths.isNotEmpty
                            ? Colors.red
                            : Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),

            // Remove last photo
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed:
                      _capturedImagePaths.isNotEmpty && !_isProcessing
                          ? _removeLastPhoto
                          : null,
                  icon: Icon(
                    Icons.undo,
                    color:
                        _capturedImagePaths.isNotEmpty
                            ? Colors.orange
                            : Colors.grey,
                    size: 28,
                  ),
                ),
                Text(
                  'Undo',
                  style: TextStyle(
                    color:
                        _capturedImagePaths.isNotEmpty
                            ? Colors.orange
                            : Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),

            // Main capture button
            GestureDetector(
              onTap: _isProcessing ? null : _capturePhoto,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isProcessing ? Colors.grey : Colors.white,
                  border: Border.all(color: Colors.white, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.camera_alt,
                  color: _isProcessing ? Colors.white : Colors.black,
                  size: 35,
                ),
              ),
            ),

            // Gallery/Preview
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    IconButton(
                      onPressed:
                          _capturedImagePaths.isNotEmpty
                              ? () {
                                showDialog(
                                  context: context,
                                  builder:
                                      (context) => AlertDialog(
                                        title: const Text('Captured Photos'),
                                        content: Text(
                                          'You have ${_capturedImagePaths.length} photos ready for PDF conversion.',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed:
                                                () => Navigator.pop(context),
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              _createPDF();
                                            },
                                            child: const Text('Create PDF'),
                                          ),
                                        ],
                                      ),
                                );
                              }
                              : null,
                      icon: Icon(
                        Icons.photo_library,
                        color:
                            _capturedImagePaths.isNotEmpty
                                ? Colors.blue
                                : Colors.grey,
                        size: 28,
                      ),
                    ),
                    if (_capturedImagePaths.isNotEmpty)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${_capturedImagePaths.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                Text(
                  'Gallery',
                  style: TextStyle(
                    color:
                        _capturedImagePaths.isNotEmpty
                            ? Colors.blue
                            : Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),

            // Create PDF
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed:
                      _capturedImagePaths.isNotEmpty && !_isProcessing
                          ? _createPDF
                          : null,
                  icon: Icon(
                    Icons.picture_as_pdf,
                    color:
                        _capturedImagePaths.isNotEmpty
                            ? Colors.green
                            : Colors.grey,
                    size: 28,
                  ),
                ),
                Text(
                  'Create PDF',
                  style: TextStyle(
                    color:
                        _capturedImagePaths.isNotEmpty
                            ? Colors.green
                            : Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
