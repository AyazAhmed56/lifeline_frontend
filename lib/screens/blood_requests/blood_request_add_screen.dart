import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../utils/constants.dart';

class BloodRequestAddScreen extends StatefulWidget {
  const BloodRequestAddScreen({super.key});

  @override
  State<BloodRequestAddScreen> createState() => _BloodRequestAddScreenState();
}

class _BloodRequestAddScreenState extends State<BloodRequestAddScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController hospitalController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController unitsController = TextEditingController();

  String? selectedBloodGroup;
  bool isSubmitting = false;

  final List<String> bloodGroups = [
    "A+",
    "A-",
    "B+",
    "B-",
    "O+",
    "O-",
    "AB+",
    "AB-",
  ];

  Future<void> submitRequest() async {
    if (!_formKey.currentState!.validate() || selectedBloodGroup == null)
      return;

    setState(() => isSubmitting = true);

    final response = await ApiService.postRequest(ApiConstants.bloodRequests, {
      "blood_group": selectedBloodGroup,
      "hospital": hospitalController.text,
      "contact": contactController.text,
      "units": unitsController.text,
    });

    setState(() => isSubmitting = false);

    if (response.statusCode == 201) {
      Navigator.pop(context, true); // success
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to submit request")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Request Blood")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: selectedBloodGroup,
                items: bloodGroups
                    .map((bg) => DropdownMenuItem(value: bg, child: Text(bg)))
                    .toList(),
                onChanged: (val) => setState(() => selectedBloodGroup = val),
                decoration: const InputDecoration(labelText: "Blood Group"),
                validator: (val) =>
                    val == null ? "Please select blood group" : null,
              ),
              TextFormField(
                controller: unitsController,
                decoration: const InputDecoration(labelText: "Units Required"),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? "Enter units required" : null,
              ),
              TextFormField(
                controller: hospitalController,
                decoration: const InputDecoration(labelText: "Hospital Name"),
                validator: (v) => v!.isEmpty ? "Enter hospital name" : null,
              ),
              TextFormField(
                controller: contactController,
                decoration: const InputDecoration(labelText: "Contact Number"),
                keyboardType: TextInputType.phone,
                validator: (v) => v!.isEmpty ? "Enter contact number" : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isSubmitting ? null : submitRequest,
                child: isSubmitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Submit Request"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
