import 'dart:convert';
import 'package:http/http.dart' as http;

class Helpers {
  // Parse backend error message safely
  static String parseError(http.Response response) {
    try {
      final data = jsonDecode(response.body);
      return data["detail"] ?? "Unknown error occurred";
    } catch (_) {
      return "Something went wrong";
    }
  }

  // Format date (e.g. YYYY-MM-DD)
  static String formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }
}
