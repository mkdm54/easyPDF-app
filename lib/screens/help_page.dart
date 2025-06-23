import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        title: Text("Pusat Bantuan", style: TextStyle(color: Colors.white)),
        backgroundColor: colors.primary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionTitle("📄 PDF Tools"),
          _buildHelpCard(
            context,
            icon: Icons.picture_as_pdf_outlined,
            title: "Cara Menggabungkan PDF",
            description:
                "1️⃣ Tekan tombol *Pilih File PDF*.\n"
                "2️⃣ Pilih beberapa file.\n"
                "3️⃣ Urutkan jika perlu.\n"
                "4️⃣ Tekan *Gabungkan PDF*.",
          ),
          const SizedBox(height: 12),
          _buildHelpCard(
            context,
            icon: Icons.document_scanner_outlined,
            title: "Scan Dokumen jadi PDF",
            description:
                "📷 Gunakan fitur *Document Scanner*.\n"
                "📌 Ambil gambar satu per satu.\n"
                "✅ Tekan *Create PDF* setelah selesai.",
          ),
          const SizedBox(height: 24),
          _buildSectionTitle("📂 File & Tema"),
          _buildHelpCard(
            context,
            icon: Icons.folder_outlined,
            title: "Lokasi File PDF",
            description:
                "📂 Disimpan di:\n"
                "- /storage/emulated/0/easy-pdf/merge-pdf\n"
                "- /storage/emulated/0/easy-pdf/scan-pdf",
          ),
          const SizedBox(height: 12),
          _buildHelpCard(
            context,
            icon: Icons.brightness_6_outlined,
            title: "Ganti Tema",
            description:
                "🌙 Tekan ikon 🌙/☀️ di dashboard untuk mode gelap / terang.",
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

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildHelpCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      shadowColor: colors.primary.withValues(alpha: 0.2),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: colors.onSurface,
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
                  Text(
                    description,
                    style: TextStyle(fontSize: 14, color: colors.surface),
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
