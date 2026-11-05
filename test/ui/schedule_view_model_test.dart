import 'package:flutter_test/flutter_test.dart';
import 'package:sesi7_aplikasi_skala_besar/data/repositories/schedule_repository.dart';
import 'package:sesi7_aplikasi_skala_besar/ui/schedule/schedule_view_model.dart';

import '../fakes/fake_campus_service.dart';

void main() {
  ScheduleViewModel create(DateTime today) => ScheduleViewModel(
        repository: ScheduleRepository(service: FakeCampusService()),
        clock: () => today,
      );

  test('hari Sabtu menampilkan jadwal Senin', () {
    expect(create(DateTime(2026, 11, 7)).selectedDay, 1);
  });

  test('selectDay memfilter jadwal', () async {
    final viewModel = create(senin());
    await viewModel.load();

    viewModel.selectDay(2);

    expect(viewModel.coursesOfDay.map((c) => c.name), ['Jaringan Komputer']);
  });
}
