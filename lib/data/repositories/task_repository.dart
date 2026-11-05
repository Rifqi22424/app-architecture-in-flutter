import 'package:flutter/foundation.dart';

import '../../domain/models/task.dart';
import '../services/campus_service.dart';

/// Repository: sumber kebenaran untuk data tugas.
///
/// Berbeda dengan jadwal, data tugas bisa BERUBAH (ditandai selesai) dan
/// dipakai oleh dua fitur sekaligus: Beranda dan Tugas. Karena itu kelas
/// ini memakai ChangeNotifier: setiap perubahan diumumkan lewat
/// notifyListeners(), dan semua view model yang mendengarkan ikut diperbarui.
class TaskRepository extends ChangeNotifier {
  TaskRepository({required CampusService service}) : _service = service;

  final CampusService _service;
  List<Task>? _cache;

  /// Daftar tugas terakhir yang diketahui (kosong jika belum dimuat).
  List<Task> get tasks => List.unmodifiable(_cache ?? const <Task>[]);

  Future<List<Task>> getTasks() async {
    if (_cache != null) return tasks;

    final data = await _service.getTasks();
    _cache = data.map((json) => Task.fromJson(json)).toList();
    notifyListeners();
    return tasks;
  }

  Future<void> setDone(String id, bool done) async {
    await _service.updateTask(id, done: done);

    _cache = [
      for (final task in _cache ?? const <Task>[])
        task.id == id ? task.copyWith(done: done) : task,
    ];
    notifyListeners();
  }
}
