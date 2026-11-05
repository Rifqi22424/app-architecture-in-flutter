import 'package:flutter_test/flutter_test.dart';
import 'package:sesi7_aplikasi_skala_besar/data/repositories/task_repository.dart';

import '../fakes/fake_campus_service.dart';

void main() {
  test('getTasks mengubah data mentah menjadi model Task', () async {
    final repository = TaskRepository(service: FakeCampusService());

    final tasks = await repository.getTasks();

    expect(tasks, hasLength(4));
    expect(tasks.first.title, 'Laporan praktikum Sesi 6');
    expect(tasks.first.due, DateTime(2026, 11, 9));
  });

  test('setDone mengubah tugas dan memberi tahu pendengar', () async {
    final repository = TaskRepository(service: FakeCampusService());
    await repository.getTasks();
    var notified = 0;
    repository.addListener(() => notified++);

    await repository.setDone('t1', true);

    expect(repository.tasks.firstWhere((t) => t.id == 't1').done, isTrue);
    expect(notified, 1);
  });
}
