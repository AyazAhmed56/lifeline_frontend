class Medicine {
  final int id;
  final String name;
  final String dosage;
  final String frequency;
  final String? startDate;
  final String? endDate;

  Medicine({
    required this.id,
    required this.name,
    required this.dosage,
    required this.frequency,
    this.startDate,
    this.endDate,
  });

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      id: json["id"],
      name: json["name"],
      dosage: json["dosage"],
      frequency: json["frequency"],
      startDate: json["start_date"],
      endDate: json["end_date"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "dosage": dosage,
      "frequency": frequency,
      "start_date": startDate,
      "end_date": endDate,
    };
  }
}
