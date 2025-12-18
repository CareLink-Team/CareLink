class PrescriptionItem {
  final String medicineName;
  final String? dosage;
  final String? frequency;
  final String? duration;

  PrescriptionItem({
    required this.medicineName,
    this.dosage,
    this.frequency,
    this.duration,
  });

  factory PrescriptionItem.fromMap(Map<String, dynamic> map) {
    return PrescriptionItem(
      medicineName: map['medicine_name'],
      dosage: map['dosage'],
      frequency: map['frequency'],
      duration: map['duration'],
    );
  }
}
