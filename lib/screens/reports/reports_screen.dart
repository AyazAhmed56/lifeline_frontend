import 'dart:convert';
import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../utils/constants.dart';
import 'add_report_screen.dart';
import 'report_detail_screen.dart';

class ReportsScreen extends StatefulWidget {
  @override
  _ReportsScreenState createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  List reports = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchReports();
  }

  Future<void> fetchReports() async {
    final response = await ApiService.getRequest(ApiConstants.reports);
    if (response.statusCode == 200) {
      setState(() {
        reports = jsonDecode(response.body);
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Reports")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: reports.length,
              itemBuilder: (context, index) {
                final report = reports[index];
                return ListTile(
                  leading: Icon(Icons.picture_as_pdf, color: Colors.red),
                  title: Text(report["title"] ?? "Untitled Report"),
                  subtitle: Text(report["date"] ?? "N/A"),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ReportDetailScreen(report: report),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.upload_file),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AddReportScreen()),
        ).then((_) => fetchReports()), // refresh after upload
      ),
    );
  }
}
