import 'package:flutter/material.dart';
import '../utils/number_validator.dart';

/// Halaman Penjumlahan & Pengurangan
/// Melakukan operasi pertambahan (+) dan pengurangan (-) antara dua angka.
class AddSubPage extends StatefulWidget {
  const AddSubPage({super.key});

  @override
  State<AddSubPage> createState() => _AddSubPageState();
}

class _AddSubPageState extends State<AddSubPage> {
  final _formKey = GlobalKey<FormState>();
  final _num1Controller = TextEditingController();
  final _num2Controller = TextEditingController();
  String _result = '';

  /// Fungsi untuk menghitung operasi tambah atau kurang
  void _hitung(String operasi) {
    if (_formKey.currentState!.validate()) {
      final double a = NumberValidator.parse(_num1Controller.text);
      final double b = NumberValidator.parse(_num2Controller.text);
      
      final double hasil = (operasi == '+') ? (a + b) : (a - b);

      setState(() {
        // Tampilkan hasil, hilangkan trailing nol jika bilangan bulat
        _result = 'Hasil: ${_formatResult(hasil)}';
      });
    } else {
      setState(() => _result = '');
    }
  }

  /// Format output agar jika bulat tidak muncul .00 (misal: 10 bukan 10.00)
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
        title: const Text('Penjumlahan & Pengurangan'),
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
                  hintText: 'Contoh: 10 atau 12.5',
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
                  hintText: 'Contoh: 5 atau -3',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => NumberValidator.validate(v),
              ),
              const SizedBox(height: 20),

              // Tombol Tambah dan Kurang
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () => _hitung('+'),
                      icon: const Icon(Icons.add),
                      label: const Text('Tambah (+)'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () => _hitung('-'),
                      icon: const Icon(Icons.remove),
                      label: const Text('Kurang (-)'),
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
                    color: Colors.deepPurple.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.deepPurple.shade200),
                  ),
                  child: Text(
                    _result,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
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
