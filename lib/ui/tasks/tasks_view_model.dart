import 'package:flutter/foundation.dart';

import '../../data/repositories/task_repository.dart';
import '../../domain/models/task.dart';

/// Logika layar Tugas: memisahkan tugas belum/sudah selesai,
/// dan meneruskan centang ke repository.
class TasksViewModel extends ChangeNotifier {
  TasksViewModel({required TaskRepository repository}) : _repository = repository {
    _repository.addListener(notifyListeners);
    load();
  }

  final TaskRepository _repository;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Object? _error;
  Object? get error => _error;

  List<Task> get pending => _repository.tasks.where((task) => !task.done).toList();
  List<Task> get done => _repository.tasks.where((task) => task.done).toList();

  Future<void> load() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _repository.getTasks();
    } catch (e) {
      _error = e;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Mengembalikan false jika gagal, supaya layar bisa memberi tahu pengguna.
  Future<bool> toggle(Task task) async {
    try {
      await _repository.setDone(task.id, !task.done);
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  void dispose() {
    _repository.removeListener(notifyListeners);
    super.dispose();
  }
}
