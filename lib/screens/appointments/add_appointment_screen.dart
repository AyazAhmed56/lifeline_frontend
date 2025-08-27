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
  final dateCtrl = TextEditingController();
  final notesCtrl = TextEditingController();

  bool isLoading = false;

  Future<void> addAppointment() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final response = await ApiService.postRequest("/api/appointments", {
      "doctor_name": doctorCtrl.text,
      "date": dateCtrl.text,
      "notes": notesCtrl.text,
    });

    setState(() => isLoading = false);

    if (response.statusCode == 201) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to add appointment")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Appointment")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: doctorCtrl,
                decoration: const InputDecoration(labelText: "Doctor Name"),
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
              TextFormField(
                controller: dateCtrl,
                decoration: const InputDecoration(
                  labelText: "Date (YYYY-MM-DD)",
                ),
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
              TextFormField(
                controller: notesCtrl,
                decoration: const InputDecoration(labelText: "Notes"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isLoading ? null : addAppointment,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Save"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
