class HealthRecord {
  final int id;
  final String recordType;
  final String description;
  final String createdAt;

  HealthRecord({
    required this.id,
    required this.recordType,
    required this.description,
    required this.createdAt,
  });

  factory HealthRecord.fromJson(Map<String, dynamic> json) {
    return HealthRecord(
      id: json["id"],
      recordType: json["record_type"],
      description: json["description"],
      createdAt: json["created_at"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "record_type": recordType,
      "description": description,
      "created_at": createdAt,
    };
  }
}
