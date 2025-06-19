import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_pdf/widgets/button_tools.dart';

class ToolsMenuPage extends StatefulWidget {
  const ToolsMenuPage({super.key});

  @override
  State<ToolsMenuPage> createState() => _ToolsMenuPageState();
}

class _ToolsMenuPageState extends State<ToolsMenuPage> {
  final List<Map<String, dynamic>> listButtonTools = [
    {
      'icon': Icon(Icons.edit, color: Colors.orange[300], size: 35),
      'label': 'Edit PDF',
    },
    {
      'icon': Icon(Icons.picture_as_pdf, color: Colors.red, size: 35),
      'label': 'JPG to PDF',
    },
    {
      'icon': Icon(Icons.image, color: Colors.blue, size: 35),
      'label': 'PDF to JPG',
    },
    {
      'icon': Icon(Icons.compress, color: Colors.pink, size: 35),
      'label': 'Compress Image',
    },
    {
      'icon': Icon(Icons.camera_alt, color: Colors.green, size: 35),
      'label': 'Scan to PDF',
    },
    {
      'icon': SvgPicture.asset(
        'assets/svg/table_merge_cells_icon.svg',
        width: 35,
        height: 35,
        colorFilter: const ColorFilter.mode(Colors.purple, BlendMode.srcIn),
      ),
      'label': 'Merge PDF',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: 24,
              mainAxisSpacing: 24,
              childAspectRatio: 1,
              children:
                  listButtonTools.map((item) {
                    return ButtonTools(
                      icon: item['icon'],
                      label: item['label'],
                      onpressed: () {
                        
                      },
                    );
                  }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
