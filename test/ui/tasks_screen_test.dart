import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sesi7_aplikasi_skala_besar/data/repositories/task_repository.dart';
import 'package:sesi7_aplikasi_skala_besar/ui/tasks/tasks_screen.dart';
import 'package:sesi7_aplikasi_skala_besar/ui/tasks/tasks_view_model.dart';

import '../fakes/fake_campus_service.dart';

void main() {
  testWidgets('mencentang tugas memindahkannya ke Selesai', (tester) async {
    final viewModel = TasksViewModel(
      repository: TaskRepository(service: FakeCampusService()),
    );
    await tester.pumpWidget(MaterialApp(home: TasksScreen(viewModel: viewModel)));
    await tester.pumpAndSettle();
    expect(find.text('Belum selesai (3)'), findsOneWidget);

    await tester.tap(find.text('Laporan praktikum Sesi 6'));
    await tester.pumpAndSettle();

    expect(find.text('Belum selesai (2)'), findsOneWidget);
    expect(find.text('Selesai (2)'), findsOneWidget);
  });
}
