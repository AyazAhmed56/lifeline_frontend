// lib/screens/medicines/medicine_detail_screen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class MedicineDetailScreen extends StatefulWidget {
  final Map medicine;
  const MedicineDetailScreen({super.key, required this.medicine});

  @override
  State<MedicineDetailScreen> createState() => _MedicineDetailScreenState();
}

class _MedicineDetailScreenState extends State<MedicineDetailScreen> {
  bool deleting = false;
  bool loading = false;
  Map? med;

  @override
  void initState() {
    super.initState();
    med = widget.medicine;
  }

  Future<void> deleteMedicine() async {
    setState(() => deleting = true);
    try {
      final res = await ApiService.deleteRequest(
        "/api/medicines/${med!['id']}",
      );
      if (res.statusCode == 200) {
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Delete failed: ${res.statusCode}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => deleting = false);
    }
  }

  // Optional: refresh details from server
  Future<void> refresh() async {
    setState(() {
      loading = true;
    });
    try {
      final res = await ApiService.getRequest("/api/medicines/${med!['id']}");
      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        setState(() {
          med = body is Map ? body : (body['data'] ?? body);
        });
      }
    } catch (_) {}
    if (mounted)
      setState(() {
        loading = false;
      });
  }

  @override
  Widget build(BuildContext context) {
    final m = med!;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Medicine Detail"),
        actions: [
          IconButton(
            onPressed: deleting ? null : deleteMedicine,
            icon: deleting
                ? const CircularProgressIndicator()
                : const Icon(Icons.delete),
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    m['name'] ?? "Unnamed",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text("Dosage: ${m['dosage'] ?? '-'}"),
                  const SizedBox(height: 6),
                  Text("Frequency: ${m['frequency'] ?? '-'}"),
                  const SizedBox(height: 6),
                  Text("Start: ${m['start_date'] ?? '-'}"),
                  const SizedBox(height: 6),
                  Text("End: ${m['end_date'] ?? '-'}"),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: refresh,
                    child: const Text("Refresh"),
                  ),
                ],
              ),
            ),
    );
  }
}
