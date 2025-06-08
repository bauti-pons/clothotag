import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';

class NfcScannerScreen extends StatefulWidget {
  const NfcScannerScreen({Key? key}) : super(key: key);

  @override
  State<NfcScannerScreen> createState() => _NfcScannerScreenState();
}

class _NfcScannerScreenState extends State<NfcScannerScreen> {
  String _status = 'Acerca la tarjeta NFC…';
  bool _scanning = false;

  /// Inicia la lectura y actualiza el estado con el resultado
  Future<void> _startScan() async {
    setState(() {
      _status = 'Escaneando…';
      _scanning = true;
    });

    try {
      // Inicia la detección (timeout 15 s)
      final tag = await FlutterNfcKit.poll(
        timeout: const Duration(seconds: 15),
      );

      // UID o NDEF
      String result;
      if (tag.ndefAvailable == true && tag.ndefType != null) {
        final ndef = await FlutterNfcKit.readNDEFRecords();
        if (ndef.isNotEmpty) {
          result = 'NDEF: ${ndef.map((r) => r.toString()).join(",")}';
        } else {
          result = 'NDEF vacío, UID: ${tag.id}';
        }
      } else {
        result = 'UID: ${tag.id}';
      }

      setState(() => _status = result);
    } catch (e) {
      setState(() => _status = 'Error: $e');
    } finally {
      // Finaliza la sesión NFC
      await FlutterNfcKit.finish();
      setState(() => _scanning = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Web y desktop no soportan NFC → mostramos aviso
    final unsupported = kIsWeb ||
        defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.linux ||
        defaultTargetPlatform == TargetPlatform.macOS;

    return Scaffold(
      appBar: AppBar(title: const Text('Escanear NFC')),
      body: unsupported
          ? const Center(
        child: Text(
          'El lector NFC solo está disponible\n'
              'en dispositivos Android o iOS reales.',
          textAlign: TextAlign.center,
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _status,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              icon: const Icon(Icons.nfc),
              onPressed: _scanning ? null : _startScan,
              label: Text(_scanning ? 'Escaneando…' : 'Iniciar lectura'),
            ),
          ],
        ),
      ),
    );
  }
}
