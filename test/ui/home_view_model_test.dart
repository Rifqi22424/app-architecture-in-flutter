import 'package:flutter_test/flutter_test.dart';
import 'package:sesi7_aplikasi_skala_besar/data/repositories/schedule_repository.dart';
import 'package:sesi7_aplikasi_skala_besar/data/repositories/task_repository.dart';
import 'package:sesi7_aplikasi_skala_besar/ui/home/home_view_model.dart';

import '../fakes/fake_campus_service.dart';

// View model dites TANPA layar dan TANPA server: cukup service palsu.
void main() {
  late FakeCampusService service;
  late TaskRepository tasks;
  late HomeViewModel viewModel;

  setUp(() async {
    service = FakeCampusService();
    tasks = TaskRepository(service: service);
    viewModel = HomeViewModel(
      scheduleRepository: ScheduleRepository(service: service),
      taskRepository: tasks,
      clock: senin,
    );
    await viewModel.load();
  });

  test('menampilkan kuliah hari Senin saja', () {
    expect(viewModel.todayCourses.map((c) => c.name), [
      'Pemrograman Perangkat Mobile',
      'Rekayasa Perangkat Lunak',
      'Kecerdasan Buatan',
    ]);
  });

  test('tugas belum selesai diurutkan dari tenggat terdekat', () {
    expect(viewModel.pendingTasks.map((t) => t.id), ['t1', 't2', 't3']);
  });

  test('Beranda ikut berubah saat tugas dicentang di fitur lain', () async {
    await tasks.setDone('t1', true);

    expect(viewModel.pendingTasks.map((t) => t.id), ['t2', 't3']);
  });

  test('menyimpan error jika server gagal', () async {
    service.fail = true;
    final failing = HomeViewModel(
      scheduleRepository: ScheduleRepository(service: service),
      taskRepository: TaskRepository(service: service),
      clock: senin,
    );
    await failing.load();

    expect(failing.error, isNotNull);
    expect(failing.isLoading, isFalse);
  });
}
