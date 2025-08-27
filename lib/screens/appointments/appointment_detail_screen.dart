// import 'dart:convert';
import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class AppointmentDetailScreen extends StatefulWidget {
  final Map appointment;
  const AppointmentDetailScreen({super.key, required this.appointment});

  @override
  State<AppointmentDetailScreen> createState() =>
      _AppointmentDetailScreenState();
}

class _AppointmentDetailScreenState extends State<AppointmentDetailScreen> {
  bool isDeleting = false;

  Future<void> deleteAppointment() async {
    setState(() => isDeleting = true);
    final response = await ApiService.deleteRequest(
      "/api/appointments/${widget.appointment['id']}",
    );
    setState(() => isDeleting = false);

    if (response.statusCode == 200) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to delete appointment")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final appt = widget.appointment;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Appointment Detail"),
        actions: [
          IconButton(
            onPressed: isDeleting ? null : deleteAppointment,
            icon: const Icon(Icons.delete, color: Colors.red),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Doctor: ${appt['doctor_name']}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text("Date: ${appt['date']}", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text(
              "Notes: ${appt['notes'] ?? 'No notes'}",
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
