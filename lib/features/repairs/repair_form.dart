import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RepairFormScreen extends StatefulWidget {
  const RepairFormScreen({super.key});

  @override
  State<RepairFormScreen> createState() => _RepairFormScreenState();
}

class _RepairFormScreenState extends State<RepairFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descCtrl = TextEditingController();
  final _costCtrl = TextEditingController();

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    await FirebaseFirestore.instance.collection('repairs').add({
      'tagUid': 'demo-uid',           // sustituye por UID real si ya lo tienes
      'description': _descCtrl.text,
      'date': DateTime.now(),
      'cost': double.parse(_costCtrl.text),
    });
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nueva reparación')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _descCtrl,
                decoration: const InputDecoration(labelText: 'Descripción'),
                validator: (v) => v == null || v.isEmpty ? 'Obligatorio' : null,
              ),
              TextFormField(
                controller: _costCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Coste (€)'),
                validator: (v) =>
                double.tryParse(v ?? '') == null ? 'Número válido' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(onPressed: _save, child: const Text('Guardar')),
            ],
          ),
        ),
      ),
    );
  }
}
