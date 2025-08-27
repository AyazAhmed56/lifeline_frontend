class User {
  final int id;
  final String authId;
  final String name;
  final String email;
  final int? age;
  final String? bloodGroup;
  final String? phoneNo;

  User({
    required this.id,
    required this.authId,
    required this.name,
    required this.email,
    this.age,
    this.bloodGroup,
    this.phoneNo,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"],
      authId: json["auth_id"],
      name: json["name"],
      email: json["email"],
      age: json["age"],
      bloodGroup: json["blood_group"],
      phoneNo: json["phone_no"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "auth_id": authId,
      "name": name,
      "email": email,
      "age": age,
      "blood_group": bloodGroup,
      "phone_no": phoneNo,
    };
  }
}
