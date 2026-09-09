import 'package:flutter/material.dart';
import '../utils/number_validator.dart';

/// Halaman Jumlah Total Angka
/// Menghitung akumulasi total penjumlahan dari deretan angka yang dimasukkan dalam satu input teks.
/// Contoh format: "10, 20.5, 30, -5" (dipisahkan koma atau spasi).
class SumTotalPage extends StatefulWidget {
  const SumTotalPage({super.key});

  @override
  State<SumTotalPage> createState() => _SumTotalPageState();
}

class _SumTotalPageState extends State<SumTotalPage> {
  final _controller = TextEditingController();
  String _result = '';
  String _errorText = '';

  /// Fungsi untuk menghitung total dari teks yang dipisah koma/spasi/titik-koma
  void _hitungTotal() {
    final input = _controller.text.trim();

    // Reset pesan sebelumnya
    setState(() {
      _errorText = '';
      _result = '';
    });

    if (input.isEmpty) {
      setState(() => _errorText = 'Input tidak boleh kosong');
      return;
    }

    // Pisahkan teks berdasarkan koma, titik-koma, atau spasi (whitespace)
    final parts = input.split(RegExp(r'[,\s;]+')).where((e) => e.isNotEmpty);

    double total = 0.0;
    int count = 0;
    final List<String> invalidItems = [];

    for (final part in parts) {
      final normalized = part.replaceAll(',', '.');
      final double? value = double.tryParse(normalized);

      // Cek jika parsing gagal
      if (value == null) {
        invalidItems.add(part);
        continue;
      }

      // Cek batas logis
      if (value < NumberValidator.minLimit || value > NumberValidator.maxLimit) {
        invalidItems.add('$part (di luar batas)');
        continue;
      }

      total += value;
      count++;
    }

    // Jika ada item yang tidak valid, tampilkan info
    if (invalidItems.isNotEmpty) {
      setState(() {
        _errorText = 'Item tidak valid diabaikan: ${invalidItems.join(', ')}';
      });
    }

    // Jika tidak ada satu pun angka yang valid
    if (count == 0) {
      setState(() => _errorText = 'Tidak ditemukan angka yang valid');
      return;
    }

    // Tampilkan hasil akhir
    setState(() {
      final String totalFormatted = (total % 1 == 0)
          ? total.toInt().toString()
          : total.toStringAsFixed(2);
      _result = 'Total dari $count angka = $totalFormatted';
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jumlah Total Angka'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Petunjuk Penggunaan
            const Text(
              'Masukkan deretan angka yang dipisahkan koma atau spasi.\n'
              'Contoh: 10, 20.5, 30, -5',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 12),

            // Form Input Multiline
            TextField(
              controller: _controller,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Deretan Angka',
                hintText: '10, 20.5, 30, -5',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 16),

            // Tombol Hitung
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _hitungTotal,
                icon: const Icon(Icons.calculate),
                label: const Text('Hitung Total'),
              ),
            ),
            const SizedBox(height: 20),

            // Pesan Peringatan jika ada input tidak valid
            if (_errorText.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded, color: Colors.orange),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorText,
                        style: TextStyle(color: Colors.orange.shade900),
                      ),
                    ),
                  ],
                ),
              ),

            // Tampilan Hasil
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
    );
  }
}
