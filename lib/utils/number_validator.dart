/// Helper untuk memvalidasi dan mem-parsing angka input pengguna.
/// Kelas ini dibuat agar logika validasi tidak berulang di berbagai halaman (reusable).
class NumberValidator {
  // Batas angka wajar (maksimal ±1 miliar) untuk menghindari overflow atau angka tidak logis
  static const double minLimit = -1000000000;
  static const double maxLimit = 1000000000;

  /// Memvalidasi input string angka:
  /// - Tidak boleh kosong
  /// - Format angka harus benar
  /// - Bisa mengatur apakah boleh negatif ([allowNegative])
  /// - Bisa mengatur apakah boleh desimal ([allowDecimal])
  /// - Harus berada dalam rentang wajar ([minLimit] - [maxLimit])
  static String? validate(
    String? value, {
    bool allowNegative = true,
    bool allowDecimal = true,
  }) {
    if (value == null || value.trim().isEmpty) {
      return 'Input tidak boleh kosong';
    }

    // Mengganti koma (,) menjadi titik (.) agar bisa diparse oleh double.tryParse
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

    return null; // Valid (tidak ada error)
  }

  /// Mengonversi teks ke double setelah mengganti koma menjadi titik
  static double parse(String value) {
    return double.parse(value.trim().replaceAll(',', '.'));
  }
}
