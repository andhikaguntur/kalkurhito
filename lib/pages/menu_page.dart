import 'package:flutter/material.dart';
import 'login_page.dart';
import 'group_data_page.dart';
import 'add_sub_page.dart';
import 'mul_div_page.dart';
import 'odd_even_page.dart';
import 'sum_total_page.dart';

/// Halaman Menu Utama
/// Menampilkan navigasi ke semua fitur aplikasi kalkulator.
class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Utama'),
        actions: [
          // Tombol Logout di pojok kanan atas
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              // Kembali ke Halaman Login dan bersihkan riwayat navigasi
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

  /// Helper widget untuk membuat kartu menu agar kodingan tidak berulang (DRY - Don't Repeat Yourself)
  Widget _buildMenuCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget page,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
          child: Icon(icon),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // Buka halaman fitur yang dipilih
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
      ),
    );
  }
}
