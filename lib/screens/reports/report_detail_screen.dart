import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utils/constants.dart';

class ReportDetailScreen extends StatelessWidget {
  final Map report;

  ReportDetailScreen({required this.report});

  Future<void> openFile() async {
    final url = "${ApiConstants.baseUrl}/${report['file_url']}";
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Report Details")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Title: ${report["title"] ?? "N/A"}",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text("Date: ${report["date"] ?? "N/A"}"),
            SizedBox(height: 8),
            Text("Description: ${report["description"] ?? "None"}"),
            SizedBox(height: 20),
            ElevatedButton.icon(
              icon: Icon(Icons.open_in_new),
              label: Text("Open File"),
              onPressed: openFile,
            ),
          ],
        ),
      ),
    );
  }
}
