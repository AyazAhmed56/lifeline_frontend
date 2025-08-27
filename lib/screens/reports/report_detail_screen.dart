import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utils/constants.dart';

class ReportDetailScreen extends StatelessWidget {
  final Map report;
  const ReportDetailScreen({super.key, required this.report});

  Future<void> openFile() async {
    if (report['file_url'] == null) return;
    final url = "${ApiConstants.baseUrl}/${report['file_url']}";
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Report Details")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Title: ${report["title"] ?? "N/A"}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text("Date: ${report["date"] ?? "N/A"}"),
            const SizedBox(height: 8),
            Text("Description: ${report["description"] ?? "None"}"),
            const SizedBox(height: 20),
            if (report['file_url'] != null)
              ElevatedButton.icon(
                icon: const Icon(Icons.open_in_new),
                label: const Text("Open File"),
                onPressed: openFile,
              ),
          ],
        ),
      ),
    );
  }
}
