import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../models/repair.dart';
import 'repair_form.dart';

class RepairsListScreen extends StatelessWidget {
  const RepairsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repairsRef = FirebaseFirestore.instance
        .collection('repairs')
        .orderBy('date', descending: true);

    return Scaffold(
      appBar: AppBar(title: const Text('Reparaciones')),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const RepairFormScreen()),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: repairsRef.snapshots(),
        builder: (ctx, snap) {
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final repairs = snap.data!.docs
              .map((d) => Repair.fromMap(d.id, d.data()! as Map<String, dynamic>))
              .toList();
          if (repairs.isEmpty) {
            return const Center(child: Text('Sin reparaciones todavía.'));
          }
          return ListView.builder(
            itemCount: repairs.length,
            itemBuilder: (_, i) {
              final r = repairs[i];
              return ListTile(
                title: Text(r.description),
                subtitle: Text('${r.date}  |  €${r.cost.toStringAsFixed(2)}'),
              );
            },
          );
        },
      ),
    );
  }
}
