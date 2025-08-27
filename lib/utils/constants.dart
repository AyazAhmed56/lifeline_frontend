import 'package:flutter/material.dart';

class ApiConstants {
  // Base URL (backend host)
  static const String baseUrl = "http://127.0.0.1:8000";

  // Auth
  static const String register = "$baseUrl/api/users/register";
  static const String login = "$baseUrl/api/users/login";

  // Main Endpoints
  static const String appointments = "$baseUrl/api/appointments";
  static const String medicines = "$baseUrl/api/medicines";
  static const String reports = "$baseUrl/api/reports";
  static const String healthRecords = "$baseUrl/api/health_records";
  static const String bloodRequests = "$baseUrl/api/blood_requests";
  static String get emergencies => "$baseUrl/api/emergencies";

  // AI
  static const String aiSummarize = "$baseUrl/api/ai/summarize";
  static const String aiChat = "$baseUrl/agent/chat";
  static const String aiTimeline = "$baseUrl/agent/timeline";

  // Colors
  static const Color primaryColor = Colors.blue;
  static const Color secondaryColor = Colors.green;

  // Default padding
  static const double defaultPadding = 16.0;
}
