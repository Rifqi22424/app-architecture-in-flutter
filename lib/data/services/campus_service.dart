/// Service: satu-satunya kelas yang "berbicara" dengan sumber data luar.
///
/// Di contoh ini server DISIMULASIKAN dengan data tetap dan jeda waktu,
/// supaya aplikasi bisa dijalankan tanpa internet. Untuk memakai server
/// sungguhan, cukup ganti isi kelas ini dengan request `http` (Sesi 6).
/// Repository, view model, dan layar tidak perlu diubah sama sekali.
///
/// Service mengembalikan data mentah (Map, seperti hasil jsonDecode).
class CampusService {
  CampusService({this.delay = const Duration(milliseconds: 800)});

  /// Jeda pura-pura, seolah-olah menunggu jawaban server.
  final Duration delay;

  Future<List<Map<String, dynamic>>> getSchedule() async {
    await Future.delayed(delay);
    return _schedule;
  }

  /// Salinan data tugas milik service ini (bisa berubah lewat updateTask).
  final List<Map<String, dynamic>> _tasks =
      _initialTasks.map((task) => Map<String, dynamic>.of(task)).toList();

  Future<List<Map<String, dynamic>>> getTasks() async {
    await Future.delayed(delay);
    return _tasks.map((task) => Map<String, dynamic>.of(task)).toList();
  }

  Future<void> updateTask(String id, {required bool done}) async {
    await Future.delayed(delay ~/ 4);
    _tasks.firstWhere((task) => task['id'] == id)['done'] = done;
  }
}

const _schedule = [
  {'id': 'c1', 'name': 'Pemrograman Perangkat Mobile', 'room': 'Lab Komputer 2', 'weekday': 1, 'start': '08:00', 'end': '09:40'},
  {'id': 'c2', 'name': 'Rekayasa Perangkat Lunak', 'room': 'R. 301', 'weekday': 1, 'start': '10:00', 'end': '11:40'},
  {'id': 'c3', 'name': 'Kecerdasan Buatan', 'room': 'R. 204', 'weekday': 1, 'start': '13:00', 'end': '14:40'},
  {'id': 'c4', 'name': 'Jaringan Komputer', 'room': 'Lab Jaringan', 'weekday': 2, 'start': '08:00', 'end': '09:40'},
  {'id': 'c5', 'name': 'Interaksi Manusia dan Komputer', 'room': 'R. 302', 'weekday': 3, 'start': '10:00', 'end': '11:40'},
  {'id': 'c6', 'name': 'Basis Data Lanjut', 'room': 'Lab Komputer 1', 'weekday': 4, 'start': '13:00', 'end': '14:40'},
  {'id': 'c7', 'name': 'Etika Profesi', 'room': 'R. 101', 'weekday': 5, 'start': '08:00', 'end': '09:40'},
];

const _initialTasks = [
  {'id': 't1', 'title': 'Laporan praktikum Sesi 6', 'courseName': 'Pemrograman Perangkat Mobile', 'due': '2026-11-09', 'done': false},
  {'id': 't2', 'title': 'Diagram use case sistem perpustakaan', 'courseName': 'Rekayasa Perangkat Lunak', 'due': '2026-11-11', 'done': false},
  {'id': 't3', 'title': 'Resume jurnal algoritma A*', 'courseName': 'Kecerdasan Buatan', 'due': '2026-11-13', 'done': false},
  {'id': 't4', 'title': 'Konfigurasi VLAN di Packet Tracer', 'courseName': 'Jaringan Komputer', 'due': '2026-11-06', 'done': true},
];
