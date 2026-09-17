import 'package:flutter/material.dart';

/// Halaman Hitung Banyak Angka
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

  /// Fungsi untuk menghitung banyaknya angka yang dimasukkan
  void _hitungBanyak() {
    final text = _controller.text.trim();

    if (text.isEmpty) {
      setState(() {
        _hasCalculated = false;
        _countAngka = 0;
        _countDigit = 0;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.info_outline, color: Colors.white),
              SizedBox(width: 8),
              Text('Input tidak boleh kosong'),
            ],
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: Colors.redAccent.shade700,
        ),
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
          'Hitung Banyak Angka',
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Kartu Input Data
                  Container(
                    padding: const EdgeInsets.all(22),
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
                          'Analisis Jumlah Angka',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E2440),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Masukkan deretan angka (dipisah koma atau spasi) atau angka panjang untuk dianalisis.',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 18),

                        // Input TextField Multi-line
                        TextField(
                          controller: _controller,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                            signed: true,
                          ),
                          maxLines: 3,
                          decoration: InputDecoration(
                            labelText: 'Input Angka',
                            hintText: 'Contoh: 10, 25, 30, 4.5, 90',
                            prefixIcon: const Padding(
                              padding: EdgeInsets.only(bottom: 40),
                              child: Icon(Icons.edit_note_rounded, color: Color(0xFF673AB7)),
                            ),
                            filled: true,
                            fillColor: const Color(0xFFF7F5FA),
                            contentPadding: const EdgeInsets.all(16),
                            alignLabelWithHint: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(color: Color(0xFF673AB7), width: 1.5),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Tombol Hitung 
                        Container(
                          width: double.infinity,
                          height: 52,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: const LinearGradient(
                              colors: [Color(0xFF7E57C2), Color(0xFF5E35B1)],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF5E35B1).withOpacity(0.3),
                                blurRadius: 14,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: ElevatedButton.icon(
                            onPressed: _hitungBanyak,
                            icon: const Icon(Icons.calculate_outlined, color: Colors.white, size: 20),
                            label: const Text(
                              'Hitung Sekarang',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),

                  // Display Hasil Analisis
                  if (_hasCalculated) ...[
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      child: Text(
                        'Ringkasan Hasil Perhitungan',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF5E35B1),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        // Card Metric: Banyak Elemen Angka
                        Expanded(
                          child: _buildMetricCard(
                            icon: Icons.pin_invoke_rounded,
                            title: 'Banyak Bilangan',
                            subtitle: 'Elemen angka valid',
                            value: '$_countAngka',
                            accentColor: const Color(0xFF5E35B1),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Card Metric: Total Digit Karakter
                        Expanded(
                          child: _buildMetricCard(
                            icon: Icons.tag_rounded,
                            title: 'Total Digit',
                            subtitle: 'Karakter angka (0-9)',
                            value: '$_countDigit',
                            accentColor: const Color(0xFF7E57C2),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Kotak statistik / metrik angka
  Widget _buildMetricCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String value,
    required Color accentColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: accentColor, size: 22),
          ),
          const SizedBox(height: 14),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: accentColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E2440),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 11.5,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}