import 'package:flutter/material.dart';
import '../scanner/qr_scanner.dart';
import '../scanner/nfc_scanner.dart';

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
          children: [
            // Botón QR
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
            const SizedBox(height: 24),

            // Botón NFC
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
          ],
        ),
      ),
    );
  }
}
