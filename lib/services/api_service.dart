// lib/services/api_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class ApiService {
  static const String baseUrl = "http://127.0.0.1:8000"; // main root

  // ---------------- GET ----------------
  static Future<http.Response> getRequest(String endpoint) async {
    final token = await AuthService.getToken();
    return await http.get(Uri.parse(endpoint), headers: _defaultHeaders(token));
  }

  // ---------------- POST ----------------
  static Future<http.Response> postRequest(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final token = await AuthService.getToken();
    return await http.post(
      Uri.parse(endpoint),
      headers: _defaultHeaders(token),
      body: jsonEncode(body),
    );
  }

  // ---------------- PUT ----------------
  static Future<http.Response> putRequest(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final token = await AuthService.getToken();
    return await http.put(
      Uri.parse("$baseUrl$endpoint"),
      headers: _defaultHeaders(token),
      body: jsonEncode(body),
    );
  }

  // ---------------- DELETE ----------------
  static Future<http.Response> deleteRequest(String endpoint) async {
    final token = await AuthService.getToken();
    return await http.delete(
      Uri.parse("$baseUrl$endpoint"),
      headers: _defaultHeaders(token),
    );
  }

  // ---------------- MULTIPART UPLOAD ----------------
  static Future<http.StreamedResponse> multipartRequest({
    required String endpoint,
    required Map<String, String> fields,
    required File file,
    String fileField = "file",
  }) async {
    final token = await AuthService.getToken();
    var request = http.MultipartRequest("POST", Uri.parse("$baseUrl$endpoint"));

    request.headers["Authorization"] = "Bearer $token";
    request.fields.addAll(fields);
    request.files.add(await http.MultipartFile.fromPath(fileField, file.path));

    return await request.send();
  }

  // ---------------- DEFAULT HEADERS ----------------
  static Map<String, String> _defaultHeaders(String? token) {
    final headers = <String, String>{
      "Content-Type": "application/json",
      "Accept": "application/json",
    };
    if (token != null && token.isNotEmpty) {
      headers["Authorization"] = "Bearer $token";
    }
    return headers;
  }
}
