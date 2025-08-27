import 'package:flutter/material.dart';

class HealthRecordDetailPage extends StatelessWidget {
  final Map<String, dynamic> record;

  const HealthRecordDetailPage({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(record["title"] ?? "Record Detail")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Title: ${record["title"] ?? "N/A"}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              "Date: ${record["date"] ?? "N/A"}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              "Description:",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(record["description"] ?? "No description"),
          ],
        ),
      ),
    );
  }
}
