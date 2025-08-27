import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../utils/constants.dart';

class AddHealthRecordPage extends StatefulWidget {
  const AddHealthRecordPage({super.key});

  @override
  State<AddHealthRecordPage> createState() => _AddHealthRecordPageState();
}

class _AddHealthRecordPageState extends State<AddHealthRecordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  bool isSubmitting = false;

  Future<void> submitRecord() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isSubmitting = true);

    final response = await ApiService.postRequest(ApiConstants.healthRecords, {
      "title": titleController.text,
      "description": descriptionController.text,
      "date": dateController.text,
    });

    setState(() => isSubmitting = false);

    if (response.statusCode == 201) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to add health record")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Health Record")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(labelText: "Title"),
                validator: (v) => v == null || v.isEmpty ? "Enter title" : null,
              ),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: "Description"),
                maxLines: 3,
                validator: (v) =>
                    v == null || v.isEmpty ? "Enter description" : null,
              ),
              TextFormField(
                controller: dateController,
                decoration: const InputDecoration(
                  labelText: "Date (YYYY-MM-DD)",
                ),
                validator: (v) => v == null || v.isEmpty ? "Enter date" : null,
              ),
              const SizedBox(height: 20),
              isSubmitting
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: submitRecord,
                      child: const Text("Submit"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
