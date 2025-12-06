class Patient {
  final String patientId; // same as user.id
  final int age;
  final String gender;
  final String contactNumber;
  final String address;
  final String medicalCondition;
  final String caretakerId;
  final String doctorId;

  Patient({
    required this.patientId,
    required this.age,
    required this.gender,
    required this.contactNumber,
    required this.address,
    required this.medicalCondition,
    required this.caretakerId,
    required this.doctorId,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      patientId: json['patient_id'] ?? '',
      age: json['age'] ?? 0,
      gender: json['gender'] ?? '',
      contactNumber: json['contact_number'] ?? '',
      address: json['address'] ?? '',
      medicalCondition: json['medical_condition'] ?? '',
      caretakerId: json['caretaker_id'] ?? '',
      doctorId: json['doctor_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'patient_id': patientId,
    'age': age,
    'gender': gender,
    'contact_number': contactNumber,
    'address': address,
    'medical_condition': medicalCondition,
    'caretaker_id': caretakerId,
    'doctor_id': doctorId,
  };
}
