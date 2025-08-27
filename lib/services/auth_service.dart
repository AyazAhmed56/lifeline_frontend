// lib/services/auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = "http://127.0.0.1:8000/api";
  static const String _tokenKey = "auth_token";

  // Save JWT token
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  // Get JWT token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Logout
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  // ---------------- Register ----------------
  static Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password, {
    int? age,
    String? bloodGroup,
    String? phoneNo,
  }) async {
    final url = Uri.parse("$baseUrl/users");
    final body = {
      "name": name,
      "email": email,
      "password": password,
      if (age != null) "age": age,
      if (bloodGroup != null) "blood_group": bloodGroup,
      if (phoneNo != null) "phone_no": phoneNo,
    };

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception(
        "Register failed (${response.statusCode}): ${response.body}",
      );
    }
  }

  // ---------------- Login ----------------
  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    final url = Uri.parse("$baseUrl/users/login");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final token = data["access_token"];
      if (token != null && token is String) {
        await saveToken(token);
      }
      return data;
    } else {
      throw Exception(
        "Login failed (${response.statusCode}): ${response.body}",
      );
    }
  }

  // ---------------- Get Profile (/me) ----------------
  static Future<Map<String, dynamic>> getProfile() async {
    final token = await getToken();
    if (token == null) throw Exception("User not logged in");

    final url = Uri.parse("$baseUrl/users/me");
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception(
        "Failed to fetch profile (${response.statusCode}): ${response.body}",
      );
    }
  }
}
