import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../services/api_service.dart';
import '../../utils/constants.dart';

class AddReportScreen extends StatefulWidget {
  @override
  _AddReportScreenState createState() => _AddReportScreenState();
}

class _AddReportScreenState extends State<AddReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  File? selectedFile;
  bool isSubmitting = false;

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'png'],
    );
    if (result != null && result.files.single.path != null) {
      setState(() => selectedFile = File(result.files.single.path!));
    }
  }

  Future<void> uploadReport() async {
    if (!_formKey.currentState!.validate() || selectedFile == null) return;

    setState(() => isSubmitting = true);

    final response = await ApiService.multipartRequest(
      endpoint: ApiConstants.reports,
      fields: {
        "title": titleController.text,
        "description": descriptionController.text,
      },
      file: selectedFile!,
    );

    setState(() => isSubmitting = false);

    if (response.statusCode == 201) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to upload report")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Upload Report")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(labelText: "Report Title"),
                validator: (value) => value!.isEmpty ? "Enter title" : null,
              ),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: "Description"),
              ),
              SizedBox(height: 16),
              ElevatedButton.icon(
                icon: Icon(Icons.attach_file),
                label: Text(
                  selectedFile == null ? "Choose File" : "File Selected",
                ),
                onPressed: pickFile,
              ),
              SizedBox(height: 20),
              isSubmitting
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: uploadReport,
                      child: Text("Upload Report"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
