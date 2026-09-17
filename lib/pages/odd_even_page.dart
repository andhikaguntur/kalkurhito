import 'package:flutter/material.dart';
import '../utils/number_validator.dart';

/// Halaman Cek Ganjil / Genap
class OddEvenPage extends StatefulWidget {
  const OddEvenPage({super.key});

  @override
  State<OddEvenPage> createState() => _OddEvenPageState();
}

class _OddEvenPageState extends State<OddEvenPage> {
  final _formKey = GlobalKey<FormState>();
  final _numController = TextEditingController();
  String _result = '';
  bool _isEven = false;
  bool _isDecimalError = false;

  /// Fungsi untuk mengecek bilangan ganjil atau genap
  void _cek() {
    if (_formKey.currentState!.validate()) {
      final double n = NumberValidator.parse(_numController.text);

      // Cek apakah ada angka di belakang koma (desimal)
      if (n % 1 != 0) {
        setState(() {
          _isDecimalError = true;
          _result = 'Masukkan bilangan bulat untuk cek ganjil/genap';
        });
        return;
      }

      // Logika ganjil/genap: jika sisa bagi (% 2) sama dengan 0 maka genap
      final bool isGenap = (n.toInt() % 2 == 0);

      setState(() {
        _isDecimalError = false;
        _isEven = isGenap;
        _result = '${n.toInt()} adalah bilangan ${isGenap ? 'GENAP' : 'GANJIL'}';
      });
    } else {
      setState(() {
        _result = '';
        _isDecimalError = false;
      });
    }
  }

  @override
  void dispose() {
    _numController.dispose();
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
          'Cek Ganjil / Genap',
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
                    // Kartu Form Input
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
                            'Pemeriksaan Bilangan',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2E2440),
                            ),
                          ),
                        
                          const SizedBox(height: 18),

                          // Input Angka
                          TextFormField(
                            controller: _numController,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                              signed: true,
                            ),
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => _cek(),
                            decoration: InputDecoration(
                              labelText: 'Masukkan Bilangan',
                              hintText: 'Contoh: 8 atau 15',
                              prefixIcon: const Icon(Icons.pin_outlined, color: Color(0xFF673AB7)),
                              filled: true,
                              fillColor: const Color(0xFFF7F5FA),
                              contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
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
                          const SizedBox(height: 20),

                          // Tombol Cek
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
                              onPressed: _cek,
                              icon: const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
                              label: const Text(
                                'Cek Sekarang',
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

                    // Tampilan Hasil
                    if (_result.isNotEmpty)
                      _buildResultCard(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Helper untuk membangun kartu display hasil
  Widget _buildResultCard() {
    if (_isDecimalError) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFFFEBEE),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.redAccent.shade100, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.red.withOpacity(0.06),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(Icons.info_outline_rounded, color: Colors.redAccent.shade700, size: 28),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                _result,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.redAccent.shade700,
                ),
              ),
            ),
          ],
        ),
      );
    }

    final Color primaryTone = _isEven ? const Color(0xFF00897B) : const Color(0xFFE65100);
    final Color backgroundTone = _isEven ? const Color(0xFFE0F2F1) : const Color(0xFFFFF3E0);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: primaryTone.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: primaryTone.withOpacity(0.08),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Badge Jenis Bilangan
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: backgroundTone,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _isEven ? Icons.check_circle_outline_rounded : Icons.flare_rounded,
                  size: 16,
                  color: primaryTone,
                ),
                const SizedBox(width: 6),
                Text(
                  _isEven ? 'STATUS: GENAP' : 'STATUS: GANJIL',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: primaryTone,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Teks Hasil Utama
          Text(
            _result,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E2440),
            ),
          ),
        ],
      ),
    );
  }
}