import 'package:flutter/material.dart';
import '../utils/number_validator.dart';

/// Halaman Perkalian & Pembagian
/// Melakukan operasi perkalian (×) dan pembagian (÷) antara dua angka.
class MulDivPage extends StatefulWidget {
  const MulDivPage({super.key});

  @override
  State<MulDivPage> createState() => _MulDivPageState();
}

class _MulDivPageState extends State<MulDivPage> {
  final _formKey = GlobalKey<FormState>();
  final _num1Controller = TextEditingController();
  final _num2Controller = TextEditingController();
  String _result = '';
  bool _isError = false;

  /// Fungsi untuk menghitung operasi perkalian atau pembagian
  void _hitung(String operasi) {
    if (_formKey.currentState!.validate()) {
      final double a = NumberValidator.parse(_num1Controller.text);
      final double b = NumberValidator.parse(_num2Controller.text);

      // Cek pembagian dengan 0
      if (operasi == '/' && b == 0) {
        setState(() {
          _isError = true;
          _result = 'Error: Tidak dapat membagi dengan angka 0';
        });
        return;
      }

      final double hasil = (operasi == '*') ? (a * b) : (a / b);

      setState(() {
        _isError = false;
        _result = 'Hasil: ${_formatResult(hasil)}';
      });
    } else {
      setState(() {
        _result = '';
        _isError = false;
      });
    }
  }

  /// Format angka agar rapi
  String _formatResult(double val) {
    if (val % 1 == 0) {
      return val.toInt().toString();
    }
    return val.toStringAsFixed(2);
  }

  @override
  void dispose() {
    _num1Controller.dispose();
    _num2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perkalian & Pembagian'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Input Angka Pertama
              TextFormField(
                controller: _num1Controller,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Angka Pertama',
                  hintText: 'Contoh: 10 atau 4.5',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => NumberValidator.validate(v),
              ),
              const SizedBox(height: 16),

              // Input Angka Kedua
              TextFormField(
                controller: _num2Controller,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Angka Kedua',
                  hintText: 'Contoh: 2 atau 0.5',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => NumberValidator.validate(v),
              ),
              const SizedBox(height: 20),

              // Tombol Kali dan Bagi
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () => _hitung('*'),
                      icon: const Icon(Icons.close),
                      label: const Text('Kali (×)'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () => _hitung('/'),
                      icon: const Icon(Icons.safety_divider),
                      label: const Text('Bagi (÷)'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Hasil Perhitungan
              if (_result.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _isError
                        ? Colors.red.shade50
                        : Colors.deepPurple.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _isError
                          ? Colors.red.shade300
                          : Colors.deepPurple.shade200,
                    ),
                  ),
                  child: Text(
                    _result,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _isError ? Colors.red : Colors.deepPurple,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
