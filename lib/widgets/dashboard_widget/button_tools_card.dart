import 'package:flutter/material.dart';
import 'package:easy_pdf/widgets/dashboard_widget/button_tools.dart';
import 'package:easy_pdf/tools/jpg_to_pdf/jpg_to_pdf_tool.dart';
// import 'package:easy_pdf/tools/edit_pdf/edit_pdf_tool.dart';
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
      MaterialPageRoute(builder: (context) => const JpgToPdfTool()),
    );
  }

  // void _navigateToEditPdfPage() {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => const EditPdfTool()),
  //   );
  // }

  // Fungsi placeholder untuk tools lainnya
  void _showComingSoon(String toolName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$toolName - Coming Soon!'),
        backgroundColor: Colors.blue,
        duration: Duration(seconds: 2),
      ),
    );
  }

  late final List<Map<String, dynamic>> listButtonTools;

  @override
  void initState() {
    super.initState();

    listButtonTools = [
      {
        'icon': Icon(Icons.edit, color: Colors.orange[300], size: 35),
        'label': 'Edit PDF',
        // 'onPressed': () => _navigateToEditPdfPage(),
        'onPressed': () => _showComingSoon('edit PDF'),
      },
      {
        'icon': Icon(Icons.picture_as_pdf, color: Colors.red, size: 35),
        'label': 'JPG to PDF',
        'onPressed': () => _navigateToJpgToPdfPage(),
      },
      {
        'icon': Icon(Icons.image, color: Colors.blue, size: 35),
        'label': 'PDF to JPG',
        'onPressed': () => _showComingSoon('PDF to JPG'),
      },
      {
        'icon': Icon(Icons.camera_alt, color: Colors.green, size: 35),
        'label': 'Scan to PDF',
        'onPressed': () => _showComingSoon('Scan to PDF'),
      },
      {
        'icon': Icon(Icons.compress, color: Colors.pink, size: 35),
        'label': 'Compress Image',
        'onPressed': () => _showComingSoon('Compress Image'),
      },
      {
        'icon': SvgPicture.asset(
          'assets/svg/table_merge_cells_icon.svg',
          width: 35,
          height: 35,
          colorFilter: const ColorFilter.mode(Colors.purple, BlendMode.srcIn),
        ),
        'label': 'Merge PDF',
        'onPressed': () => _showComingSoon('Merge PDF'),
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: colors.surface,
      ),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: SizedBox(
          width: double.infinity,
          height: 230,
          child: GridView.count(
            scrollDirection: Axis.horizontal,
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1,
            children:
                listButtonTools.map((item) {
                  return ButtonTools(
                    icon: item['icon'],
                    label: item['label'],
                    onpressed: item['onPressed'],
                  );
                }).toList(),
          ),
        ),
      ),
    );
  }
}
