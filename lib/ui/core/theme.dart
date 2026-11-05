import 'package:flutter/material.dart';

/// Satu tempat untuk warna dan gaya aplikasi.
/// Ganti warna di sini, seluruh layar ikut berubah.
abstract final class AppTheme {
  static const Color brand = Color(0xFF2457C5);

  static ThemeData light = ThemeData(
    colorSchemeSeed: brand,
    cardTheme: const CardThemeData(margin: EdgeInsets.zero),
  );
}
