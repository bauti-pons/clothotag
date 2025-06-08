import 'package:flutter/material.dart';

import '../scanner/qr_scanner.dart';
import '../scanner/nfc_scanner.dart';
import '../repairs/repairs_list.dart';
import '../co2/co2_calculator.dart';        // ← NUEVO import

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ClothoTag'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text('Escanear QR'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const QrScannerScreen()),
                );
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.nfc),
              label: const Text('Escanear NFC'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const NfcScannerScreen()),
                );
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.build),
              label: const Text('Reparaciones'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RepairsListScreen()),
                );
              },
            ),
            const SizedBox(height: 16),
            // === NUEVO BOTÓN CO₂ =========================
            ElevatedButton.icon(
              icon: const Icon(Icons.eco),
              label: const Text('Calculador CO₂'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const Co2CalculatorScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
