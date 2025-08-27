class Emergency {
  final int id;
  final String type;
  final String description;
  final String location;
  final String createdAt;

  Emergency({
    required this.id,
    required this.type,
    required this.description,
    required this.location,
    required this.createdAt,
  });

  factory Emergency.fromJson(Map<String, dynamic> json) {
    return Emergency(
      id: json["id"],
      type: json["type"],
      description: json["description"],
      location: json["location"],
      createdAt: json["created_at"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "type": type,
      "description": description,
      "location": location,
      "created_at": createdAt,
    };
  }
}
