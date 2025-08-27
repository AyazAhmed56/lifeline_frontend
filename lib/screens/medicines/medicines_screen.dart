// lib/screens/medicines/medicines_screen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import 'add_medicine_screen.dart';
import 'medicine_detail_screen.dart';

class MedicinesScreen extends StatefulWidget {
  const MedicinesScreen({super.key});

  @override
  State<MedicinesScreen> createState() => _MedicinesScreenState();
}

class _MedicinesScreenState extends State<MedicinesScreen> {
  List medicines = [];
  bool loading = true;
  String error = "";

  @override
  void initState() {
    super.initState();
    fetchMedicines();
  }

  Future<void> fetchMedicines() async {
    setState(() {
      loading = true;
      error = "";
    });
    try {
      final res = await ApiService.getRequest("/api/medicines");
      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        // backend may return list or {data: [...]}
        setState(() {
          medicines = body is List ? body : (body['data'] ?? body);
          loading = false;
        });
      } else {
        setState(() {
          error = "Failed to load (${res.statusCode})";
          loading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = e.toString();
        loading = false;
      });
    }
  }

  void openAdd() async {
    final created = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddMedicineScreen()),
    );
    if (created == true) fetchMedicines();
  }

  void openDetail(Map item) async {
    final changed = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => MedicineDetailScreen(medicine: item)),
    );
    if (changed == true) fetchMedicines();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Medicines")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : error.isNotEmpty
          ? Center(child: Text("Error: $error"))
          : medicines.isEmpty
          ? const Center(child: Text("No medicines found"))
          : RefreshIndicator(
              onRefresh: fetchMedicines,
              child: ListView.builder(
                itemCount: medicines.length,
                itemBuilder: (context, i) {
                  final m = medicines[i];
                  return ListTile(
                    title: Text(m['name'] ?? "Unnamed"),
                    subtitle: Text(
                      "${m['dosage'] ?? ''} • ${m['frequency'] ?? ''}",
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => openDetail(m),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: openAdd,
        child: const Icon(Icons.add),
      ),
    );
  }
}
