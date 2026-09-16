import 'package:flutter/material.dart';
import '../utils/number_validator.dart';

/// Halaman Operasi Matematika / Kalkulator
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
  String _activeOperator = '';

  /// Fungsi untuk melakukan perhitungan matematika berdasarkan operator (+, -, *, /)
  void _hitung(String operator) {
    setState(() {
      _activeOperator = operator;
    });

    // 1. Cek apakah kedua input sudah valid
    if (_formKey.currentState!.validate()) {
      // 2. Ambil nilai input dan ubah menjadi tipe double
      final double a = NumberValidator.parse(_num1Controller.text);
      final double b = NumberValidator.parse(_num2Controller.text);

      // 3. Cek kondisi khusus: pembagian dengan angka 0
      if (operator == '/' && b == 0) {
        setState(() {
          _isError = true;
          _result = 'Error: Tidak bisa membagi dengan 0';
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

      // Format angka: jika bulat tidak perlu menampilkan desimal .0
      final formattedResult = hasil % 1 == 0 ? hasil.toInt().toString() : hasil.toStringAsFixed(2);

      // 5. Update tampilan dengan hasil perhitungan
      setState(() {
        _isError = false;
        _result = formattedResult;
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
    _num1Controller.dispose();
    _num2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF2E2440), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Kalkulator',
          style: TextStyle(
            color: Color(0xFF2E2440),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Kartu Input Angka
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Input Angka',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2E2440),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Input Angka Pertama
                          TextFormField(
                            controller: _num1Controller,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                              signed: true,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Angka Pertama',
                              hintText: 'Contoh: 10',
                              prefixIcon: const Icon(Icons.looks_one_outlined, color: Color(0xFF673AB7)),
                              filled: true,
                              fillColor: const Color(0xFFF7F5FA),
                              contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(color: Color(0xFF673AB7), width: 1.5),
                              ),
                            ),
                            validator: (v) => NumberValidator.validate(v),
                          ),
                          const SizedBox(height: 14),

                          // Input Angka Kedua
                          TextFormField(
                            controller: _num2Controller,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                              signed: true,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Angka Kedua',
                              hintText: 'Contoh: 5',
                              prefixIcon: const Icon(Icons.looks_two_outlined, color: Color(0xFF673AB7)),
                              filled: true,
                              fillColor: const Color(0xFFF7F5FA),
                              contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(color: Color(0xFF673AB7), width: 1.5),
                              ),
                            ),
                            validator: (v) => NumberValidator.validate(v),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Label Pilihan Operasi
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                      child: Text(
                        'Pilih Operasi',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF5E35B1),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Baris 1: Tombol Tambah (+) & Kurang (-)
                    Row(
                      children: [
                        Expanded(
                          child: _buildOperationButton(
                            label: 'Tambah (+)',
                            symbol: '+',
                            icon: Icons.add_rounded,
                            onTap: () => _hitung('+'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildOperationButton(
                            label: 'Kurang (-)',
                            symbol: '-',
                            icon: Icons.remove_rounded,
                            onTap: () => _hitung('-'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Baris 2: Tombol Kali (*) & Bagi (/)
                    Row(
                      children: [
                        Expanded(
                          child: _buildOperationButton(
                            label: 'Kali (×)',
                            symbol: '*',
                            icon: Icons.close_rounded,
                            onTap: () => _hitung('*'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildOperationButton(
                            label: 'Bagi (÷)',
                            symbol: '/',
                            icon: Icons.safety_divider_rounded,
                            onTap: () => _hitung('/'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Tampilan Hasil Perhitungan
                    if (_result.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 20),
                        decoration: BoxDecoration(
                          color: _isError ? const Color(0xFFFFEBEE) : Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: _isError ? Colors.redAccent.shade100 : const Color(0xFFD1C4E9),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: _isError
                                  ? Colors.red.withOpacity(0.08)
                                  : const Color(0xFF5E35B1).withOpacity(0.08),
                              blurRadius: 18,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              _isError ? 'Terjadi Kesalahan' : 'Hasil Perhitungan',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: _isError ? Colors.red.shade700 : Colors.deepPurple.shade400,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _result,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: _isError ? 16 : 30,
                                fontWeight: FontWeight.bold,
                                color: _isError ? Colors.red.shade900 : const Color(0xFF2E2440),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Helper untuk membangun tombol operasi modern
  Widget _buildOperationButton({
    required String label,
    required String symbol,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final bool isSelected = _activeOperator == symbol && _result.isNotEmpty;

    return Container(
      height: 52,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: isSelected
            ? const LinearGradient(
                colors: [Color(0xFF7E57C2), Color(0xFF5E35B1)],
              )
            : null,
        color: isSelected ? null : Colors.white,
        boxShadow: [
          BoxShadow(
            color: isSelected
                ? const Color(0xFF5E35B1).withOpacity(0.3)
                : Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected ? Colors.white : const Color(0xFF5E35B1),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : const Color(0xFF2E2440),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}