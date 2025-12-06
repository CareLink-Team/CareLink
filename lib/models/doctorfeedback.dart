class DoctorFeedback {
  final String feedbackId;
  final String doctorId;
  final String patientId;
  final String caretakerId;
  final DateTime dateTime;
  final String advicePrescription;
  final DateTime? nextCheckupDate;
  final String status;

  DoctorFeedback({
    required this.feedbackId,
    required this.doctorId,
    required this.patientId,
    required this.caretakerId,
    required this.dateTime,
    required this.advicePrescription,
    required this.nextCheckupDate,
    required this.status,
  });

  factory DoctorFeedback.fromJson(Map<String, dynamic> json) {
    return DoctorFeedback(
      feedbackId: json['feedback_id'] ?? '',
      doctorId: json['doctor_id'] ?? '',
      patientId: json['patient_id'] ?? '',
      caretakerId: json['caretaker_id'] ?? '',
      dateTime: DateTime.parse(json['date_time']),
      advicePrescription: json['advice_prescription'] ?? '',
      nextCheckupDate: json['next_checkup_date'] != null
          ? DateTime.tryParse(json['next_checkup_date'])
          : null,
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'feedback_id': feedbackId,
    'doctor_id': doctorId,
    'patient_id': patientId,
    'caretaker_id': caretakerId,
    'date_time': dateTime.toIso8601String(),
    'advice_prescription': advicePrescription,
    'next_checkup_date': nextCheckupDate?.toIso8601String(),
    'status': status,
  };
}
