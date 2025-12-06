class Doctor {
  final String doctorId; // same as user.id
  final String specialization;
  final String contactNumber;
  final String hospitalName;

  Doctor({
    required this.doctorId,
    required this.specialization,
    required this.contactNumber,
    required this.hospitalName,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      doctorId: json['doctor_id'] ?? '',
      specialization: json['specialization'] ?? '',
      contactNumber: json['contact_number'] ?? '',
      hospitalName: json['hospital_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'doctor_id': doctorId,
    'specialization': specialization,
    'contact_number': contactNumber,
    'hospital_name': hospitalName,
  };
}
