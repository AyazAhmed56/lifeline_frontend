// lib/screens/medicines/add_medicine_screen.dart
import 'package:flutter/material.dart';
import '../../services/api_service.dart';
// import '../../utils/helpers.dart'; // optional if you have helpers; remove if not

class AddMedicineScreen extends StatefulWidget {
  const AddMedicineScreen({super.key});

  @override
  State<AddMedicineScreen> createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends State<AddMedicineScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController dosageCtrl = TextEditingController();
  final TextEditingController freqCtrl = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;
  bool isLoading = false;

  Future<void> pickDate(bool isStart) async {
    final now = DateTime.now();
    final chosen = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );
    if (chosen != null) {
      setState(() {
        if (isStart)
          startDate = chosen;
        else
          endDate = chosen;
      });
    }
  }

  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => isLoading = true);

    final body = {
      "name": nameCtrl.text.trim(),
      "dosage": dosageCtrl.text.trim(),
      "frequency": freqCtrl.text.trim(),
      "start_date": startDate != null
          ? startDate!.toIso8601String().split('T')[0]
          : null,
      "end_date": endDate != null
          ? endDate!.toIso8601String().split('T')[0]
          : null,
    };

    try {
      final res = await ApiService.postRequest("/api/medicines", body);
      if (res.statusCode == 201 || res.statusCode == 200) {
        Navigator.pop(context, true);
      } else {
        final msg = "Failed (${res.statusCode}) ${res.body}";
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(msg)));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    dosageCtrl.dispose();
    freqCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String fmt(DateTime? d) => d == null
        ? "Choose"
        : "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";

    return Scaffold(
      appBar: AppBar(title: const Text("Add Medicine")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: "Medicine name"),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? "Required" : null,
              ),
              TextFormField(
                controller: dosageCtrl,
                decoration: const InputDecoration(
                  labelText: "Dosage (e.g. 500mg)",
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? "Required" : null,
              ),
              TextFormField(
                controller: freqCtrl,
                decoration: const InputDecoration(
                  labelText: "Frequency (e.g. 2 times/day)",
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => pickDate(true),
                      child: Text("Start: ${fmt(startDate)}"),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => pickDate(false),
                      child: Text("End: ${fmt(endDate)}"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              isLoading
                  ? const CircularProgressIndicator()
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: submit,
                        child: const Text("Save Medicine"),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
