import 'package:flutter/foundation.dart';

import '../../data/repositories/schedule_repository.dart';
import '../../domain/models/course.dart';

/// Logika layar Jadwal: memuat jadwal dan memfilter per hari.
class ScheduleViewModel extends ChangeNotifier {
  ScheduleViewModel({required ScheduleRepository repository, DateTime Function()? clock})
      : _repository = repository {
    final weekday = (clock ?? DateTime.now)().weekday;
    _selectedDay = weekday <= 5 ? weekday : 1; // Sabtu/Minggu -> tampilkan Senin
    load();
  }

  final ScheduleRepository _repository;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Object? _error;
  Object? get error => _error;

  List<Course> _courses = [];

  late int _selectedDay;
  int get selectedDay => _selectedDay;

  List<Course> get coursesOfDay =>
      _courses.where((course) => course.weekday == _selectedDay).toList();

  void selectDay(int weekday) {
    _selectedDay = weekday;
    notifyListeners();
  }

  Future<void> load() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _courses = await _repository.getSchedule();
    } catch (e) {
      _error = e;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
