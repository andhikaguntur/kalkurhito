import 'package:flutter/material.dart';

/// Halaman Hitung Banyak Angka (COUNT)
/// Menghitung berapa banyak angka/bilangan yang diinputkan (konsep COUNT, bukan penjumlahan/SUM).
class CountPage extends StatefulWidget {
  const CountPage({super.key});

  @override
  State<CountPage> createState() => _CountPageState();
}

class _CountPageState extends State<CountPage> {
  final _controller = TextEditingController();

  // Variabel untuk menampilkan hasil perhitungan count
  int _countAngka = 0;
  int _countDigit = 0;
  bool _hasCalculated = false;

  /// Fungsi untuk menghitung banyaknya angka yang dimasukkan (COUNT)
  void _hitungBanyak() {
    final text = _controller.text.trim();

    if (text.isEmpty) {
      setState(() {
        _hasCalculated = false;
        _countAngka = 0;
        _countDigit = 0;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Input tidak boleh kosong')),
      );
      return;
    }

    // 1. Memisahkan deretan angka berdasarkan koma, spasi, atau titik koma
    final items = text.split(RegExp(r'[,\s;]+')).where((e) => e.isNotEmpty);

    // 2. Menghitung berapa banyak item yang valid sebagai angka (tipe double)
    int validNumberCount = 0;
    for (final item in items) {
      final normalized = item.replaceAll(',', '.');
      if (double.tryParse(normalized) != null) {
        validNumberCount++;
      }
    }

    // 3. Menghitung total banyaknya digit angka (0-9) di dalam teks input
    int totalDigits = 0;
    for (int i = 0; i < text.length; i++) {
      if (text[i].contains(RegExp(r'[0-9]'))) {
        totalDigits++;
      }
    }

    // Update state tampilan
    setState(() {
      _countAngka = validNumberCount;
      _countDigit = totalDigits;
      _hasCalculated = true;
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
        title: const Text('Hitung Banyak Angka (COUNT)'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Penjelasan fungsi
            const Text(
              'Masukkan deretan angka (dipisah koma atau spasi) atau angka panjang untuk menghitung banyaknya data.',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 12),

            // Input TextField
            TextField(
              controller: _controller,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
                signed: true,
              ),
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Input Angka',
                hintText: 'Contoh: 10, 25, 30, 4.5, 90',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 16),

            // Tombol Hitung COUNT
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _hitungBanyak,
                icon: const Icon(Icons.format_list_numbered),
                label: const Text('Hitung Banyaknya (COUNT)'),
              ),
            ),
            const SizedBox(height: 24),

            // Hasil COUNT
            if (_hasCalculated)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.deepPurple.shade200),
                ),
                child: Column(
                  children: [
                    // Banyak Angka / Bilangan (Items Count)
                    ListTile(
                      leading: const CircleAvatar(
                        child: Icon(Icons.numbers),
                      ),
                      title: const Text('Banyak Bilangan'),
                      subtitle: const Text('Jumlah elemen angka yang diinput'),
                      trailing: Text(
                        '$_countAngka',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ),
                    const Divider(),
                    // Banyak Digit Karakter Angka (Digit Count)
                    ListTile(
                      leading: const CircleAvatar(
                        child: Icon(Icons.pin),
                      ),
                      title: const Text('Banyak Digit Angka'),
                      subtitle: const Text('Total semua digit (0-9)'),
                      trailing: Text(
                        '$_countDigit',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
