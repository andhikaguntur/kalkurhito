import 'package:flutter/material.dart';
import '../utils/number_validator.dart';

/// Halaman Cek Ganjil / Genap
/// Memeriksa apakah bilangan yang diinputkan bernilai ganjil atau genap.
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

  /// Fungsi untuk mengecek bilangan ganjil atau genap
  void _cek() {
    if (_formKey.currentState!.validate()) {
      final double n = NumberValidator.parse(_numController.text);

      // Cek apakah ada angka di belakang koma (desimal)
      if (n % 1 != 0) {
        setState(() {
          _result = 'Masukkan bilangan bulat untuk cek ganjil/genap';
        });
        return;
      }

      // Logika ganjil/genap: jika sisa bagi (% 2) sama dengan 0 maka genap
      final bool isGenap = (n.toInt() % 2 == 0);

      setState(() {
        _isEven = isGenap;
        _result = '${n.toInt()} adalah bilangan ${isGenap ? 'GENAP' : 'GANJIL'}';
      });
    } else {
      setState(() => _result = '');
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
      appBar: AppBar(
        title: const Text('Cek Ganjil / Genap'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Input Angka
              TextFormField(
                controller: _numController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Masukkan Bilangan',
                  hintText: 'Contoh: 8 atau 15',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => NumberValidator.validate(v),
              ),
              const SizedBox(height: 20),

              // Tombol Cek
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _cek,
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text('Cek Sekarang'),
                ),
              ),
              const SizedBox(height: 24),

              // Tampilan Hasil
              if (_result.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _isEven ? Colors.blue.shade50 : Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _isEven ? Colors.blue.shade200 : Colors.orange.shade200,
                    ),
                  ),
                  child: Text(
                    _result,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _isEven ? Colors.blue.shade800 : Colors.orange.shade900,
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
