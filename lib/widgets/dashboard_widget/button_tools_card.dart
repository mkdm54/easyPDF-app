import 'package:flutter/material.dart';
import 'package:easy_pdf/widgets/dashboard_widget/button_tools.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ButtonToolsCard extends StatefulWidget {
  const ButtonToolsCard({super.key});

  @override
  State<ButtonToolsCard> createState() => _ButtonToolsCardState();
}

class _ButtonToolsCardState extends State<ButtonToolsCard> {
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
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color.fromARGB(255, 255, 0, 0),
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
                    onpressed: () {},
                  );
                }).toList(),
          ),
        ),
      ),
    );
  }
}
