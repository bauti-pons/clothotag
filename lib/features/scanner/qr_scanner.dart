import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart' as ms;

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({Key? key}) : super(key: key);

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  String? _result;

  void _setResult(String code) => setState(() => _result ??= code);

  @override
  Widget build(BuildContext context) {
    late final Widget scanner;

    // Android, iOS, Web (y macOS si mobile_scanner 7.x lo soporta)
    if (kIsWeb ||
        defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      scanner = ms.MobileScanner(
        onDetect: (capture) {
          for (final b in capture.barcodes) {
            final code = b.rawValue;
            if (code != null) {
              _setResult(code);
              break;
            }
          }
        },
      );
    } else if (defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.linux) {
      // De momento no hay soporte de escáner QR en desktop
      scanner = const Center(
        child: Text(
          'El escáner QR aún no está disponible en esta plataforma.\n'
              'Prueba en la versión móvil o Web.',
          textAlign: TextAlign.center,
        ),
      );
    } else {
      scanner = const Center(child: Text('Plataforma no soportada'));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Escanear QR')),
      body: Column(
        children: [
          Expanded(child: scanner),
          Container(
            padding: const EdgeInsets.all(16),
            alignment: Alignment.center,
            child: Text(
              _result ?? 'Apunta la cámara al QR',
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
