import 'package:flutter/material.dart';
import '../utils/number_validator.dart';

/// Halaman Operasi Matematika / Kalkulator
/// Menggabungkan operasi Penjumlahan (+), Pengurangan (-), Perkalian (*), dan Pembagian (/)
/// Menggunakan tipe data `double` untuk mendukung bilangan bulat maupun pecahan.
class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  // Key untuk validasi form input
  final _formKey = GlobalKey<FormState>();

  // Controller untuk membaca nilai input angka
  final _num1Controller = TextEditingController();
  final _num2Controller = TextEditingController();

  // Variabel untuk menyimpan hasil perhitungan
  String _result = '';
  bool _isError = false;

  /// Fungsi untuk melakukan perhitungan matematika berdasarkan operator (+, -, *, /)
  void _hitung(String operator) {
    // 1. Cek apakah kedua input sudah valid
    if (_formKey.currentState!.validate()) {
      // 2. Ambil nilai input dan ubah menjadi tipe double
      final double a = NumberValidator.parse(_num1Controller.text);
      final double b = NumberValidator.parse(_num2Controller.text);

      // 3. Cek kondisi khusus: pembagian dengan angka 0
      if (operator == '/' && b == 0) {
        setState(() {
          _isError = true;
          _result = 'Error: Tidak bisa membagi dengan angka 0';
        });
        return;
      }

      // 4. Hitung hasil sesuai operator yang dipilih
      double hasil = 0.0;
      switch (operator) {
        case '+':
          hasil = a + b;
          break;
        case '-':
          hasil = a - b;
          break;
        case '*':
          hasil = a * b;
          break;
        case '/':
          hasil = a / b;
          break;
      }

      // 5. Update tampilan dengan hasil perhitungan
      setState(() {
        _isError = false;
        _result = 'Hasil: $hasil';
      });
    } else {
      // Jika form tidak valid, kosongkan hasil
      setState(() {
        _result = '';
        _isError = false;
      });
    }
  }

  @override
  void dispose() {
    // Selalu dispose controller saat halaman ditutup
    _num1Controller.dispose();
    _num2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Operasi Matematika (+, -, *, /)'),
      ),
      body: SingleChildScrollView(
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
                  hintText: 'Masukkan angka pertama',
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
                  hintText: 'Masukkan angka kedua',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => NumberValidator.validate(v),
              ),
              const SizedBox(height: 20),

              // Baris 1: Tombol Tambah (+) & Kurang (-)
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
              const SizedBox(height: 12),

              // Baris 2: Tombol Kali (*) & Bagi (/)
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

              // Tampilan Hasil Perhitungan
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
                          ? Colors.red.shade200
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
