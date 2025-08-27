class Report {
  final int id;
  final String reportType;
  final String? textContent;
  final String? aiSummary;
  final String uploadedAt;

  Report({
    required this.id,
    required this.reportType,
    this.textContent,
    this.aiSummary,
    required this.uploadedAt,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json["id"],
      reportType: json["report_type"],
      textContent: json["text_content"],
      aiSummary: json["ai_summary"],
      uploadedAt: json["uploaded_at"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "report_type": reportType,
      "text_content": textContent,
      "ai_summary": aiSummary,
      "uploaded_at": uploadedAt,
    };
  }
}
