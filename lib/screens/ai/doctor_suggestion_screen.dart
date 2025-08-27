import 'dart:convert';
import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../utils/constants.dart';

class DoctorSuggestionScreen extends StatefulWidget {
  const DoctorSuggestionScreen({super.key});

  @override
  State<DoctorSuggestionScreen> createState() => _DoctorSuggestionScreenState();
}

class _DoctorSuggestionScreenState extends State<DoctorSuggestionScreen> {
  final TextEditingController _controller = TextEditingController();
  String? suggestion;
  bool _isLoading = false;

  Future<void> getSuggestion() async {
    if (_controller.text.trim().isEmpty) return;

    setState(() => _isLoading = true);

    final response = await ApiService.postRequest(ApiConstants.aiSummarize, {
      "text": _controller.text,
    });

    setState(() => _isLoading = false);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        suggestion = data['suggestion'] ?? data['summary'] ?? "No suggestion";
      });
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to get suggestion")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Doctor Suggestions")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Enter Symptoms",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: getSuggestion,
              child: const Text("Get Suggestion"),
            ),
            const SizedBox(height: 20),
            if (_isLoading) const CircularProgressIndicator(),
            if (suggestion != null)
              Text(
                suggestion!,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
