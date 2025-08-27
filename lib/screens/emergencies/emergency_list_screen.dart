import 'package:flutter/material.dart';
import 'dart:convert';
import '../../services/api_service.dart';
import '../../utils/constants.dart';
import './add_emergency_screen.dart';
import 'emergency_detail_screen.dart';

class EmergencyListScreen extends StatefulWidget {
  const EmergencyListScreen({super.key});

  @override
  State<EmergencyListScreen> createState() => _EmergencyListScreenState();
}

class _EmergencyListScreenState extends State<EmergencyListScreen> {
  bool isLoading = true;
  List emergencies = [];

  @override
  void initState() {
    super.initState();
    fetchEmergencies();
  }

  Future<void> fetchEmergencies() async {
    final response = await ApiService.getRequest(ApiConstants.emergencies);
    if (response.statusCode == 200) {
      setState(() {
        emergencies = jsonDecode(response.body);
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to load emergencies")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Emergencies")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : emergencies.isEmpty
          ? const Center(child: Text("No emergencies found"))
          : ListView.builder(
              itemCount: emergencies.length,
              itemBuilder: (context, index) {
                final e = emergencies[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    leading: const Icon(Icons.warning, color: Colors.red),
                    title: Text(e['type'] ?? "Unknown"),
                    subtitle: Text("Location: ${e['location'] ?? 'N/A'}"),
                    trailing: Text(e['status'] ?? "pending"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EmergencyDetailScreen(emergency: e),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final added = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const EmergencyAddScreen()),
          );
          if (added == true) fetchEmergencies();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
