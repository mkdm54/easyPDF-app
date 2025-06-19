import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_pdf/widgets/dashboard_widget/button_tools.dart';
import 'package:easy_pdf/widgets/content_container.dart';

class DashboardContent extends StatefulWidget {
  const DashboardContent({super.key});

  @override
  State<DashboardContent> createState() => _DashboardContentState();
}

class _DashboardContentState extends State<DashboardContent> {
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
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      body: ContentContainer(
        child: Column(
          children: [

            // text
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Tools',
                  style: TextStyle(fontSize: 20, color: colors.onSurface),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[200],
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
            ),
          ],
        ),
      ),
    );
  }
}
