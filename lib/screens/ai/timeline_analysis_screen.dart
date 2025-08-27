import 'dart:convert';
import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../utils/constants.dart';

class TimelineAnalysisScreen extends StatefulWidget {
  const TimelineAnalysisScreen({super.key});

  @override
  State<TimelineAnalysisScreen> createState() => _TimelineAnalysisScreenState();
}

class _TimelineAnalysisScreenState extends State<TimelineAnalysisScreen> {
  bool _isLoading = false;
  String? analysis;

  Future<void> fetchTimelineAnalysis() async {
    setState(() => _isLoading = true);

    final response = await ApiService.getRequest(ApiConstants.aiTimeline);

    setState(() => _isLoading = false);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        analysis = data['analysis'] ?? "No analysis available";
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to fetch timeline analysis")),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchTimelineAnalysis();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Timeline Analysis")),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : analysis != null
            ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(analysis!, style: const TextStyle(fontSize: 16)),
              )
            : const Text("No analysis yet"),
      ),
    );
  }
}
