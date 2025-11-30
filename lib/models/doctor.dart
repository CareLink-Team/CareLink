class Doctor {
  final String doctorId;
  final String name;
  final String specialization;
  final String contactNumber;
  final String email;
  final String password;
  final String hospitalName;

  Doctor({
    required this.doctorId,
    required this.name,
    required this.specialization,
    required this.contactNumber,
    required this.email,
    required this.password,
    required this.hospitalName,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      doctorId: json['doctor_id'] ?? '',
      name: json['name'] ?? '',
      specialization: json['specialization'] ?? '',
      contactNumber: json['contact_number'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      hospitalName: json['hospital_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'doctor_id': doctorId,
    'name': name,
    'specialization': specialization,
    'contact_number': contactNumber,
    'email': email,
    'password': password,
    'hospital_name': hospitalName,
  };

  @override
  String toString() => 'Doctor($name, $specialization)';
}
