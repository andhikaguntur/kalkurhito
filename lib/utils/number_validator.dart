/// Helper sederhana untuk memvalidasi dan mem-parsing angka input pengguna.
class NumberValidator {
  /// Memvalidasi input string angka (tipe double)
  static String? validate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Input tidak boleh kosong';
    }

    // Mengganti koma (,) menjadi titik (.) agar bisa dibaca oleh double
    final normalized = value.trim().replaceAll(',', '.');
    final double? parsed = double.tryParse(normalized);

    if (parsed == null) {
      return 'Masukkan angka yang valid';
    }

    return null; // Valid (tidak ada error)
  }

  /// Mengubah teks input menjadi tipe double
  static double parse(String value) {
    return double.parse(value.trim().replaceAll(',', '.'));
  }
}
