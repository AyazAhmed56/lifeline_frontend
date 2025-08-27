// lib/screens/profile_screen.dart
// import 'dart:convert';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? _user;
  bool _loading = false;
  String _error = "";

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    setState(() {
      _loading = true;
      _error = "";
    });

    try {
      final res = await AuthService.getProfile();
      setState(() => _user = res["data"]);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    if (_loading) {
      body = const Center(child: CircularProgressIndicator());
    } else if (_error.isNotEmpty) {
      body = Center(child: Text("Error: $_error"));
    } else if (_user == null) {
      body = const Center(child: Text("No profile data"));
    } else {
      body = Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              child: Text(
                (_user?["name"] ?? (_user?["email"] ?? "U"))[0].toUpperCase(),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _user?["name"] ?? "No name",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(_user?["email"] ?? "No email"),
            const SizedBox(height: 8),
            if (_user?.containsKey("phone_no") ?? false)
              Text("Phone: ${_user?["phone_no"]}"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _fetchProfile,
              child: const Text("Refresh"),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("My Profile")),
      body: body,
    );
  }
}
