class Caretaker {
  final String caretakerId;
  final String name;
  final int age;
  final String gender;
  final String contactNumber;
  final String email;
  final String password;
  final String doctorId;

  Caretaker({
    required this.caretakerId,
    required this.name,
    required this.age,
    required this.gender,
    required this.contactNumber,
    required this.email,
    required this.password,
    required this.doctorId,
  });

  factory Caretaker.fromJson(Map<String, dynamic> json) {
    return Caretaker(
      caretakerId: json['caretaker_id'] ?? '',
      name: json['name'] ?? '',
      age: json['age'] ?? 0,
      gender: json['gender'] ?? '',
      contactNumber: json['contact_number'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      doctorId: json['doctor_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'caretaker_id': caretakerId,
    'name': name,
    'age': age,
    'gender': gender,
    'contact_number': contactNumber,
    'email': email,
    'password': password,
    'doctor_id': doctorId,
  };

  @override
  String toString() => 'Caretaker($name, Doctor: $doctorId)';
}
