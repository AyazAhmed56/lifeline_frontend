// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'auth/login_screen.dart';
import 'profile_screen.dart';

import 'appointments/appointments_screen.dart';
import 'medicines/medicines_screen.dart';
import 'reports/reports_screen.dart';
import 'health_records/health_records_screen.dart';
import './blood_requests/blood_requests_list_screen.dart';
import './emergencies/emergency_list_screen.dart';
import 'ai/ai_chat_screen.dart';
import 'ai/doctor_suggestion_screen.dart';
import 'ai/timeline_analysis_screen.dart';

import '../services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  String? _emailOrId;

  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _loadUserPreview();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      lowerBound: 0.0,
      upperBound: 0.08,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadUserPreview() async {
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

  void _openPage(Widget page) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => page,
        transitionsBuilder: (_, anim, __, child) {
          return FadeTransition(opacity: anim, child: child);
        },
      ),
    );
  }

  Widget _animatedCard({
    required String title,
    required IconData icon,
    required Color color,
    required Widget page,
    String? imageAsset,
  }) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        _openPage(page);
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(scale: _scaleAnimation.value, child: child);
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.withOpacity(0.9), color],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.6),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (imageAsset != null)
                Hero(
                  tag: title,
                  child: Image.asset(
                    imageAsset,
                    height: 50,
                    width: 50,
                    color: Colors.white,
                  ),
                )
              else
                Icon(icon, size: 50, color: Colors.white),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final modules = [
      {
        "title": "Appointments",
        "icon": Icons.event,
        "color": Colors.purple,
        "page": const AppointmentsScreen(),
        "image": null,
      },
      {
        "title": "Medicines",
        "icon": Icons.local_hospital,
        "color": Colors.orange,
        "page": const MedicinesScreen(),
        "image": null,
      },
      {
        "title": "Reports",
        "icon": Icons.file_copy,
        "color": Colors.green,
        "page": ReportsScreen(),
        "image": null,
      },
      {
        "title": "Health Records",
        "icon": Icons.medical_services,
        "color": Colors.teal,
        "page": const HealthRecordsPage(),
        "image": null,
      },
      {
        "title": "Blood Requests",
        "icon": Icons.bloodtype,
        "color": Colors.red,
        "page": const BloodRequestsListScreen(),
        "image": null,
      },
      {
        "title": "Emergencies",
        "icon": Icons.warning,
        "color": Colors.deepOrange,
        "page": const EmergencyListScreen(),
        "image": null,
      },
      {
        "title": "AI Chat",
        "icon": Icons.chat,
        "color": Colors.blue,
        "page": const AIChatScreen(),
        "image": null,
      },
      {
        "title": "Doctor Suggestion",
        "icon": Icons.medical_information,
        "color": Colors.pink,
        "page": const DoctorSuggestionScreen(),
        "image": null,
      },
      {
        "title": "Timeline Analysis",
        "icon": Icons.timeline,
        "color": Colors.cyan,
        "page": const TimelineAnalysisScreen(),
        "image": null,
      },
    ];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.blueAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _emailOrId ?? "Welcome to Lifeline",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: _openProfile,
                          icon: const Icon(Icons.person, color: Colors.black),
                        ),
                        IconButton(
                          onPressed: _logout,
                          icon: const Icon(Icons.logout, color: Colors.black),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: modules.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.1,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemBuilder: (context, index) {
                    final module = modules[index];
                    return _animatedCard(
                      title: module["title"] as String,
                      icon: module["icon"] as IconData,
                      color: module["color"] as Color,
                      page: module["page"] as Widget,
                      imageAsset: module["image"] as String?,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
