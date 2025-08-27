class BloodRequest {
  final int id;
  final String bloodGroup;
  final String hospital;
  final String contactNo;
  final String status;
  final String createdAt;

  BloodRequest({
    required this.id,
    required this.bloodGroup,
    required this.hospital,
    required this.contactNo,
    required this.status,
    required this.createdAt,
  });

  factory BloodRequest.fromJson(Map<String, dynamic> json) {
    return BloodRequest(
      id: json["id"],
      bloodGroup: json["blood_group"],
      hospital: json["hospital"],
      contactNo: json["contact_no"],
      status: json["status"],
      createdAt: json["created_at"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "blood_group": bloodGroup,
      "hospital": hospital,
      "contact_no": contactNo,
      "status": status,
      "created_at": createdAt,
    };
  }
}
