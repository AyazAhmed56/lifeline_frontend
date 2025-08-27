class Appointment {
  final int id;
  final String doctorName;
  final String hospitalName;
  final String appointmentDate;
  final String status;

  Appointment({
    required this.id,
    required this.doctorName,
    required this.hospitalName,
    required this.appointmentDate,
    required this.status,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json["id"],
      doctorName: json["doctor_name"],
      hospitalName: json["hospital_name"],
      appointmentDate: json["appointment_date"],
      status: json["status"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "doctor_name": doctorName,
      "hospital_name": hospitalName,
      "appointment_date": appointmentDate,
      "status": status,
    };
  }
}
