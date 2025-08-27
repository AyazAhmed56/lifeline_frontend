// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'auth/login_screen.dart';
import 'profile_screen.dart';
import '../services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _emailOrId;

  @override
  void initState() {
    super.initState();
    _loadUserPreview();
  }

  Future<void> _loadUserPreview() async {
    // If your backend returns user info in token or you saved it elsewhere,
    // you can fetch profile for display. For now we'll try to read token to show non-empty state.
    final token = await AuthService.getToken();
    setState(() {
      _emailOrId = token != null ? "Logged in" : null;
    });
  }

  Future<void> _logout() async {
    await AuthService.logout();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }

  void _openProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ProfileScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lifeline - Home"),
        actions: [
          IconButton(onPressed: _openProfile, icon: const Icon(Icons.person)),
          IconButton(onPressed: _logout, icon: const Icon(Icons.logout)),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(Icons.health_and_safety, size: 80),
            const SizedBox(height: 16),
            Text(
              _emailOrId ?? "Welcome to Lifeline",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _openProfile,
              child: const Text("Open Profile"),
            ),
          ],
        ),
      ),
    );
  }
}
