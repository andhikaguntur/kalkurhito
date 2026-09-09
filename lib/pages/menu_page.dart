import 'package:flutter/material.dart';

import 'login_page.dart';
import 'group_data_page.dart';
import 'calculator_page.dart';
import 'odd_even_page.dart';
import 'count_page.dart';

/// Halaman Menu Utama
/// Berisi 4 menu navigasi utama aplikasi:
/// 1. Data Kelompok
/// 2. Operasi Matematika (+, -, *, /)
/// 3. Cek Ganjil / Genap
/// 4. Hitung Banyak Angka (COUNT)
class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Utama'),
        actions: [
          // Tombol Logout di AppBar
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              // Kembali ke halaman Login
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
          // Menu 1: Data Kelompok
          _buildMenuCard(
            context,
            icon: Icons.group,
            title: '1. Data Kelompok',
            subtitle: 'Daftar nama dan NIM anggota kelompok',
            page: const GroupDataPage(),
          ),

          // Menu 2: Operasi Matematika (+, -, *, /)
          _buildMenuCard(
            context,
            icon: Icons.calculate,
            title: '2. Operasi Matematika (+, -, ×, ÷)',
            subtitle: 'Penjumlahan, pengurangan, perkalian, dan pembagian',
            page: const CalculatorPage(),
          ),

          // Menu 3: Cek Ganjil / Genap
          _buildMenuCard(
            context,
            icon: Icons.filter_2,
            title: '3. Cek Ganjil / Genap',
            subtitle: 'Cek status bilangan ganjil atau genap',
            page: const OddEvenPage(),
          ),

          // Menu 4: Hitung Banyak Angka (COUNT)
          _buildMenuCard(
            context,
            icon: Icons.format_list_numbered,
            title: '4. Hitung Banyak Angka',
            subtitle: 'Menghitung banyaknya angka/elemen yang dimasukkan',
            page: const CountPage(),
          ),
        ],
      ),
    );
  }

  /// Helper widget untuk membuat card menu agar rapi dan tidak duplikat
  Widget _buildMenuCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget page,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
          child: Icon(icon),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
      ),
    );
  }
}
