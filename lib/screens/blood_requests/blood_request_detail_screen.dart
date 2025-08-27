import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BloodRequestDetailScreen extends StatelessWidget {
  final Map<String, dynamic> request;
  const BloodRequestDetailScreen({super.key, required this.request});

  Future<void> _callContact(String number) async {
    final Uri uri = Uri(scheme: "tel", path: number);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Blood Request - ${request["blood_group"]}")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hospital: ${request["hospital"]}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text("Units Required: ${request["units"]}"),
            const SizedBox(height: 8),
            Text("Contact: ${request["contact"]}"),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.call),
              label: const Text("Call Contact"),
              onPressed: () => _callContact(request["contact"]),
            ),
          ],
        ),
      ),
    );
  }
}
