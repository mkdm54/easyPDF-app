import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text(
          "Pusat Bantuan",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: colors.primary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionTitleWithIcon(
            Icons.picture_as_pdf_outlined,
            "PDF Tools",
          ),
          _buildHelpCardWithList(
            context,
            icon: Icons.picture_as_pdf_outlined,
            title: "Cara Menggabungkan PDF",
            steps: [
              Row(
                children: [
                  const Icon(Icons.touch_app, size: 16),
                  const SizedBox(width: 4),
                  const Text("Tekan tombol *Pilih File PDF*."),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.file_present_outlined, size: 16),
                  const SizedBox(width: 4),
                  const Text("Pilih beberapa file."),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.sort, size: 16),
                  const SizedBox(width: 4),
                  const Text("Urutkan jika perlu."),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.merge_type, size: 16),
                  const SizedBox(width: 4),
                  const Text("Tekan *Gabungkan PDF*."),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildHelpCardWithList(
            context,
            icon: Icons.document_scanner_outlined,
            title: "Scan Dokumen jadi PDF",
            steps: [
              Row(
                children: [
                  const Icon(Icons.camera_alt_outlined, size: 16),
                  const SizedBox(width: 4),
                  const Text("Gunakan fitur *Document Scanner*."),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.image_outlined, size: 16),
                  const SizedBox(width: 4),
                  const Text("Ambil gambar satu per satu."),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.picture_as_pdf, size: 16),
                  const SizedBox(width: 4),
                  const Text("Tekan *Create PDF* setelah selesai."),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),

          _buildSectionTitleWithIcon(Icons.folder_outlined, "File & Tema"),
          _buildHelpCardWithList(
            context,
            icon: Icons.folder_outlined,
            title: "Lokasi File PDF",
            steps: [
              const Text("Disimpan di:"),
              const Text("- /storage/emulated/0/easy-pdf/merge-pdf"),
              const Text("- /storage/emulated/0/easy-pdf/scan-pdf"),
              const Text("- /storage/emulated/0/easy-pdf/image-to-pdf"),
            ],
          ),
          const SizedBox(height: 12),
          _buildHelpCardWithList(
            context,
            icon: Icons.brightness_6_outlined,
            title: "Ganti Tema",
            steps: [
              Wrap(
                children: [
                  const Icon(Icons.dark_mode_outlined, size: 16),
                  const SizedBox(width: 4),
                  const Text(
                    "Tekan ikon 🌙/☀️ di dashboard untuk mode gelap / terang.",
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),

          _buildSectionTitleWithIcon(Icons.phone_outlined, "Kontak Developer"),
          _buildHelpCardWithList(
            context,
            icon: Icons.email_outlined,
            title: "Email Developer",
            steps: [
              GestureDetector(
                onTap: () async {
                  final Uri emailUri = Uri(
                    scheme: 'mailto',
                    path: 'mkdmvx9@gmail.com',
                    query:
                        'subject=Pertanyaan%20Aplikasi&body=Halo%20Developer,',
                  );
                  if (await canLaunchUrl(emailUri)) {
                    await launchUrl(emailUri);
                  } else {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Tidak dapat membuka email'),
                        ),
                      );
                    }
                  }
                },
                child: Row(
                  children: [
                    const Icon(Icons.email_outlined, size: 16),
                    const SizedBox(width: 4),
                    Text('kirim ke: '),
                    Text(
                      "mkdmvx9@gmail.com",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          Center(
            child: Text(
              "Versi Aplikasi: 1.0.0",
              style: TextStyle(fontSize: 12, color: colors.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitleWithIcon(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 6),
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpCardWithList(
    BuildContext context, {
    required IconData icon,
    required String title,
    required List<Widget> steps,
  }) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      shadowColor: colors.primary.withValues(alpha: 0.2),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: colors.primary.withValues(alpha: 0.1),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 32, color: colors.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: colors.primary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  ...steps.map(
                    (step) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: step,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
