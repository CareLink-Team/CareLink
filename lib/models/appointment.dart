class Appointment {
  final String appointmentId;
  final String doctorId;
  final String caretakerId;
  final String patientId;
  final DateTime dateTime;
  final String purpose;
  final String status;

  Appointment({
    required this.appointmentId,
    required this.doctorId,
    required this.caretakerId,
    required this.patientId,
    required this.dateTime,
    required this.purpose,
    required this.status,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      appointmentId: json['appointment_id'] ?? '',
      doctorId: json['doctor_id'] ?? '',
      caretakerId: json['caretaker_id'] ?? '',
      patientId: json['patient_id'] ?? '',
      dateTime: json['date_time'] != null
          ? DateTime.parse(json['date_time'])
          : DateTime.now(), // or throw
      purpose: json['purpose'] ?? '',
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'appointment_id': appointmentId,
    'doctor_id': doctorId,
    'caretaker_id': caretakerId,
    'patient_id': patientId,
    'date_time': dateTime.toIso8601String(),
    'purpose': purpose,
    'status': status,
  };

  @override
  String toString() =>
      'Appointment(Doctor: $doctorId, Patient: $patientId, Status: $status)';
}

enum AppointmentStatus { pending, confirmed, completed }
