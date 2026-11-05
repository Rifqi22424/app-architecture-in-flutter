import 'package:flutter/material.dart';

import '../../utils/date_format.dart';
import '../core/widgets/course_card.dart';
import '../core/widgets/error_view.dart';
import 'home_view_model.dart';

/// View Beranda: hanya menampilkan isi [HomeViewModel], tanpa logika.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.viewModel});

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('NusaKampus')),
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (viewModel.error != null) {
            return ErrorView(onRetry: viewModel.load);
          }

          final text = Theme.of(context).textTheme;
          final courses = viewModel.todayCourses;
          final tasks = viewModel.pendingTasks;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(formatTanggal(viewModel.today), style: text.titleMedium),
              const SizedBox(height: 4),
              Text('Halo, selamat datang!', style: text.headlineSmall),
              const SizedBox(height: 24),
              Text('Kuliah hari ini (${courses.length})', style: text.titleSmall),
              const SizedBox(height: 8),
              if (courses.isEmpty) const Text('Tidak ada kuliah hari ini.'),
              for (final course in courses)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: CourseCard(course: course),
                ),
              const SizedBox(height: 16),
              Text('Tugas belum selesai (${tasks.length})', style: text.titleSmall),
              const SizedBox(height: 8),
              if (tasks.isEmpty) const Text('Semua tugas sudah selesai.'),
              for (final task in tasks)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.assignment_outlined),
                  title: Text(task.title),
                  subtitle: Text('Tenggat ${formatTanggal(task.due)}'),
                ),
            ],
          );
        },
      ),
    );
  }
}
