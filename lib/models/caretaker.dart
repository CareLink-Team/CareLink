class Caretaker {
  final String caretakerId;
  final int age;
  final String gender;
  final String contactNumber;
  final String doctorId;

  Caretaker({
    required this.caretakerId,
    required this.age,
    required this.gender,
    required this.contactNumber,
    required this.doctorId,
  });

  factory Caretaker.fromJson(Map<String, dynamic> json) {
    return Caretaker(
      caretakerId: json['caretaker_id'] ?? '',
      age: json['age'] ?? 0,
      gender: json['gender'] ?? '',
      contactNumber: json['contact_number'] ?? '',
      doctorId: json['doctor_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'caretaker_id': caretakerId,
    'age': age,
    'gender': gender,
    'contact_number': contactNumber,
    'doctor_id': doctorId,
  };
}
