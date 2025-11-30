class HealthData {
  final String recordId;
  final String patientId;
  final DateTime dateTime;
  final double bloodSugarLevel;
  final int bloodPressureSystolic;
  final int bloodPressureDiastolic;
  final bool medicationTaken;
  final String symptoms;
  final String remarks;

  HealthData({
    required this.recordId,
    required this.patientId,
    required this.dateTime,
    required this.bloodSugarLevel,
    required this.bloodPressureSystolic,
    required this.bloodPressureDiastolic,
    required this.medicationTaken,
    required this.symptoms,
    required this.remarks,
  });

  factory HealthData.fromJson(Map<String, dynamic> json) {
    return HealthData(
      recordId: json['record_id'] ?? '',
      patientId: json['patient_id'] ?? '',
      dateTime: DateTime.parse(json['date_time']),
      bloodSugarLevel: (json['blood_sugar_level'] ?? 0).toDouble(),
      bloodPressureSystolic: json['blood_pressure_systolic'] ?? 0,
      bloodPressureDiastolic: json['blood_pressure_diastolic'] ?? 0,
      medicationTaken: json['medication_taken'] ?? false,
      symptoms: json['symptoms'] ?? '',
      remarks: json['remarks'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'record_id': recordId,
    'patient_id': patientId,
    'date_time': dateTime.toIso8601String(),
    'blood_sugar_level': bloodSugarLevel,
    'blood_pressure_systolic': bloodPressureSystolic,
    'blood_pressure_diastolic': bloodPressureDiastolic,
    'medication_taken': medicationTaken,
    'symptoms': symptoms,
    'remarks': remarks,
  };

  @override
  String toString() =>
      'HealthData(Patient: $patientId, Sugar: $bloodSugarLevel, BP: $bloodPressureSystolic/$bloodPressureDiastolic)';
}
