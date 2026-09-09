import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Kalkulator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}

// =======================================================
// HALAMAN LOGIN
// =======================================================
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  // Username & password default (bisa diganti sesuai kebutuhan)
  final String _validUsername = 'admin';
  final String _validPassword = '12345';

  void _login() {
    if (_formKey.currentState!.validate()) {
      if (_usernameController.text == _validUsername &&
          _passwordController.text == _validPassword) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MenuPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Username atau password salah!')),
        );
      }
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.calculate, size: 80, color: Colors.deepPurple),
                const SizedBox(height: 16),
                const Text(
                  'Login Aplikasi Kalkulator',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Username tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _login,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('LOGIN', style: TextStyle(fontSize: 16)),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Hint: username = admin, password = 12345',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// =======================================================
// HALAMAN MENU UTAMA
// =======================================================
class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Utama'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildMenuCard(
            context,
            icon: Icons.group,
            title: 'Data Kelompok',
            subtitle: 'Lihat data anggota kelompok',
            page: const GroupDataPage(),
          ),
          _buildMenuCard(
            context,
            icon: Icons.add_circle_outline,
            title: 'Penjumlahan & Pengurangan',
            subtitle: 'Operasi tambah dan kurang dua angka',
            page: const AddSubPage(),
          ),
          _buildMenuCard(
            context,
            icon: Icons.close,
            title: 'Perkalian & Pembagian',
            subtitle: 'Operasi kali dan bagi dua angka',
            page: const MulDivPage(),
          ),
          _buildMenuCard(
            context,
            icon: Icons.filter_2,
            title: 'Cek Ganjil / Genap',
            subtitle: 'Input satu bilangan, cek ganjil atau genap',
            page: const OddEvenPage(),
          ),
          _buildMenuCard(
            context,
            icon: Icons.summarize,
            title: 'Jumlah Total Angka',
            subtitle: 'Total dari beberapa angka dalam satu input',
            page: const SumTotalPage(),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget page,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(child: Icon(icon)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => page));
        },
      ),
    );
  }
}

// =======================================================
// HELPER VALIDASI ANGKA (dipakai di semua halaman)
// Batas logis: -1.000.000.000 s.d. 1.000.000.000 (di luar itu dianggap tidak logis, misal triliunan)
// =======================================================
class NumberValidator {
  static const double minLimit = -1000000000; // -1 miliar
  static const double maxLimit = 1000000000; // 1 miliar

  /// allowNegative: apakah boleh angka minus
  /// allowDecimal: apakah boleh angka desimal (koma/titik)
  static String? validate(
    String? value, {
    bool allowNegative = true,
    bool allowDecimal = true,
  }) {
    if (value == null || value.trim().isEmpty) {
      return 'Input tidak boleh kosong';
    }

    final normalized = value.trim().replaceAll(',', '.');
    final double? parsed = double.tryParse(normalized);

    if (parsed == null) {
      return 'Masukkan angka yang valid';
    }

    if (!allowNegative && parsed < 0) {
      return 'Angka minus tidak diperbolehkan';
    }

    if (!allowDecimal && parsed % 1 != 0) {
      return 'Angka desimal tidak diperbolehkan';
    }

    if (parsed < minLimit || parsed > maxLimit) {
      return 'Angka tidak logis (maksimal ±1 miliar)';
    }

    return null; // valid
  }

  static double parse(String value) {
    return double.parse(value.trim().replaceAll(',', '.'));
  }
}

// =======================================================
// HALAMAN DATA KELOMPOK
// =======================================================
class GroupDataPage extends StatelessWidget {
  const GroupDataPage({super.key});

  // Ganti sesuai data kelompok kalian
  final List<Map<String, String>> members = const [
    {'nama': 'Nama Anggota 1', 'nim': '00000001'},
    {'nama': 'Nama Anggota 2', 'nim': '00000002'},
    {'nama': 'Nama Anggota 3', 'nim': '00000003'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Data Kelompok')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: members.length,
        itemBuilder: (context, index) {
          final m = members[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              leading: CircleAvatar(child: Text('${index + 1}')),
              title: Text(m['nama']!),
              subtitle: Text('NIM: ${m['nim']}'),
            ),
          );
        },
      ),
    );
  }
}

// =======================================================
// HALAMAN PENJUMLAHAN & PENGURANGAN
// =======================================================
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

  void _hitung(String operasi) {
    if (_formKey.currentState!.validate()) {
      final double a = NumberValidator.parse(_num1Controller.text);
      final double b = NumberValidator.parse(_num2Controller.text);
      double hasil = operasi == '+' ? a + b : a - b;
      setState(() {
        _result = 'Hasil: ${hasil.toStringAsFixed(2)}';
      });
    } else {
      setState(() => _result = '');
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
      appBar: AppBar(title: const Text('Penjumlahan & Pengurangan')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _num1Controller,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true, signed: true),
                decoration: const InputDecoration(
                  labelText: 'Angka Pertama',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => NumberValidator.validate(v),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _num2Controller,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true, signed: true),
                decoration: const InputDecoration(
                  labelText: 'Angka Kedua',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => NumberValidator.validate(v),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed: () => _hitung('+'),
                      child: const Text('Tambah (+)'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () => _hitung('-'),
                      child: const Text('Kurang (-)'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                _result,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =======================================================
// HALAMAN PERKALIAN & PEMBAGIAN
// =======================================================
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

  void _hitung(String operasi) {
    if (_formKey.currentState!.validate()) {
      final double a = NumberValidator.parse(_num1Controller.text);
      final double b = NumberValidator.parse(_num2Controller.text);

      if (operasi == '/' && b == 0) {
        setState(() => _result = 'Error: Tidak bisa dibagi dengan 0');
        return;
      }

      double hasil = operasi == '*' ? a * b : a / b;
      setState(() {
        _result = 'Hasil: ${hasil.toStringAsFixed(2)}';
      });
    } else {
      setState(() => _result = '');
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
      appBar: AppBar(title: const Text('Perkalian & Pembagian')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _num1Controller,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true, signed: true),
                decoration: const InputDecoration(
                  labelText: 'Angka Pertama',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => NumberValidator.validate(v),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _num2Controller,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true, signed: true),
                decoration: const InputDecoration(
                  labelText: 'Angka Kedua',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => NumberValidator.validate(v),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed: () => _hitung('*'),
                      child: const Text('Kali (×)'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () => _hitung('/'),
                      child: const Text('Bagi (÷)'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                _result,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =======================================================
// HALAMAN CEK GANJIL / GENAP
// =======================================================
class OddEvenPage extends StatefulWidget {
  const OddEvenPage({super.key});

  @override
  State<OddEvenPage> createState() => _OddEvenPageState();
}

class _OddEvenPageState extends State<OddEvenPage> {
  final _formKey = GlobalKey<FormState>();
  final _numController = TextEditingController();
  String _result = '';

  void _cek() {
    if (_formKey.currentState!.validate()) {
      final double n = NumberValidator.parse(_numController.text);
      // Karena tipe double, cek genap/ganjil hanya berlaku untuk bilangan bulat
      if (n % 2 == 0) {
        setState(() => _result = '${n.toStringAsFixed(0)} adalah bilangan GENAP');
      } else {
        setState(() => _result = '${n.toStringAsFixed(0)} adalah bilangan GANJIL');
      }
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
      appBar: AppBar(title: const Text('Cek Ganjil / Genap')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _numController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: false, signed: true),
                decoration: const InputDecoration(
                  labelText: 'Masukkan Bilangan Bulat',
                  border: OutlineInputBorder(),
                ),
                // Tidak boleh desimal karena ganjil/genap hanya untuk bilangan bulat
                validator: (v) => NumberValidator.validate(v, allowDecimal: false),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _cek,
                  child: const Text('Cek Sekarang'),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                _result,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =======================================================
// HALAMAN JUMLAH TOTAL ANGKA DALAM SATU FIELD
// Contoh input: 10, 20, 30.5, -5  -> dipisah dengan koma atau spasi
// =======================================================
class SumTotalPage extends StatefulWidget {
  const SumTotalPage({super.key});

  @override
  State<SumTotalPage> createState() => _SumTotalPageState();
}

class _SumTotalPageState extends State<SumTotalPage> {
  final _controller = TextEditingController();
  String _result = '';
  String _errorText = '';

  void _hitungTotal() {
    final input = _controller.text.trim();
    setState(() {
      _errorText = '';
      _result = '';
    });

    if (input.isEmpty) {
      setState(() => _errorText = 'Input tidak boleh kosong');
      return;
    }

    // Pisahkan berdasarkan koma, titik koma, atau spasi
    final parts = input.split(RegExp(r'[,\s;]+')).where((e) => e.isNotEmpty);

    double total = 0.0;
    int count = 0;
    List<String> invalidValues = [];

    for (final part in parts) {
      final normalized = part.replaceAll(',', '.');
      final double? value = double.tryParse(normalized);

      if (value == null) {
        invalidValues.add(part);
        continue;
      }

      if (value < NumberValidator.minLimit || value > NumberValidator.maxLimit) {
        invalidValues.add('$part (tidak logis)');
        continue;
      }

      total += value;
      count++;
    }

    if (invalidValues.isNotEmpty) {
      setState(() {
        _errorText = 'Nilai tidak valid diabaikan: ${invalidValues.join(', ')}';
      });
    }

    if (count == 0) {
      setState(() => _errorText = 'Tidak ada angka valid untuk dijumlahkan');
      return;
    }

    setState(() {
      _result = 'Total dari $count angka = ${total.toStringAsFixed(2)}';
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
      appBar: AppBar(title: const Text('Jumlah Total Angka')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Masukkan beberapa angka dipisah dengan koma atau spasi.\nContoh: 10, 20, 30.5, -5',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _controller,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Deretan Angka',
                border: OutlineInputBorder(),
                hintText: '10, 20, 30.5, -5',
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _hitungTotal,
                child: const Text('Hitung Total'),
              ),
            ),
            const SizedBox(height: 20),
            if (_errorText.isNotEmpty)
              Text(
                _errorText,
                style: const TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 8),
            Text(
              _result,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}