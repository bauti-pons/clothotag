import 'dart:js_util' as js_util;     // Interop JS <-> Dart (Promise, callMethod)
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Pantalla que calcula la huella de CO₂ invocando
/// la función Rust/WASM expuesta en `index.html` como `window.calcCO2`.
class Co2CalculatorScreen extends StatefulWidget {
  const Co2CalculatorScreen({super.key});

  @override
  State<Co2CalculatorScreen> createState() => _Co2CalculatorScreenState();
}

class _Co2CalculatorScreenState extends State<Co2CalculatorScreen> {
  final _controller = TextEditingController();
  String? _result;          // Resultado en texto (“6.25”)
  String? _error;           // Mensaje de error, si lo hubiera

  /// Valida la entrada, llama a `calcCO2` (JS/WASM) y actualiza el estado.
  Future<void> _calculate() async {
    setState(() => _error = null);

    // ── Validación del número introducido ────────────────────────────
    final kg = double.tryParse(_controller.text.replaceAll(',', '.'));
    if (kg == null) {
      setState(() => _error = 'Introduce un número válido');
      return;
    }

    // Disponible únicamente en Web (donde se carga el módulo WASM)
    if (!kIsWeb) {
      setState(() => _error = 'Disponible solo en Web');
      return;
    }

    // ── Llamada a la función JavaScript (devuelve Promise) ───────────
    try {
      final promise =
      js_util.callMethod(js_util.globalThis, 'calcCO2', [kg]); // JsPromise
      final value = await js_util.promiseToFuture<num>(promise);     // Future<num>

      setState(() => _result = value.toStringAsFixed(2));
    } catch (e) {
      setState(() => _error = 'Error al invocar calcCO2: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calculador CO₂')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Campo de entrada
            TextField(
              controller: _controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Peso (kg)'),
            ),
            const SizedBox(height: 16),

            // Botón de cálculo
            ElevatedButton(
              onPressed: _calculate,
              child: const Text('Calcular CO₂'),
            ),
            const SizedBox(height: 24),

            // Resultado o mensaje de error
            if (_result != null)
              Text(
                '$_result kg CO₂',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
            if (_error != null)
              Text(
                _error!,
                style: const TextStyle(color: Colors.redAccent),
              ),
          ],
        ),
      ),
    );
  }
}
