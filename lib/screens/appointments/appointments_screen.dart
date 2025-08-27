import 'dart:convert';
import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
import '../../services/api_service.dart';
import 'add_appointment_screen.dart';
import 'appointment_detail_screen.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  List appointments = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAppointments();
  }

  Future<void> fetchAppointments() async {
    try {
      final response = await ApiService.getRequest("/api/appointments");
      if (response.statusCode == 200) {
        setState(() {
          appointments = jsonDecode(response.body);
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching appointments: $e");
    }
  }

  void navigateToAdd() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddAppointmentScreen()),
    );
    if (result == true) fetchAppointments();
  }

  void navigateToDetail(Map appointment) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AppointmentDetailScreen(appointment: appointment),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Appointments")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                final appt = appointments[index];
                return ListTile(
                  title: Text(appt["doctor_name"] ?? "No Doctor"),
                  subtitle: Text(appt["date"] ?? ""),
                  onTap: () => navigateToDetail(appt),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: navigateToAdd,
        child: const Icon(Icons.add),
      ),
    );
  }
}
