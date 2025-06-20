import 'package:flutter/material.dart';
import 'package:easy_pdf/widgets/content_container.dart';
import 'package:easy_pdf/widgets/dashboard_widget/button_tools_card.dart';

class DashboardContent extends StatefulWidget {
  const DashboardContent({super.key});

  @override
  State<DashboardContent> createState() => _DashboardContentState();
}

class _DashboardContentState extends State<DashboardContent> {
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
            ButtonToolsCard(),
          ],
        ),
      ),
    );
  }
}
