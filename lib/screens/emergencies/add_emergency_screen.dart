import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../utils/constants.dart';

class EmergencyAddScreen extends StatefulWidget {
  const EmergencyAddScreen({super.key});

  @override
  State<EmergencyAddScreen> createState() => _EmergencyAddScreenState();
}

class _EmergencyAddScreenState extends State<EmergencyAddScreen> {
  final _formKey = GlobalKey<FormState>();
  final typeController = TextEditingController();
  final locationController = TextEditingController();
  final descriptionController = TextEditingController();

  bool isSubmitting = false;

  Future<void> submitEmergency() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isSubmitting = true);

    final response = await ApiService.postRequest(ApiConstants.emergencies, {
      "type": typeController.text,
      "location": locationController.text,
      "description": descriptionController.text,
    });

    setState(() => isSubmitting = false);

    if (response.statusCode == 201) {
      Navigator.pop(context, true); // success
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to submit emergency")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Emergency")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: typeController,
                decoration: const InputDecoration(labelText: "Emergency Type"),
                validator: (v) =>
                    v == null || v.isEmpty ? "Enter emergency type" : null,
              ),
              TextFormField(
                controller: locationController,
                decoration: const InputDecoration(labelText: "Location"),
                validator: (v) =>
                    v == null || v.isEmpty ? "Enter location" : null,
              ),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: "Description"),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              isSubmitting
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: submitEmergency,
                      child: const Text("Submit"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
