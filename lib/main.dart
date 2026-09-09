import 'package:flutter/material.dart';
import 'pages/login_page.dart';

/// Fungsi utama (entry point) aplikasi Flutter
void main() {
  runApp(const MyApp());
}

/// Root widget aplikasi
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Kalkulator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Menggunakan tema warna Material 3 berbasis Deep Purple
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // Halaman pertama yang dibuka saat aplikasi dijalankan
      home: const LoginPage(),
    );
  }
}