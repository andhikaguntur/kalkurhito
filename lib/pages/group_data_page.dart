import 'package:flutter/material.dart';

/// Model sederhana untuk merepresentasikan data anggota kelompok
class Member {
  final String nama;
  final String nim;

  const Member({required this.nama, required this.nim});
}

/// Halaman Data Kelompok
/// Menampilkan daftar nama dan NIM anggota kelompok.
class GroupDataPage extends StatelessWidget {
  const GroupDataPage({super.key});

  // Data anggota kelompok (bisa disesuaikan dengan data kelompok kalian)
  final List<Member> members = const [
    Member(nama: 'Nama Anggota 1', nim: '00000001'),
    Member(nama: 'Nama Anggota 2', nim: '00000002'),
    Member(nama: 'Nama Anggota 3', nim: '00000003'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Kelompok'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: members.length,
        itemBuilder: (context, index) {
          final member = members[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                child: Text('${index + 1}'),
              ),
              title: Text(
                member.nama,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('NIM: ${member.nim}'),
            ),
          );
        },
      ),
    );
  }
}
