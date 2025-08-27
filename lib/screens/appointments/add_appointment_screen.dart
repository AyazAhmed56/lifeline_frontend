import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class AddAppointmentScreen extends StatefulWidget {
  const AddAppointmentScreen({super.key});
  @override
  State<AddAppointmentScreen> createState() => _AddAppointmentScreenState();
}

class _AddAppointmentScreenState extends State<AddAppointmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final doctorCtrl = TextEditingController();
  final hospitalCtrl = TextEditingController();
  final dateCtrl = TextEditingController();

  bool isLoading = false;

  Future<void> addAppointment() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      // Validate date format
      final date = DateTime.tryParse(dateCtrl.text.trim());
      if (date == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid date format. Use YYYY-MM-DD.")),
        );
        setState(() => isLoading = false);
        return;
      }

      final body = {
        "doctor_name": doctorCtrl.text.trim(),
        "hospital_name": hospitalCtrl.text.trim(),
        "appointment_date": date.toIso8601String().split("T")[0], // YYYY-MM-DD
        "status": "pending",
      };

      final response = await ApiService.postRequest("/api/appointments/", body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Appointment added successfully!")),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed: ${response.statusCode} ${response.body}"),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    doctorCtrl.dispose();
    hospitalCtrl.dispose();
    dateCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Appointment")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: doctorCtrl,
                decoration: const InputDecoration(
                  labelText: "Doctor Name",
                  prefixIcon: Icon(Icons.medical_services),
                ),
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: hospitalCtrl,
                decoration: const InputDecoration(
                  labelText: "Hospital Name",
                  prefixIcon: Icon(Icons.local_hospital),
                ),
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: dateCtrl,
                decoration: const InputDecoration(
                  labelText: "Appointment Date (YYYY-MM-DD)",
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: isLoading ? null : addAppointment,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  backgroundColor: Colors.purple,
                ),
                child: isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      )
                    : const Text(
                        "Save Appointment",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
