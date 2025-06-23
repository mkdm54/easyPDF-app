import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:easy_pdf/widgets/dashboard_widget/button_tools.dart';
import 'package:easy_pdf/tools/image_to_pdf/image_to_pdf.dart';
import 'package:easy_pdf/tools/merge_pdf/merge_pdf_tool.dart';
import 'package:easy_pdf/tools/open_pdf/open_pdf_viewer.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ButtonToolsCard extends StatefulWidget {
  const ButtonToolsCard({super.key});

  @override
  State<ButtonToolsCard> createState() => _ButtonToolsCardState();
}

class _ButtonToolsCardState extends State<ButtonToolsCard> {
  void _navigateToJpgToPdfPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ImageToPdf()),
    );
  }

  void _navigateToMergePdfTool() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MergePdfTool()),
    );
  }

  void _pickPdfAndOpen() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (!mounted) return;

    if (result != null && result.files.single.path != null) {
      final filePath = result.files.single.path!;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OpenPdfViewer(path: filePath)),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Tidak ada file dipilih")));
    }
  }

  late final List<Map<String, dynamic>> listButtonTools;

  @override
  void initState() {
    super.initState();

    listButtonTools = [
      {
        'icon': Icon(Icons.picture_as_pdf, color: Colors.blue, size: 35),
        'label': 'JPG to PDF',
        'onPressed': () => _navigateToJpgToPdfPage(),
      },
      {
        'icon': Icon(Icons.remove_red_eye, color: Colors.red, size: 35),
        'label': 'Open PDF',
        'onPressed': () => _pickPdfAndOpen(),
      },
      {
        'icon': SvgPicture.asset(
          'assets/svg/table_merge_cells_icon.svg',
          width: 35,
          height: 35,
          colorFilter: const ColorFilter.mode(Colors.purple, BlendMode.srcIn),
        ),
        'label': 'Merge PDF',
        'onPressed': () => _navigateToMergePdfTool(),
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth =
        (screenWidth - 20) /
        3;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: colors.surface,
      ),
      child: SizedBox(
        height: 120,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: listButtonTools.length,
          separatorBuilder: (_, __) => const SizedBox(width: 5),
          itemBuilder: (context, index) {
            final item = listButtonTools[index];
            return SizedBox(
              width: itemWidth,
              child: ButtonTools(
                icon: item['icon'],
                label: item['label'],
                onpressed: item['onPressed'],
              ),
            );
          },
        ),
      ),
    );
  }
}
