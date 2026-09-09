import 'package:flutter/material.dart';
import '../utils/number_validator.dart';

/// Halaman Cek Ganjil / Genap
/// Memeriksa apakah sebuah bilangan bulat bernilai ganjil atau genap.
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

  /// Fungsi untuk memeriksa apakah bilangan ganjil atau genap
  void _cek() {
    if (_formKey.currentState!.validate()) {
      final double n = NumberValidator.parse(_numController.text);
      final int intVal = n.toInt();

      final bool isGenap = (intVal % 2 == 0);

      setState(() {
        _isEven = isGenap;
        _result = '$intVal adalah bilangan ${isGenap ? 'GENAP' : 'GANJIL'}';
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
              // Input Bilangan Bulat
              TextFormField(
                controller: _numController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: false,
                  signed: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Masukkan Bilangan Bulat',
                  hintText: 'Contoh: 7 atau 14',
                  border: OutlineInputBorder(),
                ),
                // Ganjil / Genap hanya berlaku untuk bilangan bulat (allowDecimal: false)
                validator: (v) => NumberValidator.validate(v, allowDecimal: false),
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

              // Hasil Pemeriksaan
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
