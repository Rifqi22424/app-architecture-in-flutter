/// Format tanggal sederhana dalam Bahasa Indonesia, tanpa package tambahan.
const hari = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
const _bulan = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];

/// "Jumat, 13 Nov"
String formatTanggal(DateTime date) {
  return '${hari[date.weekday - 1]}, ${date.day} ${_bulan[date.month - 1]}';
}
