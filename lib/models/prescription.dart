import 'prescription_item.dart';

class Prescription {
  final String id;
  final String? notes;
  final DateTime createdAt;
  final List<PrescriptionItem> items;

  Prescription({
    required this.id,
    this.notes,
    required this.createdAt,
    required this.items,
  });

  factory Prescription.fromMap(Map<String, dynamic> map) {
    return Prescription(
      id: map['prescription_id'],
      notes: map['notes'],
      createdAt: DateTime.parse(map['created_at']),
      items: (map['prescription_items'] as List)
          .map((e) => PrescriptionItem.fromMap(e))
          .toList(),
    );
  }
}
