import 'package:flutter/material.dart';

class EmergencyDetailScreen extends StatelessWidget {
  final Map emergency;
  const EmergencyDetailScreen({super.key, required this.emergency});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(emergency['type'] ?? "Emergency Detail")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Type: ${emergency['type'] ?? 'N/A'}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text("Location: ${emergency['location'] ?? 'N/A'}"),
            const SizedBox(height: 10),
            Text("Status: ${emergency['status'] ?? 'pending'}"),
            const SizedBox(height: 10),
            Text("Description: ${emergency['description'] ?? 'No details'}"),
          ],
        ),
      ),
    );
  }
}
