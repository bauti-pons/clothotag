import 'package:cloud_firestore/cloud_firestore.dart';  // ← añade esto

class Repair {
  final String id;
  final String tagUid;
  final String description;
  final DateTime date;
  final double cost;

  Repair({
    required this.id,
    required this.tagUid,
    required this.description,
    required this.date,
    required this.cost,
  });

  Map<String, dynamic> toMap() => {
    'tagUid': tagUid,
    'description': description,
    'date': date,
    'cost': cost,
  };

  factory Repair.fromMap(String id, Map<String, dynamic> map) => Repair(
    id: id,
    tagUid: map['tagUid'] as String,
    description: map['description'] as String,
    date: (map['date'] as Timestamp).toDate(),   // Timestamp → DateTime
    cost: (map['cost'] as num).toDouble(),
  );
}
