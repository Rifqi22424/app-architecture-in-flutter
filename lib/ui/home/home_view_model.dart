import 'package:flutter/foundation.dart';

import '../../data/repositories/schedule_repository.dart';
import '../../data/repositories/task_repository.dart';
import '../../domain/models/course.dart';
import '../../domain/models/task.dart';

/// Logika layar Beranda: menggabungkan data dari DUA repository
/// menjadi ringkasan hari ini.
class HomeViewModel extends ChangeNotifier {
  HomeViewModel({
    required ScheduleRepository scheduleRepository,
    required TaskRepository taskRepository,
    DateTime Function()? clock,
  })  : _scheduleRepository = scheduleRepository,
        _taskRepository = taskRepository,
        _clock = clock ?? DateTime.now {
    // Jika tugas ditandai selesai di layar Tugas, Beranda ikut berubah.
    _taskRepository.addListener(notifyListeners);
    load();
  }

  final ScheduleRepository _scheduleRepository;
  final TaskRepository _taskRepository;
  final DateTime Function() _clock; // bisa diganti saat testing

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Object? _error;
  Object? get error => _error;

  List<Course> _schedule = [];

  DateTime get today => _clock();

  List<Course> get todayCourses =>
      _schedule.where((course) => course.weekday == today.weekday).toList();

  /// Tugas yang belum selesai, tenggat terdekat lebih dulu.
  List<Task> get pendingTasks => _taskRepository.tasks
      .where((task) => !task.done).toList()
    ..sort((a, b) => a.due.compareTo(b.due));

  Future<void> load() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _schedule = await _scheduleRepository.getSchedule();
      await _taskRepository.getTasks();
    } catch (e) {
      _error = e;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _taskRepository.removeListener(notifyListeners);
    super.dispose();
  }
}
